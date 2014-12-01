---
title: Fixing Connection Errors After Upgrading Postgres
date: 2014-12-01 12:43 NZDT
tags:
---

I recently upgraded postgres from 9.2 to 9.3 using `brew upgrade postgres`. The process was smooth and `pg_upgrade` is a very handy tool.

However, trouble struck once I tried to run any specs that needed to connect to postgres. Even though postgres was _definitely_ running, suddenly I was getting:

	could not connect to server: No such file or directory (PG::ConnectionBad)
	Is the server running locally and accepting
	connections on Unix domain socket "/var/pgsql_socket/.s.PGSQL.5432"?

The fix is simple, if a little suprising. When you install the pg gem, it detects which version of postgres is installed and sets the domain socket path appropriately. The solution is as simple as reinstalling the gem.

	$ gem uninstall pg
	$ cd my-rails-app/
	$ bundle install

Hat tip to [Tammer Selah](http://tammersaleh.com/posts/installing-postgresql-for-rails-3-1-on-lion/) and this [Stack Overflow comment](http://stackoverflow.com/questions/6770649/repairing-postgresql-after-upgrading-to-osx-10-7-lion#comment8687127_6772559).
