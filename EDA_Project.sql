## Zak Kotschegarow 

## EDA ##

Select *
from layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

## Look at different columns to get ideas of the data and the layoffs ##
Select company, SUM(total_laid_off)
from layoffs_staging2
GROUP BY company
ORDER by 2 desc;

SELECT MIN(`date`), max(`date`)
from layoffs_staging2;

## looking at country layoffs ##
Select industry, SUM(total_laid_off)
from layoffs_staging2
GROUP BY industry
ORDER by 2 desc;

Select country, SUM(total_laid_off)
from layoffs_staging2
GROUP BY country
ORDER by 2 desc;

Select company, year(`date`), SUM(total_laid_off)
from layoffs_staging2
GROUP BY year(`date`), company
ORDER by 1 desc;


## position 1 and take 7 ##
## layoff for the month and year ##
## Rolling totals ##
SELECT substring(`date`,1,7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
;

SELECT substring(`date`,1,7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
;
with rolling_total as
(SELECT substring(`date`,1,7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
)
select `month`, total_off,
sum(total_off) over(order by `month`) as rolling_total
from rolling_total;

Select company, SUM(total_laid_off)
from layoffs_staging2
GROUP BY company
ORDER by 2 desc;


## looks at company and year how many people they let off
Select company,	year(`date`), SUM(total_laid_off)
from layoffs_staging2
GROUP BY company, year(`date`)
order by 3 desc;
## with that year (cte)
WITH Company_Year(company, years, total_laid_off) as 
(Select company,	year(`date`), SUM(total_laid_off)
from layoffs_staging2
GROUP BY company, year(`date`) ## ##
), Company_Year_Rank AS(
select *, dense_rank() Over(partition by years order by total_laid_off desc) as Ranking
from Company_Year
WHERE years is not null)
select *
from Company_Year_Rank
WHERE Ranking <= 5; ## 2nd cte ##

## ^^ partitions companys that ranked top 5 in layoffs 2020-2023 ##

## end of eda
## looks at laid off company, the dates, country and year, ranked them per year


















