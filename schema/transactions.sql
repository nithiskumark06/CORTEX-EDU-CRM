-- TRANSACTIONAL DATA --
-- DOAMAIN: EDTECH MONETIZATION & REVENUE --

USE cortex_crms;


-- 1. SUBSCRIPTIONS --
CREATE TABLE subcriptions(
subscription_id INT AUTO_INCREMENT PRIMARY KEY,
plan_id INT NOT NULL,
student_id INT NOT NULL,
start_date DATE NOT NULL,
end_date DATE NOT NULL,
	FOREIGN KEY(plan_id) REFERENCES subscription_plans(plan_id),
    FOREIGN KEY(student_id) REFERENCES students(student_id)
);


-- 2. ORDERS --
CREATE TABLE orders(
order_id INT AUTO_INCREMENT PRIMARY KEY,
student_id INT NOT NULL,
course_id INT NOT NULL,
order_date DATETIME NOT NULL,
order_status ENUM('Pending', 'Completed', 'Cancelled', 'Refunded') NOT NULL,
base_amount DECIMAL(10,2) NOT NULL,
discount DECIMAL(10,2) DEFAULT 0.00,
total_amount DECIMAL(10,2) NOT NULL,
payment_method ENUM('Card', 'UPI', 'NetBanking'),
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

	FOREIGN KEY(student_id) REFERENCES students(student_id),
    FOREIGN KEY(course_id) REFERENCES courses(course_id)
);


-- 3. PAYMENTS --
CREATE TABLE payments(
payment_id INT AUTO_INCREMENT PRIMARY KEY,
order_id INT NOT NULL,
payment_date DATETIME NOT NULL,
payment_status ENUM('Success', 'Failed', 'Pending') NOT NULL,

	FOREIGN KEY(order_id) REFERENCES orders(order_id)
);


-- 4. REFUNDS --
CREATE TABLE refunds(
refund_id INT AUTO_INCREMENT PRIMARY KEY,
payment_id INT NOT NULL,
refund_date DATE NOT NULL,
refund_amount DECIMAL(10,2) NOT NULL,
refund_reason VARCHAR(200),

	  FOREIGN KEY(payment_id) REFERENCES payments(payment_id)
);

-- 5. REVENUE LEDGER --
CREATE TABLE revenue_ledger(
ledger_id BIGINT AUTO_INCREMENT PRIMARY KEY,
student_id INT,
course_id INT,
transaction_date DATE NOT NULL,
transaction_type ENUM('Course Purchase','Subscription','Certificate','Refund') NOT NULL,
amount  DECIMAL(10,2) NOT NULL
);