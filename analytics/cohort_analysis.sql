-- STUDENT 360 --
-- DOMAIN : EDTECH --
-- ANALYSIS : COHORT RETENTION ANALYSIS --
-- COHORT : FIRST SUCCESSFUL PAID ENROLLMENT MONTH --

USE cortex_crms;


-- 1. VIEW : first_paid_enrollment --
-- PURPOSE : IDENTIFY FIRST SUCCESSFUL PAID ENROLLMENT --
CREATE VIEW first_paid_enrollment AS
SELECT a.student_id, b.first_name,
MIN(c.order_date) AS cohort_date
FROM enrollments a
LEFT JOIN students AS b ON a.student_id=b.student_id
LEFT JOIN orders c ON a.student_id=c.student_id AND a.course_id = c.course_id
WHERE c.order_status = 'COMPLETED'
GROUP BY a.student_id;

-- 2. VIEW : student_cohort_activity --
-- PURPOSE: MAP STUDENT ORDERS TO COHORT MONTH --
CREATE VIEW student_cohort_activity AS
SELECT a.student_id, b.first_name,
month(b.cohort_date) as cohort_month, 
PERIOD_DIFF(DATE_FORMAT(a.order_date, '%Y%m'), DATE_FORMAT(b.cohort_date, '%Y%m')) as months_since_cohort
FROM orders AS a
LEFT JOIN first_paid_enrollment as b on a.student_id = b.student_id
WHERE a.order_status = 'Completed'
ORDER BY months_since_cohort desc;

-- 3. VIEW : cohort_metrics | PURPOSE : CALCULATE ACTIVE STUDENTS AND COHORT SIZE USING WINDOW FUNCTIONS
CREATE VIEW cohort_metrics AS
SELECT cohort_month, months_since_cohort,
COUNT(DISTINCT student_id) AS active_students,
MAX(COUNT(DISTINCT student_id)) OVER (PARTITION BY cohort_month) AS cohort_size,
ROUND(COUNT(DISTINCT student_id) * 100.0/ 
MAX(COUNT(DISTINCT student_id)) OVER (PARTITION BY cohort_month), 2) AS retention_percentage
FROM student_cohort_activity
GROUP BY cohort_month, months_since_cohort
ORDER BY cohort_month, months_since_cohort;


-- VIEW : first_paid_enrollment
SELECT * FROM first_paid_enrollment;

-- VIEW : student_cohort_activity
SELECT * FROM student_cohort_activity;

-- VIEW : cohort_metrics
SELECT * FROM cohort_metrics;