-- DATA INPUT --

USE cortex_crms;

-- 7. SUBSCRIPTION PLANS IN CORE ENTITIES--
INSERT INTO subscription_plans (plan_name, plan_price, plan_validity, course_discount, free_certicates) VALUES
('Basic Plan', 999.00, 'Monthly', 5.00, 0),
('Pro Plan', 2999.00, 'Quarterly', 10.00, 1),
('Premium Plan', 9999.00, 'Yearly', 20.00, 1);

-- 4. REFUND IN TRANSACTIONS --
INSERT INTO refunds (payment_id, refund_date, refund_amount, refund_reason) VALUES
(10, '2025-01-05', 4000.00, 'Not as expected'),
(225, '2025-01-08', 2000.00, 'Duplicate payment'),
(265, '2025-01-12', 1900.00, 'Technical issues with platform'),
(418, '2025-01-15', 1800.00, 'User requested cancellation'),
(535, '2025-01-18', 6500.00, 'I changed my plan dude');



