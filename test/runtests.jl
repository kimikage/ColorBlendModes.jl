using Test
using ColorBlendModes
using ColorTypes, FixedPointNumbers

@test isempty(detect_ambiguities(ColorBlendModes, Base, Core))

const blend_modes = map(k -> parse(BlendMode, k), ColorBlendModes.mode_keywords)
const separable_modes = filter(m -> m isa ColorBlendModes.SeparableBlendMode, blend_modes)

const Ts = (Float64, Float32, N0f8, N0f16)

# RGB -> Gray conversions are implemented in Colors.jl, and the following are
# slightly different from the implementations of Colors.jl.
function ColorTypes._convert(::Type{Cout}, ::Type{C1}, ::Type{C2},
                             c) where {Cout<:AbstractGray,C1<:AbstractGray,C2<:AbstractRGB}
    Cout(ColorBlendModes.lum100(c) / 100)
end
function ColorTypes._convert(::Type{A}, ::Type{C1}, ::Type{C2},
                             c, alpha=alpha(c)) where {A<:TransparentGray,C1<:AbstractGray,C2<:AbstractRGB}
    A(ColorBlendModes.lum100(color(c)) / 100, alpha)
end


const gray_n0f8 = Gray{N0f8}[0, 0.004, 0.251, 0.498, 0.502, 0.506, 0.753, 0.996, 1]
const rgb1_n0f8 = RGB{N0f8}.(gray_n0f8)
const rgb2_n0f8 = [RGB{N0f8}(gray_n0f8[3i+mod1(i+1,3)], gray_n0f8[3i+mod1(i+2,3)], gray_n0f8[3i+mod1(i+3,3)]) for i = 0:2]


const gray_n0f16 = Gray{N0f16}[0, 2e-5, 0.25, 0.49999, 0.50001, 0.50002, 0.75001, 0.99998, 1]
const rgb1_n0f16 = RGB{N0f16}.(gray_n0f16)
const rgb2_n0f16 = [RGB{N0f16}(gray_n0f16[3i+mod1(i+1,3)], gray_n0f16[3i+mod1(i+2,3)], gray_n0f16[3i+mod1(i+3,3)]) for i = 0:2]


const gray_f32 = Gray{Float32}[0.0f0, Float32(0x1p-126), 0.25f0,
                               prevfloat(0.5f0), 0.5f0, nextfloat(0.5f0),
                               0.75f0, prevfloat(1.0f0), 1.0f0]
const rgb1_f32 = RGB{Float32}.(gray_f32)
const rgb2_f32 = [RGB{Float32}(gray_f32[3i+mod1(i+1,3)], gray_f32[3i+mod1(i+2,3)], gray_f32[3i+mod1(i+3,3)]) for i = 0:2]


const gray_f64 = Gray{Float64}[0.0, 0x1p-1022, 0.25,
                               prevfloat(0.5), 0.5, nextfloat(0.5),
                               0.75, prevfloat(1.0), 1.0]
const rgb1_f64 = RGB{Float64}.(gray_f64)
const rgb2_f64 = [RGB{Float64}(gray_f64[3i+mod1(i+1,3)], gray_f64[3i+mod1(i+2,3)], gray_f64[3i+mod1(i+3,3)]) for i = 0:2]

f64(c::C) where C<:Colorant = convert(base_colorant_type(C){Float64}, c)
f32(c::C) where C<:Colorant = convert(base_colorant_type(C){Float32}, c)
n0f8(c::C) where C<:Colorant = convert(base_colorant_type(C){N0f8}, c)
n0f16(c::C) where C<:Colorant = convert(base_colorant_type(C){N0f16}, c)

@testset "low level optimization" begin
    r_n0f8 = 0N0f8:eps(N0f8):1N0f8
    r_n0f16 = 0N0f16:eps(N0f16):1N0f16
    @testset "mul" begin
        function test_mul(v1::N, v2::N) where {T, N <: Normed{T}}
            rv1, rv2 = reinterpret(v1), reinterpret(v2)
            expected = reinterpret(N, round(T, rv1 / typemax(T) * rv2))
            ColorBlendModes.mul(v1, v2) === expected
        end
        @test all(test_mul(v1, v2) for v1 in r_n0f8,  v2 in r_n0f8)
        @test all(test_mul(v1, v2) for v1 in r_n0f16, v2 in r_n0f16)
    end

    @testset "div01" begin
        function test_div01(v1::N, v2::N) where {T, N <: Normed{T}}
            v2 == zero(N) && return true
            rv1, rv2 = reinterpret(v1), reinterpret(v2)
            expected = reinterpret(N, round(T, min(1.0, rv1 / rv2) * typemax(T)))
            ColorBlendModes.div01(v1, v2) === expected
        end
        @test all(test_div01(v1, v2) for v1 in r_n0f8,  v2 in r_n0f8)
    end
end

@testset "hue operation" begin
    Hue = ColorBlendModes.Hue

    @test ColorBlendModes._w(Hue(30.0), Hue(130.0), 0.0) ≈ 30.0
    @test ColorBlendModes._w(Hue(30.0), Hue(130.0), 0.6) ≈ 90.0
    @test ColorBlendModes._w(Hue(30.0), Hue(130.0), 1.0) ≈ 130.0
    @test ColorBlendModes._w(Hue(130.0), Hue(30.0), 0.6) ≈ 70.0
    @test ColorBlendModes._w(Hue(175.0), Hue(185.0), 0.6) ≈ 181.0
    @test ColorBlendModes._w(Hue(230.0), Hue(30.0), 0.6) ≈ 326.0
    @test ColorBlendModes._w(Hue(5.0), Hue(355.0), 0.6) ≈ 359.0

    @test ColorBlendModes._w(Hue(30.0), 1.0, Hue(130.0), 0.0) ≈ 30.0
    @test ColorBlendModes._w(Hue(30.0), 0.4, Hue(130.0), 0.6) ≈ 90.0
    @test ColorBlendModes._w(Hue(30.0), 0.0, Hue(130.0), 1.0) ≈ 130.0
    @test ColorBlendModes._w(Hue(130.0), 0.4, Hue(30.0), 0.6) ≈ 70.0
    @test ColorBlendModes._w(Hue(175.0), 0.4, Hue(185.0), 0.6) ≈ 181.0
    @test ColorBlendModes._w(Hue(230.0), 0.4, Hue(30.0), 0.6) ≈ 326.0
    @test ColorBlendModes._w(Hue(5.0), 0.4, Hue(355.0), 0.6) ≈ 359.0
end

@testset "blend: RGB" begin
    include("blend_rgb.jl")
end

@testset "blend: Gray (and RGB)" begin
    include("blend_gray.jl")
end

@testset "blend: Lab/Luv" begin
    include("blend_lab.jl")
end

@testset "blend: HSV/HSL/HSI" begin
    include("blend_hsx.jl")
end

@testset "composite" begin
    include("composite.jl")
end

@testset "keyword" begin
    @test keyword(BlendNormal) == "normal"
    @test keyword(BlendColorDodge) == "color-dodge"

    @test keyword(CompositeSourceOver) == "source-over"
end

@testset "parse" begin
    @test parse(BlendMode, "color-burn") === BlendColorBurn
    @test parse(BlendMode, "Hard-Light") === BlendHardLight
    @test_throws ArgumentError parse(BlendMode, "SoftLight")

    @test parse(CompositeOperation, "source-over") === CompositeSourceOver
    @test parse(CompositeOperation, "Source-Atop") === CompositeSourceAtop
    @test_throws ArgumentError parse(CompositeOperation, "SourceAtop")
end
