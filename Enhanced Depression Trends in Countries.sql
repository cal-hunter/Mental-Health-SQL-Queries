-- WORKING ENHANCED DEPRESSION TREND ANALYSIS

WITH depression_change AS (
  SELECT 
    curr.Entity AS Country,
    prev.[Depressive disorders (share of population) - Sex: Both - Age: Age-standardized] AS Rate_2000,
    curr.[Depressive disorders (share of population) - Sex: Both - Age: Age-standardized] AS Rate_2019,
    
    -- Absolute change
    (curr.[Depressive disorders (share of population) - Sex: Both - Age: Age-standardized] - 
     prev.[Depressive disorders (share of population) - Sex: Both - Age: Age-standardized]) AS Absolute_Change,
    
    -- Percentage change (fixed parentheses)
    ROUND(
      (curr.[Depressive disorders (share of population) - Sex: Both - Age: Age-standardized] - 
       prev.[Depressive disorders (share of population) - Sex: Both - Age: Age-standardized]) / 
      prev.[Depressive disorders (share of population) - Sex: Both - Age: Age-standardized] * 100, 
      2
    ) AS Percent_Change
  FROM 
    [mental-illnesses-prevalence] curr
  JOIN 
    [mental-illnesses-prevalence] prev 
    ON curr.Entity = prev.Entity AND prev.Year = 2000
  WHERE 
    curr.Year = 2019
    AND prev.[Depressive disorders (share of population) - Sex: Both - Age: Age-standardized] > 0  -- Avoid division by zero
    AND curr.Entity NOT LIKE '%World%'
    AND curr.Entity NOT LIKE '%income%'
)

SELECT 
  Country,
  Rate_2000,
  Rate_2019,
  Absolute_Change,
  Percent_Change,
  CASE 
    WHEN Percent_Change > 20 THEN 'Severe Worsening'
    WHEN Percent_Change > 10 THEN 'Moderate Worsening'
    WHEN Percent_Change < -10 THEN 'Improving'
    ELSE 'Stable'
  END AS Trend_Category
FROM 
  depression_change
WHERE 
  ABS(Percent_Change) > 10
ORDER BY 
  Absolute_Change DESC
LIMIT 15;