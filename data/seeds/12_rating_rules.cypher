// Rating Rules and Thresholds for Rule-Based Employee Rating System
// Phase 1: Define 5 rating dimensions with weights and thresholds
// Version: v1.0
//
// NOTE: Each threshold below binds the RatingRule, the RatingThreshold node, and the
// HAS_THRESHOLD relationship in a SINGLE statement. The loader (data/load_data.py) and
// Neo4j Browser both run each ;-terminated statement in its own scope, so a variable
// defined in one statement is UNBOUND in the next. Splitting the node MERGE from the
// relationship MERGE caused HAS_THRESHOLD to point at brand-new anonymous nodes instead
// of the threshold. Keep node + relationship together.

// 1. TASK COMPLETION RULE (40% weight)
// MERGE on rule_id only, then SET the rest. MERGE-ing on a property map that includes
// created_date: datetime() would never match on re-run (new timestamp each time) and
// would violate the rule_id uniqueness constraint. Keep volatile props out of the key.
MERGE (rule_tc:RatingRule {rule_id: 'RULE-TASK-COMPLETION'})
ON CREATE SET rule_tc.created_date = datetime()
SET rule_tc.name = 'Task Completion',
    rule_tc.dimension = 'PERFORMANCE',
    rule_tc.weight = 0.40,
    rule_tc.metric_source = 'ASSIGNED_TASK',
    rule_tc.version = 'v1.0',
    rule_tc.active = true,
    rule_tc.description = 'Percentage of assigned tasks completed on time';

