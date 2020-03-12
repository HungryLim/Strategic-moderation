Lim\_pset1\_ml
================
Lim
February 28, 2019



------------------------------------------------------------------------

``` r
tweets <- read.csv("progressive-tweet-sentiment.csv", stringsAsFactors = FALSE)
tweets <- tweets[tweets$target != "Atheism", ]
tweets <- tweets[,c("target", "tweet")]
for (i in 1:nrow(tweets)){
  tweets$cl_tweet[i]<-gsub("@\\w+ *", "", tweets$tweet[i])
  tweets$cl_tweet[i]<-tolower( tweets$cl_tweet[i])}
  
library(tm)
```

    ## Warning: package 'tm' was built under R version 3.6.3

    ## Loading required package: NLP

``` r
stop<-stopwords("en")
dtm <- quanteda::dfm(tweets$cl_tweet, tolower = FALSE,
                     remove_numbers=T,remove_symbols=T,remove_hyphens = T,
                     remove_punct = TRUE,stem=T)
```

    ## Warning: 'remove_hyphens' is deprecated, use 'split_hyphens' instead.

``` r
dtm_mat <- as.matrix(dtm)

#run this line and make document term matrix saved
#write.csv(dtm_mat,"preprocess.csv")
```

``` r
#2
#(a)
setwd("C:/Users/wooki/Dropbox/Machine learning")
load("communities.Rdata")

set.seed(1234)

train<-rep(1,1500)
valid<-rep(2,247)
test<-rep(3,247)
nums<-c(train,valid, test)
gen_id<-sample(nums,length(nums))

X$id<-gen_id
trainset<-subset(X,X$id==1)
validset<-subset(X,X$id==2)
testset<-subset(X,X$id==3)

y<-X$ViolentCrimesPerPop
validy<-validset$ViolentCrimesPerPop
testy<-testset$ViolentCrimesPerPop
trainy<-trainset$ViolentCrimesPerPop
cov_valid<-as.matrix(subset(validset, select = -c(ViolentCrimesPerPop)))
cov_test<-as.matrix(subset(testset, select = -c(ViolentCrimesPerPop)))
cov_train<-as.matrix(subset(trainset, select = -c(ViolentCrimesPerPop)))
```

``` r
library(glmnet)
```

    ## Loading required package: Matrix

    ## Loaded glmnet 3.0-1

``` r
#ridge
ridge.mod <- glmnet(cov_train, trainy, alpha = 0)

#lasso
lasso.mod <- glmnet(cov_train, trainy, alpha = 1)
```

``` r
ridge.pred <- predict(ridge.mod, s = ridge.mod$lambda
, newx =  cov_valid)
lasso.pred <- predict(lasso.mod, s = lasso.mod$lambda, newx =  cov_valid)

mse.ridge<-c()
for (i in 1:100){
  mse.ridge <- c(mse.ridge,mean(as.matrix(ridge.pred[,i])-as.matrix(validy))^2)
}

which.min(mse.ridge)
```

    ## [1] 54

``` r
mse.lasso<-c()
for (i in 1:100){
  mse.lasso <- c(mse.lasso,mean(as.matrix(lasso.pred[,i])-as.matrix(validy))^2)
}

which.min(mse.lasso)
```

    ## [1] 7

``` r
#(d)
#make predictions for model3
thelambda.lasso<-lasso.mod$lambda[1]
lasso.pred.best <- predict(lasso.mod, s = thelambda.lasso, newx =  cov_test)
#mean(as.matrix(lasso.pred.best[,i])-as.matrix(testy))^2)
```

I have worked on crossvalidation manual function and it failed to work.

