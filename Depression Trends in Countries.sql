SELECT 
    m1.Entity AS Country,
    (SELECT m2.[Depressive disorders (share of population) - Sex: Both - Age: Age-standardized] 
     FROM 'mental-illnesses-prevalence' m2 
     WHERE m2.Entity = m1.Entity AND m2.Year = 1990) AS Rate_1990,
    m1.[Depressive disorders (share of population) - Sex: Both - Age: Age-standardized] AS Rate_2019,
    (m1.[Depressive disorders (share of population) - Sex: Both - Age: Age-standardized] - 
     (SELECT m2.[Depressive disorders (share of population) - Sex: Both - Age: Age-standardized] 
      FROM 'mental-illnesses-prevalence' m2 
      WHERE m2.Entity = m1.Entity AND m2.Year = 1990)) AS Change
FROM 
    'mental-illnesses-prevalence' m1
WHERE 
    m1.Year = 2019
    AND Rate_1990 IS NOT NULL
ORDER BY 
    Change DESC
LIMIT 10;