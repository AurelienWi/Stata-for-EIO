clear
*************************************** Question 2 ***********************************************************

**** Estimate the linear demand using OLS

* Create an interaction between Z and P
gen InteractPZ = P*Z
* Regress the linear demand
reg Q P tv party InteractPZ

**** Estimate the linear demand using IV
ivregress 2sls Q tv party InteractPZ (P = hp yp)

************************************** Question 3 ************************************************************

* 1) Estimate the demand
ivregress 2sls Q tv party InteractPZ (P = hp yp)
gen betaP = _b[P]
gen betaZP = _b[InteractPZ]

* 2) Use the estimated demand parameter to construct the left hand side of the supply equation
*We need to create Q* to make appear the conduct parameter
gen Qstar = (1/(betaP + betaZP*Z))*Q

* 3) Estimate the supply equation using instruments 
ivregress 2sls P hp yp (Q= tv party) Qstar
gen phi = -(_b[Qstar])


************************************** Question 4 ************************************************************
*Compute marginal cost
gen MC = P + (phi*1/betaP)*Q

mean(MC) if Z==0
mean(MC) if Z==1

************************************** Question 6 **************************************************************

*Compute the mean of the others variables 
mean yp
mean hp
mean tv
mean party
mean Z
