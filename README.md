# 🌍 Global Mental Health Trends: SQL Analysis Project  
**Identifying Critical Anxiety Disorder Gaps (1990-2019)**  

![Anxiety Trends vs. Treatment Coverage](outputs/visualization.png)  

## 📌 **Project Motivation**  
**Why This Data?**  
- **Real-World Impact**: Mental health disorders affect 1B+ people globally ([WHO](https://www.who.int/health-topics/mental-health)). This analysis highlights treatment gaps where interventions are most needed.  
- **Understudied Angle**: Most public datasets focus on prevalence alone—I combined **prevalence trends**, **treatment access**, and **disease burden** for actionable insights.  
- **Portfolio-Ready**: Demonstrates ability to work with:  
  - Sparse/mismatched data years  
  - Complex WHO-style column names  
  - Multi-table clinical metrics  

## 🛠️ **Technical Execution**  

### **1. Data Selection & Limitations**  
**Datasets Used**:  
| File | Metrics | Time Span | Coverage |  
|------|---------|-----------|-----------|  
| `mental-illnesses-prevalence.xlsx` | Anxiety/Depression prevalence (%) | 1990-2019 | 195 countries |  
| `anxiety-treatment-gaps.xlsx` | Untreated cases (%) | Varies by country | 42 countries |  

**Known Limitations**:  
- ✖ **Year Mismatches**: Treatment data years vary (e.g., Ukraine: 2015, Chile: 2017)  
- ✖ **Sparse Coverage**: Only 42/195 countries had treatment data  
- ✖ **No Population Adjustments**: Rates are age-standardized but don’t reflect total affected people
- ✖ **Rates of diagnosis/awareness in all countries have massively increased**: Mental health issues were much less documented/understood in the past so the steep increases in cases may be partially due to this.

### **2. SQL Queries I carried out**  
### **Initial Analysis**:  

#### *[Top 10 Countries with Highest Depression Prevalence (2019)](https://github.com/cal-hunter/Mental-Health-SQL-Queries/blob/main/Top%2010%20Countries%20with%20Highest%20Depression%20Prevalence%20(2019).sql)*  
This was the first query I ran on the data, which found ten countries with the highest depression rates in 2019.  

#### **Findings:**  
| Country | Year | Depression Rate |  
|---------|------|-----------------|  
|  Uganda | 2019 | 6.5845194 |  
|  Palestine | 2019 | 6.5845194 |  
|  Greenland | 2019 | 6.5845194 |  
etc...  



#### *[Depression Trends in Countries](https://github.com/cal-hunter/Mental-Health-SQL-Queries/blob/main/Depression%20Trends%20in%20Countries.sql)*  
I then decided to look at the trends of depression in Countries, establishing which countries had the biggest changes in depression from 1990 to 2019. After completing this query I realised there was room for improvement which I will now document.  

#### **Findings:**  
| Country | Rate_1990 | Rate_2019 | Change |   
|---------|-----------|-----------|--------|    
|  Spain | 4.083788	| 4.704455 | 0.620667
|United States |	3.7964869 |	4.375998 |	0.5795111
Mexico |	3.0490386 |	3.5358298 |	0.4867912

etc...  

### **3. Enhancing Depression Trends Query:**  

#### *[Enhanced Depression Trends in Countries](https://github.com/cal-hunter/Mental-Health-SQL-Queries/blob/main/Enhanced%20Depression%20Trends%20in%20Countries.sql)*  
**Problem 1:** In the original the subqueries were nested so became unreadable when using complex logic which was limiting.  
**Solution:** Used common table expressions (CTEs)  

#### 🔧 What I changed
- Before:  
    SELECT (SELECT...FROM...) AS Rate_1990, (SELECT...FROM...) AS
  Change

- After:  
     WITH depression_change AS (...)
  SELECT Country, Rate_2000, Rate_2019 FROM depression_change

**Problem 2:** I had only looked at absolute changes, which lacked context, not showing which trends are clinically significant.  
**Solution:** Calculate a relative percentage change  

#### 🔧 What I added
- ROUND((new - old) / NULLIF(old, 0) * 100, 2)

**Problem 3:** I didn't like how unreadable/unclear the trends were presented in the first query, raw numbers only show so much, especially to an external reader.  
**Solution:** Create severity tears which were inspired by real World Heath Organisation classes which made the data more understandable and actionable.  

#### 🔧 What I added  
- CASE 
  WHEN Percent_Change > 20 THEN 'Severe Worsening'  
  WHEN Percent_Change > 10 THEN 'Moderate Worsening'  
END

#### 🔧 Other things I added  
I also added some data filtering such as: avoiding dividing by zero and excluding group aggregates incase any were included.

### **4. Further SQL Queries I carried out**  

#### *[Anxiety Trends in Countries](https://github.com/cal-hunter/Mental-Health-SQL-Queries/blob/main/Anxiety%20Trends%20in%20Countries.sql)*  
Following on from this, I looked into the trends of anxiety disorders within countries.

### **Final Advanced Analysis**:  
#### *[Analysing the relationship between Anxiety disorder trends and Anxiety Disorder Treatment in Countries](https://github.com/cal-hunter/Mental-Health-SQL-Queries/blob/main/Analysing%20the%20relationship%20between%20Anxiety%20disorder%20trends%20and%20Anxiety%20Disorder%20Treatment%20in%20Countries.sql)*  
To finish off this project I wanted to do a more indepth analysis, using data from separate related excel documents.  
In this query I paired the anxiety trends I had already established, with the latest treatment data on Anxiety in these countries. My query highlighted countries where Anxiety disorders are increasing most rapidly, and where treatment gaps are worst, which together formed a variable which ranked severity (countries with rising anxiety disorders and low treatment for these disorders). 

#### **Limitations & Adjustments**
**Data Constraints**:  
- Treatment data covers only 42/195 countries  
- Year coverage varies (2005-2019) and is only one year for each country 

**Adaptations**:  
1. Used **latest available treatment year** per country  
2. Focused analysis on **countries with both trend + treatment data**  
3. Clearly reported sample size reductions  

**Still Valuable Because**:  
- Reveals **directional insights** (e.g., "All high-anxiety-increase countries with data show >40% untreated rates")  
- Highlights **critical data gaps** for future research

#### **Issues I encountered**  
1) With there being only a select few of data entries to be used I had to somehow work out how to make my query ensure it was only using the ones available.
2) On the first try it only displayed two countries repeating, so I had to figure out how to remove duplicates.
3) Initially the parameters I used were too loose, so no countries were flagging up as critical or high risk, they were all just review, this obviously wasn't what I'd hoped for.



