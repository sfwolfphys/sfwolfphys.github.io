---
layout: post
title:  "Interfering Cicada Populations"
categories: [riddler, fun]
tags: [riddler]
---


## [The riddle](https://fivethirtyeight.com/features/can-you-solve-this-astronomical-enigma/)

> Earlier this year, a new generation of [Brood X](https://www.scientificamerican.com/article/brood-x-cicadas-are-emerging-at-last1/) cicadas had emerged in many parts of the U.S. This particular brood emerges every 17 years, while some other cicada broods emerge every 13 years. Both 13 and 17 are prime numbers — and relatively prime with one another — which means these broods are rarely in phase with other predators or each other. In fact, cicadas following a 13-year cycle and cicadas following a 17-year cycle will only emerge in the same season once every 221 (i.e., 13 times 17) years!
>
> Now, suppose there are two broods of cicadas, with periods of A and B years, that have just emerged in the same season. However, these two broods can also interfere with each other one year after they emerge due to a resulting lack of available food. For example, if A is 5 and B is 7, then B’s emergence in year 14 (i.e., 2 times 7) means that when A emerges in year 15 (i.e., 3 times 5) there won’t be enough food to go around.
> 
> If both A and B are relatively prime and are both less than or equal to 20, what is the longest stretch these two broods can go without interfering with one another’s cycle? (Remember, both broods just emerged this year.) For example, if A is 5 and B is 7, then the interference would occur in year 15.

## Functions and background

First, we need to define what is meant by the term _relatively prime_.  Two numbers are relatively prime, if the greatest common factor between the two numbers is 1.  For example, 2 and 9 are relatively prime.  The factors of 2 are 1 and 2, and the factors of 9 are 1, 3, and 9.  The largest number common to both lists is 1.  Fortunately, R has a package that lets you calculate the greatest common factor:  It is the `gcd()` function in the `FRACTION` package.  I'm going to code a function called `isRelPrime()` which takes two inputs `a` and `b` and returns `TRUE/FALSE` if the inputs are relatively prime.


{% highlight r %}
library(FRACTION)

isRelPrime = function(a,b){
    gcd(a,b) == 1
}
{% endhighlight %}

Next, let's think about the interference condition.  

### Case 1
We will observe interference if the $$B$$ brood emerges the year after the $$A$$ brood:

$$
nB = mA+1
$$

(where $$n$$ and $$m$$ are arbitrary integers).  Now, if $$(N,M)$$ solve this equation, then $$(N+A, M+B)$$ will also solve this. Since we want a minimum interference time, we can restrict ourselves to $$n<A$$ and $$m<B$$.

### Case 2
We can also observe interference if the $$A$$ brood emerges the year after the $$B$$ brood:

$$
nA = mB + 1
$$

We will put similar restrictions on $$n<B$$ and $$m<A$$.


{% highlight r %}
minInterferenceTime = function(a,b){
    if(!isRelPrime(a,b)){
        return(NULL)
    }
    ## Case 1 nB = mA + 1
    case1left = (1:a)*b
    case1right = (1:b)*a + 1
    case1 = case1left[which(case1left %in% case1right)]
    ## Case 2 nA = mB + 1
    case2left = (1:b)*a
    case2right = (1:a)*b + 1
    case2 = case2left[which(case2left %in% case2right)]
    mIT = min(c(case1,case2))
    return(mIT)
}
{% endhighlight %}

Note, this whole $$A$$ and $$B$$ are relatively prime is relatively important...pardon the pun...For example, 2 and 4 are not relatively prime.  For example, if $$A=2$$ and $$B=4$$, then they will never interfere, because they will always emerge in even years, and not one year before or after an even year.

## Results

Given the constraints of the problem, I think writing a few short loops is appropriate


{% highlight r %}
longestTime = 0
for(a in 2:19){
    for(b in (a+1):20){
        if(isRelPrime(a,b)){
            t = minInterferenceTime(a,b)
            longestTime = max(c(longestTime,t))
        }
    }
}
{% endhighlight %}

So, the longest time from this year (when both broods emerge) is going to be 153 years.  This occurs if $$A=17$$ and $$B=19$$ or vice versa.  



