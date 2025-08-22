
*main text figures-Forest area kernel plots and forest plots, bar graphs, and coefficient plots

*******************************
**** PART 0: Figure 1A,1B,1C forest basal area kernel density plots and Forest plots for basal area
********************************
*Figure 1A 

 use "$processData/forest.plot_v0.dta",clear
  twoway (kdensity basal if project==1 & year==0, bwidth(2000) lcolor(black)
      lwidth(thick) lpattern(longdash_dot)) (kdensity basal if project==0 & year==0,
      bwidth(2000) lcolor(black) lwidth(thick) lpattern(solid) connect(direct)),
      ytitle("Density") xtitle("Basal Area (sq.cm.)") legend(order(1 "Treatment/Post"
      2 "Control/Pre") ring(0))
	  
graph save A1 "$results/Figure_1A.gph", replace
graph export "$results/Figure_1A.emf", replace	

*Figure 1B	  
  
  twoway (kdensity basal if project==1 & year==1, bwidth(2000) lcolor(black)
      lwidth(thick) lpattern(longdash_dot)) (kdensity basal if project==0 & year==1,
      bwidth(2000) lcolor(black) lwidth(thick) lpattern(solid) connect(direct)),
      ytitle("Density") xtitle("Basal Area (sq.cm.)") legend(order(1 "Treatment/Post"
      2 "Control/Post") ring(0))
	  
graph save B1 "$results/Figure_1B.gph", replace
graph export "$results/Figure_1B.emf", replace	  

 *Figure 1C
 use "$processData/forestplot_basal.dta",clear 
 
 rename *, lower
 destring highci, replace
 
