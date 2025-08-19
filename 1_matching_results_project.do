
   * ******************************************************************** *
   * ******************************************************************** *
   *                                                                      *
   *   Replicating results for behavioral variables and reason change    *
   *               using differnt matching techniques                     *       
   *                                                                      *
   *                                                                      *                       
   *                                                                      *
   *                                                                      *
   *                                                                      *
   * ******************************************************************** *
   * ******************************************************************** *

       /*
       ** PURPOSE:      The purpose of this do file is calculate ATE for different models, different outcome variables using three different types of matching techniques.  
       ** OUTLINE:      PART 0: Forest Basal Area
                        PART 1: Behavior variables
						PART 2: Motivation variables
						PART 3: Did for Behavior variables
						PART 2: Did for Motivation
                    

       ** WRITEN BY:    Varnitha Kurli

       ** Last date modified:  Dec 27th, 2024
       */

*Treatment variables meaning
use "$processData/data_v0.dta" , clear
gen parti_proj=1 if parti==1 & project==1
replace parti_proj=0 if parti==0 & project==1 
lab var parti_proj "1 if hh are participating and are in project 0 if hh are not participating and are in project"
gen parti_non_proj=1 if parti==1 
replace parti_non_proj=0 if project==0 
lab var parti_non_proj "1 if hh is participating 0 if hh is in non-project areas"
gen non_parti=.
replace non_parti=1 if parti==0 & project==1
replace non_parti=0 if project==0
lab var parti_non_proj "1 if hh is  not participating in project 0 if hh is in non-project areas"


gen fuelch_nostd=hhfuel06-hhfuel11
lab var fuelch_nostd "Non standardized chnage in hhfuel from hhfuel2011-hhfuel2006"

gen cgrazech_nostd=cgraze06-cgraze11
lab var fuelch_nostd "Non standardized chnage in cattle graze. cgraze2006-cgraze2011"

gen fuelzero_nostd=(hhfuel11==0 & hhfuel06!=0)

lab var fuelzero_nostd "Non standardized value where hhfuelin2011 drops to zero"


gen cgrazezero_nostd=(cgraze11==0 & cgraze06!=0 )

lab var cgrazezero_nostd "Non standardized value where cattle grazing in 2011 drops to zero"

gen lpgnew_nostd=(lpg11==1 & lpg06==0)
gen cstallnew_nostd=(cstall11!=0 & cstall06==0)

lab var lpgnew_nostd "Non standardized value where new lpg connection in 2011"
lab var cstallnew_nostd "Non standardized value where cattle stall changes from 0 to some non-zero value in 2011"

*choosing the cutoffs to form groups with approximately the same number per group for fuelcut and cstallcut
egen fuelcut =cut(hhfuel06), group(4) label

egen cgrazecut =cut(cgraze06), group(4) label

* generate standardized variables

egen fuelch=std(fuelch_nostd), mean(0) std(1)
egen cgrazech=std(cgrazech_nostd), mean(0) std(1)
egen lpgnew=std(lpgnew_nostd), mean(0) std(1)
egen cstallnew=std(cstallnew_nostd), mean(0) std(1)
egen fuelzero=std(fuelzero_nostd), mean(0) std(1)
egen cgrazezero=std(cgrazezero_nostd), mean(0) std(1)
egen hhfuel06_std=std(hhfuel06), mean(0) std(1)
gen reasonch1=0 if reason==1
replace reasonch1=0 if reason==4
replace reasonch1=1 if reason==3
replace reasonch1=-1 if reason==2
egen reasonch=std(reasonch1), mean(0) std(1)
save "$processData/data_v1.dta" , replace


*******************************
**** PART 0: Model 1-Project vs Non-Project
*\ diff model for forest basal area
******************************** 

 use "$processData/forest.plot_v0.dta",clear  
 
 // Diff-in-Diff
  
log using "$logs/forest_basalarea.log",replace

*reg basal project year did
reg basal i.pair i.aspect project year did slope elevation, robust
  
log close


 
*******************************
**** PART 1: Model 1-Project vs Non-Project
*\ nnmatch,psmatch2, and diff models for different behavior variables
******************************** 
use "$processData/data_household.dta", clear
log using "$logs/behavior.log" ,replace
cem reasonch fuelcut hhnum06(3.5) newroom06(2.2) hhfuel06(60.7) newspaper06(4.5), tr(project)
nnmatch fuelch project hhfuel06 hhnum06 newroom06 sc months06  newspaper06 irrigate06 lpg06 if cem_matched==1 , exact(pair reason2006) m(4) 
est store fch_nnmatch_proj1
nnmatch fuelch project hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 lpg06 if cem_matched==1, exact(pair reason2006) m(4) robust(4)
est store fch_cem2_proj2
nnmatch fuelch project hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 lpg06 if cem_matched==1, exact(pair reason2006) m(4) robust(4) bias(hhfuel06)
est store fch_cem2_proj3
bootstrap r(ate), reps(100): psmatch2 project if cem_matched==1, outcome(fuelch) mahal(hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 lpg06) neighbor(4) ai(4) ate
est store fch_psmatch2_proj1

