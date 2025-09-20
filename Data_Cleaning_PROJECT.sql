## DATA CLEANING
## Zak Kotschegarow

SELECT *
FROM layoffs;

## 1. Remove duplicates
## 2. Standarize the Data
## 3. Null values
## 4. Remove any columns

## makes table so we don't mess with the raw data
CREATE TABLE layoffs_staging
LIKE layoffs;

## inserts data into the empty table
INSERT layoffs_staging
SELECT *
FROM layoffs;

select *
from layoffs_staging;

## identify duplicates
SELECT *,
ROW_NUMBER() OVER(PARTITION BY 
company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY 
company, location, industry, 
total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

## CHECKING COMPANY
SELECT *
FROM layoffs_staging
WHERE company = 'Oda';

## Staging 2 data base (make another table)
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;


INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;
## ^ copy of the table + row_num

delete
FROM layoffs_staging2
WHERE row_num > 1; 

SELECT *
FROM layoffs_staging2;
## WHERE row_num > 1; 
## THAT REMOVED THE DUPLICATES

## Standarding data ##
SELECT company, (TRIM(company))
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry 
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


SELECT distinct country, trim(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = trim(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';


SELECT `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

#SELECT `date`
#from layoffs_staging2;

ALTER TABLE layoffs_staging2
modify column `date` DATE;

#select *
#from layoffs_staging2;


## NULL and blank values ##
SELECT *
from layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT *
from layoffs_staging2
WHERE industry is null
or industry = '';

## Check a company
SELECT *
from layoffs_staging2
WHERE company = 'Airbnb';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry Is null OR t1.industry = '')
AND t2.industry is not null;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry Is null
AND t2.industry is not null;

SELECT *
from layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

## delete columns where both those are null
DELETE
from layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

Select * 
from layoffs_staging2;

ALTER table layoffs_staging2
drop column row_num;

## END OF data cleaning

