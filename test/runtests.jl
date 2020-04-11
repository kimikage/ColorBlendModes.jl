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

function test_rgb_over_rgb(bm, expected_f64)
    @test all(t->bm(t[1]...) ≈ t[2],
              zip(((c1, c2) for c1 in rgb1_f64, c2 in rgb2_f64), expected_f64))

    @test all(c->bm(c[1], c[2]) ≈ bm(c[1]|>f64, c[2]|>f64)|>f32,
              ((c1, c2) for c1 in rgb1_f32, c2 in rgb2_f32))
    @test all(c->bm(c[1], c[2]) === bm(c[1]|>f64, c[2]|>f64)|>n0f8,
              ((c1, c2) for c1 in rgb1_n0f8, c2 in rgb2_n0f8))
    @test all(c->bm(c[1], c[2]) === bm(c[1]|>f64, c[2]|>f64)|>n0f16,
              ((c1, c2) for c1 in rgb1_n0f16, c2 in rgb2_n0f16))

    @test all(c->bm(c[1], c[2]) ≈ bm(c[1]|>f64, c[2]|>f64)|>f32,
              ((c2, c1) for c1 in rgb1_f32, c2 in rgb2_f32))
    @test all(c->bm(c[1], c[2]) === bm(c[1]|>f64, c[2]|>f64)|>n0f8,
              ((c2, c1) for c1 in rgb1_n0f8, c2 in rgb2_n0f8))
    @test all(c->bm(c[1], c[2]) === bm(c[1]|>f64, c[2]|>f64)|>n0f16,
              ((c2, c1) for c1 in rgb1_n0f16, c2 in rgb2_n0f16))
end

function test_gray_over_gray(bm)
    @test all(c->gray(bm(c[1], c[2])) === red(bm(RGB(c[1]), RGB(c[2]))),
              ((c1, c2) for c1 in gray_f64, c2 in gray_f64))
    @test all(c->gray(bm(c[1], c[2])) === red(bm(RGB(c[1]), RGB(c[2]))),
              ((c1, c2) for c1 in gray_f32, c2 in gray_f32))
    @test all(c->gray(bm(c[1], c[2])) === red(bm(RGB(c[1]), RGB(c[2]))),
              ((c1, c2) for c1 in gray_n0f8, c2 in gray_n0f8))
    @test all(c->gray(bm(c[1], c[2])) === red(bm(RGB(c[1]), RGB(c[2]))),
              ((c1, c2) for c1 in gray_n0f16, c2 in gray_n0f16))
end

function test_gray_over_rgb(bm)
    @test all(c->bm(c[1], c[2]) === bm(c[1], RGB(c[2])),
              ((c1, c2) for c1 in rgb2_f64, c2 in gray_f64))
    @test all(c->bm(c[1], c[2]) === bm(c[1], RGB(c[2])),
              ((c1, c2) for c1 in rgb2_f32, c2 in gray_f32))
    @test all(c->bm(c[1], c[2]) === bm(c[1], RGB(c[2])),
              ((c1, c2) for c1 in rgb2_n0f8, c2 in gray_n0f8))
    @test all(c->bm(c[1], c[2]) === bm(c[1], RGB(c[2])),
              ((c1, c2) for c1 in rgb2_n0f16, c2 in gray_n0f16))
end

function test_rgb_over_gray(bm)
    @test all(c->bm(c[1], c[2]) === bm(c[1], Gray(c[2])),
              ((c1, c2) for c1 in gray_f64, c2 in rgb2_f64))
    @test all(c->bm(c[1], c[2]) === bm(c[1], Gray(c[2])),
              ((c1, c2) for c1 in gray_f32, c2 in rgb2_f32))
    @test all(c->bm(c[1], c[2]) === bm(c[1], Gray(c[2])),
              ((c1, c2) for c1 in gray_n0f8, c2 in rgb2_n0f8))
    @test all(c->bm(c[1], c[2]) === bm(c[1], Gray(c[2])),
              ((c1, c2) for c1 in gray_n0f16, c2 in rgb2_n0f16))
end

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

