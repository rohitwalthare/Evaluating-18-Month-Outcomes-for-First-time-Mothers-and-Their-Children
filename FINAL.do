
* Set up commands
*log close
clear 
set more off
*log using "final_project.smcl", replace
use "C:\a_fall_2022_courses\Project Evaluation\Final Project\BB_Data.dta"
*use "C:\a_fall_2022_courses\Project Evaluation\Final Project\BabyBook_Datav13.dta"
cd "C:\a_fall_2022_courses\Project Evaluation\Final Project"

*count displays the number of observations in the data*
*num rows = 2468  num rows after dropping unneeded IDs = 2392
*count 

*IDs to drop:drop observations where AWFamID equals the IDs below*
drop if inlist(AWFamID,1431, 1420, 1142, 1121, 1335, 1427, 1503, 1643, 1517, 1271, 1467, 1358, 1414, 1303, 1081, 1433, 1136, 1437, 1401, 1675, 1385, 1299,1468, 1577, 1563, 1359, 1351, 1618, ///
532, 1680, 1419, 1433, 1142, 1437, 1468, 1335, 1081, 1414, 1401, 1431, 1643, 1358, 1503, 1121, 1303, 1467, 1385, 1675, 1136, 1532, 1351, 1121, 1121, 1675, 1142, 1468, 1401, 1303, 1433, ///
1081,  1385, 1335, 1358, 1136, 1437, 1351, 1121, 1643, 1467, 1503, 1437, 1467, 1675, 1643, 1468, 1675)

*Tag the ID of each individual mother with a new variable*
egen ID_tag = tag(AWFamID) 
*check to be sure there are 167 unique IDs left in the data set*
tab ID_tag

* drop rows with data from phone interviews
drop if inlist(WaveSort, 2.2, 2.6, 3.2, 3.6, 4.2, 4.6, 5.2, 5.6, 6.2, 6.4, 6.6, 6.8)

*display number of cols and rows
*describe, short

** below is an approximation of the overall participation rates at each wave - we will report attrition by baby's age **
*tab WaveSort

** below is the crosstab of Wave and StudyGroup 
** StudyGroup is the experimental condition (3 levels)
*tab WaveSort StudyGrp 




******CLEANING CODE********

* Cleaning code from Professor Andrade
** Baby's age in months
gen DOBMonths=(awdate-cDOB)/30.4    /* baby age in month */
replace DOBMonths=0 if WaveSort==1  /*It is prenatal period when WaveSort==1, so we assign 0 to birth date*/

gen DOBMonthsR=round(DOBMonths)     /* gen rounded baby age */
replace DOBMonthsR=0 if WaveSort==1 /* Fill in missing cDOB values from other values (within family ID) */

label var DOBMonths "Baby's age in Months"
label var DOBMonthsR "Baby's age in Months rounded"
*tab DOBMonths
*tab DOBMonthsR


* Renaming VARS of interest 
rename AWBQ18 public_assistance
rename A1BQ18T type_publicassistance
rename A1BQ40 class_now_prev
rename AWBQ20 planned
rename A1MomAge MomAge
rename AWBQ02 race
rename AWBQ03 Hispanic
rename AWBQ04 highest_edu
rename AWBQ05 health_status
rename AWBQ06 marital_status
rename AWBQ11 months_worked_12_mos

*rename and transform
rename AWBQ50 gender
bysort AWFamID: egen gender_t=mean(gender)
*codebook gender_t

*codebook co_habitate
rename AWBQ07S2 co_habitate 
bysort AWFamID: egen co_habitate_t=mode(co_habitate)
*codebook co_habitate_t

rename AWBQ08B regchildcare
bysort AWFamID: egen regchildcare_t=mode(regchildcare)
*codebook regchildcare
*codebook regchildcare_t


** Making descriptive labels for VARs of interest
*codebook race 
label define racel 1 "African-American" 3 "Asian" 4 "White" 6 "Other" 7 "Multi-racial"
label values race racel 
*need to remove duplicate values before tabulating
*tab race
 
