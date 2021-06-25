---
layout: post
title:  "Three Strikes and score"
categories: [riddler, fun, bowling]
tags: [riddler]
---


## [The riddle](https://fivethirtyeight.com/features/can-you-bowl-three-strikes/)

> Scoring in bowling can be a tricky matter. There are 10 frames, and in each frame you get two chances to knock down as many of the 10 pins as you can. Each pin knocked down is worth 1 point, and the pins are reset after each frame. Your score is then the sum of the scores across all 10 frames.
>
> If only it were that simple. There are [special rules](http://www.fryes4fun.com/Bowling/scoring.htm) for spares (when you’ve knocked down all 10 pins with the second ball of a frame) and strikes (when you knock down all 10 pins with your first ball). Whenever you bowl a strike, that frame is scored as 10 plus the scores of your next two rolls. This can lead to some dependency issues at the end of the game, which means the final frame has its own set of rules that I won’t go into here.
>
> For example, if you bowled three strikes and missed every subsequent shot (i.e., they were gutter balls), your third frame would be worth 10 points, your second frame would be worth 20 and your first frame 30. Your final score would be 30 + 20 + 10, or 60 points.
>
> This week, Magritte is going bowling, and the bowling gods have decided that he will bowl exactly three strikes in three randomly selected frames. All the other frames will consist of nothing but gutter balls. Magritte also lacks patience for bowling’s particular rules. If one of his three strikes comes on the 10th and final frame and he is prompted to bowl further to complete the game, he will bowl gutter balls out of frustration.
>
> What score can Magritte expect to achieve? (That is, with three randomly placed strikes, what is his average score?)

## Functions and background

Some of the assumptions that we have made (either a frame is a strike, or a double gutter ball) make coding a bowling score calculator that can handle other cases superflouous.  What we will do first is generate all possible "games" that Magritte could have.  Basically, we need to calculate all possible permutations of this "game":


{% highlight r %}
(baseGame = c(rep('S',3),rep('G',7)))
{% endhighlight %}



{% highlight text %}
##  [1] "S" "S" "S" "G" "G" "G" "G" "G" "G" "G"
{% endhighlight %}
Here each letter is the result from a frame, where "S" indicates a strike and "G" indicates a gutter ball.  Let's generate permutations:


{% highlight r %}
gamePerms = function(nStrike, nGutter){
    nTot = nStrike + nGutter
    if(nStrike < 1){
        return(matrix(rep('G',nGutter),nrow=1))
    }else if(nGutter < 1){
        return(matrix(rep('S',nStrike),nrow=1))
    }else{
        res = matrix(nrow = 0, ncol = nTot)
        res = rbind(res, cbind('S',gamePerms(nStrike = nStrike - 1, nGutter = nGutter)))
        res = rbind(res, cbind('G',gamePerms(nStrike = nStrike, nGutter = nGutter - 1)))
        return(res)
    }
}
{% endhighlight %}

Next, I'm going to parse each string looking for the following patterns:

- `SSS` will be replaced by `TDS`.  (Triple, Double, Single)
- `SS` will be replaced by `DS`. (Double, Single)

*Note: This substitution pattern won't work if there is a chance that there can be 4 strikes in a row.*


{% highlight r %}
scoreStrings = function(scoStr){
    scoStr = gsub('SSS','TDS',scoStr)
    scoStr = gsub('SS','DS',scoStr)
    return(scoStr)
}
{% endhighlight %}

This way, we can make scores by counting a `T` as 30 points, a `D` as 20 points, a `S` as 10 points, and a `G` as 0 points.  Then we add.  


{% highlight r %}
scoreSubs = function(scoLett){
    sco = ifelse(scoLett=='T',30,
                 ifelse(scoLett=='D',20,
                        ifelse(scoLett=='S',10,0)))
    return(sco)
}
{% endhighlight %}

## Results

Let's generate all of the possible games and convert them into strings:


{% highlight r %}
possGames = gamePerms(nStrike = 3, nGutter = 7)
possGameStr = apply(possGames, 1, function(x) paste(x,collapse=""))
{% endhighlight %}

Now, let's make the substitutions:

{% highlight r %}
adjStrings = scoreStrings(possGameStr)
frameScores = matrix(scoreSubs(unlist(strsplit(adjStrings,''))),ncol=10,byrow = TRUE)
gameScores = rowSums(frameScores)
{% endhighlight %}

The average game score is: 36.6666667.  

There are three different scores that can be achieved:

- 60 (all three strikes in a row) occurs 8 times. (TDS pattern)
- 40 (two strikes in a row, third strike not consecutive) occurs 56 times. (`DS - S` or `S - DS` pattern)
- 30 (all three strikes have at least one gutter-ball between them) occurs 56 times.

