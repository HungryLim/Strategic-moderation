# Motivation
Why is there a huge variation among large businesses' political spending?
* Do the ideological biases of users (corporate boards and donors) constrain the giving of corporate PACs?
    * Amount of PAC's spending
    * Recipients of PAC's spending
    
# Existing findings and theories
* Internal constraints as donors' partisanship can affect the group's activities. (Li 2018)
* Ideological heterogeneity within and across boardrooms (Bonica 2016)


# Types of PACs and corporate PACs’ moderate contribution profile
<p align="center">
  <img src="emos.png" width="400" />
  <img src="table.PNG" width="400"  />
</p>



# Theory and hypothesis
* Theory:  Ideological diversity in boardroom can constrain corporate PAC's spending because leaders check and balance group's behaviors with limited resources. 
* Hypothesis: As ideological diversity within boardroom increases,  political spending of interest group's PAC decreases.

# Data
Fortune 500 companies as of 2012

* Independent variables (Bonica 2016)
  * The variance of board directors’ ideologies within a company (CFscore)
  * The mean of board directors’ ideologies by a company 
  * The proportion of female board directors within a company 
  * Sector of a company

* Dependent variable (FEC)
  * Corporate PACs’ spending (total disbursement)

* Model
Negative binomial regression
  * Unit of analysis: firm


* Ideologies of Congress members and board directors 



```r
require 'redcarpet'
markdown = Redcarpet.new("Hello World!")
puts markdown.to_html
```
            
