---
title: Upload Progress in Ruby with curb
date: 2014-05-22 00:17 NZST
---

A friend was telling me how difficult it was to get the progress of a file upload in ruby using the standard Net::HTTP library or any of the popular HTTP wrapper gems. He wanted to get simple details similar to curl.

    $ curl --progress-bar --form --upload=@1mb.txt http://requestb.in/ztmawczt > /dev/null
    ######################################################                    75.5%

Fortunately, there is the [curb][curb github] gem which provides ruby bindings around [libcurl][curl]. Using this gem, we can use the `on_progress` method to do something like this:

~~~ ruby
curl.on_progress do |download_size, downloaded, upload_size, uploaded|
  print "\r#{uploaded}/#{upload_size}"
  true
end
~~~

The [documentation][on_progress docs] is a little sparse, and there are two major caveats to watch out for:

  1. You MUST return true from this block if you want the upload to continue
  2. Any exceptions that occur in the block will be swallowed and reraised as an Curl::Err::AbortedByCallbackError. This makes development a little bit painful, but you use your own `begin ... rescue ... end` inside the block to help debug if needed.

I've published a full [working example on github][repo].


[curb github]: https://github.com/taf2/curb
[curl]: http://curl.haxx.se/libcurl/
[on_progress docs]: http://rubydoc.info/gems/curb/Curl/Easy#on_progress-instance_method
[repo]: https://github.com/danielfone/curb-upload-progress