*codebook Hispanic 
** levels are 0, 1, and missing
** 0 = no, 1 = yes
label define Hispanicl 0 "Non-Hispanic" 1 "Hispanic"
label values Hispanic Hispanicl
tab Hispanic


*codebook highest_edu 
label define highest_edul 1 "Some high school" 2 "Completed high school or GED" 3 "Some college" 4 "Associate degree" 5 "Bachelor's degree" 6 "Some grad school" 7 "Graduate degree"
label values highest_edu highest_edul 
tab highest_edu

*codebook health_status
label define health_statusl 1 "Excellent" 2 "Very good" 3 "Good" 4 "Fair" 5 "Poor" 
label values health_status health_statusl 
tab health_status

*codebook marital_status
label define marital_statusl 0 "Never married/ Single" 1 "Now married" 2 "Living as married" 3 "Widowed" 4 "Divorced" 5 "Separated" 
label values marital_status marital_statusl 
tab marital_status

*codebook co_habitate 
label define co_habitatel 0 "live alone" 2 "co-habitate father" 1 "co-habitate other adult"  
label values co_habitate_t co_habitatel 
tab co_habitate_t 


****** Creating cross-sectional data set ***************

*frame change default
*frame drop baseline
frame copy default baseline
frame change baseline

tab ID_tag

** VARs to keep for the cross-sectional
keep ID_tag AWFamID AWO1B01C AWO1B02C AWO1B03C AWO1B04C AWO1B05C AWO1B06C AWO1B07C AWO1B08C AWO1B09C AWO1B10C AWO1B11C AWO1B12C AWO1B33C  AWO1B14C  AWO1B15C AWO1B16C AWO1B17C AWO1B18C AWO1B19C AWO1B20C AWO1B21C AWO1B22C AWO1B23C AWO1B24C AWO1B25C AWO1B26C AWO1B27C AWO1B28C AWO1B29C AWO1B30C AWO1B31C regchildcare_t type_publicassistance public_assistance race planned class_now_prev MomAge gender_t Hispanic highest_edu health_status marital_status co_habitate_t StudyGrp DOBMonthsR months_worked_12_mos

* use tab ID_tag to make sure 167 units are still in the data set
*tab ID_tag

**
local baseline AWO1B01C AWO1B02C AWO1B03C AWO1B04C AWO1B05C AWO1B06C AWO1B07C AWO1B08C AWO1B09C AWO1B10C AWO1B11C AWO1B12C AWO1B14C AWO1B15C AWO1B16C AWO1B17C AWO1B18C AWO1B19C AWO1B20C AWO1B21C AWO1B22C AWO1B23C AWO1B24C AWO1B25C AWO1B26C AWO1B27C AWO1B28C AWO1B29C AWO1B30C AWO1B31C

foreach var in `baseline' {
drop if `var'==.
}

* use tab ID_tag to make sure 167 units are still in the data set
*tab ID_tag

*summary statistics of stable characteristics at baseline
*sum AWFamID highest_edu Hispanic health_status marital_status planned race co_habitate_t public_assistance MomAge type_publicassistance class_now_prev regchildcare_t gender_t StudyGrp DOBMonthsR months_worked_12_mos

* creating a variable list to use to test for sig. differences among the groups
*global controls highest_edu Hispanic health_status marital_status planned race co_habitate_t public_assistance type_publicassistance class_now_prev regchildcare_t gender_t DOBMonthsR ///

save cross_sectional_group_2, replace
********************************************************************************



******** Adding calculated columns to the panel data set ***********************
frame change default
*describe, short

** if all 167 moms had participated from wave 1 to wave 7, there would be 1,169 rows (167 X 7 = 1,169)
** attrition across the study period accounts for the fact that there are only 1,130 rows in this data set
*tab StudyGrp WaveSort


**** Parenting Scores, Waves 1 - 7

* Parenting Wave 1 = prenatal
egen Parenting1 = rowtotal(AWO1B03C),m
replace Parenting1=Parenting1/1
*egen Parenting1v2 =rowmean()

* Parenting Wave 2 = 2 mos 
egen Parenting2 = rowtotal(AWO2B08C AWO2B12C),m
replace Parenting2=Parenting2/2

