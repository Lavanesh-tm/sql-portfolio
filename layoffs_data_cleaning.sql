-- Make a working copy of the original table
CREATE TABLE layoffs_copy1 LIKE layoffs;

INSERT INTO layoffs_copy1
SELECT * FROM layoffs;

-- Create a second copy with an extra column for row numbers (to find duplicates)
CREATE TABLE layoffs_copy2 (
    company TEXT,
    location TEXT,
    industry TEXT,
    total_laid_off INT,
    percentage_laid_off TEXT,
    date TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions INT,
    row_num INT
);

-- Generate row numbers for duplicate detection
INSERT INTO layoffs_copy2
SELECT
    *,
    ROW_NUMBER() OVER (
        PARTITION BY company, location, industry,
                     total_laid_off, percentage_laid_off,
                     date, stage, country, funds_raised_millions
    ) AS row_num
FROM layoffs_copy1;

-- Remove duplicate rows
DELETE FROM layoffs_copy2
WHERE row_num > 1;

-- Convert date column to proper DATE format
UPDATE layoffs_copy2
SET date = STR_TO_DATE(date, '%m/%d/%Y');

ALTER TABLE layoffs_copy2
MODIFY date DATE;

-- Trim company names
UPDATE layoffs_copy2
SET company = TRIM(company);

-- Clean up industry names (e.g., Crypto, CryptoCurrency → Crypto)
UPDATE layoffs_copy2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Remove trailing periods from location names
UPDATE layoffs_copy2
SET location = TRIM(TRAILING '.' FROM location);

-- Remove trailing periods from company names
UPDATE layoffs_copy2
SET company = TRIM(TRAILING '.' FROM company);

-- Remove trailing periods from country
UPDATE layoffs_copy2
SET country = TRIM(TRAILING '.' FROM country);

-- Fill missing industries where other rows for the same company have the value
UPDATE layoffs_copy2 t1
JOIN layoffs_copy2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- Remove rows that don't contain layoff information
DELETE FROM layoffs_copy2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

-- Drop the helper column
ALTER TABLE layoffs_copy2
DROP COLUMN row_num;

-- Final dataset
SELECT * FROM layoffs_copy2;
