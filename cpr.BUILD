cc_library(
    name = "cpr",
    hdrs = glob(["include/cpr/**/*.h"]),
    includes = ["include"],
    visibility = ["//visibility:public"],

    srcs = glob(["cpr/**/*.cpp"]),
    # On Apple platforms, use boost::filesystem to fulfill CPR's need for std::filesystem.
    # std::filesystem is available in macOS 10.15, iOS/tvOS 13.0, and watchOS 6.0.
    # At least at the time of writing, most Apple users will have a deployment target older than that and therefore need to backport std::filesystem.
    # Ideally, we'd have a select to use boost only if there the deployment target aka minimum_os_version is less than the minima above, but it doesn't seem like there's currently a good way to do that https://github.com/bazelbuild/rules_apple/issues/1817
    # As it is, the dead code should just get stripped on older versions.
    # Note: We #define CPR_USE_BOOST_FILESYSTEM via cpr.patch.
    deps = ["@curl"] + select({
        "//conditions:default": [],
        # Merge these together if/when https://github.com/bazelbuild/platforms/issues/37 is resolved.
        "@platforms//os:macos" : ["@boost//:filesystem"],
        "@platforms//os:ios" : ["@boost//:filesystem"],
        "@platforms//os:tvos" : ["@boost//:filesystem"],
        "@platforms//os:watchos" : ["@boost//:filesystem"],
    }),
)
