 *******************************
**** PART 0: Forest Plot level analysis 
********************************
 use "$processData/forest.plot_v0.dta",clear
 reg basal year project did slope i.aspect elevation i.district, robust 

 

