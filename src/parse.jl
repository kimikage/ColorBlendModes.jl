
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
    k = get(mode_keyword, s, nothing)
    k !== nothing && return BlendMode{Symbol(k)}()
    kl = get(lowercase(strip(keyword)), s, nothing)
    kl !== nothing && return BlendMode{Symbol(kl)}()
    throw(ArgumentError("invalid keyword: $keyword"))
end
