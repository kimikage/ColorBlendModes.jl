
# complement
_n(v::T) where T = oneunit(T) - v

# linear interpolation
_w(v1::T, v2::T, w) where T = convert(T, muladd(_n(w), v1, w * v2))

@inline (mode::BlendMode)(c1, c2; opacity=nothing, clipping=false) =
    _blend(mode, c1, c2, opacity, Val{clipping})

"""
    blend(c1, c2; mode=BlendNormal, opacity=1)
"""
@inline blend(c1, c2; mode::BlendMode=BlendNormal, opacity=nothing, clipping=false) =
    _blend(mode, c1, c2, opacity, Val{clipping})

# drop clipping kwarg
@inline _blend(mode::BlendMode, c1, c2, opacity, ::Type{Val{false}}) =
    _blend(mode, c1, c2, opacity)

@inline _blend(mode::BlendMode, c1::Color, c2, opacity, ::Type{Val{true}}) =
    _blend(mode, c1, c2, opacity)

# without opacity
@inline _blend(mode::BlendMode, c1, c2, ::Nothing) =
    _blend(mode, c1, c2)

@inline _blend(mode::BlendMode, c1::C1, c2::C2, ::Nothing) where {C1 <: Color, C2 <: TransparentColor{<:C1}} =
    _blend(BlendNormal, c1, _blend(mode, c1, color(c2)), alpha(c2))

# with opacity
@inline _blend(mode::BlendMode, c1::C, c2::C, opacity::Real) where C <: Color =
    mapc((v1, v2) -> _w(v1, v2, opacity), c1, _blend(mode, c1, c2))

@inline _blend(mode::BlendMode, c1::C1, c2::C2, opacity::Real) where {C1 <: Color, C2 <: TransparentColor{<:C1}} =
    _blend(BlendNormal, c1, _blend(mode, c1, color(c2)), alpha(c2) * opacity)

@inline _blend(mode::BlendMode, c1::C1, c2::C2, opacity::Real) where {C1 <: Color, C2 <: Color} =
    _blend(mode, c1, convert(C1, c2))




_blend(::BlendMode{:normal}, c1::C, c2::C) where C <: Color = c2

_blend(::BlendMode{:multiply}, c1::C, c2::C) where C <: Color = mapc(mul, c1, c2)

mul(v1, v2) = v1 * v2
@fastmath function mul(v1::N, v2::N) where N <: Normed
    rv1, rv2, r1 = reinterpret(v1), reinterpret(v2), reinterpret(oneunit(v2))
    m = widemul(rv1, rv2) / convert(floattype(N), r1)
    reinterpret(N, unsafe_trunc(typeof(r1), round(m)))
end
function mul(v1::N0f8, v2::N0f8)
    m = UInt16(reinterpret(v1)) * UInt16(reinterpret(v2))
    z = m + ((m + 0x80) >> 0x8) + 0x80
    reinterpret(N0f8, unsafe_trunc(UInt8, z >> 0x8))
end
function mul(v1::N0f16, v2::N0f16)
    m = UInt32(reinterpret(v1)) * UInt32(reinterpret(v2))
    z = m + ((m + 0x8000) >> 0x10) + 0x8000
    reinterpret(N0f16, unsafe_trunc(UInt16, z >> 0x10))
end

_blend(::BlendMode{:screen}, c1::C, c2::C) where C <: Color =
    mapc((v1, v2) -> _n(mul(_n(v1), _n(v2))), c1, c2)

_blend(::BlendMode{:overlay}, c1::C, c2::C) where C <: Color =
    _blend(BlendHardLight, c2, c1)

_blend(::BlendMode{:darken}, c1::C, c2::C) where C <: Color = mapc(min, c1, c2)

_blend(::BlendMode{:lighten}, c1::C, c2::C) where C <: Color = mapc(max, c1, c2)

_blend(::BlendMode{Symbol("color-dodge")}, c1::C, c2::C) where C <: Color =
    mapc(dodge, c1, c2)

function dodge(v1, v2)
    v1 == zero(v1) && return v1
    v2 == oneunit(v2) && return v2
    div01(v1, _n(v2))
end

div01(v1, v2) = convert(typeof(v1), min(1, v1 / v2))
@fastmath function div01(v1::N0f8, v2::N0f8)
    rv1, rv2, r1 = reinterpret(v1), reinterpret(v2), reinterpret(oneunit(v2))
    d = Float32(rv1) * r1 / Float32(rv2)
    reinterpret(N0f8, unsafe_trunc(typeof(r1), min(Float32(r1), round(d))))
