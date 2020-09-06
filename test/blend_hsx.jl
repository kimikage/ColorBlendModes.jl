
@testset "$C" for C in (HSV, HSL, HSI)
    @testset "$C over $C: $T" for T in (Float64, Float32)
        @test BlendNormal(    C{T}(100,  0.75,  0), C{T}(0, 0.5, 1)) ≈ C{T}(0, 0.5, 1)
        @test BlendHue(       C{T}(100,  0.75,  0), C{T}(0, 0.5, 1)) ≈ C{T}(0, 0.75, 0)
        @test BlendSaturation(C{T}(100,  0.75,  0), C{T}(0, 0.5, 1)) ≈ C{T}(100, 0.5, 0)
        @test BlendColor(     C{T}(100,  0.75,  0), C{T}(0, 0.5, 1)) ≈ C{T}(0, 0.5, 0)
        @test BlendLuminosity(C{T}(100,  0.75,  0), C{T}(0, 0.5, 1)) ≈ C{T}(100, 0.75, 1)
    end

    A = coloralpha(C)
    @testset "$A over $C: $T" for T in (Float64, Float32)
        @test BlendNormal(C{T}(100,  0.75,  0), A{T}(0, 0.5, 1, 0.6)) ≈ C{T}(40, 0.6, 0.6)
    end

    @testset "$C over $A: $T" for T in (Float64, Float32)
        @test BlendNormal(A{T}(100,  0.75, 0, 0.6), C{T}(0, 0.5, 1)) ≈ A{T}(0, 0.5, 1, 1)
    end

    @testset "$A over $A: $T" for T in (Float64, Float32)
        @test BlendNormal(A{T}(100,  0.75, 0, 0.6), A{T}(0, 0.5, 1, 0.6)) ≈ A{T}(200/7, 4/7, 5/7, 0.84)
    end

    @testset "$C over gray $C: $T" for T in (Float64, Float32)
        @test blend(C{T}(100, 0, 1), C{T}(200, 1, 0.5), opacity=0.5) ≈ C{T}(200, 0.5, 0.75)
    end
end