* Parenting Wave 3 = 4 mos  *******************************************************
** the decision to use Parenting2 for Parenting3 needs to be documented in the report
frame copy default Parenting3_df
frame change Parenting3_df
keep Parenting2 WaveSort AWFamID

rename Parenting2 Parenting3
keep if WaveSort ==2
replace WaveSort = 3

*be sure the working directory is set to the the same directory that the default data is in
save Parenting3_df, replace

frame change default
merge 1:1 AWFamID WaveSort using Parenting3_df.dta

*************************************************************************************

* Parenting Wave 5 = 9 mos
egen Parenting5 = rowtotal(AWO5B04C AWO5B06C),m
replace Parenting5=Parenting5/2


* Parenting Wave 4 = 6 mos***********************************************************
** the decision to use Parenting2 for Parenting3 needs to be documented in the report
*frame drop test
frame copy default Parenting4_df
frame change Parenting4_df
keep Parenting5 WaveSort AWFamID

rename Parenting5 Parenting4
keep if WaveSort ==5
replace WaveSort = 4

*be sure the working directly is set to the the same directly that the default data is in
save Parenting4_df, replace

frame change default
merge 1:1 AWFamID WaveSort using Parenting4_df.dta, nogenerate

** check Parenting4 and Parenting5
*order AWFamID WaveSort Parenting2 Parenting3 Parenting4 Parenting5
**************************************************************************************

* Parenting Wave 6 = 12 mos
egen Parenting6 = rowtotal(AWO6B01C AWO6B04C AWO6B10C AWO6B11C AWO6B17C),m
replace Parenting6=Parenting6/5

* Parenting Wave 7 = 18 mos
egen Parenting7= rowtotal(AWO7B03C AWO7B04C AWO7B05C AWO7B07C),m
replace Parenting7=Parenting7/4

egen totalpar_sum= rowtotal(Parenting1 Parenting2 Parenting3 Parenting4 Parenting5 Parenting6 Parenting7)
*egen totalpar_mean= rowmean(Parenting1 Parenting2 Parenting5 Parenting6 Parenting7)
*pwcorr totalpar_sum totalpar_mean

*bysort DOBMonthsR: sum totalpar_sum if StudyGrp==1
*bysort DOBMonthsR: sum totalpar_sum if StudyGrp==3
*bysort DOBMonthsR: sum totalpar_sum
*graphed in Excel*


**** Development Scores, Waves 1 - 7

* Development Wave 1 = prenatal
egen Development1 = rowtotal(AWO1B04C AWO1B06C AWO1B07C AWO1B08C AWO1B33C AWO1B14C AWO1B22C AWO1B23C AWO1B24C AWO1B25C AWO1B30C AWO1B31C),m
replace Development1=Development1/12
*egen Development1v2 =rowmean()

* Development Wave 2 = 2 mos 
egen Development2 = rowtotal(AWO2B02C AWO2B05C AWO2B11C AWO2B13C AWO2B14C AWO2B15C AWO2B17C AWO2B18C AWO2B20C AWO2B23C AWO2B24C AWO2B27C AWO2B29C AWO2B30C),m
replace Development2=Development2/14

* Development Wave 3 = 4 mos
egen Development3 = rowtotal(AWO3B04C AWO3B08C AWO3B11C AWO3B15C),m
replace Development3=Development3/4

* Development Wave 4 = 6 mos
egen Development4 = rowtotal(AWO4B17C AWO4B20C),m
replace Development4=Development4/2

* Development Wave 5 = 9 mos
egen Development5 = rowtotal(AWO5B03C AWO5B07C),m
replace Development5=Development5/2

* Development Wave 6 = 12 mos
egen Development6 = rowtotal(AWO6B02C AWO6B03C AWO6B14C AWO6B16C AWO6B05C),m
replace Development6=Development6/5

* Development Wave 7 = 18 mos
egen Development7= rowtotal(AWO7B08C AWO7B09C AWO7B12C),m 
replace Development7=Development7/3

