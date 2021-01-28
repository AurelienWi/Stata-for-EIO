clear
use "C:\Users\Alexis\Desktop\Cours M1\Semestre 2\Empirical IO\Problem set 2\cars_ps.dta"

*Question 3:
*create the dependent variable 
egen Q = sum(qu), by(country year)
gen L = pop/3
gen sj_s0 = qu/(L-Q)
gen lnsj_s0 = log(sj_s0)

*create the nesting variable
egen Qg = sum(qu), by(country year class)
gen sg = Qg/L
gen sj = qu/L
gen sj_sg = sj/sg
gen lnsj_sg = log(sj_sg)

*define the data as a panel for stata
egen yearcountry=group(year country), label
xtset co yearcountry

*try the ols regression
xtreg lnsj_s0 year country2-country5 horsepower fuel width height weight domestic princ lnsj_sg, fe

*create instruments : the sum of observed characteristics of other products by segment
*and the sums of other products characteristics by segment in the same firm:

egen sum_horsepower = sum(horsepower), by(country year class)
gen other_horsepower = sum_horsepower-horsepower

egen sumfirm_horse = sum(horsepower), by(country year class brand)
gen othersumfirm_horse = sumfirm_horse-horsepower



egen sum_fuel = sum(fuel), by(country year class)
gen other_fuel = sum_fuel-fuel

egen sumfirm_fuel = sum(fuel), by(country year class brand)
gen othersumfirm_fuel = sumfirm_fuel-fuel



egen sum_width = sum(width), by(country year class)
gen other_width = sum_width-width

egen sumfirm_width = sum(width), by(country year class brand)
gen othersumfirm_width = sumfirm_width-width



egen sum_height = sum(height), by(country year class)
gen other_height = sum_height-height

egen sumfirm_height = sum(height), by(country year class brand)
gen othersumfirm_height = sumfirm_height-height



egen sum_weight = sum(weight), by(country year class)
gen other_weight = sum_weight-weight

egen sumfirm_weight = sum(weight), by(country year class brand)
gen othersumfirm_weight = sumfirm_weight-weight



egen sum_domestic = sum(domestic), by(country year class)
gen other_domestic = sum_domestic-domestic

egen sumfirm_domestic = sum(domestic), by(country year class brand)
gen othersumfirm_domestic = sumfirm_domestic-domestic


*first step of the IV regression: 
xtreg princ other_horsepower other_fuel other_width other_height other_weight other_domestic othersumfirm_horse othersumfirm_fuel othersumfirm_width othersumfirm_height othersumfirm_weight othersumfirm_domestic, fe
xtreg lnsj_sg other_horsepower other_fuel other_width other_height other_weight other_domestic othersumfirm_horse othersumfirm_fuel othersumfirm_width othersumfirm_height othersumfirm_weight othersumfirm_domestic, fe

*second step of the IV regression:
xtivreg lnsj_s0 year country2-country5 horsepower fuel width height weight domestic (princ lnsj_sg = other_horsepower other_fuel other_width other_height other_weight other_domestic othersumfirm_horse othersumfirm_fuel othersumfirm_width othersumfirm_height othersumfirm_weight othersumfirm_domestic), fe


*Question 4:
*compute own price elasticities
gen betaprinc = _b[princ]
gen betalnsj_sg = _b[lnsj_sg]
gen elast_own = -(betaprinc)/(1-betalnsj_sg )*sj*(1-betalnsj_sg *sj_sg-(1-betalnsj_sg)*sj)*(princ/sj)

*compute mean own price elasticities for BMW and Mercedes:
egen mean_elastBMW = mean(elast_own) if brand == 3, by(year country)
egen mean_elastMercedes = mean(elast_own) if brand == 16, by(year country)

*compute mean cross-price elasticities for BMW and Mercedes with mergersim package:
mergersim init, nests(class) price(princ) quantity(qu) marketsize(L) firm(brand)

xtivreg M_ls (princ M_lsjg = other_horsepower other_fuel other_width other_height other_weight other_domestic othersumfirm_horse othersumfirm_fuel othersumfirm_width othersumfirm_height othersumfirm_weight othersumfirm_domestic) horsepower fuel width height domestic year country2-country5, fe 	

mergersim market if brand == 3
mergersim market if brand == 16


*Question 5:

*initialize relevant parameters

mergersim init, nests(class) price(princ) quantity(qu) marketsize(L) firm(brand)

*premerger investigation

xtivreg M_ls (princ M_lsjg = other_horsepower other_fuel other_width other_height other_weight other_domestic othersumfirm_horse othersumfirm_fuel othersumfirm_width othersumfirm_height othersumfirm_weight othersumfirm_domestic) horsepower fuel width height domestic year country2-country5, fe 	
mergersim market if year == 1999


*merger simulation: BMW (seller=3) and Mercedes (buyer=16) in Germany 1999

*simulation without cost efficiencies:
mergersim simulate if year == 1999 & country == 3, seller(3) buyer(16) ///
	 method(fixedpoint) maxit(40) dampen(0.5) detail
	
*simulation with 10% cost efficiency: 
mergersim simulate if year == 1999 & country == 3, seller(3) buyer(16) ///
	sellereff(0.10) buyereff(0.10) method(fixedpoint) maxit(40) dampen(0.5) detail