``` r
cross_validation <- function(x, y, k){
  #Transform vectors as a dataframe
  data = as.data.frame(cbind("x"= x,"y"=y))
  dfTrain<-data[sample(nrow(data)),]
  folds <- cut( seq(1,nrow(data)), breaks= k, labels=FALSE)
  lambda <- 10^seq(10, -2, length = 100)
  
  results <- c()
  # Do the cross validation for K fold
  for(i in 1:k){

    testIndexes <- which(folds==i,arr.ind=TRUE)
    testData <- dfTrain[testIndexes, ]
    trainData <- dfTrain[-testIndexes, ]
    lasso.mod<- glmnet(x[trainData,], y[trainData], alpha = 1, lambda = lambda)
    
    lasso.pred <- predict(lasso.mod, s = lambda, newx =  x[trainData])
    mse.ridge<-c()
    for (i in 1:100){
      mse.ridge <- c(mse.ridge,mean(as.matrix(lasso.pred[,i])-as.matrix(validy))^2)
    }
    
    results = rbind(results,PMSE)
  }
  results <- as.data.frame(results)
  
  return(as.data.frame(apply(results,2,mean)))
}
```

*Y*|*x* ∼ *B**e**r**n*(*p*)
*L*(*β*)=∏*p*<sub>*i*</sub><sup>*Y*<sub>*i*</sub></sup>(1 − *p*<sub>*i*</sub>)<sup>1 − *Y*<sub>*i*</sub></sup>
*l**o**g**L*(*β*)=∑*l**o**g*(*p*<sub>*i*</sub><sup>*Y*<sub>*i*</sub></sup>(1 − *p*<sub>*i*</sub>)<sup>1 − *Y*<sub>*i*</sub></sup>)
 When we clean this equation and chnage $p\_i=\\frac{\\exp(X\_i^T \\beta)}{1+exp(X\_i^T \\beta)}$
*l**o**g**L*(*β*)=∑(*Y*<sub>*i*</sub>*X*<sub>*i*</sub><sup>*T*</sup>*β* + *l**o**g*(1)−*l**o**g*(1 + exp(*X*<sub>*i*</sub><sup>*T*</sup>*β*)))
$$\\frac{d}{d \\beta\_j} logL(\\beta)=\\sum(Y\_i X\_{ij} - \\frac{\\exp(X\_i ^T)X\_{ij}}{1+\\exp(X\_i ^T)} ) $$

$$\\frac{d^2}{d \\beta\_j d \\beta\_k} logL(\\beta) =\\sum (-X\_{ij} X\_{ik}\\frac{\\exp{(X\_i^T \\beta)}}{(1+\\exp{(X\_i^T \\beta)})^2})$$

$$\\frac{d^2}{d \\beta\_j^2} logL(\\beta) = \\sum(-X\_{ij}^2\\frac{\\exp{(X\_i^T \\beta)}}{(1+\\exp{(X\_i^T \\beta)})^2} )$$

``` r
library(ggplot2)
library(dplyr)
## simulation dataset
set.seed(02139)
n <- 1000
d <- data.frame(x_1 = rnorm(n, mean=0, sd=1),
                x_2 = rnorm(n, mean=0, sd=1))
d$y <- 2 * d$x_1 + 3 * d$x_2 + rnorm(n, mean=0, sd=1)
beta_grid <- expand.grid(beta_1=seq(-1,5,.1),beta_2=seq(-1,5,.1))



calc_ssr <- function(beta_star, d){
  X <- as.matrix(d[,c("x_1","x_2")])
  e <- d$y - X%*% beta_star
  return(crossprod(e))
}
## calculate the error for all combinations of beta1 and beta2
beta_grid$ssr <- apply(beta_grid, 1, calc_ssr, d)

#lambda
lambda=1

#penalty
beta_grid$penalty_ridge<-lambda*(beta_grid$beta_1^2+beta_grid$beta_2^2)
beta_grid$penalty_lasso<-lambda*(abs(beta_grid$beta_1)+abs(beta_grid$beta_2))

#full loss function for ridge
beta_grid$full_ridge<-beta_grid$ssr+beta_grid$penalty_ridge

#full loss fucntion for lasso
beta_grid$full_lasso<-beta_grid$ssr+beta_grid$penalty_lasso


## beta_ols is the the vector of two betas that empirically minimizes the
## sum of squared error.
beta_ols <- beta_grid[which.min(beta_grid$ssr),]

#penalty graph of ridge
ggplot(beta_grid, aes(x=beta_1, y=beta_2)) +
  geom_tile(aes(fill=log(penalty_ridge))) +
  stat_contour(aes(z=penalty_ridge), color="gray30") +
  geom_vline(xintercept=0) +
  geom_hline(yintercept=0) +

  scale_fill_gradient(low="#FEE8C8", high="#E34A33",breaks=range(log(beta_grid$penalty_ridge)),
                    labels=c("low","high"), name="Ridge") +
  xlab(expression(beta[1])) +
  ylab(expression(beta[2])) +
  coord_fixed() +
  labs(title = "Penalty for Ridge")
```

