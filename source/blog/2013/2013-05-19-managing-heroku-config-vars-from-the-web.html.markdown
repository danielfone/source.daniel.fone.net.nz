---
title: "Managing Heroku Config Vars from the Web"
updated: 2014-11-28
---

<div class="notice">
  **Deprecation Notice**

  This functionality has now been implemented (in its rightful place) in the Heroku dashboard. The gem no longer maintained.
  See <https://devcenter.heroku.com/changelog-items/455>
</div>

### The Problem

[Heroku](http://heroku.com) don't provide a way to manage an application's [configuration variables](https://devcenter.heroku.com/articles/config-vars) through a web interface. Although an application's ENV shouldn't really be used for domain-specific configuration or settings that change frequently, sometimes it's a hassle to drop into a console when doing something as trivial as updating SMTP settings or cycling OAuth tokens.

What I really want to achieve is turning this:

    $ heroku config:set GITHUB_USERNAME=joesmith
    Adding config vars and restarting myapp... done, v12
    GITHUB_USERNAME: joesmith

into this:

![heroku-config-update](2013-05-19-managing-heroku-config-vars-from-the-web/heroku-config-update.png)

### The Solution

The [heroku_config_vars](https://github.com/danielfone/heroku_config_vars) Rails engine provides a web interface for managing an application's Heroku configuration. This makes it possible for administrators without CLI access to manage their Heroku configuration.

![screenshot](2013-05-19-managing-heroku-config-vars-from-the-web/screenshot-1.png)
![screenshot](2013-05-19-managing-heroku-config-vars-from-the-web/screenshot-2.png)
![screenshot](2013-05-19-managing-heroku-config-vars-from-the-web/screenshot-3.png)

Installation and usage instructions can be found on [github](https://github.com/danielfone/heroku_config_vars). Feedback, questions, bugs, PRs are welcome!

Enjoy.
