@testset "combination: RGB" begin
    t1, t2 = RGBA{Float32}(1, 0.75, 0, 0.6), RGBA{Float64}(0, 0.5, 1, 0.4)
    c1, c2 = RGB{Float64}(t1), RGB{Float64}(t2)
    g1, g2 = AGray{Float32}(1, 0.6), AGray{Float64}(0, 0.4)

    for op in (CompositeClear,
               CompositeCopy,
               CompositeDestination,
               CompositeSourceOver,
               CompositeDestinationOver,
               CompositeSourceIn,
               CompositeDestinationIn,
               CompositeSourceOut,
               CompositeDestinationOut,
               CompositeSourceAtop,
               CompositeDestinationAtop,
               CompositeXor,
               CompositeLighter)
        @testset "op=$(keyword(op)), mode=$(keyword(mode))" for mode in (BlendNormal,
                                                                         BlendLighten,
                                                                         BlendLuminosity)
            b = blend(t1, t2, mode=mode, op=op)
            c = blend(c2, blend(c1, c2, mode=mode), opacity=alpha(t1))
            @test b === mode(t1, t2, op=op) === op(t1, t2, mode=mode)
            @test color(b) ≈ color(op(t1, RGBA(c, alpha(t2))))
            @test alpha(b) === alpha(blend(g1, g2, op=op))
        end
    end

end
