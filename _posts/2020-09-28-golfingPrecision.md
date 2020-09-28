---
layout: post
title:  "Golfing Precision"
categories: [riddler, fun]
tags: [riddler]
---


## The riddle
Only time for the express this week, and since it's about a physics major, well, I couldn't resist.

> The U.S. Open concluded last weekend, with physics major Bryson DeChambeau emerging victorious. Seeing his favorite golfer win his first major got Dan thinking about the precision needed to be a professional at the sport.
>
> A typical hole is about 400 yards long, while the cup measures a mere 4.25 inches in diameter. Suppose that, with every swing, you hit the ball X percent closer to the center of the hole. For example, if X were 75 percent, then with every swing the ball would be four times closer to the hole than it was previously.
> 
> For a 400-yard hole, assuming there are no hazards (water, sand or otherwise) in the way, what is the minimum value of X so that you’ll shoot par, meaning you’ll hit the ball into the cup in exactly four strokes?

## Functions and background
No functions needed this week.  Just some algebra.  So the distance that you are away from the hole after the $$n^{\text{th}}$$ stroke is:

$$
d_n = d_0 (1 - x)^n
$$

where $$d_0 = 400$$ yards (the initial distance from the hole).  So we want to know for what value of $$x$$ is $$d_4 < \frac{c}{2}$$.  Here $$c = 4.25$$ inches, the cup diameter.  Let's rewrite the above equation under the condition that:

$$
d_0 (1-x)^4 \leq \frac{c}{2}
$$

This can be solved for $$x$$:

$$
x \geq 1 - \left(\frac{c}{2d_0}\right)^{\frac{1}{4}}
$$

## Results
Plug and chug:

{% highlight r %}
c = 4.25/2/36 # cup radius in yards
d0 = 400
x = 1 - (c/d0)^(1/4)
xBogey = 1 - (c/d0)^(1/5)
xBirdie = 1 - (c/d0)^(1/3)
xBad = 1 - (c/d0)^(1/6)
{% endhighlight %}
So you need to be within 88.98% (Rounded to 2 decimal places).


## Extensions
It was trivial to do above, but I thought it would be cool to see what a "birdie" golfer and a "bogey" golfer looks like.  I'll note that on a typical PGA tour event (***not*** the US Open), Par is not a winning score, and the best pros can be closer to birdie golfers.

- Bogey: 82.87%
- Birdie: 94.72%

And if you are a bad golfer like me, you've never broken 100, so that's 77.01%.  If you just like [Bad Golf, then these guys are for you](https://www.youtube.com/channel/UCrEkTg1razLTBO42AgJsz_w).

### The road not traveled
I'm not going to do them, but there are a number of questions that could be answered.  Some are closely related to this problem, others require a re-conceptualization.  Lets start easy:

- How does the required accuracy change on a 300 yard par 3 hole?  A 500 yard par 5?
- Another way of restating the previous is: Given this required accuracy, how long should a par 3 be?  A par 5?

The biggest shortcoming of this model is that this assumes a one-dimensional course (and deterministic golfing).  How could you model a 2D course?  This would still be a flat course, and assumes no rough, wind, or hazards (on a zeroth order anyway), but could produce some other interesting questions.  One way of doing this that would keep the spirit of the initial model intact could look like this:

- Put the tee at $$(0,-d_0)$$, and the cup at the origin.
- On the first shot, assume you have a landing area centered on $$(0, -xd_0)$$ with a radius of $$x d_0$$.  Randomly select a landing spot within this area.
- Repeat until you are within $$\frac{c}{2}$$ of the cup location.

One shortcoming of this model is that you would *never* overshoot the hole.

My last idea:  This analysis always assumes that the goal of every shot is to hit the ball in the hole.  Unless I'm mistaken, there has never been an ace shot on a par 5 hole.  (I'll let the reader google that.)  In reality, the goal is to hit the ball to a place where you can make another good shot (find the fairway, avoid the bloody woods).  I'm thinking about an analysis where we can explore the adage, "drive for show, putt for dough."  This is how I'd explore that:

1. Keep the 2D course simulation I describe above.
2. Allow a club selection phase.  For simplicity, I'll use 3 clubs with two parameters: max length and precision.
- ***Putter*** - used for all shots less than 20 yards.  Works just like the simulation described above (always aiming at the cup).
- ***Iron*** - used for all shots less than 200 yards. Works just like the simulation described above (always aiming at the cup)
- ***Driver*** - used for all shots longer than 200 yards, but cannot hit the ball longer than 300 yards.  If you are farther than 300 yards from the cup, your center landing spot is on the line closer to the hole and the radius of the circle is the precision of the driver times 300 yards.
    
Since the winning percentage in the previous part was just under 90%, I'd say that the average error $$(1-x)$$ in all clubs should be 10% (or some constraint like that) and let you play with parameters to maximize your chances of scoring lower.  For example, you could pick a flat distribution (X = 90% for each club) or do something more like this (X_driver = 85%, X_iron = 90%, and X_putter = 95%).  The average error constraint could be explored in each of the regimes described above (bogey golfer, bad golfer, birdie golfer...)