egen totaldev_sum= rowtotal(Development1 Development2 Development3 Development4 Development5 Development6 Development7)
*egen totaldev_mean= rowmean(Development1 Development2 Development3 Development4 Development5 Development6 Development7)
*pwcorr totaldev_sum totaldev_mean

bysort DOBMonthsR: sum totaldev_sum if StudyGrp==1
bysort DOBMonthsR: sum totaldev_sum if StudyGrp==3
bysort DOBMonthsR: sum totaldev_sum
*graphed in Excel* 

**** Total Knowledge Scores, Waves 1 - 7

* Total_knowledge Wave 1 = prenatal
egen Total_knowledge1 = rowtotal(AWO1B01C AWO1B02C AWO1B03C AWO1B04C AWO1B05C AWO1B06C AWO1B07C AWO1B08C AWO1B09C AWO1B10C AWO1B11C AWO1B12C AWO1B33C AWO1B14C AWO1B15C AWO1B16C ///
AWO1B17C AWO1B18C AWO1B19C AWO1B20C AWO1B21C AWO1B22C AWO1B23C AWO1B24C AWO1B25C AWO1B26C AWO1B27C AWO1B28C AWO1B29C AWO1B30C AWO1B31C),m
replace Total_knowledge1=Total_knowledge1/31
*egen Total_knowledge1v2 =rowmean()

* Total_knowledge Wave 2 = 2 mos 
egen Total_knowledge2 = rowtotal(AWO2B01C AWO2B02C AWO2B03C AWO2B04C AWO2B05C AWO2B06C AWO2B07C AWO2B08C AWO2B09C AWO2B10C AWO2B11C AWO2B12C AWO2B13C AWO2B14C AWO2B15C AWO2B16C ///
AWO2B17C AWO2B18C AWO2B19C AWO2B20C AWO2B21C AWO2B22C AWO2B23C AWO2B24C AWO2B25C AWO2B26C AWO2B27C AWO2B28C AWO2B29C AWO2B30C),m
replace Total_knowledge2=Total_knowledge2/30

* Total_knowledge Wave 3 = 4 mos
egen Total_knowledge3 = rowtotal(AWO3B01C AWO3B02C AWO3B03C AWO3B04C AWO3B05C AWO3B06C AWO3B07C AWO3B08C AWO3B09C AWO3B10C AWO3B11C AWO3B12C AWO3B13C AWO3B14C AWO3B15C AWO3B16C ///
AWO3B17C AWO3B18C AWO3B19C),m
replace Total_knowledge3=Total_knowledge3/19

* Total_knowledge Wave 4 = 6 mos
egen Total_knowledge4 = rowtotal(AWO4B01C AWO4B02C AWO4B03C AWO4B04C AWO4B05C AWO4B06C AWO4B07C AWO4B08C AWO4B09C AWO4B10C AWO4B11C AWO4B12C AWO4B13C AWO4B14C AWO4B15C AWO4B16C ///
AWO4B17C AWO4B18C AWO4B19C AWO4B20C),m
replace Total_knowledge4=Total_knowledge4/20

* Total_knowledge Wave 5 = 9 mos
egen Total_knowledge5 = rowtotal(AWO5B01C AWO5B02C AWO5B03C AWO5B04C AWO5B18C AWO5B06C AWO5B07C AWO5B08C AWO5B09C AWO5B10C AWO5B11C AWO5B12C AWO5B13C AWO5B14C AWO5B15C AWO5B16C),m
replace Total_knowledge5=Total_knowledge5/16


* Total_knowledge Wave 6 = 12 mos
egen Total_knowledge6 = rowtotal(AWO6B01C AWO6B02C AWO6B03C AWO6B04C AWO6B05C AWO6B06C AWO6B07C AWO6B08C AWO6B09C AWO6B10C AWO6B11C AWO6B12C AWO6B13C AWO6B14C AWO6B15C AWO6B16C AWO6B17C),m
replace Total_knowledge6=Total_knowledge6/17

* Total_knowledge Wave 7 = 18 mos
egen Total_knowledge7= rowtotal(AWO7B01C AWO7B02C AWO7B03C AWO7B04C AWO7B05C AWO7B06C AWO7B07C AWO7B08C AWO7B09C AWO7B10C AWO7B11C AWO7B12C AWO7B13C),m
replace Total_knowledge7=Total_knowledge7/13

