# 🎵 Apple iTunes Music Store — SQL Analysis Project

![SQL](https://img.shields.io/badge/SQL-SQLite-blue?style=flat-square&logo=sqlite)
![Status](https://img.shields.io/badge/Status-Completed-success?style=flat-square)
![Data](https://img.shields.io/badge/Records-4757%20Invoice%20Lines-orange?style=flat-square)

> A complete end-to-end SQL analysis of the Apple iTunes Music Store database — covering customer behavior, sales trends, genre performance, and business recommendations.

---

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Database Schema](#-database-schema)
- [Project Structure](#-project-structure)
- [Key Business Questions](#-key-business-questions)
- [Key Findings](#-key-findings)
- [Setup Instructions](#️-setup-instructions)
- [SQL Queries Covered](#-sql-queries-covered)
- [Tools Used](#️-tools-used)
- [Recommendations](#-recommendations)
- [Author](#-author)

---

## 📌 Project Overview

Apple iTunes maintains a large digital music store with millions of tracks and thousands of customers worldwide. This project analyzes the iTunes relational database to generate actionable insights for improving product offerings, customer targeting, and operational efficiency.

**Dataset Summary:**

| Table         | Records |
|---------------|---------|
| Customers     | 59      |
| Employees     | 9       |
| Invoices      | 614     |
| Invoice Lines | 4,757   |
| Tracks        | 3,503   |
| Albums        | 347     |
| Artists       | 275     |
| Genres        | 25      |
| Playlists     | 18      |
| Media Types   | 5       |

---

## 🗄️ Database Schema

The database contains 11 interrelated tables:

```
artist ──→ album ──→ track ──→ invoice_line ──→ invoice ──→ customer ──→ employee
                       │
               genre / media_type / playlist_track ──→ playlist
```

**Key Relationships:**
- `artist` → `album` → `track` (music catalog chain)
- `customer` → `invoice` → `invoice_line` → `track` (sales chain)
- `employee` → `customer` (support chain)

---

## 📁 Project Structure

```
itunes-music-analysis/
│
├── 📂 data/                        # Raw CSV datasets
│   ├── customer.csv
│   ├── employee.csv
│   ├── invoice.csv
│   ├── invoice_line.csv
│   ├── track.csv
│   ├── album.csv
│   ├── artist.csv
│   ├── genre.csv
│   ├── playlist.csv
│   ├── playlist_track.csv
│   └── media_type.csv
│
├── 📂 queries/                     # All SQL query files
│   ├── 01_database_setup.sql       # CREATE TABLE statements
│   ├── 02_customer_analytics.sql   # Customer behavior queries
│   ├── 03_sales_revenue.sql        # Sales & revenue analysis
│   ├── 04_product_analysis.sql     # Track, genre, artist queries
│   └── 05_advanced_analytics.sql   # Window functions & CTEs
│
├── 📂 reports/                     # Final outputs
│   └── iTunes_Final_Report.docx    # Complete business report
│
├── 📂 assets/                      # Screenshots / visuals (optional)
│
└── README.md                       # Project documentation
```

---

## ❓ Key Business Questions

### Customer Analytics
- Which customers have spent the most money?
- What is the average customer lifetime value?
- How many customers are repeat vs one-time buyers?
- Which countries generate the most revenue per customer?

### Sales & Revenue
- What are the monthly revenue trends?
- Which employee contributes the most revenue?
- Which quarters have peak music sales?

### Product & Content
- Which tracks and artists generate the most revenue?
- Are there tracks that have never been purchased?
- Which media formats are most popular?

### Genre & Artist Performance
- Which genres dominate sales?
- Who are the top 5 highest-grossing artists?
- Are certain genres more popular in specific countries?

---

## 📊 Key Findings

| Metric                    | Value       |
|---------------------------|-------------|
| 💰 Total Revenue          | $4,709.43   |
| 👥 Total Customers        | 59          |
| 🧾 Total Invoices         | 614         |
| 📄 Avg Invoice Value      | $7.67       |
| 💎 Avg Customer LTV       | $79.82      |
| 🔁 Repeat Customer Rate   | 100%        |
| 🎵 Top Genre              | Rock (55.4%)|
| 🌍 Top Country            | USA ($1,040)|
| 🏆 Top Artist             | Queen       |
| ⚠️ Unpurchased Tracks     | 1,697 (48.5%)|

---

## 🛠️ Setup Instructions

### Prerequisites
- [DB Browser for SQLite](https://sqlitebrowser.org/dl/) — free, no installation of server needed

### Step 1 — Create the database
1. Open DB Browser for SQLite
2. Click **New Database** → name it `itunes_analysis.db`
3. Go to **Execute SQL** tab
4. Copy and run the contents of `queries/01_database_setup.sql`

### Step 2 — Import CSV data
Import in this exact order (foreign key dependencies):
1. `media_type.csv`
2. `genre.csv`
3. `artist.csv`
4. `album.csv`
5. `employee.csv`
6. `track.csv`
7. `customer.csv`
8. `invoice.csv`
9. `invoice_line.csv`
10. `playlist.csv`
11. `playlist_track.csv`

**How to import:** `File → Import → Table from CSV file`
- ✅ Check "Column names in first line"
- ✅ Separator: Comma (,)
- ✅ Table name must match exactly (e.g. `customer`)

### Step 3 — Verify data loaded correctly
```sql
SELECT 'customer'      AS tbl, COUNT(*) AS rows FROM customer      UNION ALL
SELECT 'track',                COUNT(*)         FROM track          UNION ALL
SELECT 'invoice',              COUNT(*)         FROM invoice        UNION ALL
SELECT 'invoice_line',         COUNT(*)         FROM invoice_line   UNION ALL
SELECT 'artist',               COUNT(*)         FROM artist;
```

### Step 4 — Run the analysis queries
Execute files in `queries/` folder in numbered order.

---

## 📝 SQL Queries Covered

| File | Concepts Used | Queries |
|------|--------------|---------|
| `01_database_setup.sql` | CREATE TABLE, PRIMARY KEY, FOREIGN KEY | 11 |
| `02_customer_analytics.sql` | JOIN, GROUP BY, HAVING, subquery | 5 |
| `03_sales_revenue.sql` | STRFTIME, CASE WHEN, multi-table JOIN | 5 |
| `04_product_analysis.sql` | LEFT JOIN, NULL check, OVER() | 5 |
| `05_advanced_analytics.sql` | RANK(), LAG(), CTE (WITH), PARTITION BY | 9 |

**SQL Concepts demonstrated:**
- `JOIN`, `LEFT JOIN`, multi-table joins (up to 5 tables)
- `GROUP BY`, `HAVING`, `ORDER BY`
- `CASE WHEN` for conditional logic
- `STRFTIME()` for date manipulation
- Window functions: `RANK()`, `LAG()`, `SUM() OVER()`
- CTEs using `WITH` clause
- Subqueries and derived tables
- `JULIANDAY()` for date difference calculation

---

## 🛠️ Tools Used

| Tool | Purpose |
|------|---------|
| SQLite (via DB Browser) | Database engine & query execution |
| Python (pandas) | Data validation & pre-analysis |
| docx (Node.js) | Final report generation |
| Git & GitHub | Version control & project hosting |

---

## 💡 Recommendations

### For Marketing Team
- Launch genre-targeted campaigns — Rock & Metal fans drive 68% of revenue
- Re-engage customers with personalized "We miss you" campaigns
- Promote underperforming genres (Classical, Jazz) via curated playlists

### For Product Team
- Archive the 1,697 unpurchased tracks (48.5% of catalog is dead inventory)
- Introduce album bundle pricing to increase average order value
- Invest in modern AAC format migration for better audio quality

### For Operations Team
- Standardize Jane Peacock's techniques (highest avg invoice: $8.17)
- Explore high-potential markets: India shows strong LTV at $111.87

---

## 👤 Author

**[Your Name]**
- 📧 Email: akashchauhan@gmail.com
- 🐙 GitHub: [github.com/yourusername](https://github.com/Akchauhan262)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

*If you found this project helpful, please ⭐ star the repository!*
