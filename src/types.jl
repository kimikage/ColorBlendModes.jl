
"""
    BlendMode{mode}
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
"""
const BlendOverlay = BlendMode{:overlay}()


"""
    BlendDarken
"""
const BlendDarken = BlendMode{:darken}()


"""
    BlendLighten
"""
const BlendLighten = BlendMode{:lighten}()


"""
    BlendColorDodge
"""
const BlendColorDodge = BlendMode{Symbol("color-dodge")}()


"""
    BlendColorBurn
"""
const BlendColorBurn = BlendMode{Symbol("color-burn")}()


"""
    BlendHardLight
"""
const BlendHardLight = BlendMode{Symbol("hard-light")}()


"""
    BlendSoftLight
"""
const BlendSoftLight = BlendMode{Symbol("soft-light")}()


"""
    BlendDifference
"""
const BlendDifference = BlendMode{:difference}()


"""
    BlendExclusion
"""
const BlendExclusion = BlendMode{:exclusion}()



const BlendHue= BlendMode{:hue}()
const BlendSaturation = BlendMode{:saturation}()
const BlendColor = BlendMode{:color}()
const BlendLuminosity = BlendMode{:luminosity}()


const SeparableBlendMode = Union{
    BlendMode{:normal},
    BlendMode{:multiply},
    BlendMode{:screen},
    BlendMode{:overlay},
    BlendMode{:darken},
    BlendMode{:lighten},
    BlendMode{Symbol("color-dodge")},
    BlendMode{Symbol("color-burn")},
    BlendMode{Symbol("hard-light")},
    BlendMode{Symbol("soft-light")},
    BlendMode{:difference},
    BlendMode{:exclusion},
}

const NonSeparableBlendMode = Union{
    BlendMode{:hue},
    BlendMode{:saturation},
    BlendMode{:color},
    BlendMode{:luminosity},
}