cem reasonch fuelcut hhnum06(3.5) newroom06(2.2) hhfuel06(60.7) newspaper06(4.5), tr(project)
nnmatch fuelzero project hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 lpg06  if cem_matched==1, exact(pair reason2006) m(4)  
est store f0_nnmatch_proj1
nnmatch fuelzero project hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 lpg06 if cem_matched==1, exact(pair reason2006) m(4) robust(4) 
est store f0_nnmatch_proj2
nnmatch fuelzero project hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 lpg06 if cem_matched==1, exact(pair reason2006) m(4) robust(4) bias(hhfuel06)
est store f0_nnmatch_proj3
bootstrap r(ate), reps(100): psmatch2 project if cem_matched==1, outcome(fuelzero) mahal(hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 lpg06) neighbor(4) ai(4) ate 
est store f0_psmatch2_proj1

cem reasonch fuelcut hhnum06(3.5) newroom06(2.2) hhfuel06(60.7) newspaper06(4.5), tr(project)
nnmatch lpgnew project hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 lpg06 if cem_matched==1, exact(pair reason2006) m(4)  
est store lpg_nnmatch_proj1
nnmatch lpgnew project hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 lpg06 if cem_matched==1, exact(pair reason2006) m(4) robust(4) 
est store lpg_nnmatch_proj2
nnmatch lpgnew project hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 lpg06 if cem_matched==1, exact(pair reason2006) m(4) robust(4) bias(hhfuel06)
est store lpg_nnmatch_proj3
bootstrap r(ate), reps(100): psmatch2 project if cem_matched==1, outcome(lpgnew) mahal(hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 lpg06) neighbor(4) ai(4) ate
est store lpg_psmatch2_proj1

cem reasonch cgrazecut hhnum06(3.5) newroom06(2.2) cgraze06(0.5) newspaper06(4.5), tr(project)
nnmatch cgrazech project hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 cstall06 if cem_matched==1 , exact(pair reason2006) m(4)  
est store cch_nnmatch_proj1
nnmatch cgrazech project hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 cstall06 if cem_matched==1, exact(pair reason2006) m(4) robust(4) 
est store cch_nnmatch_proj2 
nnmatch cgrazech project hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 cstall06 if cem_matched==1, exact(pair reason2006) m(4) robust(4) bias(cgraze06)
est store cch_nnmatch_proj3
bootstrap r(ate), reps(100): psmatch2 project if cem_matched==1, outcome(cgrazech) mahal(hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 cstall06) neighbor(4) ai(4) ate 
est store cch_psmatch2_proj1

cem reasonch cgrazecut hhnum06(3.5) newroom06(2.2) cgraze06(0.5) newspaper06(4.5), tr(project)
nnmatch cgrazezero project hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 cstall06 if cem_matched==1, exact(pair reason2006) m(4) 
est store c0_nnmatch_proj1
nnmatch cgrazezero project hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 cstall06 if cem_matched==1, exact(pair reason2006) m(4) robust(4) 
est store c0_nnmatch_proj2
nnmatch cgrazezero project hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 cstall06 if cem_matched==1, exact(pair reason2006) m(4) robust(4) bias(cgraze06)
est store c0_nnmatch_proj3
bootstrap r(ate), reps(100): psmatch2 project if cem_matched==1, outcome(cgrazezero) mahal(hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 cstall06) neighbor(4) ai(4) ate
est store c0_psmatch2_proj1

cem reasonch cgrazecut hhnum06(3.5) newroom06(2.2) cgraze06(0.5) newspaper06(4.5), tr(project)
nnmatch cstallnew project hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 cstall06 if cem_matched==1, exact(pair reason2006) m(4)
est store cstall_nnmatch_proj1
nnmatch cstallnew project hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 cstall06 if cem_matched==1, exact(pair reason2006) m(4) robust(4) 
est store cstall_nnmatch_proj2
nnmatch cstallnew project hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 cstall06 if cem_matched==1, exact(pair reason2006) m(4) robust(4) bias(cgraze06)
est store cstall_nnmatch_proj3
bootstrap r(ate), reps(100): psmatch2 project if cem_matched==1, outcome(cstallnew) mahal(hhfuel06 hhnum06 newroom06 sc months06 cgraze06 newspaper06 irrigate06 cstall06) neighbor(4) ai(4) ate
est store cstall_psmatch2_proj1

