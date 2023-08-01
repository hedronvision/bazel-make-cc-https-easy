cc_library(
    name = "cpr",
    hdrs = glob(["include/cpr/**/*.h"]),
    includes = ["include"],
    visibility = ["//visibility:public"],

    srcs = glob(["cpr/**/*.cpp"]),
    # On Apple platforms, use https://github.com/gulrak/filesystem to fulfill CPR's need for std::filesystem.
    # std::filesystem is unavailable before macOS 10.15, iOS/tvOS 13.0, and watchOS 6.0.
    # At least at the time of writing, most Apple users will have a deployment target older than that and therefore need to backport std::filesystem.
    # Note: We splice in the code via cpr.patch.
    deps = ["@curl", "@hedron_std_filesystem_backport"],
)
