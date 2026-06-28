-- 1. Create the Users Table
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    signup_date DATE,
    device_type VARCHAR(50)
);

-- 2. Create the Products Table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

-- 3. Create the Events Table
CREATE TABLE Events (
    event_id INT PRIMARY KEY,
    user_id INT,
    product_id INT,
    event_time TIMESTAMP,
    event_type VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);


-- 1. Insert Fake Users
INSERT INTO Users (user_id, signup_date, device_type) VALUES
(1, '2026-06-01', 'Mobile'),
(2, '2026-06-02', 'Desktop'),
(3, '2026-06-03', 'Mobile');

-- 2. Insert Fake Products
INSERT INTO Products (product_id, product_name, category, price) VALUES
(101, 'Wireless Headphones', 'Electronics', 150.00),
(102, 'Mechanical Keyboard', 'Electronics', 85.00),
(103, 'Running Shoes', 'Apparel', 120.00);

-- 3. Insert Fake Events (The Funnel)

-- User 1 buys the headphones (Full Funnel)
INSERT INTO Events (event_id, user_id, product_id, event_time, event_type) VALUES
(1001, 1, 101, '2026-06-27 10:00:00', 'page_view'),
(1002, 1, 101, '2026-06-27 10:05:00', 'add_to_cart'),
(1003, 1, 101, '2026-06-27 10:10:00', 'checkout'),
(1004, 1, 101, '2026-06-27 10:15:00', 'purchase');

-- User 2 adds keyboard to cart but abandons it (Abandons at Cart)
INSERT INTO Events (event_id, user_id, product_id, event_time, event_type) VALUES
(1005, 2, 102, '2026-06-27 11:00:00', 'page_view'),
(1006, 2, 102, '2026-06-27 11:02:00', 'add_to_cart');

-- User 3 gets to checkout for shoes but leaves (Abandons at Checkout)
INSERT INTO Events (event_id, user_id, product_id, event_time, event_type) VALUES
(1007, 3, 103, '2026-06-27 14:00:00', 'page_view'),
(1008, 3, 103, '2026-06-27 14:10:00', 'add_to_cart'),
(1009, 3, 103, '2026-06-27 14:15:00', 'checkout');

SELECT * FROM Events;

SELECT 
    event_type, 
    COUNT(event_id) AS number_of_actions
FROM Events
GROUP BY event_type
ORDER BY 
    CASE event_type
        WHEN 'page_view' THEN 1
        WHEN 'add_to_cart' THEN 2
        WHEN 'checkout' THEN 3
        WHEN 'purchase' THEN 4
    END;


WITH AbandonedCarts AS (
    -- Step 1: Find people who added to cart, but did NOT purchase
    SELECT user_id, product_id
    FROM Events
    WHERE event_type = 'add_to_cart'
    AND user_id NOT IN (
        SELECT user_id 
        FROM Events 
        WHERE event_type = 'purchase'
    )
)
-- Step 2: Join with the Products table to calculate the lost money
SELECT 
    p.product_name,
    COUNT(a.user_id) AS missed_sales,
    SUM(p.price) AS total_lost_revenue
FROM AbandonedCarts a
JOIN Products p ON a.product_id = p.product_id
GROUP BY p.product_name;

WITH FunnelCounts AS (
    SELECT 
        event_type,
        COUNT(event_id) AS users_at_step,
        CASE event_type
            WHEN 'page_view' THEN 1
            WHEN 'add_to_cart' THEN 2
            WHEN 'checkout' THEN 3
            WHEN 'purchase' THEN 4
        END AS step_order
    FROM Events
    GROUP BY event_type
),
FunnelWithLag AS (
    SELECT 
        event_type,
        users_at_step,
        LAG(users_at_step) OVER (ORDER BY step_order) AS previous_step_users,
        step_order
    FROM FunnelCounts
)
SELECT 
    event_type AS funnel_stage,
    users_at_step,
    previous_step_users,
    ROUND(
        (users_at_step::DECIMAL / NULLIF(previous_step_users, 0)) * 100, 2
    ) AS step_conversion_rate_pct
FROM FunnelWithLag
ORDER BY step_order;