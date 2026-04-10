/*
Answer : What are the top skills based on salary?
- Look at the average salary associated with each skill for data analyst positions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analyst and
    helps identify the most financially rewarding skills to acquire or improve
*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id 
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills 
ORDER BY
    avg_salary DESC
LIMIT 25

/*
High Demand for Big Data & ML Skills: 
Top salaries are driven by analysts skilled in big data tools (PySpark, Databricks), machine learning libraries (scikit-learn, DataRobot), 
and Python ecosystems (Pandas, NumPy), reflecting strong demand for large-scale data processing and predictive capabilities.

Software Development & Data Engineering Crossover: 
Proficiency in tools like GitLab, Airflow, and Kubernetes highlights a growing overlap between analytics and engineering, 
with higher pay for those who can build, automate, and manage data pipelines.

Cloud Computing Expertise: Familiarity with cloud platforms and data infrastructure (GCP, Elasticsearch, Linux) 
underscores the shift toward cloud-based analytics,where cloud skills significantly enhance an analyst’s earning potential.
*/