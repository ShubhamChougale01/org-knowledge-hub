// Rating Rules and Thresholds for Rule-Based Employee Rating System
// Phase 1: Define 5 rating dimensions with weights and thresholds
// Version: v1.0

// 1. TASK COMPLETION RULE (40% weight)
MERGE (rule_tc:RatingRule {
  rule_id: 'RULE-TASK-COMPLETION',
  name: 'Task Completion',
  dimension: 'PERFORMANCE',
  weight: 0.40,
  metric_source: 'ASSIGNED_TASK',
  version: 'v1.0',
  active: true,
  created_date: datetime()
})
SET rule_tc.description = 'Percentage of assigned tasks completed on time';

// Task Completion Thresholds
MERGE (t_tc_5:RatingThreshold {
  threshold_id: 'THRESHOLD-TC-5',
  rule_id: 'RULE-TASK-COMPLETION',
  min_value: 0.90,
  max_value: 1.00,
  star_value: 5
})
SET t_tc_5.description = '90-100% completion';
MATCH (rule:RatingRule {rule_id: 'RULE-TASK-COMPLETION'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_tc_5);

MERGE (t_tc_4:RatingThreshold {
  threshold_id: 'THRESHOLD-TC-4',
  rule_id: 'RULE-TASK-COMPLETION',
  min_value: 0.75,
  max_value: 0.89,
  star_value: 4
})
SET t_tc_4.description = '75-89% completion';
MATCH (rule:RatingRule {rule_id: 'RULE-TASK-COMPLETION'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_tc_4);

MERGE (t_tc_3:RatingThreshold {
  threshold_id: 'THRESHOLD-TC-3',
  rule_id: 'RULE-TASK-COMPLETION',
  min_value: 0.60,
  max_value: 0.74,
  star_value: 3
})
SET t_tc_3.description = '60-74% completion';
MATCH (rule:RatingRule {rule_id: 'RULE-TASK-COMPLETION'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_tc_3);

MERGE (t_tc_2:RatingThreshold {
  threshold_id: 'THRESHOLD-TC-2',
  rule_id: 'RULE-TASK-COMPLETION',
  min_value: 0.40,
  max_value: 0.59,
  star_value: 2
})
SET t_tc_2.description = '40-59% completion';
MATCH (rule:RatingRule {rule_id: 'RULE-TASK-COMPLETION'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_tc_2);

MERGE (t_tc_1:RatingThreshold {
  threshold_id: 'THRESHOLD-TC-1',
  rule_id: 'RULE-TASK-COMPLETION',
  min_value: 0.00,
  max_value: 0.39,
  star_value: 1
})
SET t_tc_1.description = 'Below 40% completion';
MATCH (rule:RatingRule {rule_id: 'RULE-TASK-COMPLETION'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_tc_1);

// 2. PUNCTUALITY & ATTENDANCE RULE (20% weight)
MERGE (rule_pa:RatingRule {
  rule_id: 'RULE-PUNCTUALITY',
  name: 'Punctuality & Attendance',
  dimension: 'RELIABILITY',
  weight: 0.20,
  metric_source: 'ATTENDANCE',
  version: 'v1.0',
  active: true,
  created_date: datetime()
})
SET rule_pa.description = 'Combined late days + absences (lower is better)';

// Punctuality Thresholds (penalty days: late_days + absence_days)
MERGE (t_pa_5:RatingThreshold {
  threshold_id: 'THRESHOLD-PA-5',
  rule_id: 'RULE-PUNCTUALITY',
  min_value: 0.0,
  max_value: 5.0,
  star_value: 5
})
SET t_pa_5.description = '0-5 penalty days';
MATCH (rule:RatingRule {rule_id: 'RULE-PUNCTUALITY'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_pa_5);

MERGE (t_pa_4:RatingThreshold {
  threshold_id: 'THRESHOLD-PA-4',
  rule_id: 'RULE-PUNCTUALITY',
  min_value: 6.0,
  max_value: 10.0,
  star_value: 4
})
SET t_pa_4.description = '6-10 penalty days';
MATCH (rule:RatingRule {rule_id: 'RULE-PUNCTUALITY'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_pa_4);

MERGE (t_pa_3:RatingThreshold {
  threshold_id: 'THRESHOLD-PA-3',
  rule_id: 'RULE-PUNCTUALITY',
  min_value: 11.0,
  max_value: 15.0,
  star_value: 3
})
SET t_pa_3.description = '11-15 penalty days';
MATCH (rule:RatingRule {rule_id: 'RULE-PUNCTUALITY'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_pa_3);

MERGE (t_pa_2:RatingThreshold {
  threshold_id: 'THRESHOLD-PA-2',
  rule_id: 'RULE-PUNCTUALITY',
  min_value: 16.0,
  max_value: 20.0,
  star_value: 2
})
SET t_pa_2.description = '16-20 penalty days';
MATCH (rule:RatingRule {rule_id: 'RULE-PUNCTUALITY'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_pa_2);

MERGE (t_pa_1:RatingThreshold {
  threshold_id: 'THRESHOLD-PA-1',
  rule_id: 'RULE-PUNCTUALITY',
  min_value: 21.0,
  max_value: 1000.0,
  star_value: 1
})
SET t_pa_1.description = '20+ penalty days';
MATCH (rule:RatingRule {rule_id: 'RULE-PUNCTUALITY'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_pa_1);

// 3. BEHAVIOR & COLLABORATION RULE (20% weight)
MERGE (rule_bc:RatingRule {
  rule_id: 'RULE-BEHAVIOR',
  name: 'Behavior & Collaboration',
  dimension: 'TEAMWORK',
  weight: 0.20,
  metric_source: 'MANAGER_FEEDBACK',
  version: 'v1.0',
  active: true,
  created_date: datetime()
})
SET rule_bc.description = 'Manager feedback score on teamwork and communication (1-100)';

// Behavior Thresholds (feedback score 1-100)
MERGE (t_bc_5:RatingThreshold {
  threshold_id: 'THRESHOLD-BC-5',
  rule_id: 'RULE-BEHAVIOR',
  min_value: 90.0,
  max_value: 100.0,
  star_value: 5
})
SET t_bc_5.description = '90-100 feedback score';
MATCH (rule:RatingRule {rule_id: 'RULE-BEHAVIOR'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_bc_5);

MERGE (t_bc_4:RatingThreshold {
  threshold_id: 'THRESHOLD-BC-4',
  rule_id: 'RULE-BEHAVIOR',
  min_value: 80.0,
  max_value: 89.0,
  star_value: 4
})
SET t_bc_4.description = '80-89 feedback score';
MATCH (rule:RatingRule {rule_id: 'RULE-BEHAVIOR'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_bc_4);

MERGE (t_bc_3:RatingThreshold {
  threshold_id: 'THRESHOLD-BC-3',
  rule_id: 'RULE-BEHAVIOR',
  min_value: 70.0,
  max_value: 79.0,
  star_value: 3
})
SET t_bc_3.description = '70-79 feedback score';
MATCH (rule:RatingRule {rule_id: 'RULE-BEHAVIOR'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_bc_3);

MERGE (t_bc_2:RatingThreshold {
  threshold_id: 'THRESHOLD-BC-2',
  rule_id: 'RULE-BEHAVIOR',
  min_value: 60.0,
  max_value: 69.0,
  star_value: 2
})
SET t_bc_2.description = '60-69 feedback score';
MATCH (rule:RatingRule {rule_id: 'RULE-BEHAVIOR'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_bc_2);

MERGE (t_bc_1:RatingThreshold {
  threshold_id: 'THRESHOLD-BC-1',
  rule_id: 'RULE-BEHAVIOR',
  min_value: 0.0,
  max_value: 59.0,
  star_value: 1
})
SET t_bc_1.description = 'Below 60 feedback score';
MATCH (rule:RatingRule {rule_id: 'RULE-BEHAVIOR'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_bc_1);

// 4. LEARNING & GROWTH RULE (10% weight)
MERGE (rule_lg:RatingRule {
  rule_id: 'RULE-LEARNING',
  name: 'Learning & Growth',
  dimension: 'DEVELOPMENT',
  weight: 0.10,
  metric_source: 'CERTIFICATION_COUNT',
  version: 'v1.0',
  active: true,
  created_date: datetime()
})
SET rule_lg.description = 'Certifications and new skills acquired in period';

// Learning Thresholds (count of certifications/skills)
MERGE (t_lg_5:RatingThreshold {
  threshold_id: 'THRESHOLD-LG-5',
  rule_id: 'RULE-LEARNING',
  min_value: 3.0,
  max_value: 1000.0,
  star_value: 5
})
SET t_lg_5.description = '3+ certifications/skills';
MATCH (rule:RatingRule {rule_id: 'RULE-LEARNING'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_lg_5);

MERGE (t_lg_4:RatingThreshold {
  threshold_id: 'THRESHOLD-LG-4',
  rule_id: 'RULE-LEARNING',
  min_value: 2.0,
  max_value: 2.99,
  star_value: 4
})
SET t_lg_4.description = '2 certifications/skills';
MATCH (rule:RatingRule {rule_id: 'RULE-LEARNING'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_lg_4);

MERGE (t_lg_3:RatingThreshold {
  threshold_id: 'THRESHOLD-LG-3',
  rule_id: 'RULE-LEARNING',
  min_value: 1.0,
  max_value: 1.99,
  star_value: 3
})
SET t_lg_3.description = '1 certification/skill';
MATCH (rule:RatingRule {rule_id: 'RULE-LEARNING'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_lg_3);

MERGE (t_lg_1:RatingThreshold {
  threshold_id: 'THRESHOLD-LG-1',
  rule_id: 'RULE-LEARNING',
  min_value: 0.0,
  max_value: 0.99,
  star_value: 1
})
SET t_lg_1.description = 'No certifications/skills acquired';
MATCH (rule:RatingRule {rule_id: 'RULE-LEARNING'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_lg_1);

// 5. WORK QUALITY RULE (10% weight)
MERGE (rule_wq:RatingRule {
  rule_id: 'RULE-QUALITY',
  name: 'Work Quality',
  dimension: 'CRAFTSMANSHIP',
  weight: 0.10,
  metric_source: 'BUG_RATIO',
  version: 'v1.0',
  active: true,
  created_date: datetime()
})
SET rule_wq.description = 'Bug ratio: bugs reported / tasks completed (lower is better)';

// Quality Thresholds (bug ratio as percentage)
MERGE (t_wq_5:RatingThreshold {
  threshold_id: 'THRESHOLD-WQ-5',
  rule_id: 'RULE-QUALITY',
  min_value: 0.0,
  max_value: 0.05,
  star_value: 5
})
SET t_wq_5.description = '<5% bug ratio';
MATCH (rule:RatingRule {rule_id: 'RULE-QUALITY'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_wq_5);

MERGE (t_wq_4:RatingThreshold {
  threshold_id: 'THRESHOLD-WQ-4',
  rule_id: 'RULE-QUALITY',
  min_value: 0.05,
  max_value: 0.10,
  star_value: 4
})
SET t_wq_4.description = '5-10% bug ratio';
MATCH (rule:RatingRule {rule_id: 'RULE-QUALITY'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_wq_4);

MERGE (t_wq_3:RatingThreshold {
  threshold_id: 'THRESHOLD-WQ-3',
  rule_id: 'RULE-QUALITY',
  min_value: 0.10,
  max_value: 0.20,
  star_value: 3
})
SET t_wq_3.description = '10-20% bug ratio';
MATCH (rule:RatingRule {rule_id: 'RULE-QUALITY'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_wq_3);

MERGE (t_wq_2:RatingThreshold {
  threshold_id: 'THRESHOLD-WQ-2',
  rule_id: 'RULE-QUALITY',
  min_value: 0.20,
  max_value: 0.40,
  star_value: 2
})
SET t_wq_2.description = '20-40% bug ratio';
MATCH (rule:RatingRule {rule_id: 'RULE-QUALITY'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_wq_2);

MERGE (t_wq_1:RatingThreshold {
  threshold_id: 'THRESHOLD-WQ-1',
  rule_id: 'RULE-QUALITY',
  min_value: 0.40,
  max_value: 1.00,
  star_value: 1
})
SET t_wq_1.description = '>40% bug ratio';
MATCH (rule:RatingRule {rule_id: 'RULE-QUALITY'})
MERGE (rule)-[:HAS_THRESHOLD]->(t_wq_1);
