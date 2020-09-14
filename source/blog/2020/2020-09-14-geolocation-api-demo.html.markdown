---

title: Browser Geolocation API Demo
date: 2020-09-14 20:37 NZST
tags:

---

I was recently investigating the feasibility and capability of browser-based Geolocation, especially on mobile devices as an alternative to native mobile development. The Geolocation API is a [W3C standard](https://www.w3.org/TR/geolocation-API/) that defines a high-level JavaScript API for websites to query the physical position of a device. According to the ever-useful [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/Geolocation_API), the APIs are well-supported.

There are two ways to retrieve location:

- Request the device's current position (`getCurrentPosition`)
- Track the device's position over time (`watchPosition`)

Both methods can be configured with a timeout, a maximum age (for returning cached data), and an accuracy hint. Returned positions have a timestamp and coordinates, which includes latitude/longitude with 95% confidence range, altitude with 95% confidence range if supported, and speed and heading if supported. Any request for location data will prompt the user for permission.

Testing across a range of desktop and mobile devices, the behaviour varied somewhat. In particular, the interactions of the location cache with the `timeout` and `maximumAge` options was hard to understand, and `maximumAge` wasn't always strictly followed.

I've put together [single-page HTML demo](https://daniel.fone.net.nz/browser-geolocation-demo/), which is [<200 LOC](https://github.com/danielfone/browser-geolocation-demo/). I've included an iframe version below.

### Notes & Questions

- In almost all of my testing, the actual location was within the 95% area returned by `getCurrentPosition`, but I think this depends on WiFi SSID mapping. The spec doesn't care how the device determines it's position beyond the `enableHighAccuracy` option. For example, [Apple](https://support.apple.com/en-us/HT207092) uses "GPS and Bluetooth (where they're available), along with crowd-sourced Wi-Fi hotspots and cellular towers to determine the approximate location of your device."
- The `enableHighAccuracy` option is indicative only, in mobile Safari this can be disabled.
- How do devices determine 95% confidence (`accuracy` and `altitudeAccuracy`) is this consistent across devices?
- According to the spec, the successCallback for `watchPosition` "is only invoked when a new position is obtained and this position differs significantly from the previously reported position. The definition of what constitutes a significant difference is left to the implementation." In my testing, this was called every few seconds on a stationary device.

### Further Reading

- Geolocation API Specification — 2nd Edition 8 November 2016 at time of writing. <https://www.w3.org/TR/geolocation-API/>
- Current draft of above — <https://w3c.github.io/geolocation-api/>
- Geolocation API on the MDN web docs — <https://developer.mozilla.org/en-US/docs/Web/API/Geolocation_API>


<iframe src="https://daniel.fone.net.nz/browser-geolocation-demo/" width="100%" height=700></iframe>
