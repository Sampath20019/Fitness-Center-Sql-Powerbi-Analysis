SELECT * FROM USERS;
SELECT * FROM PAYMENTS;
SELECT * FROM EXPENSES;

SELECT COUNT(*) AS TOTAL_USERS
FROM USERS;

SELECT COUNT(*) AS TOTAL_PAYMENTS
FROM PAYMENTS;

SELECT COUNT(*) AS TOTAL_EXPENSES
FROM EXPENSES;


-- FITNESS CENTER BUSINESS ANALYSIS
-- Database: Oracle
-- Tables: USERS, PAYMENTS, EXPENSES

-- ============================================================
-- OVERALL BUSINESS OVERVIEW
-- Analyze overall fitness center performance using
-- customer count, payment count and revenue metrics.
-- ============================================================
-- OVERALL BUSINESS OVERVIEW
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM USERS) AS TOTAL_CUSTOMERS,
    (SELECT COUNT(*) FROM PAYMENTS) AS TOTAL_PAYMENTS,
    (SELECT SUM(AMOUNT) FROM PAYMENTS) AS TOTAL_REVENUE,
    (SELECT ROUND(AVG(AMOUNT), 2) FROM PAYMENTS) AS AVERAGE_PAYMENT,
    (SELECT MIN(AMOUNT) FROM PAYMENTS) AS MIN_PAYMENT,
    (SELECT MAX(AMOUNT) FROM PAYMENTS) AS MAX_PAYMENT
FROM DUAL;
-- BUSINESS INSIGHT:
-- The fitness center has 100 registered customers and
-- recorded 100 payment transactions, generating total
-- revenue of ₹40,90,000.
-- The average payment is ₹40,900, while payment values
-- range from ₹10,000 to ₹80,000.
-- ============================================================
-- MEMBERSHIP ANALYSIS
-- Analyze the number of customers across different
-- membership types.
-- ============================================================
SELECT
    MEMBERSHIP,
    COUNT(*) AS TOTAL_MEMBERS
FROM USERS
GROUP BY MEMBERSHIP
ORDER BY TOTAL_MEMBERS DESC;
-- BUSINESS INSIGHT:
-- Gold membership is the most popular with 35 customers (35%).
-- Platinum membership has 33 customers (33%), while Silver has 32 customers (32%).
-- The membership distribution is relatively balanced across all three membership types.

-- Analyze active and expired memberships.

SELECT
    STATUS,
    COUNT(*) AS TOTAL_MEMBERS
FROM USERS
GROUP BY STATUS
ORDER BY TOTAL_MEMBERS DESC;

-- BUSINESS INSIGHT:
-- 56 customers (56%) have expired memberships,
-- while 44 customers (44%) have active memberships.
-- The higher number of expired memberships indicates
-- a potential customer retention and renewal opportunity.

-- Analyze membership type and membership status together.

SELECT
    MEMBERSHIP,
    STATUS,
    COUNT(*) AS TOTAL_MEMBERS
FROM USERS
GROUP BY MEMBERSHIP, STATUS
ORDER BY MEMBERSHIP, STATUS;
-- BUSINESS INSIGHT:
-- Gold has 15 active and 20 expired members.
-- Platinum has 18 active and 15 expired members.
-- Silver has 11 active and 21 expired members.
-- Silver has the highest number of expired memberships,
-- indicating a strong opportunity for customer renewal and retention.
-- Platinum has the highest number of active members.

-- ============================================================
-- REVENUE ANALYSIS
-- Analyze revenue based on payment status.
-- ============================================================

SELECT
    STATUS,
    COUNT(*) AS TOTAL_PAYMENTS,
    SUM(AMOUNT) AS TOTAL_REVENUE,
    ROUND(AVG(AMOUNT), 2) AS AVERAGE_PAYMENT
FROM PAYMENTS
GROUP BY STATUS
ORDER BY TOTAL_REVENUE DESC;

