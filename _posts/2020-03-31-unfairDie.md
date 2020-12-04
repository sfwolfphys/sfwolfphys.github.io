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

The average number of rolls to end the game for a 6-sided die is: 9.655 ± 0.018.


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
## -0.139237 -0.004868  0.019866  0.036062  0.041398 
## 
## Coefficients:
##                 Estimate Std. Error t value Pr(>|t|)    
## (Intercept)      0.11280    0.02870    3.93    0.002 ** 
## log10(dieSides)  1.08869    0.02079   52.37 1.54e-15 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.0552 on 12 degrees of freedom
## Multiple R-squared:  0.9956,	Adjusted R-squared:  0.9953 
## F-statistic:  2743 on 1 and 12 DF,  p-value: 1.545e-15
{% endhighlight %}

It looks like the relationship between the average number of rolls and the number of sides on the die is linear.  (Note that the slope of the previous regression is: 1.0887)  Performing a linear regression, we see that there is a small offset.


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
##     Min      1Q  Median      3Q     Max 
## -3.5616  0.0241  0.4336  0.6335  0.9188 
## 
## Coefficients:
##              Estimate Std. Error  t value Pr(>|t|)    
## (Intercept) -2.944553   0.349041   -8.436 2.17e-06 ***
## dieSides     2.013459   0.001294 1556.042  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1.226 on 12 degrees of freedom
## Multiple R-squared:      1,	Adjusted R-squared:      1 
## F-statistic: 2.421e+06 on 1 and 12 DF,  p-value: < 2.2e-16
{% endhighlight %}

![plot of chunk unnamed-chunk-8](/figure/2020-03-31-unfairDieunnamed-chunk-8-1.png)
