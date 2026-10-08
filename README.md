Repeated cross-sectional analysis for spatial patterns UK census Greater London
Data from ward 2001, 2011, 2021 cross-category socio-occupational status and ethnicity

FIles:

* `df_final.xlsx`: the final harmonized dataset. It contains repeated cross-sectional data. Each row is a borough_year unit of observation
  32 boroughs of Greater London plus City of London repeated for 3 waves, i.e. 99 observations
* `df_index.xlsx`: reports the segregation indexes for each subgroup on the ethnic and socio-occupational dimension: Duncan dissimilarity index, Lieberson exposure and Shannon normalized weighted for each subgroup. Not conditional and conditional to each dimension
* `data_manipulation.R`: the code to elaborate and harmonize the data at the ward level contained in the `data_ward` folder and run analyses