![](Lim_problem1---Copy_files/figure-markdown_github/unnamed-chunk-6-1.png)

``` r
#penalty graph of lasso
ggplot(beta_grid, aes(x=beta_1, y=beta_2)) +
  geom_tile(aes(fill=log(penalty_lasso))) +
  stat_contour(aes(z=penalty_lasso), color="gray30") +
  geom_vline(xintercept=0) +
  geom_hline(yintercept=0) +

  scale_fill_gradient(low="#FEE8C8", high="#E34A33",breaks=range(log(beta_grid$penalty_lasso)),
                    labels=c("low","high"), name="Lasso") +
  xlab(expression(beta[1])) +
  ylab(expression(beta[2])) +
  coord_fixed() +
  labs(title = "Penalty for Lasso")
```

![](Lim_problem1---Copy_files/figure-markdown_github/unnamed-chunk-6-2.png)

``` r
ggplot(beta_grid, aes(x=beta_1, y=beta_2)) +
  geom_tile(aes(fill=log(full_ridge))) +
  stat_contour(aes(z=full_ridge), color="gray30") +

  geom_vline(xintercept=0) +
  geom_hline(yintercept=0) +
  scale_fill_gradient(low="#FEE8C8", high="#E34A33",
                      breaks=range(log(beta_grid$full_ridge)),
                      labels=c("low","high"), name="Ridge") +
  xlab(expression(beta[1])) +
  ylab(expression(beta[2])) +
  coord_fixed() +
  labs(title = paste("Tau= ", lambda))
```

![](Lim_problem1---Copy_files/figure-markdown_github/unnamed-chunk-7-1.png)

``` r
plot_list = list()
# Create the loop.vector (all the columns)
lambda_ch <- c(250, 500, 1000,  2000)


for (i in 1:4) { # Loop over loop.vector
  
  set.seed(021391)
  n <- 1000
  d <- data.frame(x_1 = rnorm(n, mean=0, sd=1),
                  x_2 = rnorm(n, mean=0, sd=1))
  d$y <- 2 * d$x_1 + 3 * d$x_2 + rnorm(n, mean=0, sd=1)

  beta_grid <- expand.grid(beta_1=seq(-1,5,.1),beta_2=seq(-1,5,.1))

  calc_ssr <- function(beta_star, d){
    X <- as.matrix(d[,c("x_1","x_2")])
    e <- d$y - X%*% beta_star
    return(crossprod(e))
  }
  ## calculate the error for all combinations of beta1 and beta2
  beta_grid$ssr <- apply(beta_grid, 1, calc_ssr, d)
  # 
  lambda<-lambda_ch[i]
  #penalty
  beta_grid$penalty_ridge<-lambda*(beta_grid$beta_1^2+beta_grid$beta_2^2)

  #full loss function for ridge
  beta_grid$full_ridge<-beta_grid$ssr+beta_grid$penalty_ridge
  
  ## beta_ols is the the vector of two betas that empirically minimizes the
  ## sum of squared error.
  beta_ols <- beta_grid[which.min(beta_grid$ssr),]
  
  
  # Plot histogram of x
  p=ggplot(beta_grid, aes(x=beta_1, y=beta_2)) +
  geom_tile(aes(fill=log(full_ridge))) +
  stat_contour(aes(z=full_ridge), color="gray30") +
  stat_contour(aes(z=penalty_ridge), color="gray30") +
  geom_vline(xintercept=0) +
  geom_hline(yintercept=0) +
  scale_fill_gradient(low="#FEE8C8", high="#E34A33",
                      breaks=range(log(beta_grid$full_ridge)),
                      labels=c("low","high"), name="Ridge") +
  xlab(expression(beta[1])) +
  ylab(expression(beta[2])) +
  coord_fixed() +
  labs(title = paste("Tau= ", lambda))

  
  plot_list[[i]] = p
}

library(gridExtra)
p <- grid.arrange(grobs=plot_list,ncol=2)
```

