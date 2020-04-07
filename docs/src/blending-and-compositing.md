# Blending and Compositing

## Types for specifying modes
ColorBlendModes defines two types for specifying modes: [`BlendMode`](@ref) for
the mixing of opaque colors, and [`CompositeOperation`](@ref) for the
generalized alpha compositing.

The users typically do not need to handle these types directly. Instead, the
users can handle the predefined singleton instances of those types, e.g.
[`BlendMultiply`](@ref multiply), [`BlendScreen`](@ref screen) and
[`BlendOverlay`](@ref overlay) for [`BlendMode`](@ref), or
[`CompositeSourceOver`](@ref source-over) and
[`CompositeSourceAtop`](@ref source-atop) for [`CompositeOperation`](@ref). See
[Blend Modes](@ref) and [Composite Operations](@ref) for all supported modes and
their examples. Note that these predefined constants look like types, but are
just instances.

```@docs
BlendMode
CompositeOperation
```

## Blending and compositing function
The [`blend`](@ref) function creates the mixed color of two colors based on
the specified blend mode and composite operation.
```@docs
blend
```
For example:
```jldoctest ex; setup = :(using ColorBlendModes, ColorTypes, FixedPointNumbers;)
julia> blend(RGB(1, 0.5, 0), RGB(0, 0.5, 1), mode=BlendLighten)
RGB{Float64}(1.0,0.5,1.0)
```

### Broadcasting
The [`blend`](@ref) function is compatible with the broadcasting. Therefore,
you can blend two images with the same size.
```jldoctest ex
julia> image1 = [RGB(r, 1, b) for r=0:1, b=0:1]
2×2 Array{RGB{N0f8},2} with eltype RGB{Normed{UInt8,8}}:
 RGB{N0f8}(0.0,1.0,0.0)  RGB{N0f8}(0.0,1.0,1.0)
 RGB{N0f8}(1.0,1.0,0.0)  RGB{N0f8}(1.0,1.0,1.0)

julia> image2 = [RGB(r, g, 0) for g=0:1, r=0:1]
2×2 Array{RGB{N0f8},2} with eltype RGB{Normed{UInt8,8}}:
 RGB{N0f8}(0.0,0.0,0.0)  RGB{N0f8}(1.0,0.0,0.0)
 RGB{N0f8}(0.0,1.0,0.0)  RGB{N0f8}(1.0,1.0,0.0)

julia> blend.(image1, image2, mode=BlendMultiply)
2×2 Array{RGB{N0f8},2} with eltype RGB{Normed{UInt8,8}}:
 RGB{N0f8}(0.0,0.0,0.0)  RGB{N0f8}(0.0,0.0,0.0)
 RGB{N0f8}(0.0,1.0,0.0)  RGB{N0f8}(1.0,1.0,0.0)
```
### Opacity
The keyword argument `opacity` controls the alpha of source color `c2`. If `c2`
is a opaque color, the `opacity` is used as the source alpha. If `c2` is a
transparent color, `opacity * alpha(c2)` is used as the source alpha. The
`opacity` is useful when used with broadcasting, i.e. the `opacity` acts as
so-called "layer opacity".

The following are examples where an image of green triangles (`image_green`) is
layered on an image of blue triangles (`image_blue`).
```@example ex
using ColorBlendModes # hide
using Main: CompositingExamples # hide
image_blue, image_green = [],[] # hide
for mode in (BlendNormal, BlendMultiply, BlendScreen)
    for opacity in (25, 50, 75, 100)
        blend.(image_blue, image_green, mode=mode, opacity=opacity/100)
        CompositingExamples.generate(mode, opacity) # hide
    end
end
```

|blend mode|`opacity=0.25`|`opacity=0.5 `|`opacity=0.75`|`opacity=1.0 ` (default)|
|:--------:|:------------:|:------------:|:------------:|:----------------------:|
|normal|![normal25%](assets/normal_25.png)|![normal50%](assets/normal_50.png)|![normal75%](assets/normal_75.png)|![normal100%](assets/normal_100.png)|
|multiply|![multiply25%](assets/multiply_25.png)|![multiply50%](assets/multiply_50.png)|![multiply75%](assets/multiply_75.png)|![multiply100%](assets/multiply_100.png)|
|screen|![screen25%](assets/screen_25.png)|![screen50%](assets/screen_50.png)|![screen75%](assets/screen_75.png)|![screen100%](assets/screen_100.png)|

!!! note
    The `opacity` is typically specified in the range [0,1]. A value out of the
    range can be specified, but the [`blend`](@ref) function does not clip
    the intermediate values. Therefore an arbitrary color may be returned.

## Calling with singleton instances

For convenience, the instances of [`BlendMode`](@ref) and
[`CompositeOperation`](@ref) are callable. They are equivalent to the
[`blend`](@ref) function, with the instance assigned to the keyword argument
`mode` or `op`.
```jldoctest ex
julia> c1 = RGBA(1, 0.5, 0, 0.5); c2 = RGB(0, 0.5, 1);

julia> BlendMultiply(c1, c2) === blend(c1, c2, mode=BlendMultiply)
true

julia> CompositeSourceOver(c1, c2) === blend(c1, c2, op=CompositeSourceOver)
true

julia> BlendDarken(c1, c2, opacity=0.25, op=CompositeSourceAtop)
RGBA{Float64}(0.75,0.5,0.125,0.5)

julia> CompositeSourceAtop(c1, c2, opacity=0.25, mode=BlendDarken)
RGBA{Float64}(0.75,0.5,0.125,0.5)
```

However, it is not recommended to call the predefined constants directly, e.g.
`BlendMultiply(c1, c2)`. They are should be called via method arguments or local
variables.
