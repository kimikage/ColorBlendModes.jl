
const TransparentColorN{N,C<:Color,T} = TransparentColor{C,T,N}

struct Hue{T<:Real}
    angle::T
end

const SeparableBlendMode = Union{
    BlendMode{:normal},
    BlendMode{:multiply},
    BlendMode{:screen},
    BlendMode{:overlay},
    BlendMode{:darken},
    BlendMode{:lighten},
    BlendMode{Symbol("color-dodge")},
    BlendMode{Symbol("color-burn")},
    BlendMode{Symbol("hard-light")},
    BlendMode{Symbol("soft-light")},
    BlendMode{:difference},
    BlendMode{:exclusion},
}

const NonSeparableBlendMode = Union{
    BlendMode{:hue},
    BlendMode{:saturation},
    BlendMode{:color},
    BlendMode{:luminosity},
}
