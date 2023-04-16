# Do not change the filename; it is part of the user interface.


load("@com_github_nelhage_rules_boost//:boost/boost.bzl", "boost_deps")


def hedron_keep_cc_https_easy():
    """Part 2 of setting up a WORKSPACE so you can easily make https requests from C++. 
    
    Sorry it can't be unified with hedron_make_cc_https_easy(). Bazel implementation restrictions."""

    # Below the interface boundary:
    # This is needed to get transitive dependencies of transitive dependencies--by calling their deps functions.

    # Why?
    # Bazel doesn't let you call a load except at the top level after v3 or so :/, so you have to resort to calling waves of workspace functions, one per each additional layer of transitive dependencies.
    # For more info see:
        # https://bazel.build/external/overview#shortcomings_of_the_workspace_system
        # https://github.com/bazelbuild/bazel/issues/1550
        # https://github.com/bazelbuild/bazel/issues/5815
        # https://github.com/hedronvision/bazel-make-cc-https-easy/issues/14

    boost_deps()
