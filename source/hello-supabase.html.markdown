
# Hello Supabase!

<article>

## CV

After 15 years of consulting and contracting, it's been a long time since I've submitted a CV. I've done enough hiring to know how quickly CVs get skimmed, so I'm going to bet it all on the covering letter. For a quick overview, [LinkedIn] is up-to-date-ish.

[linkedin]: https://www.linkedin.com/in/danielfone/

## Cover letter

Hello!

I realise this is long, but given the async and remote nature of the job, I want to showcase my written communication upfront. I've formatted this in markdown for easy reading—feel free to paste it into a viewer like StackEdit. Alternatively, it's published at <https://daniel.fone.net.nz/hello-supabase/> for your reading convenience.

For the last 15 years, I’ve been consulting/contracting in technical lead roles across a variety of industries — medical science, telecommunications, logistics, finance — mostly in Australia and New Zealand. The majority of my work has been behind the scenes, but I’ve shared some of my thoughts and experiences publicly if you’d like a sense of my style:

* I have a [dusty old blog] with a couple of more recent musings on [timing-safe bcrypt in postgresql] and why [software is not a desk job].
* Pre-pandemic, I spoke at conferences on topics like the [history of timekeeping] and [coding for failure].
* I've also organised and spoken regularly at our local Ruby meetup for the past decade, including talks like "A Tale of Two CTEs" (groan) and [Markov Chains in Postgres].

[dusty old blog]: https://daniel.fone.net.nz/
[timing-safe bcrypt in postgresql]: https://daniel.fone.net.nz/blog/2020/09/09/timing-safe-bcrypt-authentication-in-postgresql/
[software is not a desk job]: https://daniel.fone.net.nz/blog/2020/10/21/talking-typing-thinking-software-is-not-a-desk-job/
[history of timekeeping]: https://www.youtube.com/watch?v=UjdtH5gO_DQ
[coding for failure]: https://www.youtube.com/watch?v=VmURvpUnLeQ
[Markov Chains in Postgres]: https://gist.github.com/danielfone/2b2a084c5cf8baa22d460b86a7e59f5f

I'm always uncomfortable selling myself (maybe it's a Kiwi thing) but I'll go through the job description and give you my thoughts…

> You are: Someone with a proven track record of shipping developer-facing products from ideation to launch.

I’ve certainly shipped products from ideation to launch, including some developer-facing ones. Most recently, I developed an internal API at a telco to abstract broadband provisioning. The underlying systems at the wholesaler were tortuously complex, so creating a simple and coherent REST API for the retailer was a deeply satisfying challenge.

The best win was in 'meta-delivery' though. When we started, other teams were informally documenting their APIs in Confluence. We wrote an OpenAPI spec for ours, used it for request and response validation, and set up a GitHub action to publish an HTML version. It was so much easier, by the time we left most other teams had adopted the approach themselves. I love when good ergonomics drag other developers into the pit of success with you.

Some of my best work came in the early days of the pandemic. While working with a [medical quality assurance org], COVID struck and we urgently needed to have a QA program for all the [RATs] that were being deployed worldwide. It would be too slow to update our main platform, so we formed a small team (myself, the CTO, a head scientist, a BA, and another dev) and starting living the agile dream — iterating rapidly through prototypes to production. Within 4 weeks, we developed a new QA program and a supporting Rails app. I even coauthored a [journal article] on the project, and it turns out most of the RATs were not very effective at detecting COVID.

[medical quality assurance org]: https://rcpaqap.com.au/
[RATS]: https://en.wikipedia.org/wiki/Rapid_antigen_test
[journal article]: https://www.sciencedirect.com/science/article/pii/S2352551720301426

> Aligned with our Product Principles.

The product principles resonate deeply with me. It's easy to say, but I hope it comes through my writing. When I first used Supabase last year, I was so taken by the concept — managed postgres plus open-source systems as the backbone of your app — that I immediately gave an (uninformed but enthusiastic) talk on it. I think I'm now that supabase guy in our local meetup (or more accurately, the why-does-he-try-to-do-everything-in-Postgres guy).

> Experienced with 6+ years in relevant roles:
>
>  * ~~As a product manager for a developer tools product,~~
>  * As a developer with a keen sense of product.

I've spent **20+ years as software developer**, 99% of it building for the web, mostly Ruby/Rails/PostgreSQL, and more recently Typescript and friends. I've done some AWS wrangling, and lots of Heroku.

I've spent **15 years consulting**, building bespoke information systems for small business. Working closely with directors or managers has really honed my sense of 'product'. When you write both the code and the invoices, you quickly learn what matters and what doesn't. Many clients call me directly when they're confused about the app, so I see how users hold things, and can apply that insight straight to the codebase.

Over the last **6 years**, I’ve led engineering teams of half a dozen, coordinating BA/QA/engineering/UX, and navigating the organizational dynamics of various clients.

> Deeply knowledgeable about how Supabase products work.

To be honest, I'm superficially knowledgeable about how Supabase products work. I use Supabase, and some of the underlying tech I've used extensively. But compared to others, I can't call my knowledge deep.

That said, to me this is the easiest thing to improve. It's a delight when I get the time to deeply learn how something is designed, rather than just making something work and moving on. And it's much easier when you can read the source!