end
@fastmath function div01(v1::N0f16, v2::N0f16)
    rv1, rv2, r1 = reinterpret(v1), reinterpret(v2), reinterpret(oneunit(v2))
    d = Float64(rv1) * r1 / Float64(rv2)
    reinterpret(N0f16, unsafe_trunc(typeof(r1), min(Float64(r1), round(d))))
end

_blend(::BlendMode{Symbol("color-burn")}, c1::C, c2::C) where C <: Color =
    mapc(burn, c1, c2)

# Note that "color-burn" tends to cause the loss of significance.
function burn(v1, v2)
    v1 == oneunit(v1) && return v1
    v2 == zero(v2) && return v2
    _n(div01(_n(v1), v2))
end
burn(v1::Float32, v2::Float32) = Float32(burn(Float64(v1), Float64(v2)))
@fastmath function burn(v1::N0f8, v2::N0f8)
    v1 == oneunit(v1) && return v1
    v2 == zero(v2) && return v2
    rv1, rv2, r1 = reinterpret(v1), reinterpret(v2), reinterpret(oneunit(v2))
    d = Float32(r1) - (Float32(r1) - Float32(rv1)) * r1 / Float32(rv2)
    reinterpret(N0f8, unsafe_trunc(typeof(r1), max(0.0f0, round(d))))
end
@fastmath function burn(v1::N0f16, v2::N0f16)
    v1 == oneunit(v1) && return v1
    v2 == zero(v2) && return v2
    rv1, rv2, r1 = reinterpret(v1), reinterpret(v2), reinterpret(oneunit(v2))
    d = Float64(r1) - (Float64(r1) - Float64(rv1)) * r1 / Float64(rv2)
    reinterpret(N0f16, unsafe_trunc(typeof(r1), max(0.0, round(d))))
end

_blend(::BlendMode{Symbol("hard-light")}, c1::C, c2::C) where C <: Color =
    mapc(hardlight, c1, c2)

function hardlight(v1, v2)
    v2r = min(v2, _n(v2))
    mr = mul(v2r + v2r, ifelse(v2 == v2r, v1, _n(v1)))
    ifelse(v2 == v2r, mr, _n(mr))
end

_blend(::BlendMode{Symbol("soft-light")}, c1::C, c2::C) where C <: Color =
    mapc(softlight, c1, c2)

function softlight(v1, v2)
    v2r = min(v2, _n(v2))
    nv2r2 = _n(v2r + v2r)
    if v2r == v2 # if v2 <= 0.5
        return mul(v1, _n(mul(nv2r2, _n(v1))))
    else
        m = mul(v1, _n(v2))
        @fastmath d(v) = v <= 0.25 ? muladd(4v - 3, v, 1) * 4v : sqrt(v)
        return m + m + mul(nv2r2, convert(typeof(v1), d(v1)))
    end
end
softlight(v1::X, v2::X) where X <: FixedPoint = softlight(float(v1), float(v2)) % X

_blend(::BlendMode{:difference}, c1::C, c2::C) where C <: Color =
    mapc(difference, c1, c2)

difference(v1, v2) = max(v1, v2) - min(v1, v2)

_blend(::BlendMode{:exclusion}, c1::C, c2::C) where C <: Color =
    mapc(exclusion, c1, c2)

function exclusion(v1, v2)
    m = mul(v1, v2)
    (v1 - m) + (v2 - m)
end
function exclusion(v1::N0f8, v2::N0f8)
    rv1, rv2 = UInt16(reinterpret(v1)), UInt16(reinterpret(v2))
    m = rv1 * rv2
    z = muladd(rv1 + rv2, 0xFF, -(m + m))
    reinterpret(N0f8, unsafe_trunc(UInt8, (z + ((z + 0x80) >> 0x8) + 0x80) >> 0x8))
end
function exclusion(v1::N0f16, v2::N0f16)
    rv1, rv2 = UInt32(reinterpret(v1)), UInt32(reinterpret(v2))
    m = rv1 * rv2
    z = muladd(rv1 + rv2, 0xFFFF, -(m + m))
    reinterpret(N0f16, unsafe_trunc(UInt16, (z + ((z + 0x8000) >> 0x10) + 0x8000) >> 0x10))
end
