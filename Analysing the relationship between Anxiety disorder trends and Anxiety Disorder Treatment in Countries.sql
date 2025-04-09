-- CLEAN COUNTRY-LEVEL ANALYSIS (2019 anxiety vs single treatment year)
WITH latest_anxiety AS (
  SELECT 
    curr.Entity AS Country,
    curr.[Anxiety disorders (share of population) - Sex: Both - Age: Age-standardized] AS Anxiety_2019,
    prev.[Anxiety disorders (share of population) - Sex: Both - Age: Age-standardized] AS Anxiety_1990,
    (curr.[Anxiety disorders (share of population) - Sex: Both - Age: Age-standardized] - prev.[Anxiety disorders (share of population) - Sex: Both - Age: Age-standardized]) AS Point_Change
  FROM 
    [mental-illnesses-prevalence] curr
  JOIN 
    [mental-illnesses-prevalence] prev ON curr.Entity = prev.Entity AND prev.Year = 1990
  WHERE 
    curr.Year = 2019  -- Focus on latest year
    AND curr.[Anxiety disorders (share of population) - Sex: Both - Age: Age-standardized] IS NOT NULL
    AND prev.[Anxiety disorders (share of population) - Sex: Both - Age: Age-standardized] IS NOT NULL
),

treatment_data AS (
  SELECT 
    Entity AS Country,
    Year AS Treatment_Year,
    [Untreated, conditional] AS Untreated_Rate
  FROM 
    [anxiety-disorders-treatment-gap]
  GROUP BY Entity  -- Ensures one row per country
)

SELECT 
  a.Country,
  a.Anxiety_1990 || '% → ' || a.Anxiety_2019 || '%' AS Anxiety_Trend,
  a.Point_Change AS Absolute_Change,
  t.Untreated_Rate || '% (' || t.Treatment_Year || ')' AS Untreated_Data,
  CASE 
    WHEN a.Point_Change > 0.4 AND t.Untreated_Rate > 60 THEN '⭐ CRITICAL'
    WHEN a.Point_Change > 0.3 AND t.Untreated_Rate > 40 THEN '⚠️ HIGH RISK'
    ELSE 'Review'
  END AS Priority
FROM 
  latest_anxiety a
JOIN 
  treatment_data t ON a.Country = t.Country
WHERE 
  a.Point_Change > 0  -- Only worsening trends
ORDER BY 
  (a.Point_Change * t.Untreated_Rate) DESC  -- Sort by combined severity
LIMIT 10;