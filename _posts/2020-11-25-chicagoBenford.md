---
layout: post
title:  "Chicago Voting Data Analysis"
categories: [election2020, teaching]
tags: [election2020]
---


## Voting fraud and Benford's law:

I wanted to replicate a few of the plots created in this video about Benford's Law and voting fraud.  I'm doing this mostly because it is fun, and because I want my research students to try it too.  I'm not a political scientist, and I'll leave the interpretation of these data to experts.  To summarize the point of the video, I quote the following passage from [Deckert *et.al.* (2011)](https://www.cambridge.org/core/journals/political-analysis/article/benfords-law-and-the-detection-of-election-fraud/3B1D64E822371C461AF3C61CE91AAF6D):

> "Benford’s Law is problematical at best as a forensic tool when applied to elections." 

On to the video

<iframe width="560" height="315" src="https://www.youtube.com/embed/etx0k1nLn78" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

I will copy a few of the experts pointed out in the video to this page too.  If you want an expert viewpoint, start there.

- [Check out Steve Mould's Numberphile video about Benford's Law.](https://www.youtube.com/watch?v=XXjlR2OK1kM)
- [There’s more on Mark Nigrini’s work here:](http://www.nigrini.com/benfords-law/)
- ["Benford's Law and the Detection of Election Fraud" 2011 paper.](https://www.cambridge.org/core/journals/political-analysis/article/benfords-law-and-the-detection-of-election-fraud/3B1D64E822371C461AF3C61CE91AAF6D) (Requires access to this journal.  ECU has access as of the date of this writing.)
- [And for balance, here is a paper critical of that other paper (but only in the use of a 'second digit' check and they do not dispute the main Benford's Law claims.).](https://pdfs.semanticscholar.org/e667/b8ad9f58992828ff820ddc8a005de754c5f5.pdf) 
- [And here is a paper by the same author specifically about the 2020 US election results](http://www-personal.umich.edu/~wmebane/inapB.pdf)

### What is Benford's law?
Benford's law states that the probability that the first digit of data that spans multiple orders of magnitude follows the following probability distribution:
$$
P(d) = \log\left(1+\frac{1}{d}\right)
$$
We are going to look at that with voting data in Chicago.

## Dataset
These data were obtained from the [Chicago Board of Election commisioners website](https://chicagoelections.gov/en/election-results.asp?election=251&race=11).  

I cleaned this data elsewhere and saved the `voteTally` object to this file:

{% highlight r %}
load('chicagoVoteTally.RData')
{% endhighlight %}

Presidential candidates who were on the ballot in Chicago were:

- Joe Biden (Democrat)
- Donald Trump (Republican)
- Howie Hawkins (Green)
- Gloria La Riva (Party for Socialism and Liberation)
- Brian Carroll (American Solidarity Party)
- Jo Jorgensen (Libertarian)

The 3rd party candidates were not included in Parker's video, but I thought it might be fun to include them.

The following functions will be used to process the data further:

{% highlight r %}
firstDigit = function(x){
    # Returns the first non-zero digit of any number.  
    # It assumes the number is greater than 0.
    if(!x>=0){
        stop("Number must be greater than or equal to zero")
    }
    x = as.character(x)
    firstX = unlist(strsplit(x,split=''))[1]
    firstX = as.numeric(firstX)
    return(firstX)
}

last2digits = function(x){
    ## Turn x into a character
    x = as.character(x)
    ## Split the character into all the characters
    splitX = unlist(strsplit(x,split=''))
    ## Figure out how many digits you have
    d = length(splitX)
    if(d==1){
        last2X = paste0("0",splitX)
    }else{
        ## Grab last two digits
        last2X = splitX[(d-1):d]
        last2X = paste0(last2X,collapse='')
    }
    return(last2X)
}

drawBenfordPlot = function(dat,candidate,barColor,curveColor='gold'){
    ## If any precincts have zero votes for a candidate, remove them
    dat = dat[dat!=0]
    ## Get the first digits
    dat = sapply(dat,FUN=firstDigit)
    ymaxBen = 1.1*length(dat)*log10(2)
    ymax = max(c(ymaxBen,1.1*max(table(dat))))
    ttl = paste(candidate,'Vote First Digit')
    hist(dat, xlab="First Digit", main=ttl, col=barColor,breaks=0:9,
                   ylim=c(0,ymax), axes=F)
    axis(side=1, at=seq(0.5,8.5,by=1), labels=1:9)
    axis(2)
    # What does Benford's law say should be the answer.  Overlay as a curve
    x = 1:9 
    benford = length(dat) * log10(1+1/x)
    lines(x-0.5,benford,col=curveColor,lwd=3)
}

drawLastTwoDigitPlot = function(dat,candidate,barColor){
    ## Get the last two digits
    dat = sapply(dat,FUN = last2digits)
    counts = table(dat)
    ## Make a title and plot
    ttl = paste(candidate,'Vote Last Two digit pairs')
    barplot(counts, xlab="Last Two Digits", main=ttl, col=barColor)
}
{% endhighlight %}

## Biden plots

{% highlight r %}
drawBenfordPlot(dat=voteTally$BidenVotes,candidate = "Biden", barColor = 'blue')
{% endhighlight %}

![plot of chunk Biden-first](/figure/2020-11-25-chicagoBenford/Biden-first-1.png)


{% highlight r %}
drawLastTwoDigitPlot(dat=voteTally$BidenVotes,candidate="Biden",barColor="blue")
{% endhighlight %}

![plot of chunk Biden-last](/figure/2020-11-25-chicagoBenford/Biden-last-1.png)

## Trump plots

{% highlight r %}
drawBenfordPlot(dat=voteTally$TrumpVotes,candidate = "Trump", barColor = 'red')
{% endhighlight %}

![plot of chunk Trump-first](/figure/2020-11-25-chicagoBenford/Trump-first-1.png)


{% highlight r %}
drawLastTwoDigitPlot(dat=voteTally$TrumpVotes,candidate="Trump",barColor="red")
{% endhighlight %}

![plot of chunk Trump-last](/figure/2020-11-25-chicagoBenford/Trump-last-1.png)

## "Third party" candidates
Parker didn't include so-called third party candidates, but I didn't want to leave them out.  Granted the total votes for these candidates were quite small. Here is a histogram of all of the precinct vote distributions.  (No pretty colors because I'm lazy)


{% highlight r %}
voteTotals = voteTally[ ,c(4,6,8,10,12,14)]
library(Hmisc)
hist.data.frame(voteTotals)
{% endhighlight %}

![plot of chunk totalVotes](/figure/2020-11-25-chicagoBenford/totalVotes-1.png)


### Hawkins plots

{% highlight r %}
drawBenfordPlot(dat=voteTally$HawkinsVotes,candidate = "Hawkins", barColor = 'green')
{% endhighlight %}

![plot of chunk Hawkins-first](/figure/2020-11-25-chicagoBenford/Hawkins-first-1.png)


{% highlight r %}
drawLastTwoDigitPlot(dat=voteTally$HawkinsVotes,candidate="Hawkins",barColor="green")
{% endhighlight %}

![plot of chunk Hawkins-last](/figure/2020-11-25-chicagoBenford/Hawkins-last-1.png)

### La Riva plots

{% highlight r %}
drawBenfordPlot(dat=voteTally$LaRivaVotes,candidate = "La Riva", barColor = 'purple')
{% endhighlight %}

![plot of chunk LaRiva-first](/figure/2020-11-25-chicagoBenford/LaRiva-first-1.png)


{% highlight r %}
drawLastTwoDigitPlot(dat=voteTally$LaRivaVotes,candidate="La Riva",barColor="purple")
{% endhighlight %}

![plot of chunk LaRiva-last](/figure/2020-11-25-chicagoBenford/LaRiva-last-1.png)

### Carroll plots

{% highlight r %}
drawBenfordPlot(dat=voteTally$CarrollVotes,candidate = "Carroll", barColor = 'lightgray')
{% endhighlight %}

![plot of chunk Carroll-first](/figure/2020-11-25-chicagoBenford/Carroll-first-1.png)


{% highlight r %}
drawLastTwoDigitPlot(dat=voteTally$CarrollVotes,candidate="Carroll",barColor="lightgray")
{% endhighlight %}

![plot of chunk Carroll-last](/figure/2020-11-25-chicagoBenford/Carroll-last-1.png)

### Jorgensen plots

{% highlight r %}
drawBenfordPlot(dat=voteTally$JorgensenVotes,candidate = "Jorgensen", barColor = 'gold',
                curveColor='black')
{% endhighlight %}

![plot of chunk Jorgensen-first](/figure/2020-11-25-chicagoBenford/Jorgensen-first-1.png)


{% highlight r %}
drawLastTwoDigitPlot(dat=voteTally$JorgensenVotes,candidate="Jorgensen",barColor="gold")
{% endhighlight %}

![plot of chunk Jorgensen-last](/figure/2020-11-25-chicagoBenford/Jorgensen-last-1.png)