egen totalknow_sum=rowtotal(Total_knowledge1 Total_knowledge2 Total_knowledge3 Total_knowledge4 Total_knowledge5 Total_knowledge6 Total_knowledge7)
*egen totalknow_mean=rowmean(Total_knowledge1 Total_knowledge2 Total_knowledge3 Total_knowledge4 Total_knowledge5 Total_knowledge6 Total_knowledge7)
*pwcorr totalknow_sum totalknow_mean

*save FINAL, replace

bysort DOBMonthsR: sum totalknow_sum if StudyGrp==1
bysort DOBMonthsR: sum totalknow_sum if StudyGrp==3
bysort DOBMonthsR: sum totalknow_sum
*graphed in Excel*

** drops panel data columns that aren't 1) stable characteristics or 2) calculated columns

*keep AWFamID DOBMonthsR highest_edu Hispanic StudyGrp health_status marital_status planned race co_habitate_t public_assistance MomAge type_publicassistance class_now_prev ///
*regchildcare_t gender_t WaveSort totalpar_sum totaldev_sum totalknow_sum 
  
describe, short

                                       
global controls i.highest_edu Hispanic i.health_status i.marital_status planned i.race i.co_habitate_t public_assistance MomAge i.type_publicassistance class_now_prev regchildcare_t gender_t DOBMonthsR

sum $controls

**************** ANALYSIS BEGINS HERE *****************************************
 
frame copy default AnalysisWave7
frame change AnalysisWave7 

*generate time variable by Baby's age* 
gen round=0 if DOBMonthsR==0
replace round=1 if DOBMonthsR==18


***********  Attrition at 2, 6, 9, 12, and 18 mos ******************************
tab StudyGrp DOBMonthsR

*Testing if attrition is Random or Non-Random*
gen attrited=0

*We define attirited mothers as those mothers who left the study at a given baby's age and did not return to the study for interviews conducted at any of the subsequent baby's ages*
replace attrited=1 if inlist(AWFamID, 1207, 1218, 1224, 1231, 1302, 1311, 1328, 1343, 1350, 1369, 1406, 1428, 1464, 1466, 1496, 1519, 1596, 1608, 1633, 1647, 1648, 1674, 1676)

global covariates highest_edu Hispanic health_status marital_status planned_t race co_habitate_t public_assistance MomAge type_publicassistance regchildcare_t gender_t StudyGrp

bysort AWFamID: egen planned_t=mean(planned)

*Attrition test for all Study Groups:*
foreach x of global covariates {
  describe `x'
  tab `x' attrited if DOBMonthsR==0, chi2
 }
 anova MomAge attrited if DOBMonthsR==0
 
*Attrition test for StudyGrp==1*
 foreach x of global covariates {
  describe `x'
  tab `x' attrited if StudyGrp==1 & DOBMonthsR==0, chi2
 }
  anova MomAge attrited if StudyGrp==1 & DOBMonthsR==0
 
*Attrition test for StudyGrp==2*
 foreach x of global covariates {
  describe `x'
  tab `x' attrited if StudyGrp==2 & DOBMonthsR==0, chi2
 }
 anova MomAge attrited if StudyGrp==2 & DOBMonthsR==0
 
*Attrition test for StudyGrp==3*
 foreach x of global covariates {
  describe `x'
  tab `x' attrited if StudyGrp==3 & DOBMonthsR==0, chi2
 }
 anova MomAge attrited if StudyGrp==3 & DOBMonthsR==0

************ Rates of Change Across Groups *************************************

gen treatment=1 if StudyGrp==1
replace treatment=0 if StudyGrp==3
tab treatment round


gen interaction = treatment*round
reg totalpar_sum round interaction ib3.StudyGrp 

reg totalpar_sum round if StudyGrp ==1
reg totalpar_sum DOBMonthsR if StudyGrp ==1 & DOBMonthsR <19 
ttest totalpar_sum if round ==1, by(treatment)
codebook DOBMonthsR
count if StudyGrp ==1 & DOBMonthsR <19