> Possessing strong technical abilities and comfortable diving deep into a wide array of products. For instance, you might investigate how Realtime handles connection pooling one day and explore the implications of Postgres running in a browser the next.

This is the most satisfying part of the job for me. I thrive on mental variety, which is why I’ve juggled multiple clients and projects simultaneously for so long. And I love diving deep.

A couple of quick stories… :)

- I worked on a project recording [EEG] for epilepsy patients using [reversed cochlear implants]. I was building the web app, doing signal processing and visualisation features. By persistently chasing down things I didn't understand, I eventually found a bug in the cochlear firmware. As someone far removed from firmware development, I was unreasonably proud.

- I discovered a bug in pgcrypto while migrating authentication providers. Bcrypt hashes generated by the old application weren't being matched by `crypt` in the database. We quickly devised a work-around for the migration, but I couldn't let the issue go. Turns out there's a lot of weird nuance in bcrypt versions: $2a$ vs $2b$ vs $2x$ etc. The app generated a version pgcrypto didn't support, and instead of throwing an error, it returned garbage. I worked through the issue with the mailing list and managed to integrate the code to support the both versions. Sadly, this patch remains unmerged.

- I lead a team building an analytics platform to review laboratory testing, but we struggled to understand the advanced statistics the scientists required. To bridge the gap, I started writing a manual explaining the statistical concepts from first principles, even though I didn’t fully understand them. Of course the first draft was full of errors, but by documenting it _precisely_ but _incorrectly_, the pathologists could correct our misunderstandings in concrete ways. We iterated until we had a complete, accurate manual, which is now even used to train their junior scientists.

[reversed cochlear implants]: https://epiminder.com/the-minder-system/
[EEG]: https://en.wikipedia.org/wiki/Electroencephalography

> Obsessed with improving the developer experience.

Having worked with so many different teams, I’ve seen how much impact DX has on a team’s output. When a team experiences high friction in achieving simple tasks, morale, productivity, and quality suffer. Great tooling creates happy teams, and happy teams create great products.

Even as I spend less time 'on the tools,' one of my favourite things is to spot an error in the exception tracker, fix the bug, resolve any issues it caused, and reach out to the user directly to say, 'Hey, I noticed something went wrong—I've sorted it out for you.'

Also, I _am_ a developer, so improving developer experience is just blatant self-interest!

## Why do you want to work with us?

Honestly, even applying feels strange to me! I've been fiercely independent for such a long time now, the thought of being employed somewhere is unusual. But this opportunity really captured my imagination, and I’m keen to have a conversation. Here’s what appeals to me:

1. The Product & Company

   - Supabase is very close to the product I’ve wished existed for years.

   -  When I coach delivery teams, I emphasize (1) psychological safety and (2) retro. In my experience, everything else evolves from these. That's the same kaizen mindset I see at Supabase: just get started and make continuous improvement part of the plan.

   - I want to work on something with a broader reach and more impact than the clients I've been working with.

   - And I want to do it without being tied to my desk. I love fully remote asynchronous work!

2. The Role

   - Technical Product Manager is a role I’ve been considering for a while now. It aligns closely with what I already do, but this feels like a natural next step. Working with such talented people across a wide variety of cutting-edge technology is really the dream.


## Previous OSS
> Have you previously worked in Open Source? Tell us about it

Not as much as I’d like, and more so in the past than recently.

- I've authored [a couple of gems] that actually get used.

- As mentioned, I tried to fix [a bcrypt bug in pgcrypto]. Ultimately, I failed the gauntlet of the pg-hackers contribution cycle. In hindsight, maybe this is the system working as expected: random newbies shouldn't be able to come along and change pgcrypto easily? When I get a chance I should come back to this with a simpler approach though, because as far as I'm aware the bug is still there, and the bare minimum fix should be straightforward.

- [privatepassage.io] was a personal experiment I released a while back, but it's getting 600 uniques a month according to cloudflare. That reminds me, there used to be a subtle bug in Cloudflare Worker's websocket implementation. I should check if it's still there… 🤔

- The usual miscellanea of small bug fixes and of half-finished ideas on GitHub: <https://github.com/danielfone>

[a couple of gems]: https://rubygems.org/profiles/danielfone
[a bcrypt bug in pgcrypto]: https://www.postgresql.org/message-id/flat/5B221EBB-03D5-4C3E-BD00-CF0FB4256825%40fone.net.nz
[privatepassage.io]: https://privatepassage.io/

## Remote experience
> Have you had remote experience? How many years?

99% remote for 13 years. Async is the bestsync.

## Previous Founder
> Have you previously founded a company before? Tell us about it

Not really — I've run my own consultancy for 15+ years, mostly just me, sometimes with others. I've also spent hundreds of hours on [chessr.app] which launched last year and so far has an ARR of (checks notes)… $66. 😂

[chessr.app]: https://chessr.app/

## Expected Rate
> Optionally let us know your expected salary / contracting rate (include "per hour/day/year" etc)

I haven't had a salary in 15 years!? At the moment, I charge $200 (NZD/AUD) per hour for most of my contracts. I've made $300k+ p.a. for the last few years doing consulting.

</article>
