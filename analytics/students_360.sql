-- STUDENT 360 --
-- DOMAIN: EDTECH | COMPLETE-360 DEGREE STUDENT DATA & METRICS --


USE cortex_crms;

-- PROCEDURE: student_360  --
-- PURPOSE: GENERATE 360-DEGREE LEVEL STUDENT ANALYTICS VIEWS --

DELIMITER $$

CREATE PROCEDURE students_360()

BEGIN

-- 1. VIEW: student_info | PURPOSE: BASIC STUDENT INFO WITH ACTIVITY FILTER  --
CREATE VIEW student_info AS
SELECT student_id, first_name, phone 
FROM students;

-- 2. VIEW: learning_progress | PURPOSE: TO UNDERSTAND THE LEARNING PROGRESS OF EACH STUDENT --
CREATE VIEW learning_progress AS
SELECT a.student_id, a.first_name, 
COUNT(DISTINCT b.course_id) AS total_course_enrolled,
SUM(CASE WHEN status='Completed' THEN 1 else 0 END) AS courses_completed,
ROUND(AVG(b.progress_percent),2) AS avg_progress_in_percent
FROM students AS a
LEFT JOIN student_progress AS b on a.student_id = b.student_id
LEFT JOIN enrollments AS c on a.student_id = c.student_id
GROUP BY a.student_id ORDER BY avg_progress_in_percent desc;

-- 3. VIEW: student_engagement | PURPOSE: TO TRACK ENGAGEMENT LEVEL OF EACH STUDENT --
-- TO IDENTIFY THE STUDENTS AT RISK OF CHURN--
CREATE VIEW student_engagement AS
SELECT a.student_id, b.first_name,
MAX(a.login_date) AS last_login,
CASE
WHEN DATEDIFF(CURRENT_DATE(), MAX(a.login_date)) >200 THEN "at_risk"
WHEN DATEDIFF(CURRENT_DATE(), MAX(a.login_date)) <50 THEN "high"
ELSE "normal"
END AS churn_signal
FROM logins as a
LEFT JOIN students as b on a.student_id=b.student_id
GROUP BY a.student_id;

-- 4. VIEW: student_reviews | PURPOSE: ANALYZE FEEDBACK & RATING BEHAVIOR --
CREATE VIEW student_reviews AS
SELECT a.student_id, b.first_name,
COUNT(review_id) AS total_reviews,
ROUND(AVG(rating),2) AS avg_rating_given
FROM course_reviews as a
RIGHT JOIN students as b on a.student_id=b.student_id
GROUP BY a.student_id, b.first_name;

-- 5. VIEW : student_financials | PURPOSE : TRACK SPENDING, PAYMENTS & SUBSCRIPTIONS --
CREATE VIEW student_financials AS
SELECT a.student_id, first_name,
COUNT(DISTINCT a.order_id) AS total_orders,
SUM(a.total_amount) AS total_spent,
SUM(CASE
WHEN c.payment_status = 'success' THEN a.total_amount
ELSE 0 
END) AS successful_payment_amount, MAX(e.plan_name) AS subscription_plan,
MAX(CASE
WHEN CURRENT_DATE() BETWEEN d.start_date AND d.end_date THEN 'active'
ELSE 'expired'
END) AS subscription_status
FROM orders AS a
LEFT JOIN students AS b ON a.student_id=b.student_id
LEFT JOIN payments c ON a.order_id = c.order_id
LEFT JOIN subscriptions d ON a.student_id = d.student_id
LEFT JOIN subscription_plans e ON d.plan_id = e.plan_id
GROUP BY a.student_id
ORDER BY successful_payment_amount desc;

END $$

DELIMITER ;

CALL students_360();

-- 6. COMPLETE 360 DEGREE LEVEL STUDENT DATASET --
CREATE VIEW student_360 AS
SELECT a.student_id, b.first_name, b.total_course_enrolled, b.courses_completed, b.avg_progress_in_percent,  
c.last_login, c.churn_signal,  d.total_reviews, d.avg_rating_given, e.total_orders, e.total_spent, 
e.successful_payment_amount, e.subscription_plan, e.subscription_status
FROM student_info AS a
LEFT JOIN learning_progress AS b ON a.student_id = b.student_id
LEFT JOIN student_engagement AS c ON a.student_id = c.student_id
LEFT JOIN student_reviews AS d ON a.student_id = d.student_id
LEFT JOIN student_financials AS e ON a.student_id = e.student_id;


-- VIEW : student_info
SELECT * FROM student_info;
-- VIEW : learning_progress
SELECT * FROM learning_progress;
-- VIEW : student_engagement
SELECT * FROM student_engagement;
-- VIEW : student_reviews
SELECT * FROM student_reviews;
-- VIEW : student_financials
SELECT * FROM student_financials;
-- VIEW : student_360 (FINAL VIEW)
SELECT * FROM student_360;

