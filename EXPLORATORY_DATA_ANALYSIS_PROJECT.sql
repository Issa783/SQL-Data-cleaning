-- EXPLORATORY DATA ANALYSIS
SELECT * FROM layoff_staging2;

SELECT MAX(total_laid_off),MAX(percentage_laid_off) FROM layoff_staging2;

SELECT * FROM layoff_staging2 WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company,sum(total_laid_off) FROM layoff_staging2 
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`),MAX(`date`) FROM layoff_staging2;

SELECT country,sum(total_laid_off) FROM layoff_staging2 
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`),sum(total_laid_off) FROM layoff_staging2 
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage,sum(total_laid_off) FROM layoff_staging2 
GROUP BY stage
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`,1,7) AS MONTH,sum(total_laid_off) AS total_off
FROM layoff_staging2 WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY MONTH ORDER BY 1 ASC;
 
WITH Rolling_total AS
(
SELECT SUBSTRING(`date`,1,7) AS MONTH,sum(total_laid_off) AS total_off
FROM layoff_staging2 WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY MONTH ORDER BY 1 ASC
)
SELECT MONTH,total_off,sum(total_off) OVER (ORDER BY MONTH) AS Rolling_total FROM
Rolling_total;

SELECT company,YEAR(`date`),sum(total_laid_off) FROM layoff_staging2 
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_year(company,years,total_laid_off) AS 
(
SELECT company,YEAR(`date`),sum(total_laid_off) FROM layoff_staging2 
GROUP BY company,YEAR(`date`)
),Company_Year_Rank AS
(SELECT *,DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
 FROM Company_year 
 WHERE years IS NOT NULL
)
SELECT * FROM Company_Year_Ranklayoff_staging
WHERE Ranking <=5 ;
