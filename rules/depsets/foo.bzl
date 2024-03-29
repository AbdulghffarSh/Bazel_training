# buildifier: disable=module-docstring
FooFilesInfo = provider(doc = "", fields = ["transitive_sources"])

def get_transitive_srcs(srcs, deps):
    """Obtain the source files for a target and its transitive dependencies.

    Args:
      srcs: a list of source files
      deps: a list of targets that are direct dependencies
    Returns:
      a collection of the transitive sources
    """
    return depset(
        srcs,
        transitive = [dep[FooFilesInfo].transitive_sources for dep in deps],
    )

def _foo_library_impl(ctx):
    trans_srcs = get_transitive_srcs(ctx.files.srcs, ctx.attr.deps)
    return [
        FooFilesInfo(transitive_sources = trans_srcs),
        DefaultInfo(files = trans_srcs),
    ]

foo_library = rule(
    implementation = _foo_library_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(),
    },
)

def _foo_binary_impl(ctx):
    foocc = ctx.executable._foocc
    out = ctx.outputs.out
    trans_srcs = get_transitive_srcs(ctx.files.srcs, ctx.attr.deps)
    srcs_list = trans_srcs.to_list()
    ctx.actions.run(
        executable = foocc,
        arguments = [out.path] + [src.path for src in srcs_list],
        inputs = srcs_list,
        tools = [foocc],
        outputs = [out],
    )

_foo_binary = rule(
    implementation = _foo_binary_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(),
        "_foocc": attr.label(
            default = ":foocc",
            allow_files = True,
            executable = True,
            cfg = "exec",
        ),
        "out": attr.output(),
    },
)

def foo_binary(**kwargs):
    _foo_binary(out = "{name}.out".format(**kwargs), **kwargs)