![](Lim_problem1---Copy_files/figure-markdown_github/unnamed-chunk-8-1.png)

``` r
ggsave("bigplot.png",p)
```

So I tried to do both ols coefficient estimate and penalty, but it didn't really work out well. The basic idea is as As *λ* increases, the bias of estimator decreases but the variance increases.

``` r
library(ggplot2)
plot_list2 = list()
# Create the loop.vector (all the columns)
lambda_ch <- c(250, 500, 1000,  2000)


for (i in 1:4) { # Loop over loop.vector
  
  set.seed(021391)
  n <- 1000
  d <- data.frame(x_1 = rnorm(n, mean=0, sd=1),
                  x_2 = rnorm(n, mean=0, sd=1))
  d$y <- 2 * d$x_1 + 3 * d$x_2 + rnorm(n, mean=0, sd=1)

  beta_grid <- expand.grid(beta_1=seq(-1,5,.1),beta_2=seq(-1,5,.1))

  calc_ssr <- function(beta_star, d){
    X <- as.matrix(d[,c("x_1","x_2")])
    e <- d$y - X%*% beta_star
    return(crossprod(e))
  }
  ## calculate the error for all combinations of beta1 and beta2
  beta_grid$ssr <- apply(beta_grid, 1, calc_ssr, d)
  # 
  lambda<-lambda_ch[i]
  #penalty
  beta_grid$penalty_lasso<-lambda*(abs(beta_grid$beta_1)+abs(beta_grid$beta_2))

  #full loss function for ridge
  beta_grid$full_lasso<-beta_grid$ssr+beta_grid$penalty_lasso
  
  ## beta_ols is the the vector of two betas that empirically minimizes the
  ## sum of squared error.
  beta_ols <- beta_grid[which.min(beta_grid$ssr),]
  
  
p1=ggplot(beta_grid, aes(x=beta_1, y=beta_2)) +
  geom_tile(aes(fill=log(penalty_lasso))) +
  stat_contour(aes(z=penalty_lasso), color="gray30") +
  stat_contour(aes(z=full_lasso), color="gray30") +
  geom_vline(xintercept=0) +
  geom_hline(yintercept=0) +

  scale_fill_gradient(low="#FEE8C8", high="#E34A33",breaks=range(log(beta_grid$penalty_lasso)),
                    labels=c("low","high"), name="Lasso") +
  xlab(expression(beta[1])) +
  ylab(expression(beta[2])) +
  coord_fixed() +
  labs(title = paste("Tau= ", lambda))

  
  plot_list2[[i]] = p1
}

library(gridExtra)
p1 <- grid.arrange(grobs=plot_list2,ncol=2)
```

![](Lim_problem1---Copy_files/figure-markdown_github/unnamed-chunk-9-1.png)

``` r
ggsave("bigplot2.png",p1)
```

Given,
$$\\hat{\\beta}\_{ridge}=argmin\_{\\beta}\\sum(y\_i -X\_i^T\\beta^\*)^2+\\lambda\\sum\\beta^{\*2}$$
 When we expand this,
=(*y* − *X**β*)<sup>*T*</sup>(*y* − *X**β*)+*λ**β*′*β*
= − 2*β*<sup>*T*</sup>*x*<sup>*T*</sup>*y* + *β*<sup>*T*</sup>(*X*<sup>*T*</sup>*X* + *λ**I*)*β*

Take derivative of above equation with beta and set it equal to zero.
$$\\frac{d}{d \\beta}(-2\\beta^Tx^Ty+\\beta^T(X^TX +\\lambda I)\\beta)=-2X^Ty+2(X^TX+\\lambda I)\\beta =0$$
 When we solve this,
