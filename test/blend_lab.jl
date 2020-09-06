
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

@testset "$C" for C in (LCHab, LCHuv)
    @testset "$C over gray $C: $T" for T in (Float64, Float32)
        @test blend(C{T}(40, 0, 100), C{T}(60, 100, 200), opacity=0.5) ≈ C{T}(50, 50, 200)
    end
end
