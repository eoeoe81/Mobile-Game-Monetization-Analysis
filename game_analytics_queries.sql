-- ============================================
-- GAME ANALYTICS QUERIES (SQLite Compatible)
-- Dataset: data_mentah_game
-- Created: 2026-08-19
-- ============================================

-- QUERY 1: Top 10 Spenders
-- Menampilkan 10 pemain dengan total pembelanjaan tertinggi
-- Fixed: Added secondary sort for consistent results
-- ============================================
SELECT
    UserID,
    Country,
    GameGenre,
    CASE
        WHEN Age BETWEEN 13 AND 20 THEN 'Teen'
        WHEN Age BETWEEN 21 AND 30 THEN 'Young Adult'
        WHEN Age BETWEEN 31 AND 40 THEN 'Adult'
        ELSE 'Mature'
    END AS Age_Bucket,
    SUM(InAppPurchaseAmount) AS Total_Spent
FROM
    mobile_game_inapp_purchases
WHERE Age > 0  -- Filter out invalid age data
GROUP BY
    UserID, Country, GameGenre, Age_Bucket
ORDER BY
    Total_Spent DESC, UserID
LIMIT 10;


-- QUERY 2: Revenue by Country with Spending Segments
-- Menampilkan total revenue per negara dengan breakdown spending segment
-- Fixed: SpendingSegment dihitung per-user (agregasi dulu), bukan per-transaction
-- Sortir berdasarkan Total_Users untuk highlight market size (volume)
-- ============================================
WITH UserSpending AS (
    SELECT
        UserID,
        Country,
        SUM(InAppPurchaseAmount) AS User_Total_Spent
    FROM
        mobile_game_inapp_purchases
    WHERE Age > 0
    GROUP BY
        UserID, Country
)
SELECT
    Country,
    CASE
        WHEN User_Total_Spent >= 100 THEN 'Whale'
        WHEN User_Total_Spent BETWEEN 50 AND 99 THEN 'Dolphin'
        WHEN User_Total_Spent BETWEEN 1 AND 49 THEN 'Minnow'
        ELSE 'Non-Spender'
    END AS SpendingSegment,
    COUNT(UserID) AS Total_Users,
    SUM(User_Total_Spent) AS Total_Revenue,
    ROUND(AVG(User_Total_Spent), 2) AS ARPU
FROM
    UserSpending
GROUP BY
    Country, SpendingSegment
ORDER BY
    Total_Users DESC, Country;


-- QUERY 3: Monthly Revenue Trend with Age Filter
-- Menampilkan trend revenue per bulan
-- Fixed: DATE_FORMAT → strftime untuk SQLite
-- ============================================
SELECT
    strftime('%Y-%m', Timestamp) AS Month,
    SUM(InAppPurchaseAmount) AS Total_Revenue,
    COUNT(DISTINCT UserID) AS Total_Users
FROM
    mobile_game_inapp_purchases
WHERE Age > 0  -- Filter out invalid age data
GROUP BY
    Month
ORDER BY
    Month;


-- QUERY 4: Device Performance with Age Filter
-- Menampilkan performa per device (jumlah player dan total revenue)
-- ============================================
SELECT
    Device,
    COUNT(DISTINCT UserID) AS Total_Players,
    SUM(InAppPurchaseAmount) AS Total_Revenue,
    ROUND(AVG(InAppPurchaseAmount), 2) AS Avg_Revenue_Per_Transaction
FROM
    mobile_game_inapp_purchases
WHERE Age > 0  -- Filter out invalid age data
GROUP BY
    Device
ORDER BY
    Total_Revenue DESC;


-- QUERY 5: Genre Performance with Spending Segments
-- Menampilkan performa per genre game dengan breakdown spending segment
-- Fixed: SpendingSegment dihitung per-user (agregasi dulu), bukan per-transaction
-- ============================================
WITH UserGenreSpending AS (
    SELECT
        UserID,
        GameGenre,
        SUM(InAppPurchaseAmount) AS User_Total_Spent
    FROM
        mobile_game_inapp_purchases
    WHERE Age > 0
    GROUP BY
        UserID, GameGenre
)
SELECT
    GameGenre,
    CASE
        WHEN User_Total_Spent >= 100 THEN 'Whale'
        WHEN User_Total_Spent BETWEEN 50 AND 99 THEN 'Dolphin'
        WHEN User_Total_Spent BETWEEN 1 AND 49 THEN 'Minnow'
        ELSE 'Non-Spender'
    END AS SpendingSegment,
    COUNT(UserID) AS Total_Players,
    SUM(User_Total_Spent) AS Total_Revenue,
    ROUND(AVG(User_Total_Spent), 2) AS ARPU
FROM
    UserGenreSpending
GROUP BY
    GameGenre, SpendingSegment
ORDER BY
    GameGenre, Total_Revenue DESC;


-- ============================================
-- ADDITIONAL INSIGHTS (Optional)
-- ============================================

-- Country Summary: Total users, revenue, dan ARPU per country (tanpa breakdown segment)
SELECT
    Country,
    COUNT(DISTINCT UserID) AS Total_Players,
    SUM(InAppPurchaseAmount) AS Total_Revenue,
    ROUND(SUM(InAppPurchaseAmount) * 1.0 / COUNT(DISTINCT UserID), 2) AS ARPU
FROM
    mobile_game_inapp_purchases
WHERE Age > 0
GROUP BY
    Country
ORDER BY
    Total_Players DESC;


-- Genre Summary: Total users, revenue, dan ARPU per genre (tanpa breakdown segment)
SELECT
    GameGenre,
    COUNT(DISTINCT UserID) AS Total_Players,
    SUM(InAppPurchaseAmount) AS Total_Revenue,
    ROUND(SUM(InAppPurchaseAmount) * 1.0 / COUNT(DISTINCT UserID), 2) AS ARPU
FROM
    mobile_game_inapp_purchases
WHERE Age > 0
GROUP BY
    GameGenre
ORDER BY
    Total_Revenue DESC;
