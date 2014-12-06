---
title: Fixing Connection Errors After Upgrading Postgres
date: 2014-12-01 12:43 NZDT
tags:
summary: You may need to reinstall the pg gem after upgrading postgres.
---

I recently upgraded Postgres from 9.2 to 9.3 using `brew upgrade postgres`. The process was smooth and `pg_upgrade` is a very handy tool.

However, trouble struck once I tried to run any specs that needed to connect to Postgres. Even though Postgres was _definitely_ running, suddenly I was getting:

	could not connect to server: No such file or directory (PG::ConnectionBad)
	Is the server running locally and accepting
	connections on Unix domain socket "/var/pgsql_socket/.s.PGSQL.5432"?

The problem was that the new version of Postgres listens on /tmp/.s.PGSQL.5432 instead. I could've messed around with the config and made Postgres use the domain socket it was previously, or told Rails explictly how to connect, but both of those approaches seemed like work I shouldn't have to do. At no point had I told Rails to connect to postgres on that path, Rails had assumed it, and now its assumptions were wrong.

The fix is simple, if a little suprising. When you install the 'pg' gem, it detects which version of Postgres is installed and sets the domain socket path appropriately. The solution is as simple as reinstalling the gem.

	$ gem uninstall pg
	$ cd my-rails-app/
	$ bundle install

Hat tip to [Tammer Selah](http://tammersaleh.com/posts/installing-postgresql-for-rails-3-1-on-lion/) and this [Stack Overflow comment](http://stackoverflow.com/questions/6770649/repairing-postgresql-after-upgrading-to-osx-10-7-lion#comment8687127_6772559).
