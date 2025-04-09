SELECT 
    Entity AS Country, 
    Year, 
    [Depressive disorders (share of population) - Sex: Both - Age: Age-standardized] AS Depression_Rate  
FROM 
    'mental-illnesses-prevalence' 
WHERE 
    Year = 2019  
ORDER BY 
    Depression_Rate DESC  
LIMIT 10;  