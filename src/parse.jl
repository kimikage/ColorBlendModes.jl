
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

function Base.parse(::Type{<:BlendMode}, keyword::AbstractString)
    keyword in mode_keywords && return BlendMode{Symbol(keyword)}()
    kl = lowercase(strip(keyword))
    kl in mode_keywords && return BlendMode{Symbol(kl)}()
    throw(ArgumentError("invalid keyword: $keyword"))
end

const op_keywords = [
    "source-over",
    "source-atop",
]

function Base.parse(::Type{<:CompositeOperation}, keyword::AbstractString)
    keyword in op_keywords && return CompositeOperation{Symbol(keyword)}()
    kl = lowercase(strip(keyword))
    kl in op_keywords && return CompositeOperation{Symbol(kl)}()
    throw(ArgumentError("invalid keyword: $keyword"))
end
