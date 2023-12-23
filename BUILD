# Stardoc users only: Depend on "@hedron_make_cc_https_easy//:bzl_srcs_for_stardoc" as needed.
# Why? Stardoc requires all loaded files to be listed as deps; without this we'd prevent users from running Stardoc on their code when they load from this tool in, e.g., their own workspace.bzl.
filegroup(
    name = "bzl_srcs_for_stardoc",
    visibility = ["//visibility:public"],
    srcs = glob(["**/*.bzl"]) + [
        "@bazel_tools//:bzl_srcs", "@hedron_std_filesystem_backport//:bzl_srcs_for_stardoc"
    ],
)
