
const TransparentColorN{N,C<:Color,T} = TransparentColor{C,T,N}

struct Hue{T<:Real}
    angle::T
    isgray::Bool
    Hue(angle::T, isgray::Bool=false) where {T <: Real} = new{T}(angle, isgray)
    Hue(c::C) where {T, C<:Union{HSV{T}, HSL{T}, HSI{T},
                                 AHSV{T}, AHSL{T}, AHSI{T}, HSVA{T}, HSLA{T}, HSIA{T}}} =
        new{T}(c.h, c.s == zero(T))
    Hue(c::C) where {T, C<:Union{LCHab{T}, LCHuv{T},
                                 ALCHab{T}, ALCHuv{T}, LCHabA{T}, LCHuvA{T}}} =
        new{T}(c.h, c.c == zero(T))
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
