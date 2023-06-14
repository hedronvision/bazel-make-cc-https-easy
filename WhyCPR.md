# Why do we recommend CPR as a C++ HTTPS request (client) library?

CPR strikes a great balance. Its interface makes delightfully great use of modern C++ constructs—like what networking support would be like were it built into C++.

It's also build on top of the battle-tested robustness of libcurl, meaning that you get a bombproof implementation as well as that great interface.

Here were the other options we seriously considered, ranked from closest to furthest from being used:
 Other options seriously considered, ranked best to worst:
- cpp-httplib https://github.com/yhirose/cpp-httplib
  - A very good looking header-only library. Would have been a good alternative; CPR just seemed slightly better, and it seemed safer to piggyback on the battle-tested solidity of libcurl.
- POCO project https://github.com/pocoproject/poco
  - Looked fine, but like it might be kinda heavy Java/C#/Enterprise clunky, and less focused on HTTPS usability. It would have been much more work to wrap!
- Reusing the internals of Microsoft's (internal but open source C++ telemetry code https://github.com/microsoft/cpp_client_telemetry/tree/main/lib/http
  - Looks okay-ish, but a bit confusing, not documented, and not meant for external consumption.
- Cronet, the networking library behind Chromium
  - Probably great, but there are just no good external docs on how to use it, and googlesource is such a pain to browse compared to GitHub.
  - If we ever wanted to pick this back up, GRPC looks to have a cronet transport backend that we might be able to leverage https://github.com/grpc/grpc/tree/master/src/core/ext/transport/cronet
    - We can't just always piggyback on GRPC more generally, because sometimes you need to use HTTP for interoperability. For example, even for code you write, serverless backends don't support being GRPC servers
- https://github.com/microsoft/cpprestsdk aka Casablanca
  - Sadly retired by Microsoft and no longer recommended for use in new projects. See the top of their Readme. Would otherwise likely have been our choice.
- https://github.com/spotify/NFHTTP
  - Killed because I happened to stumble upon a *very* problematic security choice.
    - Evaporates trust, because who knows what else is in there...
      - See disabling of SSL certificate verification on Android/Apple here https://github.com/spotify/NFHTTP/pull/26
  - Key pros: Advertised a nice caching layer and called into native backends on iOS for efficiency.
    - Note, iOS (in general) doesn't cache between apps, presumably for privacy. The benefit is just that Apple's code is rumored to make better use of the antennas than you can do via public APIs. This is alluded to in NFHTTP's README.
  - Key cons: (Other than the security issue.) Mostly abandoned and out of use by Spotify. https://github.com/spotify/NFHTTP/issues/45
