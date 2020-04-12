
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
