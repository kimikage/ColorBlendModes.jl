# ColorBlendModes

This package provides the definitions and compositing operations of the
[blend modes](https://en.wikipedia.org/wiki/Blend_modes).

The behavior of this package is based on the CSS
[Compositing and Blending Level 1](https://drafts.fxtf.org/compositing-1/).

## Basic usage
For details of the API, see [Blending and Compositing](@ref).

```jldoctest
julia> using ColorBlendModes, ColorTypes, FixedPointNumbers;

julia> BlendMultiply(RGB{Float32}(1.0, 0.5, 0.0), RGB{Float32}(0.5, 0.5, 0.5))
RGB{Float32}(0.5f0,0.25f0,0.0f0)

julia> blend(RGB(1, 1, 0), RGB(0, 1, 1), mode=BlendDarken)
RGB{N0f8}(0.0,1.0,0.0)

julia> image1 = [RGB(r, 1, b) for r=0:1, b=0:1]
2×2 Array{RGB{N0f8},2} with eltype RGB{N0f8}:
 RGB{N0f8}(0.0,1.0,0.0)  RGB{N0f8}(0.0,1.0,1.0)
 RGB{N0f8}(1.0,1.0,0.0)  RGB{N0f8}(1.0,1.0,1.0)

julia> image2 = [RGB(r, g, 0) for g=0:1, r=0:1]
2×2 Array{RGB{N0f8},2} with eltype RGB{N0f8}:
 RGB{N0f8}(0.0,0.0,0.0)  RGB{N0f8}(1.0,0.0,0.0)
 RGB{N0f8}(0.0,1.0,0.0)  RGB{N0f8}(1.0,1.0,0.0)

julia> BlendDifference.(image1, image2)
2×2 Array{RGB{N0f8},2} with eltype RGB{N0f8}:
 RGB{N0f8}(0.0,1.0,0.0)  RGB{N0f8}(1.0,1.0,1.0)
 RGB{N0f8}(1.0,0.0,0.0)  RGB{N0f8}(0.0,0.0,1.0)
```
