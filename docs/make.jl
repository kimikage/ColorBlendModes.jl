using Documenter, ColorBlendModes

module CompositingExamples
    using ColorBlendModes, PNGFiles

    images = Dict{String, AbstractMatrix}()

    function load_image(filename)
        img = get(images, filename, nothing)
        if img === nothing
            img = PNGFiles.load(joinpath("assets", filename))
            images[filename] = img
        end
        img
    end

    function generate(bm::BlendMode)
        grad_256  = load_image("grad_256.png")
        juliadots = load_image("juliadots.png")
        wave_256  = load_image("wave_256.png")

        out = bm.(bm.(grad_256, juliadots), wave_256, opacity=0.4)
        PNGFiles.save(joinpath("assets", keyword(bm) * ".png"), out)
        nothing
    end
end

makedocs(
    clean = false,
    modules = [ColorBlendModes],
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true",
                             assets = ["assets/mix.css"]),
    checkdocs = :exports,
    sitename = "ColorBlendModes",
    pages    = Any[
        "Introduction" => "index.md",
        "Blend Modes" => "blendmodes.md",
        "Index" => "functionindex.md",
        ]
    )

deploydocs(
    repo = "github.com/kimikage/ColorBlendModes.jl.git",
    target = "build")