-- BUSINESS INSIGHT:
-- All 100 payment transactions are marked as Paid,
-- representing 100% successful payment transactions.
-- The fitness center generated total recorded revenue of ₹40,90,000.
-- The average payment amount is ₹40,900 per transaction.

-- Analyze revenue generated through different payment modes.

SELECT
    PAYMENT_MODE,
    COUNT(*) AS TOTAL_PAYMENTS,
    SUM(AMOUNT) AS TOTAL_REVENUE,
    ROUND(AVG(AMOUNT), 2) AS AVERAGE_PAYMENT
FROM PAYMENTS
GROUP BY PAYMENT_MODE
ORDER BY TOTAL_REVENUE DESC;
-- BUSINESS INSIGHT:
-- Online payment has the highest number of transactions with 34 payments.
-- However, Card payments generate the highest revenue of ₹15,50,000.
-- Card also has the highest average payment value of ₹46,969.70.
-- Online generated ₹12,80,000, while Cash generated ₹12,60,000.
-- The higher average transaction value of Card payments makes it
-- the strongest payment mode in terms of revenue generation.

-- ============================================================
-- EXPENSE ANALYSIS
-- Analyze overall fitness center expenses.
-- ============================================================

SELECT
    COUNT(*) AS TOTAL_EXPENSE_RECORDS,
    SUM(AMOUNT) AS TOTAL_EXPENSES,
    ROUND(AVG(AMOUNT), 2) AS AVERAGE_EXPENSE,
    MIN(AMOUNT) AS MIN_EXPENSE,
    MAX(AMOUNT) AS MAX_EXPENSE
FROM EXPENSES;
-- BUSINESS INSIGHT:
-- The fitness center recorded 90 expense transactions.
-- Total expenses amounted to ₹11,74,472.
-- The average expense per transaction was ₹13,049.69.
-- Expenses ranged from a minimum of ₹333 to a maximum of ₹33,500.
-- This indicates significant variation in expense amounts across transactions.

-- Analyze expenses by expense category.
SELECT
    EXPENSETYPE,
    COUNT(*) AS EXPENSE_RECORDS,
    SUM(AMOUNT) AS TOTAL_EXPENSE,
    ROUND(AVG(AMOUNT), 2) AS AVERAGE_EXPENSE
FROM EXPENSES
GROUP BY EXPENSETYPE
ORDER BY TOTAL_EXPENSE DESC;
-- BUSINESS INSIGHT:
-- Salaries are the largest expense category, totaling ₹7,70,500
-- across 23 expense records.
-- Salaries account for approximately 65.6% of total business expenses.
-- Rent is the second-highest expense at ₹1,90,000.
-- Electricity expenses amount to ₹1,02,179.
-- Miscellaneous and Maintenance expenses are comparatively lower.
-- Salary costs are therefore the primary expense driver for the fitness center.

-- ============================================================
-- PROFIT ANALYSIS
-- Compare total revenue with total expenses.
-- Profit = Revenue - Expenses
-- ============================================================

SELECT
    (SELECT SUM(AMOUNT) FROM PAYMENTS) AS TOTAL_REVENUE,
    (SELECT SUM(AMOUNT) FROM EXPENSES) AS TOTAL_EXPENSES,
    (SELECT SUM(AMOUNT) FROM PAYMENTS)
    -
    (SELECT SUM(AMOUNT) FROM EXPENSES) AS NET_PROFIT
FROM DUAL;
-- BUSINESS INSIGHT:
-- The fitness center generated total revenue of ₹40,90,000.
-- Total business expenses amounted to ₹11,74,472.
-- After deducting total expenses from total revenue,
-- the fitness center generated a net profit of ₹29,15,528.
-- The business generated a strong profit margin of approximately 71.3%.
-- This indicates that the fitness center is currently operating profitably,
-- with revenue significantly higher than its total expenses.

-- ============================================================
-- MONTHLY BUSINESS PERFORMANCE
-- Analyze monthly revenue, expenses and profit.
-- ============================================================

