---
title: Handling Token Generation Collisions In ActiveRecord
date: 2014-12-10 12:28 NZDT
tags:
summary: Use <code>rescue ActiveRecord::RecordNotUnique</code> with <code>retry</code> to handle collisions when applicable.
featured: true
---

In my [previous post](/blog/2014/12/07/generating-unique-random-tokens/) we looked at generating unique, random tokens to securely identify records with. While UUIDs solve this problem well, they are unweidly. In some cases, it's handy to have an identifier that's shorter and hence easier to read out. Naturally, the problem with shorter tokens is collisions. As we reduce our available pool of tokens, the chance that a randomly selected one will be unique goes down quickly.

Whether this trade off makes sense is entirely dependent on the application. Let's say we're identifying an order in a particular month. If we need a short, readable token that's unique _only among this month's orders_, we can probably use a short token. This is because the number of orders in a given month is not going to grow linearly — we can expect it to hover around a certain percentage of the total available tokens.

So let's say we need to keep track of a hundred thousand constantly changing items with a six digit, hexadecimal token. The chance of a random token colliding with an existing one is going to be roughly 0.3%.[^1] While this isn't going to happen frequently, we definitely need to handle the case gracefully.

### A First Attempt

The trick is to set the token in a separate SQL query. ActiveRecord's `after_create` is a good fit for this kind of task. In the event of a collision, ActiveRecord will handily raise an `ActiveRecord::RecordNotUnique` which we can rescue and retry. If we were setting the token in a `before_create`, we wouldn't be able to simply retry the save.

~~~ruby
class Order < ActiveRecord::Base

  after_create :generate_token

private

  def generate_token
    update_column :token, SecureRandom.hex(3)
  rescue ActiveRecord::RecordNotUnique
    retry
  end

end
~~~

    > Order.create!
      DEBUG -- SQL (0.1ms)  begin transaction
      DEBUG -- SQL (0.1ms)  INSERT INTO "orders" DEFAULT VALUES
      DEBUG -- SQL (2.6ms)  UPDATE "orders" SET "token" = '99a8b4' WHERE "orders"."id" = 9
      ERROR -- SQLite3::ConstraintException: UNIQUE constraint failed: orders.token: UPDATE "orders" SET "token" = '99a8b4' WHERE "orders"."id" = 9
      DEBUG -- SQL (0.1ms)  UPDATE "orders" SET "token" = 'd776b10' WHERE "orders"."id" = 9
      DEBUG -- SQL (0.1ms)  commit transaction
    => #<Order id: 9, token: "d776b10">

Not bad for a first try.

  * `SecureRandom.hex(3)` produces something like `"c41a84"` which is what our tokens should look like.
  * `update_column` is the fastest way to update the attribute because it goes straight to the database. It's been around since Rails 3.1.
  * We're only rescuing in the event of a token collision (`ActiveRecord::RecordNotUnique`), so it's pretty much safe to just retry. But…

### Limited Retries

While this works, it's a bad idea to blindly retry without some kind of limit on the number of retries. Even if the system is designed so that the chances of multiple consecutive collisions are tiny, you never know when the system will start operating outside of its original design.

Let's introduce a variable to monitor how many retries we've made.

~~~ruby
def generate_token
  update_column :token, SecureRandom.hex(3)
rescue ActiveRecord::RecordNotUnique => e
  @token_attempts ||= 0
  @token_attempts += 1
  retry if @token_attempts < 3
  raise e, "Retries exhausted"
end
~~~

    DEBUG -- SQL (0.0ms)  begin transaction
    DEBUG -- SQL (0.0ms)  INSERT INTO "orders" DEFAULT VALUES
    DEBUG -- SQL (0.1ms)  UPDATE "orders" SET "token" = 'c3' WHERE "orders"."id" = 32
    ERROR -- SQLite3::ConstraintException: UNIQUE constraint failed: orders.token: UPDATE "orders" SET "token" = 'c3' WHERE "orders"."id" = 32
    DEBUG -- SQL (0.1ms)  UPDATE "orders" SET "token" = '50' WHERE "orders"."id" = 32
    ERROR -- SQLite3::ConstraintException: UNIQUE constraint failed: orders.token: UPDATE "orders" SET "token" = '50' WHERE "orders"."id" = 32
    DEBUG -- SQL (0.2ms)  UPDATE "orders" SET "token" = 'cb' WHERE "orders"."id" = 32
    ERROR -- SQLite3::ConstraintException: UNIQUE constraint failed: orders.token: UPDATE "orders" SET "token" = 'cb' WHERE "orders"."id" = 32
    DEBUG -- SQL (0.1ms)  rollback transaction
    ActiveRecord::RecordNotUnique: Retries exhausted

That's functional, but it could be improved. Here's a slightly nicer version.

~~~ruby
MAX_RETRIES = 3
def generate_token
  update_column :token, SecureRandom.hex(3)
rescue ActiveRecord::RecordNotUnique => e
  @token_attempts = @token_attempts.to_i + 1
  retry if @token_attempts < MAX_RETRIES
  raise e, "Retries exhausted"
end
~~~

A few notes:

  * `@token_attempts.to_i` will evaluate to 0 if `@token_attempts` hasn't been previously set. This is because unassigned instance variables are `nil` and `nil.to_i => 0`
  * It's also a good habit to name our fixed numbers via constants. In the original version, the number the 3 was a bit of a magic number. `MAX_RETRIES` communicates exactly what this number represents and makes it clear where to change it.
  * Our `raise` encapsulates the original exception with a more helpful message. `e.cause` is set to the rescued exception:

        [1] pry(#<Order>)> e
        => #<ActiveRecord::RecordNotUnique: Retries exhausted>
        [2] pry(#<Order>)> e.cause
        => #<ActiveRecord::RecordNotUnique: SQLite3::ConstraintException: UNIQUE constraint failed: orders.token: UPDATE "orders" SET "token" = '58' WHERE "orders"."id" = 68>
        [3] pry(#<Order>)> e.cause.cause
        => #<SQLite3::ConstraintException: UNIQUE constraint failed: orders.token>
        [4] pry(#<Order>)>

There we have it. If the use-case is right, this is a safe and simple pattern for generating tokens on an ActiveRecord object where there is a reasonable possibility of collisions.


[^1]: Once again using the square approximation of the [Birthday Problem][wiki-bday]. [WolframAlpha][wa-bday].

[wiki-bday]: http://en.wikipedia.org/wiki/Birthday_problem
[wa-bday]: http://www.wolframalpha.com/input/?i=100000+%2F+%282+*+%2816%5E6%29%29
