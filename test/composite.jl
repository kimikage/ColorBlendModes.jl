
@testset "composite: RGB" begin
    @testset "clear: $T" for T in Ts
        @test CompositeClear(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0, 0, 0, 0)
    end
    @testset "copy: $T" for T in Ts
        @test CompositeCopy(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0, 0.5, 1, 0.6)
    end
    @testset "destination: $T" for T in Ts
        @test CompositeDestination(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(1, 0.75, 0, 0.6)
    end
    @testset "source-over: $T" for T in Ts
        @test CompositeSourceOver(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(2/7, 4/7, 5/7, 0.84)
        @test CompositeSourceOver(RGBA{T}(1, 0.75, 0, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0, 0.5, 1, 0.6)
        @test CompositeSourceOver(RGBA{T}(1, 0.75, 0, 1), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0.4, 0.6, 0.6, 1)
    end
    @testset "destination-over: $T" for T in Ts
        @test CompositeDestinationOver(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(5/7, 19/28, 2/7, 0.84)
        @test CompositeDestinationOver(RGBA{T}(1, 0.75, 0, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0, 0.5, 1, 0.6)
        @test CompositeDestinationOver(RGBA{T}(1, 0.75, 0, 1), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(1, 0.75, 0, 1)
    end
    @testset "source-in: $T" for T in Ts
        @test CompositeSourceIn(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0, 0.5, 1, 0.36)
        @test CompositeSourceIn(RGBA{T}(1, 0.75, 0, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0, 0, 0, 0)
        @test CompositeSourceIn(RGBA{T}(1, 0.75, 0, 1), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0, 0.5, 1, 0.6)
    end
    @testset "destination-in: $T" for T in Ts
        @test CompositeDestinationIn(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(1, 0.75, 0, 0.36)
        @test CompositeDestinationIn(RGBA{T}(1, 0.75, 0, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0, 0, 0, 0)
        @test CompositeDestinationIn(RGBA{T}(1, 0.75, 0, 1), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(1, 0.75, 0, 0.6)
    end
    @testset "source-out: $T" for T in Ts
        @test CompositeSourceOut(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0, 0.5, 1, 0.24)
        @test CompositeSourceOut(RGBA{T}(1, 0.75, 0, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0, 0.5, 1, 0.6)
        @test CompositeSourceOut(RGBA{T}(1, 0.75, 0, 1), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0, 0, 0, 0)
    end
    @testset "destination-out: $T" for T in Ts
        @test CompositeDestinationOut(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(1, 0.75, 0, 0.24)
        @test CompositeDestinationOut(RGBA{T}(1, 0.75, 0, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0, 0, 0, 0)
        @test CompositeDestinationOut(RGBA{T}(1, 0.75, 0, 1), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(1, 0.75, 0, 0.4)
    end
    @testset "source-atop: $T" for T in Ts
        @test CompositeSourceAtop(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0.4, 0.6, 0.6, 0.6)
        @test CompositeSourceAtop(RGBA{T}(1, 0.75, 0, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0, 0, 0, 0)
        @test CompositeSourceAtop(RGBA{T}(1, 0.75, 0, 1), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0.4, 0.6, 0.6, 1)
    end
    @testset "destination-atop: $T" for T in Ts
        @test CompositeDestinationAtop(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0.6, 0.65, 0.4, 0.6)
        @test CompositeDestinationAtop(RGBA{T}(1, 0.75, 0, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0, 0.5, 1, 0.6)
        @test CompositeDestinationAtop(RGBA{T}(1, 0.75, 0, 1), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(1, 0.75, 0, 0.6)
    end
    @testset "xor: $T" for T in Ts
        @test CompositeXor(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0.5, 0.625, 0.5, 0.48)
        @test CompositeXor(RGBA{T}(1, 0.75, 0, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0, 0.5, 1, 0.6)
        @test CompositeXor(RGBA{T}(1, 0.75, 0, 1), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(1, 0.75, 0, 0.4)
    end
    @testset "lighter: $T" for T in Ts
        @test CompositeLighter(RGBA{T}(1, 0.75, 0, 0.6), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0.6, 0.75, 0.6, 1)
        @test CompositeLighter(RGBA{T}(1, 0.75, 0, 0), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(0, 0.5, 1, 0.6)
        @test CompositeLighter(RGBA{T}(1, 0.75, 0, 1), RGBA{T}(0, 0.5, 1, 0.6)) ≈ RGBA{T}(1, 1, 0.6, 1)
    end
end