WITH MONTHLY_REVENUE AS
(
    SELECT
        TO_CHAR(PAYMENTDATE, 'YYYY-MM') AS MONTH,
        SUM(AMOUNT) AS REVENUE
    FROM PAYMENTS
    GROUP BY TO_CHAR(PAYMENTDATE, 'YYYY-MM')
),
MONTHLY_EXPENSES AS
(
    SELECT
        TO_CHAR(EXPENSES_DATE, 'YYYY-MM') AS MONTH,
        SUM(AMOUNT) AS EXPENSES
    FROM EXPENSES
    GROUP BY TO_CHAR(EXPENSES_DATE, 'YYYY-MM')
)
SELECT
    COALESCE(R.MONTH, E.MONTH) AS MONTH,
    NVL(R.REVENUE, 0) AS REVENUE,
    NVL(E.EXPENSES, 0) AS EXPENSES,
    NVL(R.REVENUE, 0) - NVL(E.EXPENSES, 0) AS PROFIT
FROM MONTHLY_REVENUE R
FULL OUTER JOIN MONTHLY_EXPENSES E
    ON R.MONTH = E.MONTH
ORDER BY MONTH;
-- BUSINESS INSIGHT:
-- Monthly business performance shows significant variation in revenue,
-- expenses and profit throughout the year.
-- November generated the highest revenue of ₹6,00,000 and the highest
-- monthly profit of ₹5,44,419.
-- December recorded the lowest revenue of ₹2,20,000.
-- January had the highest monthly expenses of ₹1,46,543,
-- while November had the lowest expenses of ₹55,581.
-- April recorded the lowest monthly profit of ₹1,10,358.
-- Overall, November was the strongest-performing month due to
-- high revenue and relatively low expenses.
-- The significant decline in revenue during December indicates
-- a potential seasonal or customer-demand variation that may
-- require further investigation.

-- ============================================================
-- CUSTOMER & FITNESS PROFILE ANALYSIS
-- ============================================================
-- Analyze customer distribution by gender.

SELECT
    GENDER,
    COUNT(*) AS TOTAL_CUSTOMERS
FROM USERS
GROUP BY GENDER
ORDER BY TOTAL_CUSTOMERS DESC;
-- BUSINESS INSIGHT:
-- The fitness center has 55 male customers (55%)
-- and 45 female customers (45%).
-- Male customers represent a slightly higher share of the
-- customer base, while the overall gender distribution
-- remains relatively balanced.

-- Analyze customer distribution by fitness goal.
SELECT
    GOAL,
    COUNT(*) AS TOTAL_CUSTOMERS
FROM USERS
GROUP BY GOAL
ORDER BY TOTAL_CUSTOMERS DESC;
-- BUSINESS INSIGHT:
-- Weight Loss is the most common fitness goal with 39 customers (39%).
-- Muscle Gain is the second most common goal with 37 customers (37%).
-- Maintenance is the least common goal with 24 customers (24%).
-- The results indicate that weight management and muscle development
-- are the primary fitness objectives among customers.

-- Analyze customer distribution by trainer.

SELECT
    TRAINER_NAME,
    COUNT(*) AS TOTAL_CUSTOMERS
FROM USERS
GROUP BY TRAINER_NAME
ORDER BY TOTAL_CUSTOMERS DESC;
-- BUSINESS INSIGHT:
-- The fitness center has 20 trainers serving 100 customers.
-- Brian Trujillo has the highest customer assignment with 9 customers.
-- Ashley Gonzalez and Dennis Velez each serve 8 customers.
-- Gina Ray serves 7 customers, while several trainers serve 6 customers.
-- Overall, customers are distributed across multiple trainers,
-- indicating a relatively balanced trainer workload.