reg totalpar_sum round ib3.StudyGrp interaction

reg totalpar_sum round if StudyGrp ==3
reg totalpar_sum round ib1.StudyGrp interaction

reg totalpar_sum round if StudyGrp ==2

* Results of model with all three groups + interaction term are the same as results
* with each group modeled separately

********************************************************************************

drop if round==. 
*tab round

*bysort AWFamID: egen planned_t=mean(planned)

*generate treatment variable by StudyGrp*
*drop if StudyGrp==2
*gen treatment=1 if StudyGrp==1
*replace treatment=0 if StudyGrp==3
*tab treatment round

*covariates*
global covariates highest_edu Hispanic marital_status planned_t race co_habitate_t public_assistance MomAge type_publicassistance regchildcare_t gender_t 

******** Checkline Baseline Similarty Among All 3 Groups **********************
* Result #1: the groups are statistically equivalent across all 
* variables except planned - ignore results for Mom's age (ANOVA test is below)
foreach x of global covariates {
describe `x'
tab `x' StudyGrp if round ==0, chi2
}

* Result #2: the groups are also statistically equivalent 
* across these continuous variables at baseline 
anova MomAge StudyGrp if round==0
anova months_worked_12_mos StudyGrp if round ==0
anova totalpar_sum StudyGrp if round ==0
anova totaldev_sum StudyGrp if round ==0
anova totalknow_sum StudyGrp if round ==0


*********** ITT Pre/ Post Analysis Begins Here ********************************
* Dropping group 2 after checking its baseline characteristics along with the other two groups
drop if StudyGrp==2

* Estimating basic characteristics by before and after 
*bys round: sum $covariates

*Using Before-After (Comparison of Means) 
* ALL results are significant at .05 level
ttest totalpar_sum if treatment==1, by(round) 
ttest totaldev_sum if treatment==1, by(round)
ttest totalknow_sum if treatment==1, by(round)

* Pre/Post Regression Models 
* Simple linear Regression 
* All results are significant at .05 level
reg totalpar_sum round if treatment==1
reg totaldev_sum round if treatment==1
reg totalknow_sum round if treatment==1

* Linear Regression with planned covariate only
* ALL results are significant at .05 level
reg totalpar_sum round planned_t if treatment==1
reg totaldev_sum round planned_t if treatment==1
reg totalknow_sum round planned_t if treatment==1

* Multivariate linear regression
* ALL results are significant at .05 level
reg totalpar_sum round $covariates if treatment==1
reg totaldev_sum round $covariates if treatment==1
reg totalknow_sum round $covariates if treatment==1



*********** ITT Randomized Group Analysis Begins Here *************************
*Using Randomized Assignment (Comparison of Means) at Follow-up 
ttest totalpar_sum if round ==1, by(treatment)
ttest totaldev_sum if round ==1, by(treatment)
ttest totalknow_sum if round ==1, by(treatment)

* Randomized assignment regression models 
* Simple linear Regression 
reg totalpar_sum treatment if round ==1
reg totaldev_sum treatment if round ==1
reg totalknow_sum treatment if round ==1

* Linear Regression with planned covariate only
reg totalpar_sum treatment planned_t if round ==1
reg totaldev_sum treatment planned_t if round ==1
reg totalknow_sum treatment planned_t if round ==1

* Multivariate linear regression
reg totalpar_sum treatment $covariates if round ==1
reg totaldev_sum treatment $covariates if round ==1
reg totalknow_sum treatment $covariates if round ==1


*********** ITT Diff in Diff Analysis Begins Here *****************************
gen treat_round = treatment*round

*bys round treatment: sum totalpar_sum
reg totalpar_sum treat_round treatment round

*bys round treatment: sum totaldev_sum
reg totaldev_sum treat_round treatment round

*bys round treatment: sum totalknow_sum
reg totalknow_sum treat_round treatment round


*********** Checking everying on wave 6 ***************************************
frame copy default AnalysisWave6
frame change AnalysisWave6

