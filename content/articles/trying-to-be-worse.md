---
title: Build Worse Software
publishDate: 2020-07-10

cover:
  url: /images/articles/trying-to-be-worse/cover.jpg
  alt: A screenshot of my first software project, X96 Panel.
  width: 1347
  height: 531

open_graph_meta:
  title: Build Worse Software
  description: >
    I've gone from being a teenager building WordPress sites to a professional
    software developer. But I've forgotten how to build software. It's time to get
    worse.
  image_url: /images/articles/trying-to-be-worse/cover.jpg
---

<big>
    One of my first software projects -- probably the first project I did that
    wasn't just building a website theme -- was building my own CMS. The year
    was 2010, I was a middle school student doing web design on the side, and I
    was tired of WordPress.
</big>

I am reminded of this project from time to time; usually I remember how much I
enjoyed building it. I used this custom CMS for some local business websites
during my consulting days. The project was just a pile of procedural PHP
scripts, with HTML and PHP just smashed together. MySQL was the database of
choice, with unprepared SQL strings littered everywhere.

Somewhere along the way since then, I learned the "right" way to build things:
carefully, with lots of planning, tests-first, deployed in a scalable way,
stateless if possible&hellip; the list goes on. And with that knowledge, I lost
the ability to just <em>build something</em>. My first question wasn't "What
features should it have?", but rather "What tools and architecture should I
choose?".

In my path to becoming a "professional programmer" **I lost the most
important goal of writing software: to solve problems**. I became
enamoured with the tools, processes, and dogmatic "correctness" of various
communities that I blinded myself to what I was actually trying to accomplish.

My projects languished in various states of incompleteness as every time I
would try and make progress, I would be hindered by a crippling narrative that
I needed to do it *the right way*. I was paralyzed by my own irrational
standards.

**My solution to this was to build worse software.** All the barriers of code
quality, tests, flawless architecture -- they're are all constructs that affect
*production* software; but they do not affect software that's just getting
started. I had to unlearn my impulses and force myself to take naïve risks and
shortcuts to getting a working solution. Visible progress is the finest
motivator.

Since then I've made an effort to purposefully write bad software first, and
good software later. By prototyping a messy, mostly-working version of
something, you explore the solution organically and have a starting point for
improvement.


If I had to sum up the lesson I learned in a sentence, it'd be&hellip; Time
heals all software? You have to build the village before the roads?
Something like that, anyway; I'm still working on it.


---

**Addendum:** A while back I found a snapshot of the code for my first CMS
archived on Google Code (RIP). I managed to export the SVN repo into Git and
have [archived the project publicly](https://github.com/alexblackie/x96-panel),
for those who are curious to see some godawful PHP. It only took a few seconds
to find an SQL injection vulnerability. Oh, how times change.
