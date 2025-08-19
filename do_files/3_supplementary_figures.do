
*supp text figures-Forest area kernel plots

*******************************
**** PART 0: forest basal area changes
******************************** 


set scheme sj

use "$processData/forest.plot_v0.dta",clear  
*Kernel density plots for 2006
keep if year==0


kdensity basal if project==0, generate(x_0  d_0) 
kdensity basal if project==1, generate(x_1  d_1) 

gen zero = (0)
drop if d_0==.
drop if x_0<0
drop if x_1<0
drop if d_1==.
twoway    ///
         rarea d_0 zero x_0, color("gs8%80") plotregion(style(none)) ///
      || rarea d_1 zero x_1, color("gs4%60") plotregion(style(none)) ///
	   xscale(range(0 20000) fextend ) ///
         subtitle(A.Pre-Treatment,size(small)) ///
         ytitle("Density",size(small)) ///
         xtitle("Basal Area in Sq.Cm",size(small)) ///
         legend(cols(1) ring(0) bplacement(neast) position(2) order( 1 "Control Areas" 2     "Treatment Areas") size(vsmall)) ///
		  ylabel(, nolabel notick) ///
		 xlabel(0 5000 10000 15000 20000,labsize(vsmall)) ///
		 xtick(0 5000 10000 15000 20000) ///
		 xsize(5) ///
		 ysize(4) ///
		 name(A, replace)
		 
graph save Graph "$results/kernel_2006_treated_control.gph",replace




use "$processData/forest.plot_v0.dta",clear  
*Kernel density plots for 2011
keep if year==1


kdensity basal if project==0, generate(x_0  d_0) 
kdensity basal if project==1, generate(x_1  d_1) 

gen zero = 0 
drop if x_0<0
drop if x_1<0
drop if d_0==.
drop if d_1==.
twoway    ///
         rarea d_0 zero x_0, color("gs8%80")  plotregion(style(none))  ///
      || rarea d_1 zero x_1, color("gs4%60")  plotregion(style(none)) ///
	   xscale(range(0 25000) fextend ) ///
	   subtitle(B.Post-Treatment,size(small)) ///
         ytitle("Density", size(small)) ///
         xtitle("Basal Area in Sq.Cm",size(small)) ///
         legend(cols(1) ring(0) bplacement(neast) position(2) order( 1 "Control Areas" 2  "Treatment Areas") size(vsmall)) /// 
		  ylabel(, nolabel notick) ///
		 xlabel(0 5000 10000 15000 20000 25000,labsize(vsmall)) ///
		 xtick(0 5000 10000 15000 20000 25000) ///
		 xsize(5) ///
		 ysize(4) ///
		 name(B, replace)
graph save Graph "$results/kernel_2011_treated_control.gph",replace
		 



use "$processData/forest.plot_v0.dta",clear  
*Kernel density plots in project areas
keep if project==1

kdensity basal if year==0, generate(x_0  d_0) 
kdensity basal if year==1, generate(x_1  d_1) 

gen zero = 0 
drop if d_0==.
drop if x_0<0
drop if x_1<0
drop if d_1==.

twoway    ///
         rarea d_0  zero  x_0, color("gs8%80")  plotregion(style(none)) ///
      || rarea d_1  zero x_1, color("gs4%60") plotregion(style(none)) ///
         ytitle("Density",size(small)) ///
         xtitle("Basal Area in Sq.Cm",size(small)) ///
         legend(cols(1) ring(0) bplacement(neast) position(2) order( 1 "Pre-Treatment" 2 "Post-Treatment") size(vsmall)) /// 
		 ylabel(, nolabel notick) ///
		 xlabel(0 5000 10000 15000 20000,labsize(vsmall)) ///
		 xscale(range(0 20000) fextend ) ///
		 xtick(0 5000 10000 15000 20000) ///
		  xsize(5) ///
		 ysize(4) ///
		 name(C, replace)
graph save Graph "$results/kernel_treated_2006_2011.gph",replace
		 
		 


use "$processData/forest.plot_v0.dta",clear  
*Kernel density plots for 2011
keep if project==0

kdensity basal if year==0, generate(x_0  d_0) 
kdensity basal if year==1, generate(x_1  d_1) 

gen zero = 0 
drop if d_0==.
drop if x_0<0
drop if x_1<0
drop if d_1==.

twoway    ///
         rarea d_0 zero x_0, color("gs8%80")  plotregion(style(none)) ///
      || rarea d_1 zero x_1, color("gs4%60") plotregion(style(none)) ///
         ytitle("Density",size(small)) ///
         xtitle("Basal Area in Sq.Cm",size(small)) ///
         legend(position(0) ring(0) cols(1) bplacement(neast) order( 1 "Pre-Treatment" 2 "Post-Treatment") size(vsmall)) /// 
		 ylabel(, nolabel notick) ///
		 xlabel(0 5000 10000 15000 20000 25000,labsize(vsmall)) ///
		 xscale(range(0 25000) fextend ) ///
		 xtick(0 5000 10000 15000 20000 25000) ///
		 xsize(5) ///
		 ysize(4) ///
		 name(D, replace)
		 
graph save Graph "$results/kernel_control_2006_2011.gph",replace

graph combine  A B C D, ///
cols(2) iscale(.7273) ysize(5) xsize(6) ///
graphregion(margin(zero))
graph save Graph "$results/kernel_all_forest_plots.gph",replace
graph export "$results/kernel_all_forest_plots.emf", replace


