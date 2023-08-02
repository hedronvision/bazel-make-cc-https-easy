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
        url = "https://github.com/libcpr/cpr/archive/1.10.4.tar.gz",
        sha256 = "88462d059cd3df22c4d39ae04483ed50dfd2c808b3effddb65ac3b9aa60b542d",
        strip_prefix = "cpr-1.10.4",
    )

    # Like many other libraries, CPR (temporarily) needs to backfill std::filesystem on Apple platforms.
    # This is public API; we'll eliminate the shim only when it's obsolete.
    maybe(
        http_archive,
        name = "hedron_std_filesystem_backport",
        url = "https://github.com/hedronvision/bazel-cc-filesystem-backport/archive/c2dcd1368200034d18acef44c8dc7127d9aaaaa3.tar.gz",
        sha256 = "3d346b05697d9eeb8f3e94839a14dc14aa5358d3cbdfd90e186c56f6a4807eb1",
        strip_prefix = "bazel-cc-filesystem-backport-c2dcd1368200034d18acef44c8dc7127d9aaaaa3",
    )
    # hedron_backport_std_filesystem is called in transitive_workspace_setup

    # CPR wraps libcurl
    # Note: libcurl updates are auto-PRd but not auto-merged, because the defines required to build it change frequently enough that you need to manually keep curl.BUILD in sync with https://github.com/curl/curl/commits/master/CMakeLists.txt. @cpsauer is responsible.
    maybe(
        http_archive,
        name = "curl",
        build_file = "@hedron_make_cc_https_easy//:curl.BUILD",
        url = "https://github.com/curl/curl/archive/curl-8_2_1.tar.gz",
        sha256 = "230d61a4b1eb3346930f2d601cc8fe5237957163e16befbe15e0ef40c56767a2",
        strip_prefix = "curl-curl-8_2_1",
    )

    # libcurl needs to bundle an SSL library on Android. We're using boringssl because it has easy Bazel support. Despite it's Google-only orientation, it's also used in, e.g., Envoy. But if LibreSSL had Bazel wrappings, we'd probably consider it.
    # We're pointing our own mirror of google/boringssl:master-with-bazel to get Renovate auto-update. Otherwise, Renovate will keep moving us back to master, which doesn't support Bazel.
        # https://bugs.chromium.org/p/boringssl/issues/detail?id=542 tracks having bazel on the boringssl master branch.
        # https://github.com/renovatebot/renovate/issues/18492 tracks Renovate support for non-default branches.
    # OPTIMNOTE: Boringssl's BUILD files should really be using assembly on Windows, if we add support https://bugs.chromium.org/p/boringssl/issues/detail?id=531
    maybe(
        http_archive,
        name = "boringssl",
        url = "https://github.com/hedronvision/boringssl/archive/bf8d61d40d12d1b12a89c298b159d0734e059604.tar.gz",
        sha256 = "5174c19ec2a5d400e5b790203516e256c56b90074233ddeba46a331853393066",
        strip_prefix = "boringssl-bf8d61d40d12d1b12a89c298b159d0734e059604",
    )
