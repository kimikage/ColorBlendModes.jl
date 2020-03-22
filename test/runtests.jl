using Test
using ColorBlendModes

@test isempty(detect_ambiguities(ColorBlendModes, Base, Core))

@testset "normal" begin

end


@testset "keyword" begin
    @test keyword(BlendNormal) == "normal"
    @test keyword(BlendColorDodge) == "color-dodge"
end

@testset "parse" begin
    @test parse(BlendMode, "color-burn") === BlendColorBurn
    @test parse(BlendMode, "Hard-Light") === BlendHardLight
    @test_throws ArgumentError parse(BlendMode, "SoftLight")
end
