# Motivation
Why is there a huge variation among large businesses' political spending?
* Do the ideological biases of users (corporate boards and donors) constrain the giving of corporate PACs?
    * Amount of PAC's spending
    * Recipients of PAC's spending
    
# Existing findings and theories
* Internal constraints as donors' partisanship can affect the group's activities. (Li 2018)
* Ideological heterogeneity within and across boardrooms (Bonica 2016)


# Types of PACs and corporate PACs’ moderate contribution profile
most PACs have centrist tendencies in terms of their contribution profile. Furthermore, single issue groups, partisan groups (such as Trump Victory PAC) and labor groups are exceptions in that they are highly partisan PACs. However, at first, as Figure below shows, most PACs are owned by businesses. Therefore, not surprisingly, major portions of money in campaign finance are from the business-oriented PACs as Figure belows right panel shows.
<p align="center">
  <img src="graphs/f1.png" />
</p>

Business/corporation PACs spend their money about half on Republican and half on Democrat candidates. Yet, overall business PACs' contribution profiles are slightly more conservative. Therefore, PACs are understood to be moderate because business PACs dominate both the amount of spending and quantity of PACs. As a result, I argue that business PACs drive the moderate profile seen in PAC contributions. As the below figure shows, this moderate ideological profile of corporate PACs are observed in every sectors. The benchmark for comparison of ideological districution is the ideological distribution in the U.S. Congress.

<p align="center">
  <img src="graphs/f3.png" width='300' />
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

<p align="center">
  <img src="graphs/f5.png" width="400" />
  <img src="graphs/f6.PNG" width="400"  />
</p>



* Dependent variable (FEC)
  * Corporate PACs’ spending (total disbursement)

Figure 4 shows that the data are highly skewed to the right near zero because many firms do not have PACs and/or spend nothing in the 2012 election cycle. The mean amount of spending among the companies that made any contribution is about $590,000 and the median is $283,000. 

<p align="center">
  <img src="graphs/f7.png" />
</p>



# Method: quantitative model and anedotes (qaulitative case study)

Now I will explain the model that I used to examine the relationship between ideological homogeneity of board directors within a firm and the corporate PACs' political spending. At first, from the data section, I learn that there is over-dispersion in corporate PACs' spending (dependent variable) in that it is skewed to the right. This pattern is observed from overall data and all the different sectors. Therefore, this pattern is not driven by one sector as we can see in Figure 7. Also the variance (553139) exceeds the mean (417) of the data (amount of spending binned by $1000). In these given conditions, negative binomial regression model is useful. In Boinca's paper, he puts raw dollars into bins of $1000 intervals (such as $0 to $1000) to make count data, I used the same bin to make count variable as dependent variable for negative binomial regression model (Unit of analysis: firm) (2016). Therefore, by using negative binomial regression, I can examine whether ideological biases of corporate boards constrain the giving of corporate PACs.


I will also provide several anecdotes to explain the relationship among various actors in corporate political spending, and why ideological diversity in boardrooms can constrain the amount and pattern of corporate PACs. The anecdotes are explained with following analysis. At first, I will explain why corporate PAC's ideology is distinctive compared to the Congress and its board directors. Then, I will show the money-weighted CFscores of corporate PAC's money recipients to explain how that is related to corporate PAC's CFscores. Lastly, I will compare corporate PAC donors' ideologies, board directors' ideologies and corporate PAC's ideological profile. Then, I will discuss distinctive characteristics of corporate elites and corporate PACs' ideology. 


# Main results
The results from negative binomial model are in Table 2. The result shows that higher the variance of board directors within a company, the corporate PAC spends less money in politics. It means one unit increases in the variance of board directors' CFscores, about log of 1.07 binned dollar decreases in the corporate PAC's spending. In other words, if boardroom is more ideologically homogeneous, the corporation spends more money as a PAC. The result also shows that higher proportion of female in boardroom, the PAC spends more. It means that every one unit increase in the proportion of female in boardroom, there is about log of 0.04 binned dollar increase in the corporate PAC spending. Model 2 in Table 2 which is without the categorical variable, sector, also shows almost the same results.


<p align="center">
  <img src="graphs/predspend.png" width="400" />
</p>

As Table 2's model 1 shows, to compare differences among different sectors, I set the reference group as Energy sector because it has a high mean value among sectors. The categorical variable as sector shows that the expected difference between energy and basic material sector is about log of 1.22 binned dollar and the difference between energy and consumer cyclical sector is about log of 1.76 binned dollar. It means that expected spending of energy sector companies are larger than basic material and consumer cyclical sectors. Model 2's results can be better explained by Figure 8. Figure 8 shows the expected spending of corporate PACs with 95 percent confident intervals. When there is an interquartile range change in boardroom diversity, we expect to see about 100 binned dollar difference. For instance, if a Intel Group's boardroom (0.590; 3rd quartile) is ideologically homogeneous as close to Goldman Sachs Group's boardroom (0.318; 1st quartile), Intel Group's PAC could have spent about \$100k (about 100 binned dollar difference) more in politics.


The main finding shows that ideological homogeneity in boardroom is positively related to corporate PAC's spending. Although at this point, with the observational data, it is difficult to claim there is a causal relationship between ideological homogeneity and PAC's spending, the finding is important in that ideological homogeneity of group's elites is related to the group's collective behavior. Also there are several interesting points regarding heterogeneity within groups in case of corporate PAC. 

```r
require 'redcarpet'
markdown = Redcarpet.new("Hello World!")
puts markdown.to_html
```
            
