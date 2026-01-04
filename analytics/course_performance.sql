-- COURSE 360 --
-- DOMAIN : EDTECH --
-- PURPOSE: COMPLETE COURSE PERFORMANCE & REVENUE ANALYTICS --

USE cortex_crms;


-- 1. VIEW : course_enrollments
-- PURPOSE : TRACK ENROLLMENT & COMPLETION METRICS 
CREATE course_enrollments AS
SELECT a.course_id, b.course_title,
COUNT(DISTINCT a.enrollment_id) AS total_enrollments,
COUNT(DISTINCT
CASE
WHEN c.order_status = 'Completed' THEN c.order_id
END) AS students_attending
FROM enrollments AS a
LEFT JOIN courses AS b ON a.course_id = b.course_id
LEFT JOIN orders AS c ON a.course_id = c.course_id AND c.student_id = a.student_id
GROUP BY course_id;

-- 2. VIEW : course_revenue
-- PURPOSE : REVENUE, ORDERS & REFUND ANALYSIS
CREATE VIEW course_revenue AS
SELECT a.course_id,
COUNT(DISTINCT a.order_id) AS total_orders,
SUM(
CASE
WHEN a.order_status = 'Completed' THEN total_amount
ELSE 0
END) AS gross_revenue,
SUM(c.refund_amount) AS total_refunds
FROM orders as a
LEFT JOIN payments AS b ON a.order_id = b.order_id 
LEFT JOIN refunds AS c ON b.payment_id = c.payment_id
GROUP BY a.course_id
ORDER BY gross_revenue;


