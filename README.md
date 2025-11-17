# sql-portfolio

This repository contains a small SQL project where I clean a layoffs dataset in MySQL and turn it into an analysis‑ready table.  
My goal here was to practice real data‑cleaning work in SQL: de‑duplicating rows, standardising text fields, and fixing date formats.

---

## Project Structure

```text
sql-portfolio/
├─ data/
│  └─ layoffs.csv
├─ sql/
│  └─ layoffs_data_cleaning.sql
└─ README.md
```

- `data/layoffs.csv` – raw layoffs dataset.
- `sql/layoffs_data_cleaning.sql` – full cleaning script.

---

## Dataset

Each row in the dataset represents a layoff event for a company, with columns such as:

- `company` – company name
- `location` – city or region
- `industry` – industry label
- `total_laid_off` – number of employees laid off
- `percentage_laid_off` – percentage of workforce laid off
- `date` – layoff date
- `stage` – funding stage (e.g., Seed, Series A)
- `country` – country name
- `funds_raised_millions` – funds raised in millions (when available)

The raw CSV includes duplicates, inconsistent text formatting, and dates stored as strings.

---

## Cleaning Workflow (SQL)

All logic lives in `sql/layoffs_data_cleaning.sql`.  
At a high level, I do the following:

1. **Work on copies instead of the original**

   - Create `layoffs_copy1` as a direct copy of the imported `layoffs` table.
   - Create `layoffs_copy2` with an extra `row_num` column used for duplicate detection.

2. **Remove exact duplicates**

   - Use `ROW_NUMBER()` with a `PARTITION BY` on all key columns to assign a row number per group of identical rows.
   - Delete rows where `row_num > 1` so only one copy of each record remains.

3. **Fix the date column**

   - Convert the text `date` column (`MM/DD/YYYY`) using `STR_TO_DATE`.
   - Change the column type to `DATE` so it can be used safely in time‑based queries.

4. **Tidy up text fields**

   - Trim whitespace from `company`.
   - Normalise `industry` so variants like `Crypto` / `CryptoCurrency` are stored as `Crypto`.
   - Remove trailing dots from `location`, `company`, and `country`.

5. **Fill missing industry values**

   - For rows where `industry` is `NULL`, copy the industry from another row of the same company when it exists.
   - This reduces missing values without inventing new categories.

6. **Drop rows without layoff information**

   - Remove rows where **both** `total_laid_off` and `percentage_laid_off` are `NULL`, since they don’t contain useful signal.

7. **Clean up helper columns**

   - Drop the `row_num` column once duplicates are handled.
   - The final cleaned table is **`layoffs_copy2`**.

---

## How to Run It

1. **Create a schema**

   ```sql
   CREATE DATABASE dataset_layoffs;
   ```

2. **Import the CSV**

   - In MySQL Workbench (or another client), import `data/layoffs.csv` into a table named `layoffs` inside `dataset_layoffs`.

3. **Execute the script**

   - Open `sql/layoffs_data_cleaning.sql`.
   - Set the active schema to `dataset_layoffs`.
   - Run the script from top to bottom.

4. **Use the cleaned table**

   ```sql
   SELECT * FROM layoffs_copy2;
   ```

   `layoffs_copy2` is the table I use for any further analysis, dashboards, or visualisations.

---

## Skills Demonstrated

- Writing and running multi‑step SQL data‑cleaning scripts
- Using window functions (`ROW_NUMBER`) for de‑duplication
- Converting and validating date fields
- Standardising categorical text data
- Handling missing values in a controlled way
