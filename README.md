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

### **2. Query Evolution & Enhancements**  
**Initial Analysis**:  
```sql
-- Basic anxiety trend calculation (v1)
SELECT Entity, [Anxiety disorders...] 
FROM prevalence 
WHERE Year = 2019;
