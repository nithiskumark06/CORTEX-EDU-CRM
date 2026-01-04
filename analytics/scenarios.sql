-- DOMAIN: EDTECH ANALYTICS SCENARIOS

-- 1. MOST ENGAGED STUDENTS THIS MONTH
SELECT student_id, first_name, subscription_plan, total_course_enrolled, 
avg_progress_in_percent, 
IF(DATEDIFF(CURRENT_DATE(), MAX(last_login)) < 30, MAX(last_login), NULL) AS last_active_at
FROM student_360
GROUP BY student_id HAVING last_active_at IS NOT NULL;

-- 2. AVERAGE COURSE PROGRESS RATE PER COHORT
SELECT ELT(a.cohort_month, 'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec') AS cohort_monthS, 
b.course_id, D.course_title, c.avg_progress_in_percent, a.cohort_size AS num_students_in_cohort
FROM cohort_360 AS a 
LEFT JOIN enrollments AS b ON a.student_id = b.student_id
LEFT JOIN  student_360 AS c ON a.student_id = c.student_id
LEFT JOIN  courses AS d ON b.course_id = d.course_id
ORDER BY a.cohort_month;

-- 3. STUDENTS AT RISK OF CHURN
SELECT student_id, first_name, last_login, churn_signal, subscription_status
FROM student_360
WHERE churn_signal = 'at_risk';

-- 4. HIGH REVENUE BUT LOW PARTICIPATION COURSES
SELECT a.course_id, a.course_title, b.gross_revenue,
ROUND(a.students_attending / NULLIF(a.total_enrollments, 0) *100, 2) AS participation_rate
FROM course_enrollments AS a
LEFT JOIN course_revenue AS b on a.course_id = b.course_id
GROUP BY course_id
HAVING b.gross_revenue >= AVG(b.gross_revenue) AND participation_rate < 70.00;

-- 5. INSTRUCTOR RANKING BASED ON PERFORMANCE
SELECT RANK() OVER (ORDER BY total_revenue_generated DESC) AS instructor_rank,
instructor_id, full_name, num_courses_taught, total_revenue_generated, avg_course_rating
 FROM( 
SELECT  a.instructor_id, a.full_name, 
COUNT(b.course_id) AS num_courses_taught, 
SUM(c.gross_revenue) AS total_revenue_generated, 
ROUND(AVG(rating), 2) AS avg_course_rating
FROM instructors AS a
LEFT JOIN courses AS b ON a.instructor_id = b.instructor_id
LEFT JOIN course_revenue AS c ON b.course_id = c.course_id
LEFT JOIN course_reviews AS d ON b.course_id = d.course_id
GROUP BY a.instructor_id) t

-- 6. IMPACT OF DISCOUNTS
SELECT a.plan_id, a.plan_name, 
SUM(c.discount) AS total_discount,
SUM(c.total_amount) AS total_payment,
COUNT(enrollment_id) AS num_enrollments
FROM subscription_plans AS a
LEFT JOIN subscriptions AS b on a.plan_id = b.plan_id
LEFT JOIN orders AS c ON b.student_id = c.student_id 
LEFT JOIN enrollments AS d ON b.student_id = d.student_id
GROUP BY a.plan_id;

-- 7. COURSES WITH HIGH RATINGS BUT LOW ENGAGEMENT
SELECT a.course_id, a.course_title, 
ROUND(AVG(c.avg_rating_given),2) AS avg_ratings, 
ROUND(AVG(c.avg_progress_in_percent),2) AS avg_progress, 
COUNT(b.enrollment_id) AS num_students_enrolled
FROM courses AS a 
LEFT JOIN enrollments AS b ON a.course_id = b.course_id
LEFT JOIN student_360 AS c ON b.student_id = c.student_id
GROUP BY course_id
HAVING avg_ratings >= 5 AND avg_progress <= 50.00
ORDER BY avg_ratings DESC;
