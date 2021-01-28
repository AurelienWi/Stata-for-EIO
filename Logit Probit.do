rename (D A S M) (Employment Age School Marital_Status)

*******************************************************************
*						Why not Linear
*					 What is Logit Probit
*******************************************************************

* When a logit or a Probit would be appropriated ? 

** All depends on the nature of the dependant variable 
 
*** If we have a binary ~ dummy variable this would be the good model to fit

describe

* Our interest variable is the dummy Employed/Unemployed

** But could not we juste use a linear Model ? 

*** Ofc, and it will then be a "Linear Probability Model"

**** Let's try this 

reg Employment Age School

* The good point with this method is its interpretation

** We can immediatly interprete our coefficient and conclude on the 
** marginale effect 

*** And we know that OLS provides Consitent, Unibiaised estimates

**** But then, why would we not use it ?

* The main concern is that there is no limitation on the prediction 
* from this model ~ on the predicted variable 

** In other word, there is nothing forcing our predicted probability
** to be between 0 and 1.  

predict Dhat_lpm 

sum Dhat_lpm

* We see that we have a maximum value above 1 so literraly above 100%

** That's why we will use non-linear model to force the prediction
** of that function to lie in that [0:1] range

*** Logit and Probit are derived from cumulative density fonction

* For the logit, it is from Logistic(~log) Normal Distribution

* For the Probit, it is from Standard Normal Distribution

** We can show easily that in both cases, the fitted probability, the
** probability that Y is equal to 1, conditionnaly on X, will have 
** 0 & 1 as their limitation

*** Ie, as the input goes to infinity that (G)function becomes 
*** asymptotic at 1. And as the imput goes to negative infinity, it 
*** becomes asymptotic to 0 

* But then, our regression is no longer linear in parameters

** So, how do we come up with the BetaHat coefficient estimates but
** we can't use OLS estimation 

* In both case we use the maximum LikeliHood Estimation

** The basic Idea is that we want to choose those paremeters(BetaHat)
** that maximizes the joint probability of observing the outcome 
** that we see. (The 1 for the 1 and the 0 for the 0)
*** Ie, the probability to see a 1 when a 1 indeed occurs 

*******************************************************************
*					Application of Logit Probit
*******************************************************************


probit Employment Age School 

* Let's see if we overcome the problem with our prediction 

predict Dhatt_pr 

sum Dhatt

* So we indeed overcome that issue

** There are other ways to interpret and to motivated probit/logit
** but that is the easiest way to think about it

* So now, what else can we take out of this estimation

** The first we always do with regression, we look at the coefficient
** to see if they make sense, if they correspond to our intuition  

*** Normally we interpret them as a linear coefficient, so as a 
*** MARGINAL EFFECT of X on Y

* But here, as our coefficient (Bhat) occurs in a non-linear function
* these are not the marginal effect 

** In fact mathematically, we would have to take the derivative of 
** the probability that Y = 1 knowing X, with respect to X1 then X2... 
** RQ : That's why logit is easier (easier derivative) in theory

*** But Stata does it for us either way so no care 

**** To get the marginal effect we just have to type "mfx"

mfx

* Which we can now compare to our linear model 

** Here we estimated the impact on each additional year of schooling
** keeping Age Constant, on the probability of being employed

* Let's do the same thing with the Logit model

logit Employment Age School

predict Dhat_logit

* Again, at that point, those coefficient are with that non-linear
* (G)function, THESE ARE NOT THE MARGINAL EFFECTS

** We just take the derivative described above with the same command

mfx

* We fortunately obtain similar resutls as for the Probit model

* Few notes on that "mfx" command 

** 1 _ Rememeber that when we take the derivative of that(G)function
**	   it is evaluated at specific inputs (All the value of the 
**     Betahat and the value of our X variables)
**     The default is to plug in the sample mean for each of those
**     X variables, but we can adjust that

mfx, at(mean)

* So, we indeed get the same results (that is the default option)

** But we can change it so that we still take the mean, but we want
** School to equal 10. So that it will calculate the marginal effect
** beginning at 10 years of Scooling (look for heterogeneity)

mfx, at(mean School=10)

