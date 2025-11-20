SELECT * FROM layoffs_copy2;

SELECT 
    MAX(total_laid_off),
    MAX(percentage_laid_off)
FROM layoffs_copy2;

SELECT *
FROM layoffs_copy2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT *
FROM layoffs_copy2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT 
    company,
    SUM(total_laid_off) AS total_laid_off_sum
FROM layoffs_copy2
GROUP BY company
ORDER BY total_laid_off_sum DESC;

SELECT 
    MIN(date) AS min_date,
    MAX(date) AS max_date
FROM layoffs_copy2;

SELECT 
    industry,
    SUM(total_laid_off) AS industry_total
FROM layoffs_copy2
GROUP BY industry
ORDER BY industry_total DESC;

SELECT 
    country,
    SUM(total_laid_off) AS country_total
FROM layoffs_copy2
GROUP BY country
ORDER BY country_total DESC;

SELECT 
    YEAR(date) AS layoff_year,
    SUM(total_laid_off) AS total_per_year
FROM layoffs_copy2
GROUP BY layoff_year
ORDER BY layoff_year DESC;

SELECT 
    stage,
    SUM(total_laid_off) AS stage_total
FROM layoffs_copy2
GROUP BY stage
ORDER BY stage;

SELECT 
    SUBSTRING(date, 1, 7) AS month,
    SUM(total_laid_off) AS monthly_total
FROM layoffs_copy2
WHERE SUBSTRING(date, 1, 7) IS NOT NULL
GROUP BY month
ORDER BY month;

WITH monthly_data AS (
    SELECT 
        SUBSTRING(date, 1, 7) AS month,
        SUM(total_laid_off) AS total_off
    FROM layoffs_copy2
    WHERE SUBSTRING(date, 1, 7) IS NOT NULL
    GROUP BY month
)
SELECT 
    month,
    total_off,
    SUM(total_off) OVER (ORDER BY month) AS rolling_total
FROM monthly_data
ORDER BY month;

SELECT 
    company,
    YEAR(date) AS year,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_copy2
GROUP BY company, year
ORDER BY total_laid_off DESC;

WITH company_year AS (
    SELECT 
        company,
        YEAR(date) AS year,
        SUM(total_laid_off) AS total_laid_off
    FROM layoffs_copy2
    GROUP BY company, year
),
ranked AS (
    SELECT 
        *,
        DENSE_RANK() OVER (
            PARTITION BY year 
            ORDER BY total_laid_off DESC
        ) AS rank_within_year
    FROM company_year
    WHERE year IS NOT NULL
)
SELECT *
FROM ranked
WHERE rank_within_year <= 5
ORDER BY year DESC, rank_within_year;

SELECT * FROM layoffs_copy2;
