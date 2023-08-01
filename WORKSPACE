# This file existed originally to enable quick local development via local_repository.
    # See ./ImplementationReadme.md for details on local development.
    # Why? local_repository didn't work without a WORKSPACE, and new_local_repository required overwriting the BUILD file (as of Bazel 5.0).

workspace(name = "hedron_make_cc_https_easy")

load("@hedron_make_cc_https_easy//:workspace_setup.bzl", "hedron_make_cc_https_easy")
hedron_make_cc_https_easy()
load("@hedron_make_cc_https_easy//:transitive_workspace_setup.bzl", "hedron_keep_cc_https_easy")
hedron_keep_cc_https_easy()
