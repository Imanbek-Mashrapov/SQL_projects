-- Exploratory Data Analysis

SELECT * FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off) as total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC;

SELECT MIN(date), MAX(date)
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off) as total_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_laid_off DESC;

SELECT country, SUM(total_laid_off) as total_laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY total_laid_off DESC;

SELECT YEAR(date), SUM(total_laid_off) as total_laid_off
FROM layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off) as total_laid_off
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT SUBSTRING(date, 1, 7) AS month, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(date, 1, 7) IS NOT NULL
GROUP BY month
ORDER BY 1 ASC;

WITH Rolling_total AS
(
	SELECT SUBSTRING(date, 1, 7) AS month, SUM(total_laid_off) AS total_off
    FROM layoffs_staging2
    WHERE SUBSTRING(date, 1, 7) IS NOT NULL
    GROUP BY month
	ORDER BY 1 ASC
)
SELECT month, total_off, SUM(total_off) OVER(ORDER BY month) AS rolling_total
FROM Rolling_total;

WITH Company_years(company, years, total_off) AS 
(
	SELECT company, YEAR(date), SUM(total_laid_off) as total_laid_off
	FROM layoffs_staging2
	GROUP BY company, YEAR(date)
),
Company_rank AS 
(
	SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY  total_off DESC) as ranks
	FROM Company_years
	WHERE years IS NOT NULL
)
SELECT *
FROM Company_rank
WHERE ranks <= 5;
