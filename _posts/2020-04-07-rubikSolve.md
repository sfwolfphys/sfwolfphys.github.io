---
layout: post
title:  "Rubik's Cube Solving method"
date:   2020-04-07
categories: puzzles rubiksCube notaSpeedCuber
---

I have ripped this off from a YouTube video posted by a Wired.com author. See below:

<iframe width="560" height="315" src="https://www.youtube.com/embed/R-R0KrXvWbc" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

I'll put some of the steps below so that you can see the algorithms he uses just in case you don't want to scrub through the video.

## Make the Daisy
On the face with the yellow center, put white "petals" on the side edges around that square.

## Make the white cross
Take the center daisy petals, match the color on the corresponding face, and rotate the "petal" to the bottom.

## Solve the bottom layer
Put squares that have a white sticker on the top layer facing out.  Apply Right and Left trigger as appropriate to put in the correct bottom corner. It's hard to describe, so refer to the video. Once you've done it a few times, this kind of description is more helpful.

- Right trigger: `R U R'`
- Left trigger: `L' U L`

## Solve the 2nd (middle) layer
Apply R and L trigger as needed.  There are details in the video about looking for edge cubes on the top layer that belong in the middle layer

## Make the yellow cross
Algorithm: `F U R U' R' F'`

## Solve the yellow face
Algorithm: `R U R' U R U2 R`

## Position the corners
Algorithm: `L' U R U' L U R' R U R' U R U2 R`

## Position the edges
Algorithm for CW rotation: `F2 U R' L F2 L' R U F2`

Algorithm for CCW rotation: `F2 U' R' L F2 L' R U' F2 `
