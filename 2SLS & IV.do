* https://www.youtube.com/watch?v=cbLV981V5Ok

***********************************************************************
*				    	Instrumental Variables
***********************************************************************
 
* Apply in the case of an Endogenous Regressor 

** Ie, when there is correlation bewteen that supposed random error term
** and one (or more) of our regressor

*** Ie, COV(Xi, ui) != 0

**** So that our OLS estimator would be biaised and inconsistent

* For a variable (Z) to be a efficient instrument, it must fill three
* properties :

** 1 _ Exogenous, ie Cov(Z, u) = 0

** 2 _ It must have some correlation with our predictor 
**	   Ie, Cov(Z, Xi ) != 0 

** 3 _ It has to be external to the regression (not already present in
**	   some ways)
**	   Ie, Derivative of Y with respect to Z = 0

*** It is based on the methods of moments 

* Finaly our coefficient is just 

*		Cov(Y, Z) / Cov(Xi, Z)

* RQ : OLS coef is just { Cov(Y, Xi) / Var(Xi) }

***********************************************************************
*				    	 Two Stage Least Sqaure
***********************************************************************

* Mechanical method for using IV regression 

** Step 1 : Regress our instrumentalized variable Xi, on our 
**			instrument Z and on other predictors (if there are some)
**			Ie, replace Y by your instrumentalized variable Xi

** Step 2 : We regress our response variable Y on the fitted value
**			of above regression

*** Eventually, we can show that these Beta2SLS are exactly equal
***				to BetaIV from Method of Moment

***********************************************************************
*				    	 Application to Stata
***********************************************************************

* RQ : "ssc install estout" = pretty table for results
*	   And, we use "bcuse wage2" datasets

** We first try a linear regression of wage on educ and 
** work_experience

reg wage educ exper

* The idea is to think critically about the role of these variables

** What affect our response variable, here ppl wage, expect our 
** predicator variables, so here exept education and work_experience ?

*** There will be almost always unobservable caracteristics, here
*** talent, focus, versatility, implication..

**** These things will typically help you to get a higher wage
**** but they also will surely help you in school 

***** So that our observations with positive error_term will probably
***** have high level of wage AND high level of education 

****** We can then easily imagine that { Cov(Educ, Error) != 0 }

******* Our estimator for educ would then be biased

* At this point, we should then look for another variable that we 
* could use as instrument

** Something that may be related to the education level but won't
** direclty affect the level of wage 
** ~ A random shock on the wage won't affect this instrument variable

*** We have here a possible cool one, the number of siblings 

**** We can be pretty confident that it's an exogenous variable
**** ~ A random shock on my wage today is not going affect the number
**** of siblings that I have

***** On the other hand, having no siblings surely means that your 
***** parents have more money to spend on your education 

* RQ : You can store  results : (ESTimateSTOre ~ eststo)
*	   So that you can then show them side by side with others

eststo ols

** Let's turn to our IV reg

ivreg wage exper (educ=sibs)

eststo iv

* As guessed previoulsy, we obtain different results 

* RQ : Application of 2SLS mechaniccaly 

** 1 _ Reg our instumentalized variable on instrument & other predic

reg educ sibs exper 

** 2 _ Store the fitted value and reg Y on it and on other predicator

predict educ_hat

reg wage educ_hat exper

eststo twoSLS


* We can finally print all our differents coefficients from our 
* differents models 

estout
		
** We indeed get the same results for 2SLS & for IV reg

*** HOWEVER, the standerror, p_values, t_test ie hyptothesis testing
***			 would be a bit different.
***			 IV_reg uses the appropriate caculation but not 2SLS
***			 2SLS would then need to be corrected 
***			 So that, we should use IV_reg expect in particular cases