* Let's try now adding a variable 'Marital_Status

logit Employment Age School Marital_Status 

predict Dhat_log2

mfx

* We do this but separating Married and non-Married

mfx, at (mean Marital_Status =0)
mfx, at (mean Marital_Status =1)

** In fact, we just created an interaction term
** It is an easy way to check for sensitivity of marginal effect
** to different variables

*** We can do the same with Probit 

*******************************************************************
*						Logistic Regression
*							Odds Ratio
*******************************************************************

* One advantge of the Logit Model is that the mathematical formula
* is a lot easier to manipulate (as said before) 

** But it has also then some additional interprétation

* Odds Ration interpration of that Logit Probability Predictor
* ~ A Logistic Model 

** The difference between Odds and Probability is that the Odds
** of an event is the ratio of the probability that an even occurs
** relative the the probability that this even does not occur
** ~ P/(1-P)
*** RQ : Odds ~ Chance / Cote 

* Sometime it is indeed easier to think in terms of Odds than in 
* terms of probability

** Thanks to mathematical manipulation we can derive that Odds value

*** It can be shown that it is equal exponential(Beta1, Beta2,..) 

**** The idea is to undertands how the Odds increases when X1, X2..
**** increases by one unit  

logistic Employment Age School Marital_Status

* So we can now conclude that for every one more year of Schooling,
* the Odds of participating to labor Force doubles (1,99 ~ 2)

*******************************************************************
*						Goodness of Fit
*						  Pseudo R2
*******************************************************************

* Because we are not using OLS when using Maximum of Likelihood, we
* will get a pseudo R2

** The idea is kinda the same, how our outcome fits the actual value

*** But instead of using our SSR (Sum of Square Residuals) as 
*** primary measure of accuracy or fit, we replace that with the 
*** value of the LogLikehood
*** ~ The joint probability of observing the outcome that we see

**** So the higher that probability is the better our model is doing

* Pseudo R2 = 1 - (L1 / L0)
* where :
*	L1 : Value of log Likelihood for estimated model
*	L2 : Value of og likelihood for model with only constant 

** So, it is going to tell us to what what degree our model 
** outperform a model with no explanatory variables

*** As R2, it lies between 0 & 1
*** But it does not have the same interpretation (see above)

*******************************************************************
*						Goodness of Fit
*					  Classification Tables
*******************************************************************

* In logit and probit we can classify our outcome 
 
** It does not have an equivalent for OLS

*** We are trying to take our prediction and say in which cubbyhole 
*** we set each of our estimations in.
*** ~ Do we predict that is a 1 or do we predict that is a 0

**** And then, we can go back and look the percentage of 
**** observations we correctly classified

* Ie, a Classification gives the percentage of corrected predicted
* outcomes.

** The only thing we have to do, Post-Estimation, is to take that 
** continuous predicted probability and turn it into Classification

*** By default we have 50% trade off
*** Ie, if the predicted probability is bigger than 50% we will 
***		classify it as a 1, and oppositily if it fall below 50%.

* It brings us two caractestics upon which we can evaluation our 
* model 

*	1 _ "Sensitivity" :
**		The percent of actual 1's correctly predicted

*	2 _ "Specificity" :  
**		The percent of actual 0's correctly predicted

*** A perfect model would then have Sensitivity + Specificity = 200

**** We get this with the 'lstat' command 

lstat

*******************************************************************
*				Goodness of Fit & Model Specification
*				   Joint Significance Testing (LR)
*******************************************************************

* Because we can't use SSR (and so R2) the F-statistic is not on our 
* table

** We then use a Likelihood ratio test statistic

*** It does the same thing as our Pseudo_R2
*** It replace SSR with the Log_Likelihood

**** It can be shown that if we take two times the Log_Likelihood
**** between two competing models (a restricted and an unrestricted),
**** that value will follow a Khi_Square distribution.
**** Where the number of degree of freedom are the number of 
**** restriction that differentiate our two models (our predicators)

* It is our LR results in our table
* (Where we would see a F_statistic in an OLS model)

** We can do the same as with F_stat in an OLS
** ~ We can test the joint significance for a subset of varialbes
** Ie, we can apply forward / backward / mixed testing
