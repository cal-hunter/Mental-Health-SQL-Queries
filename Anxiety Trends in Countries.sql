-- ENHANCED ANXIETY TREND ANALYSIS (1990 to Latest Year)

WITH base_data AS (
  SELECT 
    Entity,
    Year,
    [Anxiety disorders (share of population) - Sex: Both - Age: Age-standardized] AS Anxiety_Rate
  FROM 
    [mental-illnesses-prevalence]
  WHERE 
    Year IN (1990, (SELECT MAX(Year) FROM [mental-illnesses-prevalence]))
),

anxiety_changes AS (
  SELECT 
    curr.Entity AS Country,
    prev.Anxiety_Rate AS Anxiety_1990,
    curr.Anxiety_Rate AS Anxiety_Latest,
    curr.Year AS Latest_Year,
    -- Absolute and relative changes
    (curr.Anxiety_Rate - prev.Anxiety_Rate) AS Absolute_Change,
    ROUND(
      ((curr.Anxiety_Rate - prev.Anxiety_Rate) * 100.0 / 
      NULLIF(prev.Anxiety_Rate, 0)), 
      2
    ) AS Percent_Change,
    -- Data quality indicators
    CASE 
      WHEN prev.Anxiety_Rate < 1.0 THEN 'Low Baseline' 
      ELSE 'Normal Baseline'
    END AS Data_Quality
  FROM 
    base_data curr
  JOIN 
    base_data prev ON curr.Entity = prev.Entity AND prev.Year = 1990
  WHERE 
    curr.Year != 1990
)

SELECT 
  Country,
  Anxiety_1990,
  Anxiety_Latest,
  Latest_Year,
  Absolute_Change,
  Percent_Change || '%' AS Percent_Change,
  -- Enhanced trend classification
  CASE 
    WHEN Absolute_Change > 2.0 THEN 'Severe Increase'
    WHEN Absolute_Change > 1.0 THEN 'Moderate Increase'
    WHEN Absolute_Change < -1.0 THEN 'Improvement'
    ELSE 'Minimal Change'
  END AS Trend_Severity,
  Data_Quality
FROM 
  anxiety_changes
WHERE 
  Country NOT LIKE '%income%'
  AND Country NOT LIKE '%region%'
  AND Data_Quality = 'Normal Baseline'
ORDER BY 
  Absolute_Change DESC
LIMIT 10;