log close

*******************************
**** PART 2: Model 1-Project vs Non-Project
*\ nnmatch3 for motivatiob variable -full sample and different sub-sample. 
******************************** 

use "$processData/data_individual.dta", clear
log using "$logs/motivation.log" ,replace

* The outcome variable here is reasonch and we explore different sub-samples
*cem gender06 sc age06(25.5) education06(6) newstv06(2.6) hhfuel06(60.7) cstall06(1.6),tr(project)
cem reasonch hhnum06(3.5) newroom06(2.2) hhfuel06(60.7) newstv06(1.1), tr(project)
nnmatch reasonch1 project sc age06 education06 newroom06 newstv06 if cem_matched ==1, exact(reason2006 pair) m(4) robust(4) bias(education06 age06)
nnmatch reasonch1 project sc age06 education06 newroom06 newstv06 if gender06==0 & cem_matched ==1, exact(reason2006 pair) m(4) robust(4) bias(education06 age06)
nnmatch reason project sc age06 education06 newroom06 newstv06 if gender06==1 & cem_matched ==1, exact(reason2006 pair) m(4) robust(4) bias(education06 age06)
nnmatch reasonch1 project sc age06 education06 newroom06 newstv06 if age06 >=41 & cem_matched ==1 , exact(reason2006 pair) m(4) robust(4) bias(education06 age06)
nnmatch reason project sc age06 education06 newroom06 newstv06 if age06 <41 & cem_matched ==1, exact(reason2006 pair) m(4) robust(4) bias(education06 age06)
nnmatch reasonch1 project sc age06 education06 newroom06 newstv06 if education06>=8 & cem_matched ==1, exact(reason2006 pair) m(4) robust(4) bias(education06 age06)
nnmatch reasonch1 project sc age06 education06 newroom06 newstv06 if education06<8 & cem_matched ==1, exact(reason2006 pair) m(4) robust(4) bias(education06 age06)
nnmatch reasonch1 project sc age06 education06 newroom06 newstv06 if sc==1 & cem_matched ==1, exact(reason2006 pair) m(4) robust(4) bias(education06 age06)
nnmatch reasonch1 project sc age06 education06 newroom06 newstv06 if sc==0 & cem_matched ==1, exact(reason2006 pair) m(4) robust(4) bias(education06 age06)
nnmatch reasonch1 project sc age06 education06 newroom06 newstv06 if hhnum06 <=2 & cem_matched ==1, exact(reason2006 pair) m(4) robust(4) bias(education06 age06)
nnmatch reasonch1 project sc age06 education06 newroom06 newstv06 if hhnum06 >2 & hhnum06 <=4 & cem_matched ==1, exact(reason2006 pair) m(4) robust(4) bias(education06 age06)
nnmatch reasonch1 project sc age06 education06 newroom06 newstv06 if hhnum06 >4 & cem_matched ==1, exact(reason2006 pair) m(4) robust(4) bias(education06 age06)
cem reasonch hhnum06(3.5) newroom06(2.2) hhfuel06(60.7) newstv06(1.1) if project==1, tr(parti)
nnmatch reasonch1 parti sc age06 education06 newroom06 newstv06 if project==1 & cem_matched ==1, exact(reason2006 pair) m(4) robust(4) bias(education06 age06)
log close

*******************************
**** PART 3: -Project vs Non-Project
*\ diff in diff for different behavior variables
******************************** 

* Diff-in-diff 
log using "$logs/behavior.log", append
use "$processData/data_household.dta",clear  
keep reasonch fuelcut cgrazecut hhnum06 newroom06 newspaper06 hhid hhfuel06 hhfuel11 cgraze06 cgraze11 lpg06 lpg11 cstall11 cstall06 project
cem reasonch cgrazecut hhnum06(3.5) newroom06(2.2) cgraze06(0.5) newspaper06(4.5), tr(project) 
 rename hhnum06 hhnum
 rename newroom06 newroom
 rename newspaper06 newspaper
 rename hhfuel06 hhfuel6
 rename cgraze06 cgraze6
 rename lpg06 lpg6
 rename cstall06 cstall6
 reshape long hhfuel cgraze lpg cstall , i(hhid) j(j)
 rename j year
 gen time= (year==11)
 egen hhfuel_std=std(hhfuel), mean(0) std(1)
 egen cgraze_std=std(cgraze),mean(0) std(1)
 gen fuelzero=1 if (hhfuel[_n]<hhfuel[_n-1])
 replace fuelzero=0 if fuelzero==1 & hhfuel>0 
 replace fuelzero=0 if fuelzero==.
 gen cgrazezero=1 if (cgraze[_n]<cgraze[_n-1])
 replace cgrazezero=0 if cgrazezero==1 & cgraze>0
 replace cgrazezero=0 if cgrazezero==.
 gen lpgnew=1 if    (lpg[_n]!=lpg[_n-1]) 
 replace lpgnew=0 if year==06
 replace lpgnew=0 if lpgnew==.
 gen t=1 if(cstall>0)
 replace t=0 if (cstall==0)
 gen cstallnew=1 if    (t[_n]!=t[_n-1]) & (t[_n]>t[_n-1])
 replace cstallnew=0 if year==06
 replace cstallnew=0 if cstallnew==.
 egen fuelzero_std=std(fuelzero), mean(0) std(1)
 egen cgrazezero_std=std(cgrazezero),mean(0) std(1)
 egen lpgnew_std=std(lpgnew), mean(0) std(1)
 egen cstallnew_std=std(cstallnew),mean(0) std(1)
 
