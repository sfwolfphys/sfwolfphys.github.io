---
layout: post
title:  "Solving a simple puzzle"
categories: fun blogging
tags: quasi-rant
---



I caught [this article](https://www.r-bloggers.com/2021/06/r-coding-challenge-7-1-ways-to-solve-a-simple-puzzle/) in my feed this morning and it got me thinking.  It discusses a simple problem:

> Take the numbers 1 to 100, square them, and add all the even numbers while subtracting the odd ones!

The article itself lays out 7 ways to solve the puzzle.  One is quite boring (just type everything in by hand like a calculator).  I think the point of the article is cool - specifically, that there are often many ways to solve a problem.  It did make me think about how I would work with a student to solve this problem though.  I feel like the article is focused on experienced R users (note the general lack of comments in the code) rather than to a new user.

I think my favorite solution is somewhat similar to the first solution that he immediately thought of...well, the one right after the boring one...with a few extra steps.  I can imagine a dialog with a student looking like this...(Note, I'm a physics professor by trade, so when I'm teaching students to code, I'm often pointing them in the direction of useful functions so that they can solve the physics)

### Solving the problem

Me: Ok, so what do we need to solve this problem?

Student:  Well, it would be really nice if we had all of the even numbers in one vector and all of the odd numbers in another vector.

Me: Great!  Let's check out the `seq()` function.  Put these lines into your interpreter and see what pops out:


{% highlight r %}
seq(from=1,to=10,by=2)
{% endhighlight %}



{% highlight text %}
## [1] 1 3 5 7 9
{% endhighlight %}



{% highlight r %}
seq(from=2,to=10,by=2)
{% endhighlight %}



{% highlight text %}
## [1]  2  4  6  8 10
{% endhighlight %}
Can we use these to generate what you want?

Student:  Yes!  I think I can do this:

{% highlight r %}
odds = seq(from=1,to=100,by=2)
evens = seq(from=2,to=100,by=2)
{% endhighlight %}
Ok, now can I just square these things?

Me:  Whenever I'm unsure of something, I like to try it out on a shorter vector that I can check by hand.  Like this:

{% highlight r %}
x = 1:5
x^2
{% endhighlight %}



{% highlight text %}
## [1]  1  4  9 16 25
{% endhighlight %}
Does, $$x^2$$ produce what you expect?

Student:  Yes, I think it does!  From here, I think I can just square, sum, and then find the difference.  I'll try that out:

{% highlight r %}
sum(evens^2) - sum(odds^2)
{% endhighlight %}



{% highlight text %}
## [1] 5050
{% endhighlight %}
I get 5050, does that make sense?

Me: That's what I have too.


## Challenge accepted
I'll end by noting that the author points out that the answer to this problem is identical to "What's the sum of all numbers 1 to 100?"  I thought that I'd prove that for fun.

So, we are looking for the sum of all the even numbers squared between 1 and 100, subtracted by the sum of all the odd numbers squared on the same interval.  We can write the solution $$S$$ as:

$$
S = \sum_{n=1}^{50} (2n)^2 - \sum_{n=1}^{50} (2n-1)^2 = \sum_{n=1}^{50} \left[(2n)^2 - (2n-1)^2\right]
$$

The term in the square brackets matches the form for the difference of squares.  Let's use that to re-write:

$$ 
S = \sum_{n=1}^{50} \left[\left(2n - (2n-1)\right)\left(2n + (2n-1)\right) \right]
$$

This simplifies to:

$$ 
S = \sum_{n=1}^{50} \left[\left(1\right)\left(2n + (2n-1)\right) \right]
$$

The 1 can just go away, and let's split the sum apart again:

$$
S = \sum_{n=1}^{50} 2n + \sum_{n=1}^{50} (2n-1)
$$

The first term is just the sum of all _even_ numbers between 1 and 100, and the second term is the sum of all _odd_ numbers between 1 and 100.  Therefore:

$$
S = \sum_{n=1}^{100} n = \frac{100(100+1)}{2} = 5050
$$

I should note that this result requires that the maximum term must be even.  For example, the sum of all numbers from 1 to 99 is 4950.  But, the same question (evens^2 - odds^2) for 1:99 is somewhat different:


{% highlight r %}
sum(seq(2,99,2)^2) - sum(seq(1,99,2)^2)
{% endhighlight %}



{% highlight text %}
## [1] -4950
{% endhighlight %}

To re-cast the proof for an odd max value, I'd have to include zero as a term for the evens:

$$
S' = \sum_{n=0}^{49} (2n)^2 - \sum_{n=0}^{49} (2n+1)^2 = \sum_{n=0}^{49} \left[(2n)^2 - (2n+1)^2\right]
$$

And note that the left hand term simplifies to -1...

$$ 
S' = \sum_{n=0}^{49} \left[\left(-1\right)\left(2n + (2n+1)\right) \right]
$$

So, for an odd max value, the answer is just -1 times the sum of all values up to that max value.

$$
S' = - \sum_{n=0}^{99} n = - \frac{99(99+1)}{2} = -4950
$$

This was just too cool not to write up.
