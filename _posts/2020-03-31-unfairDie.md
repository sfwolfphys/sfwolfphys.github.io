---
layout: post
title:  "Making an unfair die"
categories: [riddler, fun]
tags: [riddler, dice, probability]
---


## Turning a fair die into an unfair die

Here is [this week's Riddler problem](https://fivethirtyeight.com/features/can-you-get-the-gloves-out-of-the-box/).  

> You start with a fair 6-sided die and roll it six times, recording the results of each roll. You then write these numbers on the six faces of another, unlabeled fair die. For example, if your six rolls were 3, 5, 3, 6, 1 and 2, then your second die wouldn’t have a 4 on it; instead, it would have two 3s.
> 
> Next, you roll this second die six times. You take those six numbers and write them on the faces of yet another fair die, and you continue this process of generating a new die from the previous one.
> 
> Eventually, you’ll have a die with the same number on all six faces. What is the average number of rolls it will take to reach this state?
> _Extra credit_: Instead of a standard 6-sided die, suppose you have an N-sided die, whose sides are numbered from 1 to N. What is the average number of rolls it would take until all N sides show the same number?

### Functions to build the simulation
There are two functions that I will use to accomplish the required tasks.  First, we need to build the new die from the old die


{% highlight r %}
makeNewDie = function(sides){
  newSides = sample(sides,replace=TRUE)
  return(newSides)
}
{% endhighlight %}

Then we will play the die game for a generic N sided die:

{% highlight r %}
playDieGame = function(N){
  roll = 0
  dieSides = 1:N
  uniqueDieSides = unique(dieSides)
  while(length(uniqueDieSides)>1){
    # Roll the dice
    roll = roll + 1
    dieSides = makeNewDie(dieSides)
    uniqueDieSides = unique(dieSides)
  }
  return(roll)
}
{% endhighlight %}

### Results for N=6
Let's play the game 100000 times and find an average!

{% highlight r %}
n = 100000
# Simulate the die game n times
gameResult = replicate(n, playDieGame(6))
avgResult = mean(gameResult)
errResult = sd(gameResult)/sqrt(n)
{% endhighlight %}

The average number of rolls to end the game for a 6-sided die is: 9.665 ± 0.018.


![plot of chunk unnamed-chunk-5](/figure/2020-03-31-unfairDieunnamed-chunk-5-1.png)

### Results for more N values
Let's check out some trends for different numbers of die sides to explore the trend.  I will begin by doing a power law regression to see if the relationship is indeed linear.

{% highlight r %}
nSims = 10000
dieSides = c(2:10,30,50,70,100,1000)
avgRes = NULL
seRes = NULL
for(nSides in dieSides){
  # Simulate the die game nSims times
  gameRes = replicate(nSims, playDieGame(nSides))
  avgRes = c(avgRes, mean(gameRes))
  seRes = c(seRes, sd(gameRes)/sqrt(nSims))
}
dieRoll.lm = lm(log10(avgRes) ~ log10(dieSides))
summary(dieRoll.lm)
{% endhighlight %}



{% highlight text %}
## 
## Call:
## lm(formula = log10(avgRes) ~ log10(dieSides))
## 
## Residuals:
##       Min        1Q    Median        3Q       Max 
## -0.143024 -0.002115  0.021287  0.035489  0.043296 
## 
## Coefficients:
##                 Estimate Std. Error t value Pr(>|t|)    
## (Intercept)      0.11317    0.02915   3.883  0.00218 ** 
## log10(dieSides)  1.08889    0.02111  51.579 1.85e-15 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.05605 on 12 degrees of freedom
## Multiple R-squared:  0.9955,	Adjusted R-squared:  0.9951 
## F-statistic:  2660 on 1 and 12 DF,  p-value: 1.853e-15
{% endhighlight %}

It looks like the relationship between the average number of rolls and the number of sides on the die is linear.  (Note that the slope of the previous regression is: 1.0889)  Performing a linear regression, we see that there is a small offset.


{% highlight r %}
dieRollLin.lm = lm(avgRes ~ dieSides)
summary(dieRollLin.lm)
{% endhighlight %}



{% highlight text %}
## 
## Call:
## lm(formula = avgRes ~ dieSides)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -1.10938 -0.09199  0.11542  0.27813  0.51316 
## 
## Coefficients:
##               Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -2.5360899  0.1271109  -19.95 1.43e-10 ***
## dieSides     2.0043637  0.0004712 4253.53  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.4464 on 12 degrees of freedom
## Multiple R-squared:      1,	Adjusted R-squared:      1 
## F-statistic: 1.809e+07 on 1 and 12 DF,  p-value: < 2.2e-16
{% endhighlight %}

![plot of chunk unnamed-chunk-8](/figure/2020-03-31-unfairDieunnamed-chunk-8-1.png)
