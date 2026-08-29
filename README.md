# Mobile Game Monetization Analytics

## Project Overview
Mobile game monetization data analysis to identify revenue streams and optimize monetization strategies, using SQL (SQLite) for data aggregation and Excel for visualization.

## Files
- `mobile_game_inapp_purchases.csv` — raw data (3,024 users) from kaggle, [Mobile Game In-App Purchases Dataset 2025](https://www.kaggle.com/datasets/pratyushpuri/mobile-game-in-app-purchases-dataset-2025)
- `game_analytics_queries.sql` — SQL queries
- `query1-7_*.csv` — query results
- `Dashboard_Game_Analytics.xlsx` — pivot tables + charts

## Key Insights

**User Segmentation**
- Whale: 2.2% of paying users → 58.3% of revenue
- Dolphin: 13.7% of users → 33.2% of revenue
- Minnow: 84.1% of users → 8.5% of revenue

**Geographic**
- India: highest volume (237 players, $2.6M revenue), mid ARPU (~$10,970)
- Afghanistan: highest ARPU (~$17,684) despite low volume (91 players)
- USA and India have near-identical ARPU — no large premium-vs-mass gap between them

**Platform**
- Android: highest total revenue ($13.1M) and player count (1,702)
- iOS: fewer players (1,203) but higher avg revenue per transaction ($9,742 vs $7,696)

**Genre**
- Battle Royale: highest revenue ($2.6M) and ARPU ($14,035)
- Racing: close second ($2.56M)
- Simulation/Sandbox/Casual: high volume, low ARPU — better fit for ad monetization

**Monthly Trend**
- Revenue peaks in April ($4.7M) and July ($4.38M)
- August is lowest ($1.44M) — likely a partial-month data cutoff, not a real drop

## Business Recommendations
1. Whale users → VIP program, priority support
2. India → volume/ads-driven strategy
3. High-ARPU markets (e.g. Afghanistan) → premium IAP, avoid price cuts
4. iOS → premium features first; Android → accessibility and reach
5. Battle Royale/Racing/Strategy → IAP-heavy; Casual/Simulation/Sandbox → ad-heavy

## How to Run
```bash
sqlite3 game_analytics.db
.mode csv
.import mobile_game_inapp_purchases.csv data_mentah_game
sqlite3 game_analytics.db < game_analytics_queries.sql
```

## Tools
SQLite · Excel (Pivot Tables & Charts) · Markdown

## Limitations
- Synthetic/Kaggle dataset, not real production data
- August data likely incomplete (partial month)
- "Unknown" device category (59 players) too small to base strategy on

## About

**Jessica Leo**
Junior Data Analyst | Information Systems Student
[LinkedIn](https://www.linkedin.com/in/jessicaleooo)
