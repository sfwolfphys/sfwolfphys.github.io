---
layout: post
title:  "Best strategy for a fencing relay"
categories: [riddler, fun]
tags: [riddler]
---


## [The riddle](https://fivethirtyeight.com/features/en-garde-can-you-win-the-fencing-relay/)

> You are the coach at Riddler Fencing Academy, where your three students are squaring off against a neighboring squad. Each of your students has a different probability of winning any given point in a match. The strongest fencer has a 75 percent chance of winning each point. The weakest has only a 25 percent chance of winning each point. The remaining fencer has a 50 percent probability of winning each point.
>
> The match will be a relay. First, one of your students will face off against an opponent. As soon as one of them reaches a score of 15, they are both swapped out. Then, a different student of yours faces a different opponent, continuing from wherever the score left off. When one team reaches 30 (not necessarily from the same team that first reached 15), both fencers are swapped out. The remaining two fencers continue the relay until one team reaches 45 points.
>
> As the coach, you can choose the order in which your three students occupy the three positions in the relay: going first, second or third. How will you order them? And then what will be your team’s chances of winning the relay?


## Functions and background
We need a function that simulates a relay:


{% highlight r %}
simulateRelay = function(pOrder){
    if(length(pOrder)!=3){
        stop("The number of participants is 3.")
    }
    ## Initialize
    matchResult = NULL
    myWins = 0
    oppWins = 0
    # First leg:
    while(max(myWins,oppWins)<15){
        if(runif(1) < pOrder[1]){
            matchResult = c(matchResult,'myTeam')
            myWins = myWins + 1
        }else{
            matchResult = c(matchResult,'opp')
            oppWins = oppWins + 1
        }
    }
    # Second leg:
    while(max(myWins,oppWins)<30){
        if(runif(1) < pOrder[2]){
            matchResult = c(matchResult,'myTeam')
            myWins = myWins + 1
        }else{
            matchResult = c(matchResult,'opp')
            oppWins = oppWins + 1
        }
    }
    # Final leg:
    while(max(myWins,oppWins)<45){
        if(runif(1) < pOrder[3]){
            matchResult = c(matchResult,'myTeam')
            myWins = myWins + 1
        }else{
            matchResult = c(matchResult,'opp')
            oppWins = oppWins + 1
        }
    }
    
    relayResult = ifelse(myWins==45,'My Team','The Opponent')
    res = list('rres'=relayResult,'myWins'=myWins,'oppWins'=oppWins,
               'allMatches'=matchResult)
    return(res)
}
{% endhighlight %}

## Results

Before I present results, I'd like to state my idea of how this should work.  My general thought is that the strongest player should go last.  In general, I want my strongest player out for the longest time.  If the order is from weakest to strongest, on average, we expect the following results:
- Weakest player will win 25% of matches, opponent wins 75% of the matches.  So this player will be out for 20 matches, and get 5 wins.  Score 5-15.
- Medium player will win 50% of matches, and should be out there for 30 matches total.  Score 20-30.
- Best player will win 75% of matches and needs to win 25 matches before other player wins 15.  Given the win probability, this player would be expected to win 25 matches in 33 tries.

If I play my best player in any spot but the last one, the most matches that can be won are 15, and my sense is that we want the player who can gain wins most efficiently out for the longest time.


{% highlight r %}
playerProbs = c(0.25,0.5,0.75)

Nsims=1000
relayResTab = NULL
for(p1 in playerProbs){
    otherProbs = playerProbs[playerProbs!=p1]
    for(p2 in otherProbs){
        p3 = otherProbs[otherProbs!=p2]
        pOrder = c(p1,p2,p3)
        relayWins = 0
        for(n in 1:Nsims){
            relaySim = simulateRelay(pOrder = pOrder)
            relayWins = relayWins + 
                ifelse(relaySim$rres=="My Team", 1, 0)
        }
        winPct = relayWins/Nsims*100
        orderTab = data.frame(p1,p2,p3,'WinPct'=winPct)
        if(is.null(relayResTab)){
            relayResTab = orderTab
        }else{
            relayResTab = rbind(relayResTab,orderTab)
        }
    }
}
## Order the table
relayResTab = relayResTab[order(-relayResTab$WinPct),]
{% endhighlight %}

The labels in this table `p1`, `p2`, and `p3` are the win probabilities of the first, second, and third players respectively.
<!-- html table generated in R 4.1.2 by xtable 1.8-4 package -->
<!-- Mon Dec 13 16:31:53 2021 -->
<table border=1>
<tr> <th> p1 </th> <th> p2 </th> <th> p3 </th> <th> WinPct </th>  </tr>
  <tr> <td align="right"> 0.50 </td> <td align="right"> 0.25 </td> <td align="right"> 0.75 </td> <td align="right"> 93.40 </td> </tr>
  <tr> <td align="right"> 0.25 </td> <td align="right"> 0.50 </td> <td align="right"> 0.75 </td> <td align="right"> 93.10 </td> </tr>
  <tr> <td align="right"> 0.25 </td> <td align="right"> 0.75 </td> <td align="right"> 0.50 </td> <td align="right"> 84.20 </td> </tr>
  <tr> <td align="right"> 0.75 </td> <td align="right"> 0.25 </td> <td align="right"> 0.50 </td> <td align="right"> 17.10 </td> </tr>
  <tr> <td align="right"> 0.50 </td> <td align="right"> 0.75 </td> <td align="right"> 0.25 </td> <td align="right"> 7.30 </td> </tr>
  <tr> <td align="right"> 0.75 </td> <td align="right"> 0.50 </td> <td align="right"> 0.25 </td> <td align="right"> 6.40 </td> </tr>
   </table>

These results show that my intuition is correct, the strongest player going last is indeed optimal.  In fact, any order that had the highest rated player after the lowest rated player made the team's victory more than 80% probable.

## Extensions

I thought it would be interesting to watch the win count change like a basketball game flow graph.  



