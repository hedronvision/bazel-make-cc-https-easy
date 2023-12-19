# Stardoc users only: Depend on "@hedron_compile_commands//:bzl_srcs_for_stardoc" as needed.
# Why? Stardoc requires all loaded files to be listed as deps; without this we'd prevent users from running Stardoc on their code when they load from this tool in, e.g., their own workspace.bzl.
filegroup(name = "bzl_srcs_for_stardoc", srcs = glob(["**/*.bzl"]) + ["@bazel_tools//:bzl_srcs"], visibility = ["//visibility:public"])
