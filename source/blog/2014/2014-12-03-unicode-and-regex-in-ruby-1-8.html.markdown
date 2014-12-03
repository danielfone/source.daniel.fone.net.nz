---
title: Unicode and Regex in Ruby 1.8
date: 2014-12-03 23:33 NZDT
tags:
summary: Regex doesn't play nicely with unicode in Ruby 1.8, so watch your input data! Specifically, '\W' (non-word character) only matches ascii characters.
---

For the last 6 months, I have been locked in mortal combat with the worst type of bug ever. It is the kind of bug that demonstrably occurs in production, but it is very intermittent, and you cannot ever reproduce it.

Finally today, that bug is no more.

#### The Problem

Users of this particular app can submit comments on 'tasks'. Comments can contain mentions of other users with a `@user` syntax, much like Github. This notifies the mentioned user(s) of the comment.

Although it had been working fine, it started intermittently failing — less than 1% of the time. Although it wasn't frequent, it was incredibly unhelpful because commenters wouldn't know that their message hadn't been sent, and would blindly wait for some response.


#### Failing to Diagnose

* The regex that matched metions was `/(?:^|\W)@(\w+)/`, which worked fine in every test case we had.
* Even when I had examples of failing comments, I could copy them out of the database, run them through the parser, and they would correctly send all the notifications.
* I could _not_ see why the mentions weren't getting parsed, and I couldn't reproduce the errors.


#### Breakthrough

The relevant parts of the process for these mentions were as follows:

  1. Take a (potentially HTML) comment
  2. Convert it to plain text
  3. Parse it for mentions and send notifications
  4. Save it to the database

After countless hours of debugging, I discovered the gotcha was in step 2. The HTML to text conversion would (among other things) take HTML entities and convert them to their unicode equivalents. This wasn't a problem _unless_ the entity happened to be an `&nbsp;` which would sometimes randomly appear in front of @mentions. This would then be converted to a unicode 'NO-BREAK SPACE' (U+00A0) which looks **exactly** the same as a space.

When this unicode character occurred before a mention, Ruby 1.8 [^1] would no longer match the `\W` portion of the regex and the user would never be notified. By the time the comment was in the database, the unicode was gone and the cause was entirely obscured.

#### Solution

As is often the case, having a reproducible fault made the solution easy. Simply normalising unicode before trying to parse the comments for mentions completely eliminated the issue. In this instance, Iconv did the trick, and the whole method ended up something like this:

~~~ruby
def parse_mentions(comment)
  normalized_comment = Iconv.conv('ASCII//TRANSLIT//IGNORE', 'UTF8', comment)
  names = normalized_comment.scan(/(?:^|\W)@(\w+)/).flatten
  User.all(:conditions => { :username => names }, :select => :email).map(&:email)
end
~~~

Phew.

[^1]: Thankfully, in modern versions of Ruby, this regex matches unicode exactly as you'd expect it to.
