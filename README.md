# Layoffs SQL Project — Data Cleaning & Exploratory Data Analysis

This project showcases my end‑to‑end process of preparing a real layoffs dataset for analysis using MySQL. The goal was to approach the data the same way I would in a professional environment—clean it thoroughly, validate assumptions, explore trends, and document clear insights.

---

## Project Structure

```
sql-portfolio/
│
├── data/
│   └── layoffs.csv
│
├── sql/
│   └── layoffs_data_cleaning.sql
│
├── eda/
│   ├── layoffs_eda.sql
│   └── screenshots/
│       ├── summary_stats_1.png
│       ├── summary_stats_2.png
│       ├── top_companies.png
│       ├── yearly_layoffs.png
│       └── monthly_trends.png
│
└── README.md
```

---

## 1. Data Cleaning (MySQL)

All cleaning logic is in **layoffs_data_cleaning.sql**.  
The raw dataset contained duplicate entries, inconsistent category values, missing fields, and unformatted dates.  
My cleaning steps included:

### • Creating Working Copies
I created `layoffs_copy1` and `layoffs_copy2` to preserve raw data and ensure each stage of the cleaning pipeline was traceable.

### • Removing Duplicates
Used `ROW_NUMBER()` to identify and remove exact duplicates across all key columns.

### • Standardizing Date Formats
Converted text‑based dates into proper `DATE` format using `STR_TO_DATE`, enabling reliable time‑based analysis.

### • Normalizing Text Fields
- Trimmed whitespace  
- Cleaned inconsistent industry labels  
- Removed trailing punctuation  

### • Handling Missing Values
Where possible, missing industries were filled using information from other rows of the same company.

### • Final Output Table
All cleaning steps result in a fully standardized and analysis‑ready table: **`layoffs_copy2`**.

---

## 2. Exploratory Data Analysis (EDA)

All EDA queries are stored in **layoffs_eda.sql**.  
The analysis focuses on identifying trends across companies, industries, years, and months.

### Summary Statistics
- Maximum layoffs and highest layoff percentage  
  *(see `summary_stats_1.png`)*  
- Date range of the dataset  
  *(see `summary_stats_2.png`)*  

### Companies with the Highest Layoffs
Grouped layoffs by company to identify major contributors.  
*(see `top_companies.png`)*

### Yearly Trends
Analyzed layoffs across years to understand broader industry changes.  
*(see `yearly_layoffs.png`)*

### Monthly Trends and Rolling Totals
Explored month‑to‑month changes and cumulative layoff patterns.  
*(see `monthly_trends.png`)*

---

## Key Insights

- Layoff activity spikes significantly during 2022–2023.  
- The largest tech companies account for a major share of total layoffs.  
- Some early‑stage companies show 100% workforce reduction, indicating shutdowns or full restructuring.  
- Dataset starts in early 2020, aligning with global economic disruptions.

---

## How to Run the Project

1. Import `layoffs.csv` into MySQL.  
2. Run all steps in `sql/layoffs_data_cleaning.sql`.  
3. Query the cleaned dataset:

```
SELECT * FROM layoffs_copy2;
```

4. Run EDA queries from:

```
SOURCE eda/layoffs_eda.sql;
```

---

## Skills Demonstrated

- SQL data cleaning and transformation  
- Window functions for deduplication and rolling analysis  
- Date conversion and validation  
- Trend and aggregate analysis  
- Structuring a clean, reproducible SQL workflow  
- Presenting results clearly with supporting visuals  
