module BlendModes

export BlendMode,
       BlendNormal,
       BlendMultiply,
       BlendScreen,
       BlendOverlay,
       BlendDarken,
       BlendLighten,
       BlendColorDodge,
       BlendColorBurn,
       BlendHardLight,
       BlendSoftLight,
       BlendDifference,
       BlendExclusion,
       BlendHue,
       BlendSaturation,
       BlendColor,
       BlendLuminosity

"""
    BlendMode{mode}

A type used for specifying the mixing mode of opaque colors. The `mode` should
be a symbol.
"""
struct BlendMode{mode} end

"""
    BlendNormal

The destination color is always the source color.
```
    Cdest = Csrc
```
"""
const BlendNormal = BlendMode{:normal}()


"""
    BlendMultiply

The source color is multiplied by the backdrop color.
```
    Cdest = Cb × Csrc
```
"""
const BlendMultiply = BlendMode{:multiply}()


"""
    BlendScreen

The complementary colors of the source and backdrop colors are multiplied, and
the destination color is the complementary color of the multiplicated color.
```
    Cdest = 1 - ((1 - Cb) × (1 - Csrc))
```
"""
const BlendScreen = BlendMode{:screen}()


"""
    BlendOverlay

This mode uses the [`multiply`](@ref BlendMultiply) or [`screen`](@ref
BlendScreen) mode, depending on the backdrop color. The overlay mode is the
inverse of the [`hard-light`](@ref BlendHardLight) mode.
```
    if Cb <= 0.5
        Cdest = Csrc × 2Cb
    else
        Cdest = 1 - ((1 - Csrc) × (1 - 2Cb))
    end
```
"""
const BlendOverlay = BlendMode{:overlay}()


"""
    BlendDarken

The darker values of the backdrop color and the source color are selected.
```
    Cdest = min(Cb, Csrc)
```
"""
const BlendDarken = BlendMode{:darken}()


"""
    BlendLighten

The lighter values of the backdrop color and the source color are selected.
```
    Cdest = max(Cb, Csrc)
```
"""
const BlendLighten = BlendMode{:lighten}()


"""
    BlendColorDodge

The destination color is the result of dividing the backdrop color by the
complementary color of the source color.
```
    if Cb == 0
        Cdest = 0
    elseif Csrc == 1
        Cdest = 1
    else
        Cdest = min(1, Cb / (1 - Csrc))
    end
```
"""
const BlendColorDodge = BlendMode{Symbol("color-dodge")}()


"""
    BlendColorBurn

The destination color is the result of dividing the complementary color of the
backdrop color by the source color.

ColorBlendModes uses the definition of W3C drafts as shown below. Note that
there is a variant, which returns `0` when `Cb == 1` and `Csrc == 0`.
```
    if Cb == 1
        Cdest = 1
    elseif Csrc == 0
        Cdest = 0
    else
        Cdest = 1 - min(1, (1 - Cb) / Csrc)
    end
```
"""
const BlendColorBurn = BlendMode{Symbol("color-burn")}()


"""
    BlendHardLight

This mode uses the [`multiply`](@ref BlendMultiply) or [`screen`](@ref
BlendScreen) mode, depending on the source color. The overlay mode is the
inverse of the [`overlay`](@ref BlendOverlay) mode.
```
    if Csrc <= 0.5
        Cdest = Cb × 2Csrc
    else
        Cdest = 1 - ((1 - Cb) × (1 - 2Csrc))
    end
```
"""
const BlendHardLight = BlendMode{Symbol("hard-light")}()


"""
    BlendSoftLight

The result is similar to the [`hard-light`](@ref BlendHardLight) mode, but
milder. This mode is also related to the [`overlay`](@ref BlendOverlay) mode.

ColorBlendModes uses the definition of W3C drafts as shown below. Note that
there are different definitions of the `soft-light`.
```
    if Csrc <= 0.5
        Cdest = Cb - (1 - 2Csrc) × Cb × (1 - Cb)
    else
        if Cb <= 0.25
            D = ((4Cb - 3) × Cb + 1) × 4Cb
        else
            D = sqrt(Cb)
        end
        Cdest = Cb + (2Csrc - 1) × (D - Cb)
    end
```
"""
const BlendSoftLight = BlendMode{Symbol("soft-light")}()


"""
    BlendDifference

The destination values are the subtraction of the darker values from the lighter
values of the backdrop and source colors.
```
    Cdest = abs(Csrc - Cb)
```
"""
const BlendDifference = BlendMode{:difference}()


"""
    BlendExclusion

The result is similar to the [`difference`](@ref BlendDifference) mode, but
milder.
```
    Cdest = Cb + Csrc - 2Cb × Csrc
```
"""
const BlendExclusion = BlendMode{:exclusion}()


"""
    BlendHue

The result is a color with the hue of the source color and the saturation and
luminosity of the backdrop color.
"""
const BlendHue= BlendMode{:hue}()


"""
    BlendSaturation

The result is a color with the saturation of the source color and the hue and
luminosity of the backdrop color.
"""
const BlendSaturation = BlendMode{:saturation}()


"""
    BlendColor

The result is a color with the hue and saturation of the source color and the
luminosity of the backdrop color.
"""
const BlendColor = BlendMode{:color}()


"""
    BlendLuminosity

The result is a color with the luminosity of the source color and the hue and
saturation of the backdrop color.
"""
const BlendLuminosity = BlendMode{:luminosity}()

end # module
