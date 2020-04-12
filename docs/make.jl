using Documenter, ColorBlendModes

module CompositingExamples
    using ColorBlendModes, PNGFiles

    export load, save # just for examples
    export generate

    images = Dict{String, AbstractMatrix}()

    function load(filename)
        img = get(images, filename, nothing)
        if img === nothing
            img = PNGFiles.load(joinpath("assets", filename))
            images[filename] = img
        end
        img
    end

    function save(filename, image)
        PNGFiles.save(joinpath("assets", filename), image)
        nothing
    end

    function generate(bm::BlendMode)
        grad_256  = load("grad_256.png")
        juliadots = load("juliadots.png")
        wave_256  = load("wave_256.png")
        out = bm.(bm.(grad_256, juliadots), wave_256, opacity=0.4)
        save(keyword(bm) * ".png", out)
    end

    function generate(op::CompositeOperation, bm::BlendMode)
        blue  = load("blue.png")
        green = load("green.png")
        out = blend.(blue, green, mode=bm, op=op)
        save(keyword(op) * "_" * keyword(bm) * ".png", out)
    end
end

DocMeta.setdocmeta!(ColorBlendModes, :DocTestSetup,
                    :(using ColorBlendModes, ColorTypes, FixedPointNumbers);
                    recursive=true)

makedocs(
    clean = false,
    modules = [ColorBlendModes],
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true",
                             assets = ["assets/mix.css", "assets/favicon.ico"]),
    checkdocs = :exports,
    sitename = "ColorBlendModes",
    pages    = Any[
        "Introduction" => "index.md",
        "Blending and Compositing" => "blending-and-compositing.md",
        "Blend Modes" => "blend-modes.md",
        "Composite Operations" => "composite-operations.md",
        "Color Space Dependence" => "color-space-dependence.md",
        "Utility Functions" => "utility-functions.md",
        "Index" => "function-index.md",
        ]
    )

deploydocs(
    repo = "github.com/kimikage/ColorBlendModes.jl.git",
    target = "build")
