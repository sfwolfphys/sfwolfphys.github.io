---
layout: post
title:  "Converting LaTeX to Word for The Physics Teacher"
date:   2021-03-30
categories: [pandoc, latex, word, publishing]
---

I've been putting together a manuscript for [*The Physics Teacher*](https://aapt.scitation.org/journal/pte). I use LaTeX for all my writing, so I wanted a reference for whenever I have to submit something using MS Word. Fortunately [pandoc](https://pandoc.org) exists. I'm going to keep this pretty minimal as there are many excellent resources out there for learning pandoc (and I'm not really one of them).

## Files required

- To start any LaTeX endeavor, many times you use a [template file]({% link files/tptTemplate032021.tex %}), which I have included. This template is based on `revtex4-2` and is current as of the date of this post. Perhaps using revtex is overkill, but I like using APS style for the bibliography. Speaking of...
- An [APS bibliography style file]({% link files/american-physics-society.csl %}) is required to allow pandoc to format the references properly. I downloaded this one from [citationstyles.org](https://citationstyles.org). Many others exist there.  Go to the Author page and look for their _Zotero Style Repository_ link for something that is browse-able. (Their github repo is so large that the browser does not display all styles.)

## Command

This should do it:

```
pandoc myPaper.tex --bibliography=myBib.bib --filter pandoc-citeproc --csl american-physics-society.csl -M reference-section-title=References -o myPaper.docx
```

### Issues:
These are things that I noticed

- ***Acknowledgements*** section title is missing. Not sure how to fix. I don't have the desire to look more than I have (5 minutes)
- Also ***Section numbering*** is broken.  I guess I'm putting those in manually too. (This can be done in MS Word/Libre Office by editing the style of `Heading 1` and `Heading 2`.  I can't make them align like I want them to (flush with the left margin), but whatever.
- <del>There is a ***weird sticky space*** (yes, that's my technical term) that shows up right before citation brackets.  I did a global find-replace to get rid of them.</del> Maybe this is an artifact when viewing with Libre Office, the spacing wasn't right on genuine Word. I will play with this a little later.
- Hyperlinks don't show up.
- Word's default style is ugly. I suppose I could fix that with a reference document. There is a `--reference-docx=template.doc` argument to pandoc that could be fiddled with.  Editing the default style is another way to go.
- ***Author Institutions*** do not appear by default.

