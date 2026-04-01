SELECT*
FROM
    skills_dim
LIMIT 10;


(
SELECT
    skill_id,
    COUNT(*) AS skill_count
FROM skills_job_dim
GROUP BY skill_id
ORDER BY skill_count DESC
)
AS Skill_use

---PRACTICE PROBLEMS 1---
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    Skill_use.skill_count
from
    (
SELECT
    skill_id,
    COUNT(*) AS skill_count
FROM skills_job_dim
GROUP BY skill_id
ORDER BY skill_count DESC
limit 5
)
AS Skill_use
LEFT JOIN skills_dim
ON skills_dim.skill_id = skill_use.skill_id
ORDER BY
    skill_count DESC

---PRACTICE PROBLEM 2---
SELECT
    company_id,
    COUNT(*) AS job_count,
    CASE
    WHEN COUNT(*) <10 THEN 'Small'
    WHEN COUNT(*) BETWEEN 10 and 50 THEN 'Medium'
    ELSE 'Large'
    END AS job_open_rate
from   
    job_postings_fact
GROUP BY
    company_id

SELECT
    company_id,
    job_count,
    CASE
        WHEN job_count < 10 THEN 'Small'
        WHEN job_count BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS company_size
FROM (
    SELECT
        company_id,
        COUNT(*) AS job_count
    FROM job_postings_fact
    GROUP BY company_id
) AS company_jobs;

WITH remote_job_skills AS (
SELECT 
    skills_job_dim.skill_id,
    COUNT(*) AS skills_count
FROM
    job_postings_fact
JOIN skills_job_dim
ON  job_postings_fact.job_id = skills_job_dim.job_id
WHERE job_work_from_home = TRUE
GROUP BY
    skills_job_dim.skill_id
)
SELECT
    remote_job_skills.skill_id,
    skills_dim.skills,
    remote_job_skills.skills_count
FROM
    remote_job_skills
JOIN skills_dim
ON remote_job_skills.skill_id = skills_dim.skill_id
ORDER BY
    remote_job_skills.skills_count DESC
LIMIT 5;

CREATE TABLE january_jobs AS
SELECT*
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
SELECT*
FROM job_postings_fact
WHERE EXTRACT (MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
SELECT*
FROM job_postings_fact
WHERE EXTRACT (MONTH FROM job_posted_date) = 3;

SELECT*
FROM january_jobs

SELECT*
FROM february_jobs

SELECT*
FROM march_jobs

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs

SELECT
    job_postings_fact.job_title,
    job_postings_fact.salary_year_avg,
    company_dim.name,
    skills_dim.skills,
    skills_dim.type
    FROM
        job_postings_fact
    JOIN skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id
    JOIN skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
    JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
    WHERE
    salary_year_avg > 70000
    AND EXTRACT (QUARTER FROM job_posted_date) = 1

UNION

SELECT
    job_postings_fact.job_title,
    job_postings_fact.salary_year_avg,
    company_dim.name,
    NULL AS skills,
    NULL AS type
FROM job_postings_fact
LEFT JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE skills_job_dim.skill_id IS NULL
AND salary_year_avg > 70000
AND EXTRACT(QUARTER FROM job_posted_date) = 1

---SIMPLE ONE---
SELECT  
    job_postings_fact.job_title,  
    skills_dim.skills,  
    skills_dim.type  
FROM job_postings_fact  
LEFT JOIN skills_job_dim  
    ON job_postings_fact.job_id = skills_job_dim.job_id  
LEFT JOIN skills_dim  
    ON skills_job_dim.skill_id = skills_dim.skill_id  
WHERE salary_year_avg > 70000  
AND EXTRACT(QUARTER FROM job_posted_date) = 1;

SELECT job_title
FROM job_postings_fact
WHERE salary_year_avg > 120000

UNION ALL

SELECT job_title
FROM job_postings_fact
WHERE salary_year_avg BETWEEN 70000 AND 120000;

SELECT job_title, 'High Salary'
FROM job_postings_fact
WHERE salary_year_avg > 120000

UNION ALL

SELECT job_title, 'Medium Salary'
FROM job_postings_fact
WHERE salary_year_avg BETWEEN 70000 AND 120000;