$$\\hat{\\beta}=(X^TX+\\lambda I)^{-1}X^Ty$$
 When K &gt; N, ols cannot provide unique solution, but by addting *λ*, we can get unique $\\hat{\\beta}$.

*y* = *X**β* + *ϵ*
$$bias(\\hat{\\beta})=E(\\hat{\\beta})-\\beta$$
=(*X*<sup>*T*</sup>*X* + *λ**I*)<sup>−1</sup>(*X*<sup>*T*</sup>*X* + *λ**I*)*β* − (*X*<sup>*T*</sup>*X* + *λ**I*)<sup>−1</sup>*λ**I**β* − *β*
=(*X*<sup>*T*</sup>*X* + *λ**I*)<sup>−1</sup>*λ**I**β*
 So bias of $\\hat{\\beta}$ is not 0, so our estiamtor is no longer BLUE. This is because we introduced *λ*.

$$var(\\hat{\\beta})= var((X^TX+\\lambda I)^{-1}(X^Ty))$$
=*σ*<sup>2</sup>(*X*<sup>*T*</sup>*X* + *λ**I*)<sup>−1</sup>*X*<sup>*T*</sup>*X*(*X*<sup>*T*</sup>*X* + *λ**I*)<sup>−1</sup>
 As *λ* increases, the bias of estimator decreases but the variance increases. That means, when we do not penalize at all *λ* = 0, it is unbaised intuitively because then it is same as regular ols.

``` r
library(e1071)
iris$Species<-as.character(iris$Species)
sub<-subset(iris,Species=="setosa"|Species=="versicolor")
sub<-sub[,c("Petal.Length","Petal.Width")]

summary(sub$Petal.Length)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   1.000   1.500   2.450   2.861   4.325   5.100

``` r
summary(sub$Petal.Width)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   0.100   0.200   0.800   0.786   1.300   1.800

``` r
beta_0<-seq(4,3,length.out=10)
beta_1<-seq(-0.8,-1.5,length.out=10)

x1<-(-2)
x2<-8
y1=beta_0+beta_1*x1
y2=beta_0+beta_1*x2
a<-cbind(x1,y1)
b<-cbind(x2,y2)

plot(sub$Petal.Length,sub$Petal.Width)

#function to calculate distance
dist2d <- function(a,b,c) {
  v1 <- b - c
  v2 <- a - b
  m <- cbind(v1,v2)
  d <- abs(det(m))/sqrt(sum(v1*v1))
} 


#lines
mins<- matrix(NA, 10,1)
for (i in 1:10) {

  dis<-matrix(NA, 100,1)
  for (k in 1:100){
    
  d2 <- dist2d(as.numeric(sub[k,]),as.numeric(a[i,]),as.numeric(b[i,])) 
  dis[k]<-d2
 
  }
  m<-min(dis)
  
  mins[i]<-m
} 

#among the closest lines which one max the distance
which.max(mins)
```

    ## [1] 5

``` r
beta_0[5]
```

    ## [1] 3.555556

``` r
beta_1[5]
```

    ## [1] -1.111111

``` r
plot(sub$Petal.Length,sub$Petal.Width)
segments(a[5,1],b[5,1],a[5,2],b[5,2])
```

![](Lim_problem1---Copy_files/figure-markdown_github/unnamed-chunk-10-1.png)

``` r
#svm

library(e1071)
iris$Species<-as.character(iris$Species)
sub<-subset(iris,Species=="setosa"|Species=="versicolor")
sub2<-sub[,c("Petal.Length","Petal.Width","Species")]
sub2$Species<-as.factor(sub2$Species)
svmfit=svm(Species~.,data=sub2,kernel="linear")
plot(svmfit,sub2,Petal.Length~Petal.Width)
```

![](Lim_problem1---Copy_files/figure-markdown_github/unnamed-chunk-11-1.png)

When I do it manually, I only tested 10 different lines, but as svm package in R does, when we test many many lines, then we can get the opitimal classifier based on svm approach as we can see from the plot.