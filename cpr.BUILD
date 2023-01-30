cc_library(
    name = "cpr",
    hdrs = glob(["include/cpr/**/*.h"]),
    includes = ["include"],
    visibility = ["//visibility:public"],

    srcs = glob(["cpr/**/*.cpp"]),
    deps = ["@curl"] + select({
        "//conditions:default": [],
        # Merge these together if/when https://github.com/bazelbuild/platforms/issues/37 is resolved.
        "@platforms//os:macos" : ["@boost//:filesystem"],
        "@platforms//os:ios" : ["@boost//:filesystem"],
        "@platforms//os:tvos" : ["@boost//:filesystem"],
        "@platforms//os:watchos" : ["@boost//:filesystem"],
    }),
    # On Apple platforms, use boost::filesystem to fulfil CPR's need for std::filesystem.
    # std::filesystem::path was introduced in macOS 10.15 and iOS 13.0.  At least at the time of writing, most all Apple users will have a deployment target older than that and therefore need to backfill the functionality.
    # Ideally, we'd have a select to use boost only if there the deployment target aka minimum_os_version is less than the minima above, but it doesn't seem like there's currently a good way to do that https://github.com/bazelbuild/rules_apple/issues/1817
    # Note that CPR_USE_BOOST_FILESYSTEM is exported out of the headers, so it can't be in local_defines
    defines = select({
        "//conditions:default": [],
        # Merge these together if/when https://github.com/bazelbuild/platforms/issues/37 is resolved.
        "@platforms//os:macos" : ["CPR_USE_BOOST_FILESYSTEM"],
        "@platforms//os:ios" : ["CPR_USE_BOOST_FILESYSTEM"],
        "@platforms//os:tvos" : ["CPR_USE_BOOST_FILESYSTEM"],
        "@platforms//os:watchos" : ["CPR_USE_BOOST_FILESYSTEM"],
    }),
)
