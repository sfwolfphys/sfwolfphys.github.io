---
layout: post
title:  "Enigmerica election"
categories: [riddler, fun]
tags: [riddler]
---


## The riddle
[This week's riddle](https://fivethirtyeight.com/features/can-you-cut-the-perfect-pancake/):

> Riddler Nation’s neighbor to the west, Enigmerica, is holding an election between two candidates, A and B. Assume every person in Enigmerica votes randomly and independently, and that the number of voters is very, very large. Moreover, due to health precautions, 20 percent of the population decides to vote early by mail.
>
> On election night, the results of the 80 percent who voted on Election Day are reported out. Over the next several days, the remaining 20 percent of the votes are then tallied.
>
> What is the probability that the candidate who had fewer votes tallied on election night ultimately wins the race?



## Functions and background
I'm not going to use many custom functions to solve this one.  Essentially, the fact that votes are _random and independant_ suggests that we should use the normal distribution.  So let's do that.  In R, the functions are in the `norm` family.  I will use two in particular:

- `pnorm(x,mu,sigma)` is the probability to have a value $$x$$, drawn from the normal distribution with mean $$\mu$$ and standard deviation $$\sigma$$.  This is often referred to as a probability density.

$$
p(x) = \frac{1}{\sigma \sqrt{2\pi}} \exp\left(-\frac{1}{2}\frac{\left(x-\mu\right)^2}{\sigma^2}\right)
$$
- `dnorm(x,mu,sigma)` is the probability that a value drawn from a distribution with the same mean and standard deviation as before is less than or equal to $$x$$.
$$
d(x) = \int_{-\infty}^{x} p(x') dx'
$$

## Results
Let's define a few variables:

- $$m_1$$, this is the percent margin of the leading candidate on election night, based on election night results.  (Therefore, $$m_1>0$$ by definition.)
- $$m_2$$, this is the percent margin of the leading candidate on election night, based on mail-in voting results.  (In general, this can be both, positive and negative)
- $$m$$ is the overall margin.

Based on the problem definition, we can say:

$$
m = 0.8 m_1 + 0.2 m_2
$$

If $$m<0$$, we can say that the election night result flipped.  In order for that to happen, 

$$ 
m_2 < -4 m_1
$$

So, to determine the probability to flip, I need to know the probability for a candidate to have a margin $$m_1>0$$ on election night and a margin $$m_2 < -4m_1$$ in the mail-in voting, integrated over all possible voting margins $m_1$.

$$
P_{\text{flip}} = \int_0^\infty p(m_1) d(-4m_1) dm_1
$$

Note, that we can simply use the standard $$\mu = 0$$ and $$\sigma = 1$$ choices for the normal distribution as the actual percent margins can be normalized, and the scaling factor drops out of the margin inequality above.  Let's just integrate numerically.


{% highlight r %}
dm2 = 0.0001
margins2 = seq(0,1000,dm2)
probFlip2 = sum(dm2 * pnorm(margins2) * dnorm(-4*margins2))
{% endhighlight %}

The probability that the result flips is 7.23%.  Not incredibly likely, but not so infrequent that it's occurrence should instigate an investigation culminating in a [39+ minute youtube video](https://www.youtube.com/watch?v=8Ko3TdPy0TU) into what is not likely.  Suffice it to say, this is nowhere near the 10 billion human second century threshhold Matt Parker discusses in that video (also below).

<iframe width="560" height="315" src="https://www.youtube.com/embed/8Ko3TdPy0TU" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
