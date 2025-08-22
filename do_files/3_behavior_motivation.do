*******************************
**** PART 0: Table S17: Table of outputs (Odds Ratio) for motivation regressed on behavior change and other variables
*\ 
******************************** 

 use "$processData/behavior_motivation.dta",clear
logit reason11 gender caste s_age newstv06 hhnum06 education06 newroom06 reason06 project s_fuel s_cg, or robust
 
*******************************
**** PART 1: Table S18-S19: Table of output for dominance analysis
*\ 
******************************** 
use "$processData/behavior_motivation.dta",clear 
encode distid, generate(district)
domin reason11 gender caste age06 newstv06 hhnum06 education06 newroom06 reason06 project fuelch_abs cgrazech_abs district, reg(logit) fitstat(e(r2_p)) nocon nocomp
