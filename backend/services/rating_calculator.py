"""
Rating Calculator Service
Implements rule-based employee rating system with transparent calculation breakdown.
Version: v1.0

Supports 5 rating dimensions:
1. Task Completion (40%) - tasks_completed / tasks_assigned
2. Punctuality & Attendance (20%) - late_days + absence_days
3. Behavior & Collaboration (20%) - manager feedback score (1-100)
4. Learning & Growth (10%) - count of certifications/skills acquired
5. Work Quality (10%) - bug_ratio (bugs / tasks_completed)
"""

from typing import Dict, List, Optional, Any
from neo4j import Session
from datetime import datetime
from decimal import Decimal


def _period_to_date_str(period: str) -> str:
    """Convert period string like '2024-Q1' to ISO date string '2024-01-01'."""
    if "-Q" in period:
        year, q = period.split("-Q")
        month = (int(q) - 1) * 3 + 1
        return f"{year}-{month:02d}-01"
    return f"{period}-01-01"


class RatingCalculator:
    """
    Calculates multi-dimensional employee ratings based on Neo4j rules.
    Stores breakdown for transparency and auditability.
    """

    def __init__(self, driver):
        """Initialize with Neo4j driver"""
        self.driver = driver

    def get_active_rules(self) -> List[Dict[str, Any]]:
        """
        Fetch all active rating rules from Neo4j.
        Returns list of rule dicts with thresholds.
        """
        with self.driver.session() as session:
            result = session.run("""
                MATCH (rule:RatingRule {active: true})
                OPTIONAL MATCH (rule)-[:HAS_THRESHOLD]->(t:RatingThreshold)
                RETURN
                    rule.rule_id as rule_id,
                    rule.name as rule_name,
                    rule.dimension as dimension,
                    rule.weight as weight,
                    rule.description as description,
                    rule.metric_source as metric_source,
                    rule.version as rule_version,
                    collect({
                        threshold_id: t.threshold_id,
                        min_value: t.min_value,
                        max_value: t.max_value,
                        star_value: t.star_value,
                        description: t.description
                    }) as thresholds
                ORDER BY rule.weight DESC
            """)

            rules = []
            for record in result:
                rule = {
                    'rule_id': record['rule_id'],
                    'rule_name': record['rule_name'],
                    'dimension': record['dimension'],
                    'weight': record['weight'],
                    'description': record['description'],
                    'metric_source': record['metric_source'],
                    'version': record['rule_version'],
                    'thresholds': [t for t in record['thresholds'] if t['threshold_id']]
                }
                # Sort thresholds by min_value for easy lookup
                rule['thresholds'].sort(key=lambda x: x['min_value'], reverse=True)
                rules.append(rule)

            return rules

    def calculate_metric(
        self,
        dimension: str,
        employee_id: str,
        project_id: str,
        period: str
    ) -> Dict[str, Any]:
        """
        Calculate metric value for a specific dimension.
        Returns: {
            'metric_value': float/int,
            'metric_label': str,
            'metric_type': str,
            'found': bool
        }
        """
        with self.driver.session() as session:
            if dimension == 'PERFORMANCE':  # Task Completion
                result = session.run("""
                    MATCH (e:Employee {employee_id: $employee_id})
                    MATCH (e)-[r:ASSIGNED_TASK]->(t:Task)<-[:HAS_TASK]-(s:Sprint)<-[:HAS_SPRINT]-(p:Project {project_id: $project_id})
                    WHERE r.period = $period
                    WITH
                        count(CASE WHEN r.completed = true THEN 1 END) as completed,
                        count(t) as total
                    RETURN
                        CASE WHEN total > 0 THEN toFloat(completed) / total ELSE 0.0 END as metric_value,
                        completed as completed_count,
                        total as total_count
                """, employee_id=employee_id, project_id=project_id, period=period)

                record = result.single()
                if record:
                    metric_value = record['metric_value']
                    completed = record['completed_count']
                    total = record['total_count']
                    metric_label = f"{int(completed)}/{int(total)} tasks ({metric_value*100:.0f}%)"
                    return {
                        'metric_value': metric_value,
                        'metric_label': metric_label,
                        'metric_type': 'percentage',
                        'found': True
                    }
                return {
                    'metric_value': 0.0,
                    'metric_label': 'No tasks assigned',
                    'metric_type': 'percentage',
                    'found': False
                }

            elif dimension == 'RELIABILITY':  # Punctuality & Attendance
                result = session.run("""
                    MATCH (e:Employee {employee_id: $employee_id})
                    MATCH (e)-[:HAS_ATTENDANCE]->(a:Attendance {period: $period})
                    RETURN
                        a.total_penalty_days as penalty_days,
                        a.late_days as late_days,
                        a.absence_days as absence_days
                """, employee_id=employee_id, period=period)

                record = result.single()
                if record:
                    penalty = record['penalty_days'] or 0
                    late = record['late_days'] or 0
                    absence = record['absence_days'] or 0
                    metric_label = f"{int(penalty)} penalty days ({int(late)} late + {int(absence)} absence)"
                    return {
                        'metric_value': float(penalty),
                        'metric_label': metric_label,
                        'metric_type': 'days',
                        'found': True
                    }
                return {
                    'metric_value': 0.0,
                    'metric_label': 'No attendance data',
                    'metric_type': 'days',
                    'found': False
                }

            elif dimension == 'TEAMWORK':  # Behavior & Collaboration
                result = session.run("""
                    MATCH (e:Employee {employee_id: $employee_id})
                    MATCH (e)<-[:RATED_EMPLOYEE]-(mf:ManagerFeedback {period: $period})
                    RETURN
                        mf.feedback_score as feedback_score,
                        mf.feedback_comment as feedback_comment
                """, employee_id=employee_id, period=period)

                record = result.single()
                if record:
                    score = record['feedback_score'] or 0
                    comment = record['feedback_comment'] or ''
                    metric_label = f"Score: {int(score)}/100"
                    if comment:
                        metric_label += f" ({comment[:50]}...)" if len(comment) > 50 else f" ({comment})"
                    return {
                        'metric_value': float(score),
                        'metric_label': metric_label,
                        'metric_type': 'score',
                        'found': True
                    }
                return {
                    'metric_value': 0.0,
                    'metric_label': 'No manager feedback',
                    'metric_type': 'score',
                    'found': False
                }

            elif dimension == 'DEVELOPMENT':  # Learning & Growth
                result = session.run("""
                    MATCH (e:Employee {employee_id: $employee_id})
                    WITH e
                    OPTIONAL MATCH (e)-[hc:HAS_CERTIFICATION]->(cert:Certification)
                    WHERE hc.issued_date >= date($period_start)
                    WITH e, count(cert) as cert_count
                    OPTIONAL MATCH (e)-[hsa:HAS_SKILL_ACQUIRED]->(skill:Skill)
                    WHERE hsa.acquired_date >= date($period_start)
                    WITH cert_count, count(skill) as skill_count
                    RETURN cert_count + skill_count as total_acquisitions
                """, employee_id=employee_id, period_start=_period_to_date_str(period))

                record = result.single()
                if record:
                    count = record['total_acquisitions'] or 0
                    metric_label = f"{int(count)} certifications/skills acquired"
                    return {
                        'metric_value': float(count),
                        'metric_label': metric_label,
                        'metric_type': 'count',
                        'found': True
                    }
                return {
                    'metric_value': 0.0,
                    'metric_label': 'No new certifications/skills',
                    'metric_type': 'count',
                    'found': False
                }

            elif dimension == 'CRAFTSMANSHIP':  # Work Quality
                result = session.run("""
                    MATCH (e:Employee {employee_id: $employee_id})
                    MATCH (e)-[:HAS_BUG_RATIO {period: $period}]->(br:BugRatio)
                    WHERE br.project_id = $project_id
                    RETURN
                        br.bug_ratio as bug_ratio,
                        br.bugs_reported as bugs_reported,
                        br.tasks_completed as tasks_completed
                """, employee_id=employee_id, project_id=project_id, period=period)

                record = result.single()
                if record:
                    ratio = record['bug_ratio'] or 0.0
                    bugs = record['bugs_reported'] or 0
                    tasks = record['tasks_completed'] or 0
                    metric_label = f"{int(bugs)}/{int(tasks)} bugs ({ratio*100:.1f}%)"
                    return {
                        'metric_value': ratio,
                        'metric_label': metric_label,
                        'metric_type': 'ratio',
                        'found': True
                    }
                return {
                    'metric_value': 0.0,
                    'metric_label': 'No quality data',
                    'metric_type': 'ratio',
                    'found': False
                }

            return {
                'metric_value': 0.0,
                'metric_label': f'Unknown dimension: {dimension}',
                'metric_type': 'unknown',
                'found': False
            }

    def apply_thresholds(self, metric_value: float, rule: Dict) -> int:
        """
        Apply rule thresholds to metric value and return star rating.
        Handles both ascending (task completion %) and descending (penalty days) metrics.
        """
        if not rule.get('thresholds'):
            return 3  # Default to 3 stars if no thresholds

        # Special handling for metrics where LOWER is BETTER (penalty days, bugs)
        if rule['dimension'] in ['RELIABILITY', 'CRAFTSMANSHIP']:
            # For penalty days: LOWER penalty = HIGHER stars
            # Sort thresholds by min_value (ascending) and find the first match
            for threshold in sorted(rule['thresholds'], key=lambda x: x['min_value']):
                if metric_value <= threshold['max_value']:
                    return int(threshold['star_value'])
            return 1  # Exceed all thresholds

        else:
            # For other metrics: HIGHER value = HIGHER stars
            # Thresholds already sorted descending, find first match
            for threshold in rule['thresholds']:
                if metric_value >= threshold['min_value']:
                    return int(threshold['star_value'])
            return 1  # Below all thresholds

    def calculate_overall_rating(
        self,
        employee_id: str,
        project_id: str,
        period: str
    ) -> Dict[str, Any]:
        """
        Calculate multi-dimensional rating for employee.
        Returns:
        {
            'overall_stars': float,
            'breakdown': [
                {
                    'dimension': str,
                    'rule_id': str,
                    'rule_name': str,
                    'description': str,
                    'dimension_stars': float,
                    'metric_value': float,
                    'metric_label': str,
                    'weight': float,
                    'weighted_contribution': float
                },
                ...
            ]
        }
        """
        rules = self.get_active_rules()
        breakdown = []
        weighted_sum = 0.0
        total_weight = 0.0

        for rule in rules:
            # Get metric for this dimension
            metric_data = self.calculate_metric(
                rule['dimension'],
                employee_id,
                project_id,
                period
            )

            # Apply thresholds to get dimension stars; default to 3 when no data
            if not metric_data['found']:
                dimension_stars = 3
            else:
                dimension_stars = self.apply_thresholds(metric_data['metric_value'], rule)

            # Calculate weighted contribution
            weight = rule['weight']
            weighted_contribution = dimension_stars * weight

            breakdown.append({
                'dimension': rule['dimension'],
                'rule_id': rule['rule_id'],
                'rule_name': rule['rule_name'],
                'description': rule['description'],
                'dimension_stars': float(dimension_stars),
                'metric_value': metric_data['metric_value'],
                'metric_label': metric_data['metric_label'],
                'metric_type': metric_data['metric_type'],
                'weight': weight,
                'weighted_contribution': weighted_contribution,
                'metric_found': metric_data['found']
            })

            weighted_sum += weighted_contribution
            total_weight += weight

        # Calculate overall rating (round to nearest 0.5)
        if total_weight > 0:
            overall = weighted_sum / total_weight
            overall_stars = round(overall * 2) / 2  # Round to nearest 0.5
        else:
            overall_stars = 3.0  # Default if no weight

        return {
            'overall_stars': overall_stars,
            'breakdown': breakdown,
            'calculation_date': datetime.utcnow().isoformat() + 'Z'
        }

    def store_rating_with_breakdown(
        self,
        employee_id: str,
        project_id: str,
        period: str,
        overall_stars: float,
        breakdown: List[Dict],
        manager_comment: Optional[str] = None,
        system_comment: Optional[str] = None
    ) -> bool:
        """
        Store rating and its breakdown in Neo4j.
        Creates HAS_PROJECT_RATING relationship and HAS_RATING_BREAKDOWN relationships.
        Returns: True if successful, False otherwise
        """
        try:
            with self.driver.session() as session:
                # 1. Create or update HAS_PROJECT_RATING relationship
                session.run("""
                    MATCH (e:Employee {employee_id: $employee_id})
                    MATCH (p:Project {project_id: $project_id})
                    MERGE (e)-[r:HAS_PROJECT_RATING {period: $period}]->(p)
                    SET
                        r.overall_stars = $overall_stars,
                        r.period = $period,
                        r.calculation_date = datetime(),
                        r.calculation_method = 'rules-v1.0'
                """, employee_id=employee_id, project_id=project_id,
                    period=period, overall_stars=overall_stars)

                # 2. Upsert HAS_RATING_BREAKDOWN relationships for each dimension
                for dim in breakdown:
                    session.run("""
                        MATCH (e:Employee {employee_id: $employee_id})
                        MATCH (p:Project {project_id: $project_id})
                        MERGE (e)-[r:HAS_RATING_BREAKDOWN {dimension: $dimension, period: $period}]->(p)
                        SET
                            r.dimension_stars = $dimension_stars,
                            r.rule_id = $rule_id,
                            r.metric_value = $metric_value,
                            r.metric_type = $metric_type,
                            r.weight = $weight,
                            r.weighted_contribution = $weighted_contribution
                    """,
                        employee_id=employee_id,
                        project_id=project_id,
                        dimension=dim['dimension'],
                        dimension_stars=dim['dimension_stars'],
                        rule_id=dim['rule_id'],
                        metric_value=dim['metric_value'],
                        metric_type=dim['metric_type'],
                        weight=dim['weight'],
                        weighted_contribution=dim['weighted_contribution'],
                        period=period
                    )

                # 3. Create/update RatingExplanation node and link it to the
                #    Employee and Project it explains (so it is traversable, not orphaned)
                explanation_id = f"EXPLAIN-{employee_id}-{project_id}-{period}"
                session.run("""
                    MATCH (e:Employee {employee_id: $employee_id})
                    MATCH (p:Project {project_id: $project_id})
                    MERGE (re:RatingExplanation {explanation_id: $explanation_id})
                    SET
                        re.employee_id = $employee_id,
                        re.project_id = $project_id,
                        re.period = $period,
                        re.overall_stars = $overall_stars,
                        re.calculation_date = datetime(),
                        re.calculation_method = 'rules-v1.0',
                        re.manager_comment = $manager_comment,
                        re.system_comment = $system_comment
                    MERGE (e)-[:HAS_RATING_EXPLANATION {period: $period}]->(re)
                    MERGE (re)-[:EXPLAINS_RATING_FOR]->(p)
                """,
                    explanation_id=explanation_id,
                    employee_id=employee_id,
                    project_id=project_id,
                    period=period,
                    overall_stars=overall_stars,
                    manager_comment=manager_comment,
                    system_comment=system_comment
                )

            return True
        except Exception as e:
            print(f"Error storing rating: {e}")
            return False
