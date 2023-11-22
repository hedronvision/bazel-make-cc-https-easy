# Do not change the filename; it is part of the user interface.


load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")


def hedron_make_cc_https_easy():
    """Setup a WORKSPACE so you can easily make https requests from C++.

    Ensures you have CPR, whose interface you want to use...
    ... and its dependencies: curl, boringssl, and hedron_std_filesystem_backport.
    """

    # Unified setup for users' WORKSPACES and this workspace when used standalone.
    # See invocations in:
    #     README.md (for users)
    #     WORKSPACE (for working on this repo standalone)

    maybe(
        http_archive,
        name = "cpr",
        patches = ["@hedron_make_cc_https_easy//:cpr.patch"], # Switches to hedron_std_filesystem_backport (see https://github.com/libcpr/cpr/pull/929#issuecomment-1653008950) and removes version-define header from unbrella header <cpr/cpr.h>, since it's generated by cmake and we don't need it. If needed, could hack it in like https://github.com/curoky/tame/blob/c8926a2cd569848137ebb971a95057cb117055c3/recipes/c/cpr/default/BUILD
        build_file = "@hedron_make_cc_https_easy//:cpr.BUILD",
        url = "https://github.com/libcpr/cpr/archive/1.10.5.tar.gz",
        sha256 = "c8590568996cea918d7cf7ec6845d954b9b95ab2c4980b365f582a665dea08d8",
        strip_prefix = "cpr-1.10.5",
    )

    # Like many other libraries, CPR (temporarily) needs to backfill std::filesystem on Apple platforms.
    # This is public API; we'll eliminate the shim only when it's obsolete.
    maybe(
        http_archive,
        name = "hedron_std_filesystem_backport",
        url = "https://github.com/hedronvision/bazel-cc-filesystem-backport/archive/a770d40fde21e08b8791dce645a0011b417735c6.tar.gz",
        sha256 = "9d865af7e935f5c21af7c45088a791ac44bf8b1841ca1c4c50814f674e6fee7c",
        strip_prefix = "bazel-cc-filesystem-backport-a770d40fde21e08b8791dce645a0011b417735c6",
    )
    # hedron_backport_std_filesystem is called in transitive_workspace_setup

    # CPR wraps libcurl
    # Note: libcurl updates are auto-PRd but not auto-merged, because the defines required to build it change frequently enough that you need to manually keep curl.BUILD in sync with https://github.com/curl/curl/commits/master/CMakeLists.txt. @cpsauer is responsible.
    maybe(
        http_archive,
        name = "curl",
        build_file = "@hedron_make_cc_https_easy//:curl.BUILD",
        url = "https://github.com/curl/curl/archive/curl-8_4_0.tar.gz",
        sha256 = "5f7097e27b00e54d5522d80c0d44899084a226e9372a0d5d799ad3125dd4b8c0",
        strip_prefix = "curl-curl-8_4_0",
    )

    # libcurl needs to bundle an SSL library on Android. We're using boringssl because it has easy Bazel support. Despite it's Google-only orientation, it's also used in, e.g., Envoy. But if LibreSSL had Bazel wrappings, we'd probably consider it.
    # We're pointing our own mirror of google/boringssl:master-with-bazel to get Renovate auto-update. Otherwise, Renovate will keep moving us back to master, which doesn't support Bazel.
        # https://bugs.chromium.org/p/boringssl/issues/detail?id=542 tracks having bazel on the boringssl master branch.
        # https://github.com/renovatebot/renovate/issues/18492 tracks Renovate support for non-default branches.
    # OPTIMNOTE: Boringssl's BUILD files should really be using assembly on Windows, if we add support https://bugs.chromium.org/p/boringssl/issues/detail?id=531
    maybe(
        http_archive,
        name = "boringssl",
        url = "https://github.com/hedronvision/boringssl/archive/5a9c1f3b9f70f6a2410dbdb3cef883b7b82cadf4.tar.gz",
        sha256 = "45f04f56193c1539e2bcd66bb07a14bca144a1c568454f7381a020bbccbf24a4",
        strip_prefix = "boringssl-5a9c1f3b9f70f6a2410dbdb3cef883b7b82cadf4",
    )
