---
title: Timing-Safe bcrypt Authentication in PostgreSQL
date: 2020-09-09 18:53 NZST
summary: To avoid disclosing <abbr title="Personally Identifying Information">PII</abbr> and to prevent user enumeration during authentication, ensure you always perform a hash comparison, even if no user record is found.
featured: true
---

Many applications aim to prevent [user enumeration](https://blog.rapid7.com/2017/06/15/about-user-enumeration/) during authentication, particularly if users authenticate themselves with some PII like an email address. Well-designed login forms usually don’t disclose whether the username or password is incorrect, both because the response can be misleading,[^1] and because it will disclose the presence of accounts in the database, facilitating spear-phishing, credential stuffing, and other attacks.

However, while the response body may not disclose this, often the response time still betrays whether a matching user record exists in the database. Because effective password checking like bcrypt is deliberately so slow, the response is much quicker if there is no digest to compare the submitted plain-text against. This oversight can undermine the ambiguity of the response body and expose users to the attacks mentioned above.

Let's look at an example authentication query in PostgreSQL.[^2] First we'll add a user record.

~~~sql
insert into users (email, password_digest)
values ('daniel@example.com', crypt('my-password', gen_salt('bf')));

select * from users;

--  id |       email        |                       password_digest
-- ----+--------------------+--------------------------------------------------------------
--   1 | daniel@example.com | $2a$06$xMGQrmx5DrVvfiBqdVhZLeQJOWx95H/B..79VElnBAh/xa5bKGkwG
~~~

The [crypt function](https://www.postgresql.org/docs/12/pgcrypto.html#id-1.11.7.34.6.7) is provided by the pgcrypto module. It takes a plain-text password and a salt, and returns a hash. Since crypt-style hashes include their salt (along with the algorthim details), the same function can be used to generate new hashes or verify existing ones.[^3] In this case, we use the gen_salt function to generate a bcrypt salt with the default number of iterations (`bf` is for blowfish which is synonymous with bcrypt here). Note that this only uses the first 72 bytes of the plain-text password, a more secure approach is to digest the entire plain-text first.[^4]

Now let's look at a naive authentication query.

~~~sql
-- Correct username and password
select *
from users
where email = 'daniel@example.com'
  and password_digest = crypt('my-password', password_digest);
--  id |       email        |                       password_digest
-- ----+--------------------+--------------------------------------------------------------
--   1 | daniel@example.com | $2a$06$xMGQrmx5DrVvfiBqdVhZLeQJOWx95H/B..79VElnBAh/xa5bKGkwG
--
-- Time: 6.692 ms

-- Incorrect password
select *
from users
where email = 'daniel@example.com'
  and password_digest = crypt('password', password_digest);
--  id | email | password_digest
-- ----+-------+-----------------
--
-- Time: 6.513 ms

-- Incorrect email
select *
from users
where email = 'noone@example.com'
  and password_digest = crypt('my-password', password_digest);
--  id | email | password_digest
-- ----+-------+-----------------
--
-- Time: 0.432 ms
~~~
As we can see, checking the password against an existing hash takes several milliseconds, whereas checking the index for an email is comparatively instantaneous. This difference is increased depending on the size of the table and the number of bcrypt iterations (Rails defaults to 10). In an application I recently worked on, the difference was measurable even after the jitter introduced by the application code and network latency.

Whether you’re comparing the digests in the database like this, or taking the more common approach of comparing the hashes in your application code, <strong>the essential solution is to compare a bcrypt hash even if no real user is found<strong>.

For example:

~~~sql
with

-- select either the id and password digest matching the email, or a dummy row
target_user as (
  select id, password_digest
  from (
    select id, password_digest from users where email = :password
    union all
    select null, gen_salt('bf') -- a random salt
  ) users
  limit 1 -- only return the first row, either the real id+digest or the "null" one
),

-- perform bcrypt matching on the guaranteed single row from target_user
valid_user as (
  select id from target_user where password_digest = crypt(:password, password_digest)
)

-- select the row from the users table matching the authenticated id
select * from users natural join valid_user limit 1
~~~

Clearly, this query is a lot more complex than our naive approach, however with judicious use of comments and well-factored subqueries, I think the intention remains relatively clear. Perhaps there are simpler ways to factor this query and achieve the same result — I'd love to see some alternatives! No matter how it's achieved though, the only way to ensure that the response is truly opaque is to do the same work in all cases. One way or another we need to hash the supplied plain-text.

[^1]: For example, the user may be entering their password, but have the username wrong. See [this discussion](https://ux.stackexchange.com/questions/13516/how-to-tell-the-user-his-login-credentials-are-incorrect/13523#13523) on the UX StackExchange.

[^2]: In my experience, most applications perform this authentication check in application code rather than at the database level. The argument for this is that it’s better to discard plain-text password as early in the process as possible. This seems reasonable to me. Perhaps even more reasonable is digesting the plain-text in the browser before it’s transmitted to the app server for authentication. There may be other drawbacks for this though - comment is welcome!

[^3]: Technically, this hash format is the [Modular Crypt Format](https://passlib.readthedocs.io/en/stable/modular_crypt_format.html) or [PHC string format](https://github.com/P-H-C/phc-string-format/blob/master/phc-sf-spec.md)

[^4]: For example, using `digest(:password, 'sha1')::text` would ensure we include all the entropy from the user-supplied password into the hash. The same digest would need to be applied before verifying a password for authentication.
