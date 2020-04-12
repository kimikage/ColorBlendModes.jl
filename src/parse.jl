
const mode_keywords = [
    "normal",
    "multiply",
    "screen",
    "overlay",
    "darken",
    "lighten",
    "color-dodge",
    "color-burn",
    "hard-light",
    "soft-light",
    "difference",
    "exclusion",
    "hue",
    "saturation",
    "color",
    "luminosity",
]

"""
    parse(t::Type{BlendMode}, keyword)
    parse(t::Type{CompositeOperation}, keyword)

Parse a keyword string as a [`BlendMode`](@ref) or [`CompositeOperation`](@ref).
Keywords are case-insensitive, but hyphens cannot be omitted.

# Examples
```jldoctest
julia> parse(BlendMode, "color-burn")
BlendMode{Symbol("color-burn")}()

julia> parse(BlendMode, "soft-light") === BlendSoftLight
true

julia> parse(CompositeOperation, "source-over")
CompositeOperation{Symbol("source-over")}()

julia> parse(CompositeOperation, "source-over") === CompositeSourceOver
true

julia> parse(CompositeOperation, "SourceOver")
ERROR: ArgumentError: invalid keyword: SourceOver
```
"""
function Base.parse(::Type{BlendMode}, keyword::AbstractString)
    keyword in mode_keywords && return BlendMode{Symbol(keyword)}()
    kl = lowercase(strip(keyword))
    kl in mode_keywords && return BlendMode{Symbol(kl)}()
    throw(ArgumentError("invalid keyword: $keyword"))
end

const op_keywords = [
    "source-over",
    "source-atop",
]

function Base.parse(::Type{CompositeOperation}, keyword::AbstractString)
    keyword in op_keywords && return CompositeOperation{Symbol(keyword)}()
    kl = lowercase(strip(keyword))
    kl in op_keywords && return CompositeOperation{Symbol(kl)}()
    throw(ArgumentError("invalid keyword: $keyword"))
end