gen depvar1=.
replace depvar1=1 if basal=="project"
replace depvar1=2 if basal=="year"
replace depvar1=3 if basal=="did"
lab define depvar1 1 "Project"  2 "Year" 3 "DiD"  , replace 
lab val depvar1 depvar1
set scheme sj
 
  twoway    ///
         (scatter depvar1 coefficient, mcolor(black) msize(small) msymbol(circle)) (rcap lowci highci depvar1, lcolor(black) lwidth(medthick) lpattern(solid) horizontal) , plotregion(style(none)) ///
          ylabel(#3, labels angle(horizontal) valuelabel labsize(*2))  ///
		  xline(0, lwidth(thin) lcolor(red)) ///
		  xscale(range(-3500 3500)) ///
		  yscale(range(0.8, 1.7)) ///
		 ytitle("",size(small)) ///
         xtitle("Coefficient",size(small)) ///
         legend(cols(1) ring(0) bplacement(neast) position(2) label(1 "Coefficient") label(2 "95% CI") size(vsmall)) /// 
		 xlabel(-3500(1000)3500,labsize(small)) ///
		 ylabel(,labsize(small)) ///
		 xmtick(-3500(1000)3500) ///
		 xsize(3) ysize(3) ///
		 name(C1, replace)
		 		 
graph save C1 "$results/Figure_1C.gph", replace
graph export "$results/Figure_1C.emf", replace

*Figure 2A
set scheme sj
use "$processData/data_v1.dta", clear
twoway (kdensity hhfuel06 if project==0, bwidth(20) lcolor(black) lwidth(thick) lpattern(longdash_dot)) ///
 (kdensity hhfuel06 if project==1, bwidth(20) lcolor(black) lwidth(thick) lpattern(solid)), ///
 ytitle("Density") xtitle("% Household Energy from Fuelwood") legend(order(1 "Control/Pre" 2 "Treatment/Pre") position(6) ring(0)) ///
 name(A2A, replace)
 
twoway (kdensity hhfuel11 if project==0, bwidth(20) lcolor(black) lwidth(thick) lpattern(longdash_dot)) ///
 (kdensity hhfuel11 if project==1, bwidth(20) lcolor(black) lwidth(thick) lpattern(solid)), ///
 ytitle("Density") xtitle("% Household Energy from Fuelwood") legend(order(1 "Control/Post" 2 "Treatment/Post") position(6) ring(0)) ///
 name(A2B, replace)
 
graph combine A2A A2B, ycommon xcommon name(A2, replace)
graph display A2, xsize(10) ysize(6)
graph save A2 "$results/fig2A_fuel-kdensity-horizontal.gph",  xsize(10) ysize(6) replace
graph export "$results/fig2A_fuel-kdensity-horizontal.emf", replace

*Figure 2B

*Figure 2C
set scheme sj
* Bar Graphs for Fuel zero and cattle zero
use "$processData/bargraph.dta",clear  
lab define Project 1 "Treatment" 0 "Control", replace
lab val Project Project

gen behavior=3 if Behavior=="Forests for Fuel"
replace behavior=4 if Behavior=="Cattle-Open Grazing "
keep if behavior==3 | behavior==4

lab define behavior 3 " Zero Fuel from Forests" 4  " Zero Cattle Open Grazing" , replace
lab val behavior behavior

graph bar ProportionofHouseholds, over(Project) over(behavior,label(labsize(vsmall))) asyvars bar(1, color(gs10)) bar(2, color(gs12)) bar(3, color(gs14)) blabel(total, format(%3.2f) size(vsmall)) plotregion(style(none)) ///
ytitle("Percentage of Households",size(vsmall)) ///
legend(size(vsmall)) /// 
ylabel(,labsize(vsmall)) ///
name(C2, replace)
graph save C2 "$results/Figure_2C.gph",replace
graph export "$results/Figure_2C.emf", replace


*Figure 2D
use "$processData/results_project.dta",clear 
 
drop if DependentVariable=="LPGNew" | DependentVariable=="CattleStalllNew" | DependentVariable=="ReasonChange"

gen depvar1= DependentVariable
replace depvar1="4" if DependentVariable== "Fuel Change"
replace depvar1="3" if DependentVariable== "FuelZero"
replace depvar1="2" if DependentVariable== "Cattle Change"
replace depvar1="1" if DependentVariable== "CattleZero"

destring depvar1, replace
 
 lab define depvar1 4 "Fuel Change"  3 "Fuel Zero" 2 "Graze Change" 1 "Graze Zero"  , replace 
 
 lab val depvar1 depvar1
 
 
 rename *, lower
 set scheme s1mono
 
  twoway    ///
         (scatter depvar1 ate, mcolor(black) msize(small) msymbol(circle)) (rcap loci hici depvar1, lcolor(black) lwidth(medthick) lpattern(solid) horizontal) if matchingmethods=="NNMATCH3", plotregion(style(none)) ///
          ylabel(#5, labels angle(horizontal) valuelabel) ///
		  xline(0, lwidth(thin) lcolor(red)) ///
		  xscale(range(-.5 .3)) ///
		  yscale(range(1 (1) 4)) ///
		 ytitle("",size(small)) ///
         xtitle("Average Treatment Effect",size(small)) ///
         legend(cols(1) ring(0) bplacement(neast) position(2) label(1 "ATE") label(2 "95% CI") size(vsmall)) /// 
		 xlabel(-.5(.1).3,labsize(small)) ///
		 ylabel(,labsize(small)) ///
		 xmtick(-.5(.1).3) ///
		 name(D2, replace)
		 	 
graph save D2 "$results/Figure2D.gph",replace
graph export "$results/Figure2D.emf", replace

*Figure 3A
set scheme sj
 use "$processData/data_v1.dta",clear  
 gen reasonch_nostd=0 if reason==1 |reason==4
 replace reasonch_nostd=1 if reason==3
 replace reasonch_nostd=-1 if reason==2
 
gen dummy=reasonch_nostd
label define dummy 0 "No Change" -1 "Crowding Out" 1 "Reinforcing"
lab val dummy dummy
lab define project 1 "Treatment" 0 "Control", replace
lab val project project


*crowding out and control
gen temp1=(reasonch_nostd==0 & project==1)
*	Nochange and control
gen temp2=(reasonch_nostd==1 & project==1)
*Reinforcing and control
gen temp3=(reasonch_nostd==-1 & project==1)

*crowding out in treatment
gen temp4=(reasonch_nostd==0 & project==0)
*no change in treatment
gen temp5=(reasonch_nostd==1 & project==0)
*reinforcing in treatment
gen temp6=(reasonch_nostd==-1 & project==0)


*Bar-graph motivation number

gen number=384 if temp1==1
replace number=158 if temp2==1
replace number=266 if temp3==1
replace number=281 if temp4==1
replace number=188 if temp5==1
replace number=156 if temp6==1

format number %3.0f

graph bar number , over(dummy) over(project,label(labsize(vsmall))) asyvars bar(1, color(gs10)) bar(2, color(gs12)) bar(3, color(gs14)) blabel(total, format(%3.0f) size(vsmall)) plotregion(style(none)) ///
ytitle("Number of Households",size(vsmall)) ///
legend(size(vsmall)) /// 
ylabel(,labsize(vsmall)) ///
name(A3, replace) 
graph save A3 "$results/Figure3A.gph",replace
graph export "$results/Figure3A.emf", replace

*Figure 3B
use "$processData/results_reasonchange_subsample.dta",clear
gen depvar1= DependentVariable

replace depvar1="0" if DependentVariable=="Project participation"
replace depvar1="1" if DependentVariable== "Household Size: Large"
replace depvar1="2" if DependentVariable== "Household Size: Medium"
replace depvar1="3" if DependentVariable== "Household Size: Small"
replace depvar1="4" if DependentVariable== "Caste: High"
replace depvar1="5" if DependentVariable== "Caste: Low"
replace depvar1="6" if DependentVariable== "Education: 7 years or less"
replace depvar1="7" if DependentVariable== "Education: 8 years or more"
replace depvar1="8" if DependentVariable== "Age: 40 years or less"
replace depvar1="9" if DependentVariable== "Age: 41 years or more"
replace depvar1="10" if DependentVariable== "Gender: Female"
replace depvar1="11" if DependentVariable== "Gender: Male"
replace depvar1="12" if DependentVariable== "Project area resident"

destring depvar1, replace
 
 lab define depvar1 12 "Project area resident"  11 "Gender: Male" 10 "Gender: Female" 9 "Age: 41 years or more" 8 "Age: 40 years or less" 7 "Education: 7 years or less" 6 "Education: 8 years or more"  5 "Caste: Low" 4 "Caste: High" 3 "Household Size: Small" 2 "Household Size: Medium" 1 "Household Size: Large" 0 "Project participation", replace

 
 lab val depvar1 depvar1
 

 rename *, lower
 set scheme sj
 
  twoway    ///
         (scatter depvar1 ate, mcolor(black) msize(small) msymbol(circle)) (rcap loci hici depvar1, lcolor(black) lwidth(medthick) lpattern(solid) horizontal), plotregion(style(none)) ///
          ylabel(#15, labels angle(horizontal) valuelabel) ///
		  xline(0, lwidth(thin) lcolor(red)) ///
		  xscale(range(-.4 .2)) ///
		  yscale(range(0 (1) 12)) ///
		 ytitle("",size(small)) ///
         xtitle("Average Treatment Effect",size(small)) ///
         legend(cols(1) ring(0) margin(zero) bplacement(neast) position(1) label(1 "ATE") label(2 "95% CI") size(vsmall)) /// 
		 xlabel(-.4(.1).2,labsize(small)) ///
		 ylabel(,labsize(small)) ///
		 xmtick(-.4(.1).2) ///
		 xsize(6) ysize(3) ///
		 name(B3, replace)
		 	 
graph save B3 "$results/Figure3B.gph",replace
graph export "$results/Figure3B.emf", replace
