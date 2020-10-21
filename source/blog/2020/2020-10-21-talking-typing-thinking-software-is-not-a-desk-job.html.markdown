---
title: "Talking, Typing, Thinking: Software Is Not a Desk Job"
date: 2020-10-21 20:58 NZDT
summary: Developers over-optimise for the egonomics of typing and not enough for the egronomics of thinking.
---

I had a wonderful shower the other day.

It was late morning (as the best showers often are) and I was reflecting on how I spend my time during the day. As a work-from-home consultant, I constantly need to justify my billing and my time, and in this case I was justifying spending more of it in the shower.

Like most of us, I started my career with the impression that a productive day was spent ergonomically poised over a keyboard typing hundreds of lines of code into Microsoft Visual Basic 6.0 Professional Edition, and _not_ standing in a perfectly hot stream of high pressure fresh water. However, the longer I spend as a developer, the less I'm convinced I need to be at my desk to deliver the truly astounding spreadsheet-to-web-application business value us senior engineering consultants deliver.

So that you too can justify spending the good part of a morning enveloped in a cocoon of cleansing warmth, let's break this down and look at 5 physical activities of effective software development. Like all good listicles, this is ordered roughly in order of increasing time and importance.

## 5. Talking

Some software development probably doesn’t need any talking to be effective. I understand for example that it is universally considered bad manners to talk about linux kernel development out loud. The contents of ~/bin too, we do not speak of.

But every commercial project I’ve worked on has needed at least some talking. When people are too busy or just too shy to talk, the lack of high-bandwidth communication can make it hard to tease out requirements and unpack poorly explained business problems.

But more importantly, a lack of talking makes it hard to build trust and rapport — critical in early stages of any new relationship. As social animals, we are particularly good at doing this verbally, and not particularly good at doing this with emails and spicy subtweets.

On the other hand I’ve worked on projects where talking is a prop to disguise that no-one knows what to do. Where a dozen people sit in a room and talk for an hour without saying anything and we all walk out dumber than when we walked in.

So for most cases: talking is critical, but in the right amount.

## 4. Listening

Honestly I just included this for symmetry. The only thing I’ll add is that we have two ears and one mouth so either binaural hearing offers an evolutionary advantage against some selection pressure or we’re supposed to listen twice as much as we talk.

Take your pithy wisdom however you like it.

_(quicky googles why do we have two ears)_

## 3. Writing

Writing code of course! But also… READMEs, comments, inline documentation, PR descriptions, code reviews, git commits; this is all part of the _core work_. It's tempting to see this meta-writing as overhead on top of the real 'code' writing. But effective writing in these other places is a force multiplier for your code.

Much more importantly though, in my experience the best communication is written.