*generate time variable by Baby's age* 
gen round=0 if DOBMonthsR==0
replace round=1 if DOBMonthsR==12
drop if round==. 
tab round 
bysort AWFamID: egen planned_t=mean(planned)

*generate treatment variable by StudyGrp*
drop if StudyGrp==2
gen treatment=1 if StudyGrp==1
replace treatment=0 if StudyGrp==3
tab treatment

*covariates*
global covariates MomAge ib0.Hispanic ib5.marital_status ib0.planned_t ib4.race ib0.co_habitate_t ib0.public_assistance ib0.regchildcare_t ib0.gender_t 

codebook marital_status

* Correlations 
*corr totalpar_sum highest_edu Hispanic health_status marital_status planned_t race co_habitate_t public_assistance MomAge type_publicassistance regchildcare_t gender_t if round==0
*corr totaldev_sum highest_edu Hispanic health_status marital_status planned_t race co_habitate_t public_assistance MomAge type_publicassistance regchildcare_t gender_t if round==0 
*corr totalknow_sum highest_edu Hispanic health_status marital_status planned_t race co_habitate_t public_assistance MomAge type_publicassistance regchildcare_t gender_t if round==0


*********** TOT Pre/Post Analysis Begins Here ********************************
global covariates planned_t MomAge public_assistance regchildcare_t gender_t Hispanic i.marital_status ib4.race i.co_habitate_t
frame change AnalysisWave7

* Create labels to show in regression tables


label variable planned_t "Planned"
label variable round "Treated"

* Defining the TOT group based on total knowledge improvement

bysort AWFamID: egen baseline_knowledge=mean(Total_knowledge1)
bysort AWFamID: egen final_knowledge=mean(Total_knowledge7)
bysort AWFamID: gen knowledge_change = final_knowledge - baseline_knowledge
tabstat knowledge_change, by(treatment) stats(n mean median sd) 
histogram knowledge_change if StudyGrp ==1


* Create TOT group variable
gen TOT_group = 0
replace TOT_group = 1 if StudyGrp == 1 & knowledge_change >= .21 & knowledge_change != .
tab TOT_group 
keep if TOT_group ==1 | StudyGrp ==3
*tab TOT_group round



** 27 out of 43 study group == 1 moms in the TOT group using this method
*count if TOT_group ==1 & round ==1
*count if StudyGrp ==1 & round ==1


* Pre/Post Regression Models 
* Simple linear Regression 
reg totalpar_sum round if TOT_group ==1
reg totaldev_sum round if TOT_group ==1
reg totalknow_sum round if TOT_group ==1

* Linear Regression with planned covariate only
reg totalpar_sum round planned_t if TOT_group ==1
reg totaldev_sum round planned_t if TOT_group ==1
reg totalknow_sum round planned_t if TOT_group ==1

* Multivariate linear regression
reg totalpar_sum round $covariates if TOT_group ==1
reg totaldev_sum round $covariates if TOT_group ==1
reg totalknow_sum round $covariates if TOT_group ==1



*********** TOT Randomized Group Analysis Begins Here *************************
* Randomized assignment regression models 
* Simple linear Regression
reg totalpar_sum TOT_group if round ==1 
reg totaldev_sum TOT_group if round ==1
reg totalknow_sum TOT_group if round ==1

* Linear Regression with planned covariate only
reg totalpar_sum TOT_group planned_t if round ==1 
reg totaldev_sum TOT_group planned_t if round ==1
reg totalknow_sum TOT_group planned_t if round ==1

* Multivariate linear regression 
reg totalpar_sum TOT_group $covariates if round ==1
reg totaldev_sum TOT_group $covariates if round ==1
reg totalknow_sum TOT_group $covariates if round ==1


*********** TOT Diff in Differences Analysis Begins Here *************************
gen TOT_round = TOT_group*round

*bys TOT_group round: sum totalpar_sum
reg totalpar_sum TOT_round TOT_group round

*bys TOT_group round: sum totaldev_sum
reg totaldev_sum TOT_round TOT_group round

*bys TOT_group round: sum totalknow_sum
reg totalknow_sum TOT_round TOT_group round

tab race

save panel_group_2, replace