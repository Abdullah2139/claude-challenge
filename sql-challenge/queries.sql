CREATE TABLE users (
    user_id     INT PRIMARY KEY,
    signup_date DATE NOT NULL,
    country     VARCHAR(20)
);

CREATE TABLE subscriptions (
    sub_id      INT PRIMARY KEY,
    user_id     INT NOT NULL,
    plan        VARCHAR(10) NOT NULL,
    start_date  DATE NOT NULL,
    end_date    DATE,
    monthly_fee NUMERIC(6,2) NOT NULL
);

CREATE TABLE payments (
    payment_id   INT PRIMARY KEY,
    sub_id       INT NOT NULL,
    payment_date DATE NOT NULL,
    amount       NUMERIC(6,2) NOT NULL,
    status       VARCHAR(10) NOT NULL
);

CREATE TABLE watch_events (
    event_id    INT PRIMARY KEY,
    user_id     INT NOT NULL,
    watched_at  TIMESTAMP NOT NULL,
    title_id    INT NOT NULL,
    minutes     INT NOT NULL
);

-- Insert the Data
INSERT INTO users VALUES
(1,'2023-01-05','US'),(2,'2023-01-20','PK'),(3,'2023-02-10','US'),
(4,'2023-02-15','UK'),(5,'2023-03-01','PK'),(6,'2023-03-10','US'),
(7,'2023-04-02','PK'),(8,'2023-04-20','UK');

INSERT INTO subscriptions VALUES
(101,1,'basic','2023-01-05','2023-04-05',9.99),
(102,1,'standard','2023-04-05',NULL,14.99),
(103,2,'premium','2023-01-20','2023-03-20',19.99),
(104,2,'premium','2023-04-01',NULL,19.99),
(105,3,'basic','2023-02-10',NULL,9.99),
(106,4,'standard','2023-02-15','2023-05-15',14.99),
(107,5,'basic','2023-03-01','2023-03-25',9.99),
(108,5,'basic','2023-03-26',NULL,9.99),
(109,6,'premium','2023-03-10',NULL,19.99),
(110,7,'basic','2023-04-02','2023-06-02',9.99),
(111,8,'standard','2023-04-20',NULL,14.99);

INSERT INTO payments VALUES
(1,101,'2023-01-05',9.99,'success'),(2,101,'2023-02-05',9.99,'success'),
(3,101,'2023-03-05',9.99,'success'),(4,102,'2023-04-05',14.99,'success'),
(5,102,'2023-05-05',14.99,'success'),(6,103,'2023-01-20',19.99,'success'),
(7,103,'2023-02-20',19.99,'failed'),(8,103,'2023-02-22',19.99,'success'),
(9,104,'2023-04-01',19.99,'success'),(10,105,'2023-02-10',9.99,'success'),
(11,105,'2023-03-10',9.99,'success'),(12,105,'2023-04-10',9.99,'refunded'),
(13,106,'2023-02-15',14.99,'success'),(14,106,'2023-03-15',14.99,'success'),
(15,106,'2023-04-15',14.99,'success'),(16,107,'2023-03-01',9.99,'success'),
(17,108,'2023-03-26',9.99,'success'),(18,109,'2023-03-10',19.99,'success'),
(19,109,'2023-04-10',19.99,'success'),(20,110,'2023-04-02',9.99,'success'),
(21,111,'2023-04-20',14.99,'success');

INSERT INTO watch_events VALUES
(1,1,'2023-01-06 20:00',501,45),(2,1,'2023-01-06 20:50',502,30),
(3,1,'2023-01-06 23:40',503,20),(4,1,'2023-01-10 19:00',504,60),
(5,3,'2023-02-11 10:00',501,25),(6,3,'2023-02-11 10:30',505,50),
(7,6,'2023-03-11 21:00',502,40),(8,6,'2023-03-12 21:00',502,40),
(9,9,'2023-03-15 08:00',503,15),(10,9,'2023-03-15 08:20',503,10),
(11,9,'2023-03-15 09:10',504,55);

-- 1. Filtering: List all users from Pakistan (country = 'PK') who signed up after February 1, 2023.
SELECT *
FROM users
WHERE country = 'PK' AND signup_date > '2023-02-01';

-- 2. Joins: For each subscription, show the user's country alongside the plan and monthly fee. 
-- (Simple subscriptions JOIN users.)
SELECT 
	s.plan,
	s.monthly_fee,
	u.country
FROM subscriptions s
INNER JOIN users u
ON s.user_id = u.user_id;

-- 3. Aggregation: How many subscriptions exist per plan type (basic, standard, premium)? 
-- Show plan and count, ordered highest to lowest.
SELECT
	plan,
	COUNT(*) AS subscription_count
FROM subscriptions
GROUP BY plan
ORDER BY subscription_count DESC;

-- 4. Aggregation + filter: What is the total successful payment amount (status = 'success') 
-- collected per month?
SELECT
	TO_CHAR(payment_date, 'YYYY-MM') AS payment_month,
	SUM(amount) AS total_success_amount
FROM payments
WHERE status = 'success'
GROUP BY payment_month;

-- 5. CASE logic: For every subscription, add a column status_label that says 'Active' 
-- if end_date IS NULL, otherwise 'Churned'.
SELECT * FROM subscriptions;
SELECT
	*,
	CASE 
		WHEN end_date IS NULL THEN 'Active'
		ELSE 'Churned'
	END AS status_label
FROM subscriptions;

-- 6. Basic window function: For each user, number their subscriptions in order of start_date 
-- (1st, 2nd, 3rd...) using ROW_NUMBER().
SELECT
    user_id,
    plan,
    start_date,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY start_date) AS sub_number
FROM subscriptions;

-- 7. Simple CTE: Write a CTE that calculates total minutes watched per user from watch_events, 
-- then join it back to users to show user_id, country, and total_minutes_watched.
WITH watch_totals AS (
    SELECT
        user_id,
        SUM(minutes) AS total_minutes_watched
    FROM watch_events
    GROUP BY user_id
)
SELECT
    u.user_id,
    u.country,
    COALESCE(wt.total_minutes_watched, 0) AS total_minutes_watched
FROM users u
LEFT JOIN watch_totals wt ON u.user_id = wt.user_id;