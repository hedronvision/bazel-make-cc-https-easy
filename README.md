# Hedron's Bazel Rules for C++ HTTPS Requests — User Interface

**What is this project trying to do for me?**

Make it dead simple to make HTTPS requests from C++ (or C).

**Why use this project to get a C++ HTTPS client library?**

C++ is famously missing networking support out of the box. If you're reading this, we suspect you're in the same position we were: We needed to fill that hole for ourselves and weren't satisfied with the other options we saw. We wrote this code because all the other Bazel rules we've seen have serious problems wrapping curl, whether that's the misconfiguration in the TensorFlow's file causing memory errors or CMake wrappings that don't properly handle Bazel settings or cross compiling. The goal here is to create an easily reusable component that gets it right for everyone.

## Usage

> Basic Setup Time: 2m

Howdy, Bazel user 🤠. Let's get you making a HTTPS request in no time.

There's a bunch of text here but only because we're trying to spell things out and make them easy. If you have issues, let us know; we'd love your help making things even better and more complete—and we'd love to help you!

### First, do the usual WORKSPACE setup.

Copy this into your Bazel `WORKSPACE` file to add this repo as an external dependency, making sure to update to the [latest commit](https://github.com/hedronvision/bazel-make-cc-https-easy/commits/main) per the instructions below.

```Starlark
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")


# Hedron's Bazel Rules for C++ HTTPS Requests
# Makes @cpr, @curl, and @boringssl available for use
# https://github.com/hedronvision/bazel-make-cc-https-easy
# This also brings in @hedron_std_filesystem_backport to enable CPR across-platforms.
# Lets you use the std::filesystem API on Apple platforms, where it wouldn't otherwise be available. # (Deployment targets before macOS 10.15, iOS/tvOS 13.0, and watchOS 6.0)
# Just use fs:: as a drop-in replacement for std::filesystem.
# For more, see: https://github.com/hedronvision/bazel-cc-filesystem-backport
http_archive(
    name = "hedron_make_cc_https_easy",

    # Replace the commit hash in both places (below) with the latest, rather than using the stale one here.
    # Even better, set up Renovate and let it do the work for you (see "Suggestion: Updates" in the README).
    url = "https://github.com/hedronvision/bazel-make-cc-https-easy/archive/315416306204ce6bb2983b4a923815a7e89eb727.tar.gz",
    strip_prefix = "bazel-make-cc-https-easy-315416306204ce6bb2983b4a923815a7e89eb727",
    # When you first run this tool, it'll recommend a sha256 hash to put here with a message like: "DEBUG: Rule 'hedron_make_cc_https_easy' indicated that a canonical reproducible form can be obtained by modifying arguments sha256 = ..."
)
load("@hedron_make_cc_https_easy//:workspace_setup.bzl", "hedron_make_cc_https_easy")
hedron_make_cc_https_easy()
load("@hedron_make_cc_https_easy//:transitive_workspace_setup.bzl", "hedron_keep_cc_https_easy")
hedron_keep_cc_https_easy()
```

#### If you're using the Apple or Android-specific rules...

As with all platform-dependent C/C++ in Bazel, you'll need to use Bazel 7+ (and a similarly recent version of rules_apple) for per-platform configuration to work automatically out of the box. (Please file a PR to delete this section if Bazel 7 is now so old as to be standard.)

#### If you're compiling for Linux...

You'll need to make sure you have the libcurl development headers installed so you can use them from your code.

Run `sudo apt-get install libcurl4-openssl-dev` (Debian/Ubuntu) or the equivalent for your distribution. For install instructions for other distributions, see libcurl entries here: https://everything.curl.dev/get/linux. If you distribute a binary package based on your code, you should declare a dependency on libcurl4 or otherwise tell your users to `sudo apt-get libcurl4`. And, as always, if you learn things that would help future users, please file a PR or issue.

As background, we take the approach of dynamically linking against libraries the OS can reliably provide, and bundling (building + statically linking) otherwise. Linux is a special case because there's a great dependency-management system built in, so it can reliably provide more libraries than are shipped with the OS.

Aside: It strikes us that there's an opportunity here for a Bazel extension that would let Bazel better support Linux package managers. Please see [this proposal](https://github.com/bazelbuild/bazel/issues/17099#issue-1514981316) if you'd be interested in that or in helping hack on it. Let's continue the discussion on that issue, whether or not Google is interested in implementing it themselves.

### Second, make network requests from your C++ code.

Add `"@cpr"` to your `deps`, and use the wonderful libcpr interface!

Please see [their docs for details](https://docs.libcpr.org), but the interface is truly delightfully ergonomic. As an example:

```C++
#include <cpr/cpr.h>

cpr::Response r = cpr::Get(cpr::Url{"https://github.com"},
                  cpr::Parameters{{"key", "value"}});
```

For more on why we chose and recommend CPR, see [WhyCPR.md](WhyCPR.md)

Note that you'll need to enable C++17 or greater, if you haven't already. We satisfy this by putting the following in our .bazelrc:
```
build --cxxopt=-std=gnu++20
build --per_file_copt=.*\.mm\$@-std=gnu++20
```

#### If you're using C...

Add `"@curl"` to your `deps`, and use libcurl in all it's usual glory ([example](https://gist.github.com/whoshuu/2dc858b8730079602044), [docs](https://curl.se/libcurl/c/)).

...or just implement your C interface in C++ (using `extern "C"`) and use libCPR.

### There is no (required) step 3!

But we do have a suggestion...

### Suggestion: Updates

Improvements come frequently to the underlying libraries, including security patches, so we'd recommend keeping up-to-date.

We'd strongly recommend you set up [Renovate](https://github.com/renovatebot/renovate) (or similar) at some point to keep this dependency (and others) up-to-date by default. [We aren't affiliated with Renovate or anything, but we think it's awesome. It watches for new versions and sends you PRs for review or automated testing. It's free and easy to set up. It's been astoundingly useful in our codebase, and we've worked with the wonderful maintainer to make things great for Bazel use. And it's used in official Bazel repositories--and this one!]

If not now, maybe come back to this step later, or watch this repo for updates. [Or hey, maybe give us a quick star, while you're thinking about watching.] Like Abseil, we live at head; the latest commit to the main branch is the commit you want. So don't rely on release notifications; use [Renovate](https://github.com/renovatebot/renovate) or poll manually for new commits.


## Congratulations!

Way to make it through setup. Cheers to being able to easily use the power of the web from C++!

## OS Support

This should work seamlessly for macOS, Linux, Android, iOS, watchOS, and tvOS.

If you'd like it for Windows, we'd love your help. It should be a fair bit easier to add support than to do it yourself from scratch. We'll help guide. And your code will then work across platforms for free. Plus, you'll be helping everyone out. Please reach out on [the issue](https://github.com/hedronvision/bazel-make-cc-https-easy/issues/5) when you start up on it, just to make sure people don't duplicate efforts.

---

## Other Projects Likely Of Interest

If you're using Bazel for C or C++, you'll likely also want some of our other tooling, like...

1. Helping your editor understand your code and provide autocomplete: [hedronvision/bazel-compile-commands-extractor](https://github.com/hedronvision/bazel-compile-commands-extractor)
2. A way to use std::filesystem across platforms--which this repo already uses under the hood: [hedronvision/bazel-cc-filesystem-backport](https://github.com/hedronvision/bazel-cc-filesystem-backport)
