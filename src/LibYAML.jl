module LibYAML

using Libdl

# Load `deps.jl`, complaining if it does not exist
const depsjl_path = joinpath(@__DIR__, "..", "deps", "deps.jl")
if !isfile(depsjl_path)
    error("LibYAML not installed properly, run Pkg.build(\"LibYAML\"), restart Julia, and try again")
end
include(depsjl_path)

# Module initialization function
function __init__()
    # Always check your dependencies from `deps.jl`
    check_deps()
end



# Version Information

"""
Get the library version as a string.

The function returns the pointer to a static string of the form
`X.Y.Z`, where `X` is the major version number, `Y` is a minor version
number, and `Z` is the patch version number.
"""
function get_version_string()::String
    unsafe_string(ccall((:yaml_get_version_string, libyaml), Cstring, ()))
end

"""
Get the library version numbers.

Returns a tuple `(major, minor, patch)`.
"""
function get_version()::NTuple{3, Int}
    major = Ref{Cint}(0)
    minor = Ref{Cint}(0)
    patch = Ref{Cint}(0)
    ccall((:yaml_get_version, libyaml),
          Cvoid, (Ref{Cint}, Ref{Cint}, Ref{Cint}), major, minor, patch)
    major[], minor[], patch[]
end



# Basic Types

"""The version directive data."""
struct VersionDirective
    """The major version number."""
    major::Int
    """The minor version number."""
    minor::Int
end

"""The tag directive data."""
struct TagDirective
    """The tag handle."""
    handle::Cstring
    """The tag prefix."""
    prefix::Cstring
end



# Tokens

# Events

# Nodes

# NOTE: It turns out that wrapping LibYAML directly in Julia is not
# feasible since LibYAML uses unions in its types. It is unclear to me
# how to create respective Julia types that have the correct size. It
# might be necessary to create C wrappers that allocate or free
# LibYAML's objects, and provide Julia accessors that don't use C
# unions.

"""The document nodes."""
struct DocumentNodes
#     """The beginning of the stack."""
#     start::Ref{Node}
#     """The end of the stack."""
#     end_::Ref{Node}
#     """The top of the stack."""
#     top::Ref{Node}
end

"""The document structure."""
struct Document
    """The document nodes."""
    nodes::DocumentNodes

    """The version directive."""
    version_directive::Ref{VersionDirective}
 
#     /** The list of tag directives. */
#     struct {
#         /** The beginning of the tag directives list. */
#         yaml_tag_directive_t *start;
#         /** The end of the tag directives list. */
#         yaml_tag_directive_t *end;
#     } tag_directives;
# 
#     /** Is the document start indicator implicit? */
#     int start_implicit;
#     /** Is the document end indicator implicit? */
#     int end_implicit;
# 
#     /** The beginning of the document. */
#     yaml_mark_t start_mark;
#     /** The end of the document. */
#     yaml_mark_t end_mark;
end



# Parser definitions

struct Parser
    parser::Ptr{Cvoid}
end

"""
Parse the input stream and produce the next YAML document.

Call this function subsequently to produce a sequence of documents
constituting the input stream.

If the produced document has no root node, it means that the document
end has been reached.

An application is responsible for freeing any data associated with the
produced document object using the `document_delete()` function.

An application must not alternate the calls of `parser_load()` with the
calls of `parser_scan()` or `parser_parse()`. Doing this will break
the parser.

@param[in,out]   parser      A parser object.
@param[out]      document    An empty document object.

@return @c 1 if the function succeeded, @c 0 on error.
"""
function parser_load(parser::Parser)::Document
    doc = Ref{Document}(Document())
    ccall((:yaml_parser_load, libyaml),
          Cint, (Ptr{Cvoid}, Ref{Document}), parser.parser, doc)
    doc[]
end



# Emitter definitions

end
