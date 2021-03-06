---
layout: post
title:  "Number of Pixmit cards"
categories: [riddler, fun]
tags: [riddler]
---


## The riddle
This week's [riddler classic](https://fivethirtyeight.com/features/can-you-crack-the-case-of-the-crescent-moon/):

> You are creating a variation of a Romulan [pixmit](https://memory-alpha.fandom.com/wiki/Pixmit) deck. Each card is an equilateral triangle, with one of the digits 0 through 9 (written in Romulan, of course) at the base of each side of the card. No number appears more than once on each card. Furthermore, every card in the deck is unique, meaning no card can be rotated so that it matches (i.e., can be superimposed on) any other card.


## Functions and background
R has us mostly covered here.  First we have the `choose(n,k)` function, which counts the number of _combinations_ with length $$k$$ drawn from a number of choices `n`.  (It is also called the [binomial coefficient](https://en.wikipedia.org/wiki/Binomial_coefficient).) In math, we often write this as:

$$
{n}\choose{k}
$$

So for example, if we wanted to find the number of ways that the letters A, B, C, and D can be combined in lists of three, we'd write:


{% highlight r %}
choose(4,3)
{% endhighlight %}



{% highlight text %}
## [1] 4
{% endhighlight %}

Let's list these combinations (columns of this matrix):

{% highlight r %}
combn(LETTERS[1:4],3)
{% endhighlight %}



{% highlight text %}
##      [,1] [,2] [,3] [,4]
## [1,] "A"  "A"  "A"  "B" 
## [2,] "B"  "B"  "C"  "C" 
## [3,] "C"  "D"  "D"  "D"
{% endhighlight %}
Notice that we return "ABC", but not "BCA".  This is _good_ for us in this problem as "BCA" is a cyclic permutation of "ABC" ("no card can be rotated so that it matches...").  However, we did ***not*** return "ACB" (or any cyclic permutations of that string).

Normally, when we want to count the number of _permutations_ $$(N_{n,k})$$ of a string, we do this:

$$
N_{n,k} = { {n}\choose{k} } k!
$$

The way I think about why the $$k!$$ gets tacked onto this is because, for each of the $$k$$ elements in the string, there are $$k$$ elements that we can put in the first position, AND $$k-1$$ elements we can put in the second position, AND $$k-2$$ elements we can put in the 3rd position, and so on down to 1 element that we can put in the $$k^{\text{th}}$$ position.  Since these are successive choices, we need to multiply the number of options together.  This process will overcount by considering cyclic permutations.  We can get around this by forcing the first element of the string to be the same.  For example, the permutations of "ABC" are:
- "ABC" "BCA" "CAB" (these last two are cyclic permutations of the first)
- "ACB" "CBA" "BAC"

So that means there are 2 permutations of the letters "ABC" that are independant (not cyclically related to another permutation).  We can count these like this:

$$
N_{n,k}^{\text{no cyclic}} = { {n}\choose{k} } (k-1)!
$$


## Results
So if we have 10 digits, and we want to make cards with 3 digits as indicated, we simply multiply the result of ${10}\choose{3}$ times $2! =2$, and get:

{% highlight r %}
nCards = choose(10,3)*factorial(3-1)
{% endhighlight %}
There are 240 unique cards that can be made.

## Extensions
More from the puzzle:
> Extra credit: Suppose you allow numbers to appear two or three times on a given card. Once again, no card can be rotated so that it matches any other card. Now what is the greatest number of cards your pixmit deck can have?

We can answer this by considering how many more unique cards would we make that have:
1. Exactly two digits repeated
2. All digits repeated.

The answer to question 2 is simple:  Since we have 10 possible digits, and all digits must repeat, this adds 10 cards (000, 111, 222, etc.).

The answer to question 1 is a little more subtle.  Let's think about the string "AAB".  How many permutations of "AAB" are there that follow our rules?  Just that one.  Transposing the first two letters is identical.  Transposing the last two letters (like this "ABA") is the same as moving the first letter "A" to the end of the string...a cyclic permutation, which is not allowed.  So we can ask this question.  How many allowed cards can we make with only the letters "A" and "B"?  The answer is 2:
- "AAB"
- "ABB"

So if we want to allow duplicated digits out of $n$ possible digits on each card with $k$ sides, we need to find:

$$
N = \sum_{d=1}^k { {n}\choose{k-d+1}} (k-d)!
$$

Here $$d$$ is an index that tells us how many digits are duplicated on a card.


{% highlight r %}
dup2 = choose(10,2)*2
dup3 = 10
nTotalCards = nCards + dup2 + dup3
{% endhighlight %}
And the new total number of cards is 340.