@testset "normal" begin
    @testset "RGB over RGB" begin
        test_rgb_over_rgb(BlendNormal, [c2 for c1 in rgb1_f64, c2 in rgb2_f64])
    end

    @testset "RGBA over RGB: $T" for T in Ts
        @test BlendNormal(RGB{T}(1, 0.75, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGB{T}(0.4, 0.6, 0.6)
    end

    @testset "RGB over RGBA: $T" for T in Ts
        @test BlendNormal(RGBA{T}(1, 0.75, 0, 0.6), RGB{T}(0, 0.5, 1)) ≈ RGBA{T}(0, 0.5, 1, 1)
    end

    @testset "RGBA over RGBA: $T" for T in Ts
        @test BlendNormal(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(2/7, 4/7, 5/7, 0.84)
    end
end

@testset "multiply" begin
    @testset "RGB over RGB" begin
        test_rgb_over_rgb(BlendMultiply, RGB{Float64}[
            RGB(0.0, 0.0,                     0.0)                    RGB(0.0,                     0.0,                     0.0)                     RGB(0.0,                     0.0,                    0.0)
            RGB(0.0, 0.0,                     5.562684646268003e-309) RGB(1.1125369292536007e-308, 1.1125369292536007e-308, 1.1125369292536007e-308) RGB(2.2250738585072014e-308, 1.668805393880401e-308, 2.2250738585072014e-308)
            RGB(0.0, 5.562684646268003e-309,  0.0625)                 RGB(0.125,                   0.12500000000000003,     0.12499999999999999)     RGB(0.25,                    0.1875,                 0.24999999999999997)
            RGB(0.0, 1.1125369292536007e-308, 0.12499999999999999)    RGB(0.24999999999999997,     0.25,                    0.24999999999999994)     RGB(0.49999999999999994,     0.37499999999999994,    0.4999999999999999)
            RGB(0.0, 1.1125369292536007e-308, 0.125)                  RGB(0.25,                    0.25000000000000006,     0.24999999999999997)     RGB(0.5,                     0.375,                  0.49999999999999994)
            RGB(0.0, 1.1125369292536007e-308, 0.12500000000000003)    RGB(0.25000000000000006,     0.2500000000000001,      0.25)                    RGB(0.5000000000000001,      0.3750000000000001,     0.5)
            RGB(0.0, 1.668805393880401e-308,  0.1875)                 RGB(0.375,                   0.3750000000000001,      0.37499999999999994)     RGB(0.75,                    0.5625,                 0.7499999999999999)
            RGB(0.0, 2.2250738585072014e-308, 0.24999999999999997)    RGB(0.49999999999999994,     0.5,                     0.4999999999999999)      RGB(0.9999999999999999,      0.7499999999999999,     0.9999999999999998)
            RGB(0.0, 2.2250738585072014e-308, 0.25)                   RGB(0.5,                     0.5000000000000001,      0.49999999999999994)     RGB(1.0,                     0.75,                   0.9999999999999999)
        ])
    end

    @testset "RGBA over RGB: $T" for T in Ts
        @test BlendMultiply(RGB{T}(1, 0.75, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGB{T}(0.4, 0.525, 0.0)
    end

    @testset "RGB over RGBA: $T" for T in Ts
        @test BlendMultiply(RGBA{T}(1, 0.75, 0, 0.6), RGB{T}(0, 0.5, 1)) ≈ RGBA{T}(0, 0.425, 0.4, 1)
    end

    @testset "RGBA over RGBA: $T" for T in Ts
        @test BlendMultiply(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(2/7, 29/56, 2/7, 0.84)
    end
end

@testset "screen" begin
    @testset "RGB over RGB" begin
        test_rgb_over_rgb(BlendScreen, RGB{Float64}[
            RGB(0.0,                 0.0,                 0.25)               RGB(0.5,   0.5000000000000001, 0.49999999999999994) RGB(1.0, 0.75,   0.9999999999999999)
            RGB(0.0,                 0.0,                 0.25)               RGB(0.5,   0.5000000000000001, 0.49999999999999994) RGB(1.0, 0.75,   0.9999999999999999)
            RGB(0.25,                0.25,                0.4375)             RGB(0.625, 0.6250000000000001, 0.625)               RGB(1.0, 0.8125, 0.9999999999999999)
            RGB(0.49999999999999994, 0.49999999999999994, 0.625)              RGB(0.75,  0.75,               0.7499999999999999)  RGB(1.0, 0.875,  0.9999999999999999)
            RGB(0.5,                 0.5,                 0.625)              RGB(0.75,  0.75,               0.75)                RGB(1.0, 0.875,  1.0)
            RGB(0.5000000000000001,  0.5000000000000001,  0.6250000000000001) RGB(0.75,  0.7500000000000001, 0.75)                RGB(1.0, 0.875,  1.0)
            RGB(0.75,                0.75,                0.8125)             RGB(0.875, 0.875,              0.875)               RGB(1.0, 0.9375, 1.0)
            RGB(0.9999999999999999,  0.9999999999999999,  0.9999999999999999) RGB(1.0,   1.0,                0.9999999999999999)  RGB(1.0, 1.0,    1.0)
            RGB(1.0,                 1.0,                 1.0)                RGB(1.0,   1.0,                1.0)                 RGB(1.0, 1.0,    1.0)
        ])
    end

    @testset "RGBA over RGB: $T" for T in Ts
        @test BlendScreen(RGB{T}(1, 0.75, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGB{T}(1.0, 0.825, 0.6)
    end

    @testset "RGB over RGBA: $T" for T in Ts
        @test BlendScreen(RGBA{T}(1, 0.75, 0, 0.6), RGB{T}(0, 0.5, 1)) ≈ RGBA{T}(0.6, 0.725, 1.0, 1)
    end

    @testset "RGBA over RGBA: $T" for T in Ts
        @test BlendScreen(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(5/7, 41/56, 5/7, 0.84)
    end
end

@testset "overlay" begin
    @testset "RGB over RGB" begin
        test_rgb_over_rgb(BlendOverlay, RGB{Float64}[
            RGB(0.0,                   0.0,                     0.0)                     RGB(0.0,                     0.0,                    0.0)                     RGB(0.0,                    0.0,                    0.0)
            RGB(0.0,                   0.0,                     1.1125369292536007e-308) RGB(2.2250738585072014e-308, 2.225073858507202e-308, 2.2250738585072014e-308) RGB(4.450147717014403e-308, 3.337610787760802e-308, 4.4501477170144023e-308)
            RGB(0.0,                   1.1125369292536007e-308, 0.125)                   RGB(0.25,                    0.25000000000000006,    0.24999999999999997)     RGB(0.5,                    0.375,                  0.49999999999999994)
            RGB(0.0,                   2.2250738585072014e-308, 0.24999999999999997)     RGB(0.49999999999999994,     0.5,                    0.4999999999999999)      RGB(0.9999999999999999,     0.7499999999999999,     0.9999999999999998)
            RGB(0.0,                   2.2250738585072014e-308, 0.25)                    RGB(0.5,                     0.5000000000000001,     0.49999999999999994)     RGB(1.0,                    0.75,                   0.9999999999999999)
            RGB(2.220446049250313e-16, 2.220446049250313e-16,   0.25000000000000017)     RGB(0.5000000000000001,      0.5000000000000002,     0.5000000000000001)      RGB(1.0,                    0.75,                   0.9999999999999999)
            RGB(0.5,                   0.5,                     0.625)                   RGB(0.75,                    0.75,                   0.75)                    RGB(1.0,                    0.875,                  1.0)
            RGB(0.9999999999999998,    0.9999999999999998,      0.9999999999999998)      RGB(0.9999999999999999,      0.9999999999999999,     0.9999999999999999)      RGB(1.0,                    1.0,                    1.0)
            RGB(1.0,                   1.0,                     1.0)                     RGB(1.0,                     1.0,                    1.0)                     RGB(1.0,                    1.0,                    1.0)
        ])
    end

    @testset "RGBA over RGB: $T" for T in Ts
        @test BlendOverlay(RGB{T}(1, 0.75, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGB{T}(1.0, 0.75, 0.0)
    end

    @testset "RGB over RGBA: $T" for T in Ts
        @test BlendOverlay(RGBA{T}(1, 0.75, 0, 0.6), RGB{T}(0, 0.5, 1)) ≈ RGBA{T}(0.6, 0.65, 0.4, 1)
    end

    @testset "RGBA over RGBA: $T" for T in Ts
        @test BlendOverlay(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(5/7, 19/28, 2/7, 0.84)
    end
end

@testset "darken" begin
    @testset "RGB over RGB" begin
        test_rgb_over_rgb(BlendDarken, RGB{Float64}[
            RGB(0.0, 0.0,                     0.0)                     RGB(0.0,                     0.0,                     0.0)                     RGB(0.0,                     0.0,                     0.0)
            RGB(0.0, 2.2250738585072014e-308, 2.2250738585072014e-308) RGB(2.2250738585072014e-308, 2.2250738585072014e-308, 2.2250738585072014e-308) RGB(2.2250738585072014e-308, 2.2250738585072014e-308, 2.2250738585072014e-308)
            RGB(0.0, 2.2250738585072014e-308, 0.25)                    RGB(0.25,                    0.25,                    0.25)                    RGB(0.25,                    0.25,                    0.25)
            RGB(0.0, 2.2250738585072014e-308, 0.25)                    RGB(0.49999999999999994,     0.49999999999999994,     0.49999999999999994)     RGB(0.49999999999999994,     0.49999999999999994,     0.49999999999999994)
            RGB(0.0, 2.2250738585072014e-308, 0.25)                    RGB(0.5,                     0.5,                     0.49999999999999994)     RGB(0.5,                     0.5,                     0.5)
            RGB(0.0, 2.2250738585072014e-308, 0.25)                    RGB(0.5,                     0.5000000000000001,      0.49999999999999994)     RGB(0.5000000000000001,      0.5000000000000001,      0.5000000000000001)
            RGB(0.0, 2.2250738585072014e-308, 0.25)                    RGB(0.5,                     0.5000000000000001,      0.49999999999999994)     RGB(0.75,                    0.75,                    0.75)
            RGB(0.0, 2.2250738585072014e-308, 0.25)                    RGB(0.5,                     0.5000000000000001,      0.49999999999999994)     RGB(0.9999999999999999,      0.75,                    0.9999999999999999)
            RGB(0.0, 2.2250738585072014e-308, 0.25)                    RGB(0.5,                     0.5000000000000001,      0.49999999999999994)     RGB(1.0,                     0.75,                    0.9999999999999999)
        ])
    end

    @testset "RGBA over RGB: $T" for T in Ts
        @test BlendDarken(RGB{T}(1, 0.75, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGB{T}(0.4, 0.6, 0.0)
    end

    @testset "RGB over RGBA: $T" for T in Ts
        @test BlendDarken(RGBA{T}(1, 0.75, 0, 0.6), RGB{T}(0, 0.5, 1)) ≈ RGBA{T}(0.0, 0.5, 0.4, 1)
    end

    @testset "RGBA over RGBA: $T" for T in Ts
        @test BlendDarken(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(2/7, 4/7, 2/7, 0.84)
    end
end

@testset "lighten" begin
    @testset "RGB over RGB" begin
        test_rgb_over_rgb(BlendLighten, RGB{Float64}[
            RGB(0.0,                     2.2250738585072014e-308, 0.25)                RGB(0.5,                0.5000000000000001, 0.49999999999999994) RGB(1.0, 0.75,               0.9999999999999999)
            RGB(2.2250738585072014e-308, 2.2250738585072014e-308, 0.25)                RGB(0.5,                0.5000000000000001, 0.49999999999999994) RGB(1.0, 0.75,               0.9999999999999999)
            RGB(0.25,                    0.25,                    0.25)                RGB(0.5,                0.5000000000000001, 0.49999999999999994) RGB(1.0, 0.75,               0.9999999999999999)
            RGB(0.49999999999999994,     0.49999999999999994,     0.49999999999999994) RGB(0.5,                0.5000000000000001, 0.49999999999999994) RGB(1.0, 0.75,               0.9999999999999999)
            RGB(0.5,                     0.5,                     0.5)                 RGB(0.5,                0.5000000000000001, 0.5)                 RGB(1.0, 0.75,               0.9999999999999999)
            RGB(0.5000000000000001,      0.5000000000000001,      0.5000000000000001)  RGB(0.5000000000000001, 0.5000000000000001, 0.5000000000000001)  RGB(1.0, 0.75,               0.9999999999999999)
            RGB(0.75,                    0.75,                    0.75)                RGB(0.75,               0.75,               0.75)                RGB(1.0, 0.75,               0.9999999999999999)
            RGB(0.9999999999999999,      0.9999999999999999,      0.9999999999999999)  RGB(0.9999999999999999, 0.9999999999999999, 0.9999999999999999)  RGB(1.0, 0.9999999999999999, 0.9999999999999999)
            RGB(1.0,                     1.0,                     1.0)                 RGB(1.0,                1.0,                1.0)                 RGB(1.0, 1.0,                1.0)
        ])
    end

    @testset "RGBA over RGB: $T" for T in Ts
        @test BlendLighten(RGB{T}(1, 0.75, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGB{T}(1.0, 0.75, 0.6)
    end

    @testset "RGB over RGBA: $T" for T in Ts
        @test BlendLighten(RGBA{T}(1, 0.75, 0, 0.6), RGB{T}(0, 0.5, 1)) ≈ RGBA{T}(0.6, 0.65, 1.0, 1)
    end

    @testset "RGBA over RGBA: $T" for T in Ts
        @test BlendLighten(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(5/7, 19/28, 5/7, 0.84)
    end
end

@testset "color-dodge" begin
    @testset "RGB over RGB" begin
        test_rgb_over_rgb(BlendColorDodge, RGB{Float64}[
            RGB(0.0,                     0.0,                     0.0)                     RGB(0.0,                    0.0,                    0.0)                     RGB(0.0, 0.0,                    0.0)
            RGB(2.2250738585072014e-308, 2.2250738585072014e-308, 2.9667651446762683e-308) RGB(4.450147717014403e-308, 4.450147717014404e-308, 4.4501477170144023e-308) RGB(1.0, 8.900295434028806e-308, 2.004168360008973e-292)
            RGB(0.25,                    0.25,                    0.3333333333333333)      RGB(0.5,                    0.5000000000000001,     0.49999999999999994)     RGB(1.0, 1.0,                    1.0)
            RGB(0.49999999999999994,     0.49999999999999994,     0.6666666666666666)      RGB(0.9999999999999999,     1.0,                    0.9999999999999998)      RGB(1.0, 1.0,                    1.0)
            RGB(0.5,                     0.5,                     0.6666666666666666)      RGB(1.0,                    1.0,                    0.9999999999999999)      RGB(1.0, 1.0,                    1.0)
            RGB(0.5000000000000001,      0.5000000000000001,      0.6666666666666669)      RGB(1.0,                    1.0,                    1.0)                     RGB(1.0, 1.0,                    1.0)
            RGB(0.75,                    0.75,                    1.0)                     RGB(1.0,                    1.0,                    1.0)                     RGB(1.0, 1.0,                    1.0)
            RGB(0.9999999999999999,      0.9999999999999999,      1.0)                     RGB(1.0,                    1.0,                    1.0)                     RGB(1.0, 1.0,                    1.0)
            RGB(1.0,                     1.0,                     1.0)                     RGB(1.0,                    1.0,                    1.0)                     RGB(1.0, 1.0,                    1.0)
        ])
    end

    @testset "RGBA over RGB: $T" for T in Ts
        @test BlendColorDodge(RGB{T}(1, 0.75, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGB{T}(1.0, 0.9, 0.0)
    end

    @testset "RGB over RGBA: $T" for T in Ts
        @test BlendColorDodge(RGBA{T}(1, 0.75, 0, 0.6), RGB{T}(0, 0.5, 1)) ≈ RGBA{T}(0.6, 0.8, 0.4, 1)
    end

    @testset "RGBA over RGBA: $T" for T in Ts
        @test BlendColorDodge(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(5/7, 11/14, 2/7, 0.84)
    end
end

@testset "color-burn" begin
    @testset "RGB over RGB" begin
        test_rgb_over_rgb(BlendColorBurn, RGB{Float64}[
            RGB(0.0, 0.0, 0.0)                RGB(0.0,                   0.0,                    0.0)                    RGB(0.0,                 0.0,                 0.0)
            RGB(0.0, 0.0, 0.0)                RGB(0.0,                   0.0,                    0.0)                    RGB(0.0,                 0.0,                 0.0)
            RGB(0.0, 0.0, 0.0)                RGB(0.0,                   0.0,                    0.0)                    RGB(0.25,                0.0,                 0.24999999999999992)
            RGB(0.0, 0.0, 0.0)                RGB(0.0,       #=1.11e-16=#2.2204460492503126e-16, 0.0)                    RGB(0.49999999999999994, 0.33333333333333326, 0.4999999999999999)
            RGB(0.0, 0.0, 0.0)                RGB(0.0,                   2.2204460492503126e-16, 0.0)                    RGB(0.5,                 0.3333333333333333,  0.49999999999999994)
            RGB(0.0, 0.0, 0.0)                RGB(2.220446049250313e-16, 4.440892098500625e-16,  1.1102230246251568e-16) RGB(0.5000000000000001,  0.3333333333333335,  0.5000000000000001)
            RGB(0.0, 0.0, 0.0)                RGB(0.5,                   0.5000000000000001,     0.49999999999999994)    RGB(0.75,                0.6666666666666666,  0.75)
            RGB(0.0, 0.0, 0.9999999999999996) RGB(0.9999999999999998,    0.9999999999999998,     0.9999999999999998)     RGB(0.9999999999999999,  0.9999999999999999,  0.9999999999999999)
            RGB(1.0, 1.0, 1.0)                RGB(1.0,                   1.0,                    1.0)                    RGB(1.0,                 1.0,                 1.0)
        ])
    end

    @testset "RGBA over RGB: $T" for T in Ts
        @test BlendColorBurn(RGB{T}(1, 0.75, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGB{T}(1.0, 0.6, 0.0)
    end

    @testset "RGB over RGBA: $T" for T in Ts
        @test BlendColorBurn(RGBA{T}(1, 0.75, 0, 0.6), RGB{T}(0, 0.5, 1)) ≈ RGBA{T}(0.6, 0.5, 0.4, 1)
    end

    @testset "RGBA over RGBA: $T" for T in Ts
        @test BlendColorBurn(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(5/7, 4/7, 2/7, 0.84)
    end
end

@testset "hard-light" begin
    @testset "RGB over RGB" begin
        test_rgb_over_rgb(BlendHardLight, RGB{Float64}[
            RGB(0.0, 0.0,                     0.0)                     RGB(0.0,                     2.220446049250313e-16, 0.0)                     RGB(1.0, 0.5,   0.9999999999999998)
            RGB(0.0, 0.0,                     1.1125369292536007e-308) RGB(2.2250738585072014e-308, 2.220446049250313e-16, 2.2250738585072014e-308) RGB(1.0, 0.5,   0.9999999999999998)
            RGB(0.0, 1.1125369292536007e-308, 0.125)                   RGB(0.25,                    0.25000000000000017,   0.24999999999999997)     RGB(1.0, 0.625, 0.9999999999999998)
            RGB(0.0, 2.2250738585072014e-308, 0.24999999999999997)     RGB(0.49999999999999994,     0.5000000000000001,    0.4999999999999999)      RGB(1.0, 0.75,  0.9999999999999999)
            RGB(0.0, 2.2250738585072014e-308, 0.25)                    RGB(0.5,                     0.5000000000000001,    0.49999999999999994)     RGB(1.0, 0.75,  0.9999999999999999)
            RGB(0.0, 2.225073858507202e-308,  0.25000000000000006)     RGB(0.5000000000000001,      0.5000000000000002,    0.5)                     RGB(1.0, 0.75,  0.9999999999999999)
            RGB(0.0, 3.337610787760802e-308,  0.375)                   RGB(0.75,                    0.75,                  0.7499999999999999)      RGB(1.0, 0.875, 1.0)
            RGB(0.0, 4.4501477170144023e-308, 0.49999999999999994)     RGB(0.9999999999999999,      0.9999999999999999,    0.9999999999999998)      RGB(1.0, 1.0,   1.0)
            RGB(0.0, 4.450147717014403e-308,  0.5)                     RGB(1.0,                     1.0,                   0.9999999999999999)      RGB(1.0, 1.0,   1.0)
        ])
    end

    @testset "RGBA over RGB: $T" for T in Ts
        @test BlendHardLight(RGB{T}(1, 0.75, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGB{T}(0.4, 0.75, 0.6)
    end

    @testset "RGB over RGBA: $T" for T in Ts
        @test BlendHardLight(RGBA{T}(1, 0.75, 0, 0.6), RGB{T}(0, 0.5, 1)) ≈ RGBA{T}(0.0, 0.65, 1.0, 1)
    end

    @testset "RGBA over RGBA: $T" for T in Ts
        @test BlendHardLight(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(2/7, 19/28, 5/7, 0.84)
    end
end

@testset "soft-light" begin
    @testset "RGB over RGB" begin
        test_rgb_over_rgb(BlendSoftLight, RGB{Float64}[
            RGB(0.0,                 0.0,                 0.0)                     RGB(0.0,                     0.0,                    0.0)                     RGB(0.0,                    0.0,                    0.0)
            RGB(0.0,                 0.0,                 1.1125369292536007e-308) RGB(2.2250738585072014e-308, 2.225073858507203e-308, 2.2250738585072014e-308) RGB(8.900295434028806e-308, 5.562684646268003e-308, 8.900295434028804e-308)
            RGB(0.0625,              0.0625,              0.15625)                 RGB(0.25,                    0.25000000000000006,    0.24999999999999997)     RGB(0.5,                    0.375,                  0.49999999999999994)
            RGB(0.24999999999999994, 0.24999999999999994, 0.37499999999999994)     RGB(0.49999999999999994,     0.5,                    0.49999999999999994)     RGB(0.7071067811865475,     0.6035533905932737,     0.7071067811865475)
            RGB(0.25,                0.25,                0.375)                   RGB(0.5,                     0.5,                    0.5)                     RGB(0.7071067811865476,     0.6035533905932737,     0.7071067811865475)
            RGB(0.2500000000000001,  0.2500000000000001,  0.3750000000000001)      RGB(0.5000000000000001,      0.5000000000000001,     0.5000000000000001)      RGB(0.7071067811865476,     0.6035533905932738,     0.7071067811865476)
            RGB(0.5625,              0.5625,              0.65625)                 RGB(0.75,                    0.75,                   0.75)                    RGB(0.8660254037844386,     0.8080127018922193,     0.8660254037844386)
            RGB(0.9999999999999998,  0.9999999999999998,  0.9999999999999999)      RGB(0.9999999999999999,      0.9999999999999999,     0.9999999999999999)      RGB(0.9999999999999999,     0.9999999999999999,     0.9999999999999999)
            RGB(1.0,                 1.0,                 1.0)                     RGB(1.0,                     1.0,                    1.0)                     RGB(1.0,                    1.0,                    1.0)
        ])
    end

    @testset "RGBA over RGB: $T" for T in Ts
        @test BlendSoftLight(RGB{T}(1, 0.75, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGB{T}(1.0, 0.75, 0.0)
    end

    @testset "RGB over RGBA: $T" for T in Ts
        @test BlendSoftLight(RGBA{T}(1, 0.75, 0, 0.6), RGB{T}(0, 0.5, 1)) ≈ RGBA{T}(0.6, 0.65, 0.4, 1)
    end

    @testset "RGBA over RGBA: $T" for T in Ts
        @test BlendSoftLight(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(5/7, 19/28, 2/7, 0.84)
    end
end

@testset "difference" begin
    @testset "RGB over RGB" begin
        test_rgb_over_rgb(BlendDifference, RGB{Float64}[
            RGB(0.0,                     2.2250738585072014e-308, 0.25)                RGB(0.5,                    0.5000000000000001,     0.49999999999999994)    RGB(1.0,                    0.75,                0.9999999999999999)
            RGB(2.2250738585072014e-308, 0.0,                     0.25)                RGB(0.5,                    0.5000000000000001,     0.49999999999999994)    RGB(1.0,                    0.75,                0.9999999999999999)
            RGB(0.25,                    0.25,                    0.0)                 RGB(0.25,                   0.2500000000000001,     0.24999999999999994)    RGB(0.75,                   0.5,                 0.7499999999999999)
            RGB(0.49999999999999994,     0.49999999999999994,     0.24999999999999994) RGB(5.551115123125783e-17,  1.6653345369377348e-16, 0.0)                    RGB(0.5,                    0.25000000000000006, 0.49999999999999994)
            RGB(0.5,                     0.5,                     0.25)                RGB(0.0,                    1.1102230246251565e-16, 5.551115123125783e-17)  RGB(0.5,                    0.25,                0.4999999999999999)
            RGB(0.5000000000000001,      0.5000000000000001,      0.2500000000000001)  RGB(1.1102230246251565e-16, 0.0,                    1.6653345369377348e-16) RGB(0.4999999999999999,     0.2499999999999999,  0.4999999999999998)
            RGB(0.75,                    0.75,                    0.5)                 RGB(0.25,                   0.2499999999999999,     0.25000000000000006)    RGB(0.25,                   0.0,                 0.2499999999999999)
            RGB(0.9999999999999999,      0.9999999999999999,      0.7499999999999999)  RGB(0.4999999999999999,     0.4999999999999998,     0.49999999999999994)    RGB(1.1102230246251565e-16, 0.2499999999999999,  0.0)
            RGB(1.0,                     1.0,                     0.75)                RGB(0.5,                    0.4999999999999999,     0.5)                    RGB(0.0,                    0.25,                1.1102230246251565e-16)
        ])
    end

    @testset "RGBA over RGB: $T" for T in Ts
        @test BlendDifference(RGB{T}(1, 0.75, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGB{T}(1.0, 0.45, 0.6)
    end

    @testset "RGB over RGBA: $T" for T in Ts
        @test BlendDifference(RGBA{T}(1, 0.75, 0, 0.6), RGB{T}(0, 0.5, 1)) ≈ RGBA{T}(0.6, 0.35, 1.0, 1)
    end

    @testset "RGBA over RGBA: $T" for T in Ts
        @test BlendDifference(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(5/7, 13/28, 5/7, 0.84)
    end
end

@testset "exclusion" begin
    @testset "RGB over RGB" begin
        test_rgb_over_rgb(BlendExclusion, RGB{Float64}[
            RGB(0.0,                     2.2250738585072014e-308, 0.25)  RGB(0.5, 0.5000000000000001,  0.49999999999999994) RGB(1.0,                    0.75,                0.9999999999999999)
            RGB(2.2250738585072014e-308, 4.450147717014403e-308,  0.25)  RGB(0.5, 0.5000000000000001,  0.49999999999999994) RGB(1.0,                    0.75,                0.9999999999999999)
            RGB(0.25,                    0.25,                    0.375) RGB(0.5, 0.5,                 0.5)                 RGB(0.75,                   0.625,               0.75)
            RGB(0.49999999999999994,     0.49999999999999994,     0.5)   RGB(0.5, 0.5,                 0.5)                 RGB(0.5,                    0.5,                 0.5)
            RGB(0.5,                     0.5,                     0.5)   RGB(0.5, 0.5,                 0.5)                 RGB(0.5,                    0.5,                 0.5)
            RGB(0.5000000000000001,      0.5000000000000001,      0.5)   RGB(0.5, 0.5,                 0.5)                 RGB(0.4999999999999999,     0.49999999999999994, 0.4999999999999999)
            RGB(0.75,                    0.75,                    0.625) RGB(0.5, 0.49999999999999994, 0.5)                 RGB(0.25,                   0.375,               0.25000000000000006)
            RGB(0.9999999999999999,      0.9999999999999999,      0.75)  RGB(0.5, 0.4999999999999999,  0.5)                 RGB(1.1102230246251565e-16, 0.25000000000000006, 2.2204460492503128e-16)
            RGB(1.0,                     1.0,                     0.75)  RGB(0.5, 0.4999999999999999,  0.5)                 RGB(0.0,                    0.25,                1.1102230246251565e-16)
        ])
    end

    @testset "RGBA over RGB: $T" for T in Ts
        @test BlendExclusion(RGB{T}(1, 0.75, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGB{T}(1.0, 0.6, 0.6)
    end

    @testset "RGB over RGBA: $T" for T in Ts
        @test BlendExclusion(RGBA{T}(1, 0.75, 0, 0.6), RGB{T}(0, 0.5, 1)) ≈ RGBA{T}(0.6, 0.5, 1.0, 1)
    end

    @testset "RGBA over RGBA: $T" for T in Ts
        @test BlendExclusion(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(5/7, 4/7, 5/7, 0.84)
    end
end

@testset "hue" begin
    @testset "RGB over RGB" begin
        test_rgb_over_rgb(BlendHue, RGB{Float64}[
            RGB(0.0,                     0.0,                     0.0)                     RGB(0.0,                     0.0,                     0.0)                     RGB(0.0,                     0.0,                     0.0)
            RGB(2.2250738585072014e-308, 2.2250738585072014e-308, 2.2250738585072014e-308) RGB(2.2250738585072014e-308, 2.2250738585072014e-308, 2.2250738585072014e-308) RGB(2.2250738585072014e-308, 2.2250738585072014e-308, 2.2250738585072014e-308)
            RGB(0.25,                    0.25,                    0.25)                    RGB(0.25,                    0.25,                    0.25)                    RGB(0.25,                    0.25,                    0.25)
            RGB(0.49999999999999994,     0.49999999999999994,     0.49999999999999994)     RGB(0.49999999999999994,     0.49999999999999994,     0.49999999999999994)     RGB(0.49999999999999994,     0.49999999999999994,     0.49999999999999994)
            RGB(0.5,                     0.5,                     0.5)                     RGB(0.5,                     0.5,                     0.5)                     RGB(0.5,                     0.5,                     0.5)
            RGB(0.5000000000000001,      0.5000000000000001,      0.5000000000000001)      RGB(0.5000000000000001,      0.5000000000000001,      0.5000000000000001)      RGB(0.5000000000000001,      0.5000000000000001,      0.5000000000000001)
            RGB(0.75,                    0.75,                    0.75)                    RGB(0.75,                    0.75,                    0.75)                    RGB(0.75,                    0.75,                    0.75)
            RGB(0.9999999999999999,      0.9999999999999999,      0.9999999999999999)      RGB(0.9999999999999999,      0.9999999999999999,      0.9999999999999999)      RGB(0.9999999999999999,      0.9999999999999999,      0.9999999999999999)
            RGB(1.0,                     1.0,                     1.0)                     RGB(1.0,                     1.0,                     1.0)                     RGB(1.0,                     1.0,                     1.0)
        ])
    end

    @testset "RGBA over RGB: $T" for T in Ts
        @test BlendHue(RGB{T}(1, 0.75, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGB{T}(0.740, 0.770, 0.6) atol=max(0.0005, eps(T))
    end

    @testset "RGB over RGBA: $T" for T in Ts
        @test BlendHue(RGBA{T}(1, 0.75, 0, 0.6), RGB{T}(0, 0.5, 1)) ≈ RGBA{T}(0.340, 0.670, 1.0, 1) atol=max(0.0005, eps(T))
    end

    @testset "RGBA over RGBA: $T" for T in Ts
        @test BlendHue(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0.529, 0.693, 5/7, 0.84) atol=max(0.0005, eps(T))
    end
end

@testset "saturation" begin
    @testset "RGB over RGB" begin
        test_rgb_over_rgb(BlendSaturation, RGB{Float64}[
            RGB(0.0,                     0.0,                     0.0)                     RGB(0.0,                     0.0,                     0.0)                     RGB(0.0,                     0.0,                     0.0)
            RGB(2.2250738585072014e-308, 2.2250738585072014e-308, 2.2250738585072014e-308) RGB(2.2250738585072014e-308, 2.2250738585072014e-308, 2.2250738585072014e-308) RGB(2.2250738585072014e-308, 2.2250738585072014e-308, 2.2250738585072014e-308)
            RGB(0.25,                    0.25,                    0.25)                    RGB(0.25,                    0.25,                    0.25)                    RGB(0.25,                    0.25,                    0.25)
            RGB(0.49999999999999994,     0.49999999999999994,     0.49999999999999994)     RGB(0.49999999999999994,     0.49999999999999994,     0.49999999999999994)     RGB(0.49999999999999994,     0.49999999999999994,     0.49999999999999994)
            RGB(0.5,                     0.5,                     0.5)                     RGB(0.5,                     0.5,                     0.5)                     RGB(0.5,                     0.5,                     0.5)
            RGB(0.5000000000000001,      0.5000000000000001,      0.5000000000000001)      RGB(0.5000000000000001,      0.5000000000000001,      0.5000000000000001)      RGB(0.5000000000000001,      0.5000000000000001,      0.5000000000000001)
            RGB(0.75,                    0.75,                    0.75)                    RGB(0.75,                    0.75,                    0.75)                    RGB(0.75,                    0.75,                    0.75)
            RGB(0.9999999999999999,      0.9999999999999999,      0.9999999999999999)      RGB(0.9999999999999999,      0.9999999999999999,      0.9999999999999999)      RGB(0.9999999999999999,      0.9999999999999999,      0.9999999999999999)
            RGB(1.0,                     1.0,                     1.0)                     RGB(1.0,                     1.0,                     1.0)                     RGB(1.0,                     1.0,                     1.0)
        ])
    end

    @testset "RGBA over RGB: $T" for T in Ts
        @test BlendSaturation(RGB{T}(1, 0.75, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGB{T}(1.0, 0.75, 0.0)
    end

    @testset "RGB over RGBA: $T" for T in Ts
        @test BlendSaturation(RGBA{T}(1, 0.75, 0, 0.6), RGB{T}(0, 0.5, 1)) ≈ RGBA{T}(0.6, 0.65, 0.4, 1)
    end

    @testset "RGBA over RGBA: $T" for T in Ts
        @test BlendSaturation(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(5/7, 19/28, 2/7, 0.84)
    end
end

@testset "color" begin
    @testset "RGB over RGB" begin
        test_rgb_over_rgb(BlendColor, RGB{Float64}[
            RGB(0.0,                0.0,                0.0)                     RGB(0.0,                     0.0,                    0.0)                 RGB(0.0,                    0.0,                 0.0)
            RGB(0.0,                0.0,                2.0227944168247287e-307) RGB(1.0749149074914015e-308, 3.224744722474205e-308, 0.0)                 RGB(5.427009410993175e-308, 0.0,                 5.427009410993172e-308)
            RGB(0.2225,             0.2225,             0.4725)                  RGB(0.24999999999999994,     0.25000000000000006,    0.2499999999999999)  RGB(0.3975,                 0.14750000000000002, 0.3974999999999999)
            RGB(0.4724999999999999, 0.4724999999999999, 0.7224999999999999)      RGB(0.4999999999999999,      0.5,                    0.49999999999999983) RGB(0.6475,                 0.39749999999999996, 0.6474999999999999)
            RGB(0.4725,             0.4725,             0.7225)                  RGB(0.49999999999999994,     0.5,                    0.4999999999999999)  RGB(0.6475,                 0.3975,              0.6474999999999999)
            RGB(0.4725000000000001, 0.4725000000000001, 0.7225000000000001)      RGB(0.5,                     0.5000000000000001,     0.5)                 RGB(0.6475000000000001,     0.39750000000000013, 0.6475)
            RGB(0.7225,             0.7225,             0.9725)                  RGB(0.7499999999999999,      0.75,                   0.7499999999999999)  RGB(0.8975,                 0.6475,              0.8974999999999999)
            RGB(0.9999999999999999, 1.0,                1.0)                     RGB(0.9999999999999998,      0.9999999999999999,     0.9999999999999998)  RGB(1.0,                    1.0,                 1.0)
            RGB(1.0,                1.0,                1.0)                     RGB(1.0,                     1.0,                    1.0)                 RGB(1.0,                    1.0,                 1.0)
        ])
    end

    @testset "RGBA over RGB: $T" for T in Ts
        @test BlendColor(RGB{T}(1, 0.75, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGB{T}(0.740, 0.770, 0.6) atol=max(0.0005, eps(T))
    end

    @testset "RGB over RGBA: $T" for T in Ts
        @test BlendColor(RGBA{T}(1, 0.75, 0, 0.6), RGB{T}(0, 0.5, 1)) ≈ RGBA{T}(0.340, 0.670, 1.0, 1) atol=max(0.0005, eps(T))
    end

    @testset "RGBA over RGBA: $T" for T in Ts
        @test BlendColor(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0.529, 0.693, 5/7, 0.84) atol=max(0.0005, eps(T))
    end
end

@testset "luminosity" begin
    @testset "RGB over RGB" begin
        test_rgb_over_rgb(BlendLuminosity, RGB{Float64}[
            RGB(0.0275, 0.0275, 0.0275) RGB(0.5000000000000001, 0.5000000000000001, 0.5000000000000001) RGB(0.8525, 0.8525, 0.8525)
            RGB(0.0275, 0.0275, 0.0275) RGB(0.5000000000000001, 0.5000000000000001, 0.5000000000000001) RGB(0.8525, 0.8525, 0.8525)
            RGB(0.0275, 0.0275, 0.0275) RGB(0.5000000000000001, 0.5000000000000001, 0.5000000000000001) RGB(0.8525, 0.8525, 0.8525)
            RGB(0.0275, 0.0275, 0.0275) RGB(0.5000000000000001, 0.5000000000000001, 0.5000000000000001) RGB(0.8525, 0.8525, 0.8525)
            RGB(0.0275, 0.0275, 0.0275) RGB(0.5000000000000001, 0.5000000000000001, 0.5000000000000001) RGB(0.8525, 0.8525, 0.8525)
            RGB(0.0275, 0.0275, 0.0275) RGB(0.5000000000000001, 0.5000000000000001, 0.5000000000000001) RGB(0.8525, 0.8525, 0.8525)
            RGB(0.0275, 0.0275, 0.0275) RGB(0.5000000000000001, 0.5000000000000001, 0.5000000000000001) RGB(0.8525, 0.8525, 0.8525)
            RGB(0.0275, 0.0275, 0.0275) RGB(0.5000000000000001, 0.5000000000000001, 0.5000000000000001) RGB(0.8525, 0.8525, 0.8525)
            RGB(0.0275, 0.0275, 0.0275) RGB(0.5000000000000001, 0.5000000000000001, 0.5000000000000001) RGB(0.8525, 0.8525, 0.8525)
        ])
    end

    @testset "RGBA over RGB: $T" for T in Ts
        @test BlendLuminosity(RGB{T}(1, 0.75, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGB{T}(0.727, 0.545, 0.0) atol=max(0.0005, eps(T))
    end

    @testset "RGB over RGBA: $T" for T in Ts
        @test BlendLuminosity(RGBA{T}(1, 0.75, 0, 0.6), RGB{T}(0, 0.5, 1)) ≈ RGBA{T}(0.327, 0.445, 0.4, 1) atol=max(0.0005, eps(T))
    end

    @testset "RGBA over RGBA: $T" for T in Ts
        @test BlendLuminosity(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0.519, 0.532, 2/7, 0.84) atol=max(0.0005, eps(T))
    end
end

@testset "Gray" begin
    @testset "$(keyword(m))" for m in separable_modes
        @testset "Gray over Gray" begin
            test_gray_over_gray(m)
        end

        @testset "GrayA over Gray: $T" for T in Ts
            rgb = m(RGB{T}(1, 0.75, 0), RGBA{T}(0, 0.5, 1, 0.6))
            actual = (m(Gray{T}(1.0),  GrayA{T}(0.0, 0.6)),
                      m(Gray{T}(0.75), GrayA{T}(0.5, 0.6)),
                      m(Gray{T}(0.0),  GrayA{T}(1.0, 0.6)))
            expected = Gray{T}.((red(rgb), green(rgb), blue(rgb)))
            @test all(t -> t[1] ≈ t[2], zip(actual, expected))
        end

        @testset "Gray over GrayA: $T" for T in Ts
            rgb = m(RGBA{T}(1, 0.75, 0, 0.6), RGB{T}(0, 0.5, 1))
            actual = (m(GrayA{T}(1.0,  0.6), Gray{T}(0.0)),
                      m(GrayA{T}(0.75, 0.6), Gray{T}(0.5)),
                      m(GrayA{T}(0.0,  0.6), Gray{T}(1.0)))
            expected = GrayA{T}.((red(rgb), green(rgb), blue(rgb)), alpha(rgb))
            @test all(t -> t[1] ≈ t[2], zip(actual, expected))
        end

        @testset "GrayA over GrayA: $T" for T in Ts
            rgb = m(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6))
            actual = (m(GrayA{T}(1.0,  0.6), GrayA{T}(0.0, 0.6)),
                      m(GrayA{T}(0.75, 0.6), GrayA{T}(0.5, 0.6)),
                      m(GrayA{T}(0.0,  0.6), GrayA{T}(1.0, 0.6)))
            expected = GrayA{T}.((red(rgb), green(rgb), blue(rgb)), alpha(rgb))
            @test all(t -> t[1] ≈ t[2], zip(actual, expected))
        end
    end
end

@testset "Gray over RGB" begin
    @testset "$(keyword(m))" for m in separable_modes
        @testset "Gray over RGB" begin
            test_gray_over_rgb(m)
        end

        @testset "GrayA over RGB: $T" for T in Ts
            grays = (GrayA{T}(0.0, 0.6), GrayA{T}(0.5, 0.6), GrayA{T}(1.0, 0.6))
            actual = m.(RGB{T}(1, 0.75, 0), grays)
            expected = m.(RGB{T}(1, 0.75, 0), RGBA{T}.(grays))
            @test all(t -> t[1] ≈ t[2], zip(actual, expected))
        end

        @testset "Gray over RGBA: $T" for T in Ts
            grays = (Gray{T}(0.0), Gray{T}(0.5), Gray{T}(1.0))
            actual = m.(RGBA{T}(1, 0.75, 0, 0.6), grays)
            expected = m.(RGBA{T}(1, 0.75, 0, 0.6), RGB{T}.(grays))
            @test all(t -> t[1] ≈ t[2], zip(actual, expected))
        end

        @testset "GrayA over RGBA: $T" for T in Ts
            grays = (GrayA{T}(0.0, 0.6), GrayA{T}(0.5, 0.6), GrayA{T}(1.0, 0.6))
            actual = m.(RGBA{T}(1, 0.75, 0, 0.6), grays)
            expected = m.(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}.(grays))
            @test all(t -> t[1] ≈ t[2], zip(actual, expected))
        end
    end
end

@testset "RGB over Gray" begin
    @testset "$(keyword(m))" for m in separable_modes
        @testset "RGB over Gray" begin
            test_rgb_over_gray(m)
        end

        @testset "RGBA over Gray: $T" for T in Ts
            grays = (Gray{T}(1.0), Gray{T}(0.75), Gray{T}(0.0))
            actual = m.(grays, RGBA{T}(0.0, 0.6, 1.0, 0.6))
            expected = m.(grays, GrayA{T}(0.464, 0.6))
            @test all(t -> t[1] ≈ t[2], zip(actual, expected))
        end

        @testset "RGB over GrayA: $T" for T in Ts
            grays = (GrayA{T}(1.0, 0.6), GrayA{T}(0.75, 0.6), GrayA{T}(0.0, 0.6))
            actual = m.(grays, RGB{T}(0, 0.6, 1))
            expected = m.(grays, Gray{T}(0.464))
            @test all(t -> t[1] ≈ t[2], zip(actual, expected))
        end

        @testset "RGBA over GrayA: $T" for T in Ts
            grays = (GrayA{T}(1.0, 0.6), GrayA{T}(0.75, 0.6), GrayA{T}(0.0, 0.6))
            actual = m.(grays, RGBA{T}(0.0, 0.6, 1.0, 0.6))
            expected = m.(grays, GrayA{T}(0.464, 0.6))
            @test all(t -> t[1] ≈ t[2], zip(actual, expected))
        end
    end
end

@testset "RGB24/ARGB32/Gray24/AGray32" begin
    @test BlendHue(       RGB24(1, 0.8, 0), RGB24(0, 0.4, 1))       === RGB24(0.651, 0.792, 1.0)
    @test BlendSaturation(RGB24(1, 0.8, 0), ARGB32(0, 0.4, 1, 0.6)) === RGB24(1, 0.8, 0)
    @test BlendColor(     RGB24(1, 0.8, 0), Gray24(0.4))            === RGB24(0.773, 0.773, 0.773)
    @test BlendLuminosity(RGB24(1, 0.8, 0), AGray32(0.4, 0.6))      === RGB24(0.710, 0.573, 0.000)
    @test BlendNormal(  ARGB32(1, 0.8, 0, 0.6), RGB24(0, 0.4, 1))       === ARGB32(0, 0.4, 1, 1)
    @test BlendMultiply(ARGB32(1, 0.8, 0, 0.6), ARGB32(0, 0.4, 1, 0.6)) === ARGB32(0.286, 0.478, 0.286, 0.84)
    @test BlendScreen(  ARGB32(1, 0.8, 0, 0.6), Gray24(0.4))            === ARGB32(0.761, 0.686, 0.400, 1)
    @test BlendOverlay( ARGB32(1, 0.8, 0, 0.6), AGray32(0.4, 0.6))      === ARGB32(0.827, 0.667, 0.114, 0.84)
    @test BlendDarken(    Gray24(0.8), RGB24(0, 0.4, 1))       === Gray24(0.345)
    @test BlendLighten(   Gray24(0.8), ARGB32(0, 0.4, 1, 0.6)) === Gray24(0.8)
    @test BlendColorDodge(Gray24(0.8), Gray24(0.4))            === Gray24(1.0)
    @test BlendColorBurn( Gray24(0.8), AGray32(0.4, 0.6))      === Gray24(0.624) # 0.5 -> 0.502N0f8
    @test BlendHardLight( AGray32(0.8, 0.6), RGB24(0, 0.4, 1))       === AGray32(0.471, 1)
    @test BlendSoftLight( AGray32(0.8, 0.6), ARGB32(0, 0.4, 1, 0.6)) === AGray32(0.647, 0.84)
    @test BlendDifference(AGray32(0.8, 0.6), Gray24(0.4))            === AGray32(0.4, 1)
    @test BlendExclusion( AGray32(0.8, 0.6), AGray32(0.4, 0.6))      === AGray32(0.584, 0.84)
end

@testset "$C" for C in (Lab, Luv)
    @testset "$C over $C: $T" for T in (Float64, Float32)
        @test BlendNormal(C{T}(90,  80,  70), C{T}(60,  50, -40)) ≈ C{T}(60, 50, -40)
        @test BlendNormal(C{T}(10, -20, -30), C{T}(40, -50,  60)) ≈ C{T}(40, -50, 60)
        @test BlendMultiply(C{T}(90,  80,  70), C{T}(60,  50, -40)) ≈ C{T}(54, 98.75, 51.875)
        @test BlendMultiply(C{T}(10, -20, -30), C{T}(40, -50,  60)) ≈ C{T}(4, -62.1875, 15.9375)
        @test BlendScreen(C{T}(90,  80,  70), C{T}(60,  50, -40)) ≈ C{T}(96, 98.75, 51.875)
        @test BlendScreen(C{T}(10, -20, -30), C{T}(40, -50,  60)) ≈ C{T}(46, -62.1875, 15.9375)
        @test BlendOverlay(C{T}(90,  80,  70), C{T}(60,  50, -40)) ≈ C{T}(92, 98.75, 51.875)
        @test BlendOverlay(C{T}(10, -20, -30), C{T}(40, -50,  60)) ≈ C{T}(8, -62.1875, 15.9375)
        @test BlendHardLight(C{T}(90,  80,  70), C{T}(60,  50, -40)) ≈ C{T}(92, 98.75, 8.125)
        @test BlendHardLight(C{T}(10, -20, -30), C{T}(40, -50,  60)) ≈ C{T}(8, -62.1875, 44.0625)
        @test BlendSoftLight(C{T}(90,  80,  70), C{T}(60,  50, -40)) ≈ C{T}(90.97366596101027, 88.88878188659973, 55.9814453125)
        @test BlendSoftLight(C{T}(10, -20, -30), C{T}(40, -50,  60)) ≈ C{T}(8.2, -44.3896484375, -1.6912879754125099)
        @test BlendHue(C{T}(90,  80,  70), C{T}(60,  50, -40)) ≈ C{T}(90, 80, -64)
        @test BlendHue(C{T}(10, -20, -30), C{T}(40, -50,  60)) ≈ C{T}(10, -25, 30)
        @test BlendSaturation(C{T}(90,  80,  70), C{T}(60,  50, -40)) ≈ C{T}(90, 50, 43.75)
        @test BlendSaturation(C{T}(10, -20, -30), C{T}(40, -50,  60)) ≈ C{T}(10, -40, -60)
        @test BlendColor(C{T}(90,  80,  70), C{T}(60,  50, -40)) ≈ C{T}(90, 50, -40)
        @test BlendColor(C{T}(10, -20, -30), C{T}(40, -50,  60)) ≈ C{T}(10, -50, 60)
        @test BlendLuminosity(C{T}(90,  80,  70), C{T}(60,  50, -40)) ≈ C{T}(60, 80, 70)
        @test BlendLuminosity(C{T}(10, -20, -30), C{T}(40, -50,  60)) ≈ C{T}(40, -20, -30)
    end

    A = coloralpha(C)
    @testset "$A over $C: $T" for T in (Float64, Float32)
        @test BlendNormal(C{T}(90, 80, 70), A{T}(60, 50, -40, 0.6)) ≈ C{T}(72, 62, 4)
    end

    @testset "$C over $A: $T" for T in (Float64, Float32)
        @test BlendNormal(A{T}(90, 80, 70, 0.6), C{T}(60, 50, -40)) ≈ A{T}(60, 50, -40, 1)
    end

    @testset "$A over $A: $T" for T in (Float64, Float32)
        @test BlendNormal(A{T}(90, 80, 70, 0.6), A{T}(60, 50, -40, 0.6)) ≈ A{T}(68.57142857142857, 58.57142857142857, -8.57142857142857, 0.84)
    end
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
end