gen did=project*time
gen hh_cem=1 if cem_matched==1
replace hh_cem=0 if hh_cem==.
bysort hhid: replace hh_cem = 1 if hh_cem[_n-1]==1
reg cgraze_std project time did
reg cgrazezero_std project time did
reg cstallnew_std project time did

use "$processData/data_household.dta",clear  
keep reasonch fuelcut cgrazecut hhnum06 newroom06 newspaper06 hhid hhfuel06 hhfuel11 cgraze06 cgraze11 lpg06 lpg11 cstall11 cstall06 project
cem reasonch fuelcut hhnum06(3.5) newroom06(2.2) hhfuel06(60.7) newspaper06(4.5), tr(project) 
 rename hhnum06 hhnum
 rename newroom06 newroom
 rename newspaper06 newspaper
 rename hhfuel06 hhfuel6
 rename cgraze06 cgraze6
 rename lpg06 lpg6
 rename cstall06 cstall6
 reshape long hhfuel cgraze lpg cstall , i(hhid) j(j)
 rename j year
 gen time= (year==11)
 egen hhfuel_std=std(hhfuel), mean(0) std(1)
 egen cgraze_std=std(cgraze),mean(0) std(1)
 gen fuelzero=1 if (hhfuel[_n]<hhfuel[_n-1])
 replace fuelzero=0 if fuelzero==1 & hhfuel>0 
 replace fuelzero=0 if fuelzero==.
 gen cgrazezero=1 if (cgraze[_n]<cgraze[_n-1])
 replace cgrazezero=0 if cgrazezero==1 & cgraze>0
 replace cgrazezero=0 if cgrazezero==.
 gen lpgnew=1 if    (lpg[_n]!=lpg[_n-1]) 
 replace lpgnew=0 if year==06
 replace lpgnew=0 if lpgnew==.
 gen t=1 if(cstall>0)
 replace t=0 if (cstall==0)
 gen cstallnew=1 if    (t[_n]!=t[_n-1]) & (t[_n]>t[_n-1])
 replace cstallnew=0 if year==06
 replace cstallnew=0 if cstallnew==.
 egen fuelzero_std=std(fuelzero), mean(0) std(1)
 egen cgrazezero_std=std(cgrazezero),mean(0) std(1)
 egen lpgnew_std=std(lpgnew), mean(0) std(1)
 egen cstallnew_std=std(cstallnew),mean(0) std(1)
 
gen did=project*time
gen hh_cem=1 if cem_matched==1
replace hh_cem=0 if hh_cem==.
bysort hhid: replace hh_cem = 1 if hh_cem[_n-1]==1
reg hhfuel_std project time did
reg fuelzero_std project time did
reg lpgnew_std project time did

log close



*******************************
**** PART 4: -Project vs Non-Project
*\ diff in diff for different motivation variables
******************************** 

use "$processData/data_individual.dta", clear  
log using "$logs/motivation.log" ,append
keep gender06 sc age06 education06 newstv11 newstv06 panchgh1 hhfuel06 hhfuel11 cstall11 cstall06 project reason2006 reasonforest11 hhid
cem gender06 sc age06(25.5) education06(5.5) newstv06(2.5) panchgh1 hhfuel06(50) cstall06(0.5),tr(project)
ren reasonforest11 reason11
rename age06 age
rename education06 education
rename gender06 gender
reshape long reason hhfuel cstall newstv, i(hhid) j(j)
drop if j==6
replace hhfuel= hhfuel06 if j==2006
replace cstall =cstall06 if j==2006
replace newstv=newstv06 if j==2006
drop *06
rename j year
gen time= (year==11) 
gen hh_cem=1 if cem_matched==1
replace hh_cem=0 if hh_cem==.
bysort hhid: replace hh_cem = 1 if hh_cem[_n-1]==1
 egen reason_std=std(reason),mean(0) std(1)

diff reason if hh_cem==1, t(project) period(time)


log close
 
 
 
