---
title: Generating Unique, Random Tokens
date: 2014-12-07 21:10 NZDT
tags:
summary: If you need a random, unique token, use <code>SecureRandom.uuid</code> (or <code>SecureRandom.urlsafe_base64</code> for something shorter).
featured: true
---

Generating some kind of token for records is a common problem in web development. Fortunately, [UUIDs][rfc4122] are designed precisely for generating unique, random IDs or tokens. For most applications, you'll probably want a fully random [v4 UUID][rfc4122-4.4], which you can easily generate with [SecureRandom][rdoc-securerandom] in Ruby's standard library.

~~~ruby
require 'securerandom'
SecureRandom.uuid # => "16fc1d86-7d6e-4011-9b75-d6cd9501fe1e"
~~~

This is a widely implemented[^1] and instantly recognisable format that is vanishingly unlikely to have a collision.[^2]

Now, as an engineer, "unlikely" makes me nervous. I confess I don't have an intuitive grasp of the statistics involved, and to me the two options are "can't happen" or "will happen". Although my rational brain knows better, I still instinctively put "vanishingly unlikely" in the "will happen" category. Sure, a collision might be unlikely if we're only dealing with a small number of records, but what if we're dealing with BigData&trade;?

Well let me put it in perspective for you: you'd have to generate 112 terabytes of UUIDs before you'd even have a _one in a billion_ chance of a collision.[^3] So unless you've got a 112 terabyte database to fill with UUIDs, you're going to have a lot of other problems first.

How would this look in practice then? If I wanted a token for an ActiveRecord object, it'd look something like:

~~~ruby
class Order < ActiveRecord::Base
  before_create :generate_token, unless: :token?
private
  def generate_token
    self.token = SecureRandom.uuid
  end
end
~~~

Now you probably want an index on the `token` column, so you might as well make it a unique index. However, a collision is so unlikely to occur there's really no point handling the RecordNotUnique exception that would be raised in that event.

### Other Formats

The downside of UUID is that it's rather unwieldy. It uses 36 characters to render 16 bytes of entroy.[^4] Naturally, there are plenty of other ways to render 16 bytes of entropy and still have the same statistical properties outlined above.

SecureRandom offers a few other helpful methods for generating token-like strings. My two preferred choices are `hex` and `urlsafe_base64`. Here they all are for comparison.

~~~ruby
SecureRandom.uuid           # => "8efb5d40-32d8-43c8-a92d-d5f048c8729c"
SecureRandom.hex            # => "bad6650fc0142451e624bd89b6aa3acf"
SecureRandom.urlsafe_base64 # => "vp6xjBgi48Jgag6dqH8niw"
~~~

### Short, Memorable, Readable Tokens

What about if the token needs to be really short? I once worked on a project where certain customer facing records had an easy to read reference made of 6 hexadecimal digits. In that case, we only want 3 bytes, and the `hex` method conveniently allows us to specify how many bytes we'll need.

~~~ruby
SecureRandom.hex(3) # => "bff1a1"
~~~

Of course, now we're only dealing with 16,777,216 possible tokens and collisions are inevitable. In a future post, we'll take a look at effective ways to deal with token collisions for ActiveRecord objects.



[^1]: You can even generate one from the command line of most *nix systems with `uuidgen`.

[^2]: This — and the discussion after it — is assuming that the PRNG has sufficient entropy. SecureRandom's entropy source is system-dependent.

[^3]: Given that a UUID is 36 bytes, we want to know how many UUIDs (of which there are 2<sup>112</sup> total) will give us a one in a billion (2<sup>-30</sup>) chance of collision. We can plug the square approximation for the [Birthday Problem][wiki-bday] into WolframAlpha to get [the result][wa-bday].

[^4]: It's actually 122 bits since 6 of 128 bits are fixed as per the [RFC][rfc4122-4.4].

[rfc4122]: http://tools.ietf.org/html/rfc4122
[rfc4122-4.4]: http://tools.ietf.org/html/rfc4122#section-4.4
[rdoc-securerandom]: http://www.ruby-doc.org/stdlib-2.1.4/libdoc/securerandom/rdoc/SecureRandom.html#method-c-uuid
[wiki-bday]: http://en.wikipedia.org/wiki/Birthday_problem
[wa-bday]: http://www.wolframalpha.com/input/?i=sqrt%282+*+2%5E112+*+2%5E-30%29+*+36+bytes
