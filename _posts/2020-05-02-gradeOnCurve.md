---
layout: post
title:  "Grade on a curve? No way!"
categories: [teaching, grading, students]
tags: [teaching]
---


## Grade request

Every year I get an email that has this as a part of the text:

> I was also wondering if there was going to be a curve to the overall curve to the class.

This is probably evidence that we have students to focused on their grades, and not focused enough on their learning.  (I rarely get emails about how much they learned in my class or what they should learn...only what the test will focus on.)  

My stock answer to students is "no" and that the probably don't want to be graded on a curve anyway.  They look at me quizzically, and wonder why.  This is my attempt to go into more detail on that.

## What is a curve and why shouldn't students want that?

When you talk about the way that we conceptualize curves, you have to fall back to the [Normal distribution](https://en.wikipedia.org/wiki/Normal_distribution).  Basically it assumes that the grade distribution should look like this:

<img src="/figure/2020-05-02-gradeOnCurveunnamed-chunk-2-1.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" style="display: block; margin: auto;" />

Now we can argue about how I've centered that distribution.  But let's leave that for later.  What is more to the point is that grading on a curve means that we should want in a class of 100 to hand out grades as follows:

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:center;"> grade </th>
   <th style="text-align:right;"> number </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> A </td>
   <td style="text-align:right;"> 7 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> B </td>
   <td style="text-align:right;"> 24 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> C </td>
   <td style="text-align:right;"> 38 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> D </td>
   <td style="text-align:right;"> 24 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> F </td>
   <td style="text-align:right;"> 7 </td>
  </tr>
</tbody>
</table>

So, let me ask you, rhetorical student, do you want me to decide how many of each grade to hand out at the beginning of the semester?  Does that seem "fair" to you?  I know it doesn't sound fair to me.  And that's why I don't do it.

## That curve sucks, let's use something more realistic

I feel that the above is only part of the point.  Note that at many institutions, the GPA required to avoid academic warning/probation/suspension is 2.0 (or a C).  So we can argue that we should "want" to shift that curve to the right so that a smaller percentage of students are in danger of experiencing academic consequences. And many institutions evaluate courses based on their DFW rate (that is, the fraction of students who get a D, F, or withdraw from a course).  This particular curve would produce a DFW rate of 30.9%, which would get one on the appropriate administrator's shit list.  A grade distribution looking like this would be better recieved by many people.

<img src="/figure/2020-05-02-gradeOnCurveunnamed-chunk-4-1.png" title="plot of chunk unnamed-chunk-4" alt="plot of chunk unnamed-chunk-4" style="display: block; margin: auto;" />

Note: The distribution is actually "missing" scores greater than 100%.  I'm not going to allow for that in my diagram, and I'm too lazy to change the function generating this graph.  (I'm simply using R's built in `dnorm` and `pnorm` functions.)  Therefore, the graph is undercounting the A grades.  The grade table (which does properly count the A grades) would look like this, making my students happy:

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:center;"> grade </th>
   <th style="text-align:right;"> number </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> A </td>
   <td style="text-align:right;"> 24 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> B </td>
   <td style="text-align:right;"> 38 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> C </td>
   <td style="text-align:right;"> 29 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> D </td>
   <td style="text-align:right;"> 9 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> F </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
</tbody>
</table>

And the DFW rate would be 9.7%, making my appropriate administrator happy.  So why not use this "curve" instead?

## Philosophical impact of grading "on a curve"

Ultimately, the reason that I don't grade on a curve is that, ultimiately, I find it to be dehumanizing.  When we grade on a curve, we essentially turn the evaluation and assessment of students into a sorting task.  Education becomes the task of assigning things to students, so that I can rank them, and apply grades according to the "curve."  Plus, when I apply a curve, it makes my classroom competitive--students are fighting for a scarce resource, a higher grade--rather I want my classroom to be collaborative.  

Furthermore, there is an underlying assumption behind the curves that I drew--and the idea that grades should fall along a curve.  All of these graphics and tables were made possible through an understanding of the Normal Curve.  The normal curve is a tool that statisticians have for describing and characterizing _random systems_.  That's those [`dnorm` and `pnorm` functions](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/Normal.html) I was talking about earlier.  Why should we assume that grades should be randomly distributed?  Isn't the goal of education to actually educate?  

Finally, the idea of applying a curve ignores the x-axis of these plots and, by extension, the content of our courses and the skills we want our students to develop.  Assuming that our homework and assessments are measuring meaningful things, why would we ignore that information.  In the end, it is important that we have standards for our students, our colleagues, and the students future employers.  The *what* is important, as well as the *how well*.  This is what attracts me to the idea of [standards-based](https://arundquist.wordpress.com/2013/07/23/sbg-thoughts-after-aapt/) [grading](https://www.per-central.org/items/detail.cfm?ID=11815).  In that setting, the teacher sets out standards, and students have to show that they can meet those standards.  Then, teachers grade student work based on those standards.  