// Task Completion Thresholds
MATCH (rule:RatingRule {rule_id: 'RULE-TASK-COMPLETION'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-TC-5'})
SET t.rule_id = 'RULE-TASK-COMPLETION', t.min_value = 0.90, t.max_value = 1.00, t.star_value = 5, t.description = '90-100% completion'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

MATCH (rule:RatingRule {rule_id: 'RULE-TASK-COMPLETION'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-TC-4'})
SET t.rule_id = 'RULE-TASK-COMPLETION', t.min_value = 0.75, t.max_value = 0.89, t.star_value = 4, t.description = '75-89% completion'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

MATCH (rule:RatingRule {rule_id: 'RULE-TASK-COMPLETION'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-TC-3'})
SET t.rule_id = 'RULE-TASK-COMPLETION', t.min_value = 0.60, t.max_value = 0.74, t.star_value = 3, t.description = '60-74% completion'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

MATCH (rule:RatingRule {rule_id: 'RULE-TASK-COMPLETION'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-TC-2'})
SET t.rule_id = 'RULE-TASK-COMPLETION', t.min_value = 0.40, t.max_value = 0.59, t.star_value = 2, t.description = '40-59% completion'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

MATCH (rule:RatingRule {rule_id: 'RULE-TASK-COMPLETION'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-TC-1'})
SET t.rule_id = 'RULE-TASK-COMPLETION', t.min_value = 0.00, t.max_value = 0.39, t.star_value = 1, t.description = 'Below 40% completion'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

// 2. PUNCTUALITY & ATTENDANCE RULE (20% weight)
MERGE (rule_pa:RatingRule {rule_id: 'RULE-PUNCTUALITY'})
ON CREATE SET rule_pa.created_date = datetime()
SET rule_pa.name = 'Punctuality & Attendance',
    rule_pa.dimension = 'RELIABILITY',
    rule_pa.weight = 0.20,
    rule_pa.metric_source = 'ATTENDANCE',
    rule_pa.version = 'v1.0',
    rule_pa.active = true,
    rule_pa.description = 'Combined late days + absences (lower is better)';

// Punctuality Thresholds (penalty days: late_days + absence_days)
MATCH (rule:RatingRule {rule_id: 'RULE-PUNCTUALITY'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-PA-5'})
SET t.rule_id = 'RULE-PUNCTUALITY', t.min_value = 0.0, t.max_value = 5.0, t.star_value = 5, t.description = '0-5 penalty days'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

MATCH (rule:RatingRule {rule_id: 'RULE-PUNCTUALITY'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-PA-4'})
SET t.rule_id = 'RULE-PUNCTUALITY', t.min_value = 6.0, t.max_value = 10.0, t.star_value = 4, t.description = '6-10 penalty days'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

MATCH (rule:RatingRule {rule_id: 'RULE-PUNCTUALITY'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-PA-3'})
SET t.rule_id = 'RULE-PUNCTUALITY', t.min_value = 11.0, t.max_value = 15.0, t.star_value = 3, t.description = '11-15 penalty days'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

MATCH (rule:RatingRule {rule_id: 'RULE-PUNCTUALITY'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-PA-2'})
SET t.rule_id = 'RULE-PUNCTUALITY', t.min_value = 16.0, t.max_value = 20.0, t.star_value = 2, t.description = '16-20 penalty days'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

MATCH (rule:RatingRule {rule_id: 'RULE-PUNCTUALITY'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-PA-1'})
SET t.rule_id = 'RULE-PUNCTUALITY', t.min_value = 21.0, t.max_value = 1000.0, t.star_value = 1, t.description = '20+ penalty days'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

// 3. BEHAVIOR & COLLABORATION RULE (20% weight)
MERGE (rule_bc:RatingRule {rule_id: 'RULE-BEHAVIOR'})
ON CREATE SET rule_bc.created_date = datetime()
SET rule_bc.name = 'Behavior & Collaboration',
    rule_bc.dimension = 'TEAMWORK',
    rule_bc.weight = 0.20,
    rule_bc.metric_source = 'MANAGER_FEEDBACK',
    rule_bc.version = 'v1.0',
    rule_bc.active = true,
    rule_bc.description = 'Manager feedback score on teamwork and communication (1-100)';

// Behavior Thresholds (feedback score 1-100)
MATCH (rule:RatingRule {rule_id: 'RULE-BEHAVIOR'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-BC-5'})
SET t.rule_id = 'RULE-BEHAVIOR', t.min_value = 90.0, t.max_value = 100.0, t.star_value = 5, t.description = '90-100 feedback score'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

MATCH (rule:RatingRule {rule_id: 'RULE-BEHAVIOR'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-BC-4'})
SET t.rule_id = 'RULE-BEHAVIOR', t.min_value = 80.0, t.max_value = 89.0, t.star_value = 4, t.description = '80-89 feedback score'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

MATCH (rule:RatingRule {rule_id: 'RULE-BEHAVIOR'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-BC-3'})
SET t.rule_id = 'RULE-BEHAVIOR', t.min_value = 70.0, t.max_value = 79.0, t.star_value = 3, t.description = '70-79 feedback score'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

MATCH (rule:RatingRule {rule_id: 'RULE-BEHAVIOR'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-BC-2'})
SET t.rule_id = 'RULE-BEHAVIOR', t.min_value = 60.0, t.max_value = 69.0, t.star_value = 2, t.description = '60-69 feedback score'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

MATCH (rule:RatingRule {rule_id: 'RULE-BEHAVIOR'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-BC-1'})
SET t.rule_id = 'RULE-BEHAVIOR', t.min_value = 0.0, t.max_value = 59.0, t.star_value = 1, t.description = 'Below 60 feedback score'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

// 4. LEARNING & GROWTH RULE (10% weight)
MERGE (rule_lg:RatingRule {rule_id: 'RULE-LEARNING'})
ON CREATE SET rule_lg.created_date = datetime()
SET rule_lg.name = 'Learning & Growth',
    rule_lg.dimension = 'DEVELOPMENT',
    rule_lg.weight = 0.10,
    rule_lg.metric_source = 'CERTIFICATION_COUNT',
    rule_lg.version = 'v1.0',
    rule_lg.active = true,
    rule_lg.description = 'Certifications and new skills acquired in period';

// Learning Thresholds (count of certifications/skills)
MATCH (rule:RatingRule {rule_id: 'RULE-LEARNING'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-LG-5'})
SET t.rule_id = 'RULE-LEARNING', t.min_value = 3.0, t.max_value = 1000.0, t.star_value = 5, t.description = '3+ certifications/skills'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

MATCH (rule:RatingRule {rule_id: 'RULE-LEARNING'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-LG-4'})
SET t.rule_id = 'RULE-LEARNING', t.min_value = 2.0, t.max_value = 2.99, t.star_value = 4, t.description = '2 certifications/skills'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

MATCH (rule:RatingRule {rule_id: 'RULE-LEARNING'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-LG-3'})
SET t.rule_id = 'RULE-LEARNING', t.min_value = 1.0, t.max_value = 1.99, t.star_value = 3, t.description = '1 certification/skill'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

MATCH (rule:RatingRule {rule_id: 'RULE-LEARNING'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-LG-1'})
SET t.rule_id = 'RULE-LEARNING', t.min_value = 0.0, t.max_value = 0.99, t.star_value = 1, t.description = 'No certifications/skills acquired'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

// 5. WORK QUALITY RULE (10% weight)
MERGE (rule_wq:RatingRule {rule_id: 'RULE-QUALITY'})
ON CREATE SET rule_wq.created_date = datetime()
SET rule_wq.name = 'Work Quality',
    rule_wq.dimension = 'CRAFTSMANSHIP',
    rule_wq.weight = 0.10,
    rule_wq.metric_source = 'BUG_RATIO',
    rule_wq.version = 'v1.0',
    rule_wq.active = true,
    rule_wq.description = 'Bug ratio: bugs reported / tasks completed (lower is better)';

// Quality Thresholds (bug ratio as percentage)
MATCH (rule:RatingRule {rule_id: 'RULE-QUALITY'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-WQ-5'})
SET t.rule_id = 'RULE-QUALITY', t.min_value = 0.0, t.max_value = 0.05, t.star_value = 5, t.description = '<5% bug ratio'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

MATCH (rule:RatingRule {rule_id: 'RULE-QUALITY'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-WQ-4'})
SET t.rule_id = 'RULE-QUALITY', t.min_value = 0.05, t.max_value = 0.10, t.star_value = 4, t.description = '5-10% bug ratio'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

MATCH (rule:RatingRule {rule_id: 'RULE-QUALITY'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-WQ-3'})
SET t.rule_id = 'RULE-QUALITY', t.min_value = 0.10, t.max_value = 0.20, t.star_value = 3, t.description = '10-20% bug ratio'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

MATCH (rule:RatingRule {rule_id: 'RULE-QUALITY'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-WQ-2'})
SET t.rule_id = 'RULE-QUALITY', t.min_value = 0.20, t.max_value = 0.40, t.star_value = 2, t.description = '20-40% bug ratio'
MERGE (rule)-[:HAS_THRESHOLD]->(t);

MATCH (rule:RatingRule {rule_id: 'RULE-QUALITY'})
MERGE (t:RatingThreshold {threshold_id: 'THRESHOLD-WQ-1'})
SET t.rule_id = 'RULE-QUALITY', t.min_value = 0.40, t.max_value = 1.00, t.star_value = 1, t.description = '>40% bug ratio'
MERGE (rule)-[:HAS_THRESHOLD]->(t);