- It’s async, meaning it can be consumed whenever convenient for each reader (i.e. after a late morning shower).
- It can be easily distributed and has no fidelity loss when shared (compared to talking to John about what Sarah told you Steve said in meeting that none of you were at).
- It creates a record, as opposed to “wait, why did we…?”
- [Writing is thinking](https://alistapart.com/article/writing-is-thinking/)! Writing forces you to structure your ideas coherently (at least, it seems to for some people). It reveals shortcomings or gaps in your understanding or plan.

Because of this I encourage team comms to be mostly written. Jira, slack, emails, trello, blog posts, whatever. Even a hi-res photo of a wall of post-it notes has been an indispensible architectural road-map at times. However it's published, detailed, well-thought out writing is 💯.

Perhaps even more important than writing though is…

## 2. Reading

Having just extolled the virtues of writing READMEs, commit messages, PR descriptions, etc, I should obviously encourage you to read them. It's called README IN CAPITALS for a reason, and it's not just because it's an acronym. Yet if I had a dollar for every time someone asked me a question that was already answered in the README I would have three dollars. 💰

This is because of what I succinctly call the vicious-reading-writing-cycle-feedback-loop. When people don't update the commentary, people become trained to ignore it, so people don't update it, etc. Truthfully, if you know someone's reading your git commits, their quality will rapidly improve. Even if you've never read a coherent git commit from your colleagues before, it's never too late to ask them to elaborate on what `finally fix it` means.

But like writing, the value of reading extends well beyond the code repository.

I recently started a project involving a completely unfamiliar field of medical technology (ps you're [still my favourite](https://twitter.com/danielfone/status/1318026784454045703) patient `01-004` 📊❤️). The most valuable activity I find at this stage of a project is to read.

We have to parse a [specialised file format](https://en.wikipedia.org/wiki/European_Data_Format), for which there is [a gem](https://github.com/nsrr/edfize). But why leave all that useful context buried inside the gem? The [file specification](https://www.edfplus.info/specs/edf.html) is not that long, even if it takes many attempts to understand it. Reading the file format spec makes it much easier to understand why the gem needs to [load_digital_signals_by_epoch](https://github.com/nsrr/edfize/blob/93566cdc82b160ef319c51908c1c4a19666e2625/lib/edfize/edf.rb#L243), which in turn suggests alternative solutions to the problem you have in hand.

None of the _adjacent possible_[^1] is discoverable without the insights gained from reading these sources, so whatever you're dealing with, go to the source and read read read…

* documentation (_reading the very well-written [postgres manual](https://www.postgresql.org/docs/current/index.html) or [redis docs](https://redis.io/documentation) is the closet experience I've had to Neo downloading kung-fu into his brain_)
* code (_vastly underrated - there's not a gem in my Gemfiles I haven't `bundle open`d at least once_)
* log files, error messages, that tutorial on how to read flame graphs
* the specification, legislation, policy document, NIST guideline, the original paper in the open access journal

… you get the idea, just find the authoritative document and slurp it into your brain. Even if it seems like nothing sticks, a brief encounter with the text will leave an long-lasting impression. It's like homeopathy but real.

So talking/listening… writing/reading… and finally… _drumroll noises_

## 1. Thinking

When you boil it down, _this_ is the main effort for me, and yet it’s kind of the hidden one.

How much of my programming/coding/dev time is actually just spent _thinking_ about the problems?
Modelling the domain,
thinking through the edge cases,
mentally playing with abstractions.

And it's obvious when you think about what makes good developers. The people I value working with most are aren’t accurate typists, they're _clear thinkists_.

Yet the image persists that typing is working and working is typing and a productive day is in your chair at your desk.
So we have dual 4k monitors, mechanical keyboards, aeron chairs, touchbar, vim shortcuts, whatever optimises for us tapping away at our computers.

But how much attention do we pay to the **egonomics of thinking**?

When we elevate ‘thinking’ to core work, we naturally start to optimise for it specifically. In general, we don’t need to be in front of anything to think effectively, and often I find it better not to be. My times of greatest clarity are invariably when I'm moving, often when I'm exercising. Futher, I can read on my phone practically anywhere, and the best conversations are often had while strolling.

So while I'm glad for all the ergonomics of my workspace, increasingly I find that writing code is the brief part where I’m simply harvesting all the mental crop that I’ve sown from the talking and listening and reading and thinking.


To distill this into something a little more alliterative, I have sometimes described this as the 3 Ts of software development…

<h2 style="text-align: center">Talking · Typing · Thinking</h2>

**Talking** and listening; the verbal discussions. Most of the time we need a small but critical amount of high bandwidth synchronous comms.

**Typing** code commentary: READMEs, code reviews, PR descriptions; and all asynchorous communication: project updates, technical overviews, emails with next steps; These are all an essential part of the job and not just ancillary or busywork. Also typing actual code at some point. But I find the more time you spend typing the other stuff, the less time you need to spend (re)typing code.

**Thinking**: (including, for the purposes of alliteration, reading)

Talking, typing, thinking: this is the work we do. And I for one want to give myself the space to do all parts of it really well.

Anyway, I gotta go take a shower. 🚿

[^1]: per [Steven Johnson in the WSJ](https://www.wsj.com/articles/SB10001424052748703989304575503730101860838)

      > The adjacent possible is a kind of shadow future, hovering on the edges of the present state of things, a map of all the ways in which the present can reinvent itself.