-- Analyze average customer age, height, starting weight and BMI.
SELECT
    ROUND(AVG(AGE), 2) AS AVERAGE_AGE,
    ROUND(AVG(HEIGHT_CM), 2) AS AVERAGE_HEIGHT_CM,
    ROUND(AVG(STARTINGWEIGHT), 2) AS AVERAGE_STARTING_WEIGHT,
    ROUND(AVG(BMI), 2) AS AVERAGE_BMI
FROM USERS;
-- BUSINESS INSIGHT:
-- The average customer age is 40.84 years.
-- The average height is 169.65 cm and the average starting weight is 81.79 kg.
-- The average BMI is 28.84, indicating that customers generally
-- enter the fitness center with a relatively high BMI.
-- This supports the strong demand for weight management and
-- fitness improvement programs.

-- ============================================================
-- CUSTOMER PAYMENT ANALYSIS
-- Analyze total payment made by each customer.
-- ============================================================

SELECT
    U.USERID,
    U.USERNAME,
    U.MEMBERSHIP,
    COUNT(P.USERID) AS TOTAL_PAYMENTS,
    SUM(P.AMOUNT) AS TOTAL_PAID,
    ROUND(AVG(P.AMOUNT), 2) AS AVERAGE_PAYMENT
FROM USERS U
JOIN PAYMENTS P
    ON U.USERID = P.USERID
GROUP BY
    U.USERID,
    U.USERNAME,
    U.MEMBERSHIP
ORDER BY TOTAL_PAID DESC;
-- BUSINESS INSIGHT:
-- The analysis covers payment details for all 100 customers.
-- The highest-value customers in the result have paid ₹80,000 each
-- through a single payment transaction.
-- Several Gold members appear among the highest-paying customers,
-- indicating that higher-value payments are associated with Gold membership.
-- Customer-level payment analysis can help identify high-value customers
-- for retention and targeted membership strategies.

-- ============================================================
-- REVENUE BY MEMBERSHIP TYPE
-- Analyze revenue generated by each membership type.
-- ============================================================
SELECT
    U.MEMBERSHIP,
    COUNT(P.USERID) AS TOTAL_PAYMENTS,
    SUM(P.AMOUNT) AS TOTAL_REVENUE,
    ROUND(AVG(P.AMOUNT), 2) AS AVERAGE_PAYMENT
FROM USERS U
JOIN PAYMENTS P
    ON U.USERID = P.USERID
GROUP BY U.MEMBERSHIP
ORDER BY TOTAL_REVENUE DESC;
-- BUSINESS INSIGHT:
-- Gold membership generates the highest revenue of ₹28,00,000
-- from 35 payment transactions, with an average payment of ₹80,000.
-- Silver membership generates ₹9,60,000 from 32 transactions,
-- with an average payment of ₹30,000.
-- Platinum membership generates ₹3,30,000 from 33 transactions,
-- with an average payment of ₹10,000.
-- Gold membership is therefore the strongest revenue-generating
-- membership type despite having a similar customer count to Silver and Platinum.

-- ============================================================
-- TOP CUSTOMERS
-- Rank customers based on their total payment amount.
-- ============================================================

SELECT
    RANK() OVER (ORDER BY SUM(P.AMOUNT) DESC) AS CUSTOMER_RANK,
    U.USERID,
    U.USERNAME,
    U.MEMBERSHIP,
    SUM(P.AMOUNT) AS TOTAL_PAID
FROM USERS U
JOIN PAYMENTS P
    ON U.USERID = P.USERID
GROUP BY
    U.USERID,
    U.USERNAME,
    U.MEMBERSHIP
ORDER BY CUSTOMER_RANK;
-- BUSINESS INSIGHT:
-- Multiple customers share the highest customer rank
-- because they have the same total payment of ₹80,000.
-- The top-paying customers are primarily Gold members.
-- This indicates that Gold membership customers contribute
-- significantly to the fitness center's revenue.
-- Since several customers have the same highest payment,
-- customer revenue is distributed across multiple high-value customers
-- rather than being dependent on a single customer.