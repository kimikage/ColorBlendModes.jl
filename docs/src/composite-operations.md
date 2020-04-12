# Composite Operations
The [`CompositeOperation`](@ref) type represents the Porter-Duff operators,
or the modes of generalized alpha compositing.

The general form of the Porter-Duff equation is:
```
    αo = αsrc × Fa + αb × Fb
    co = αsrc × Fa × Csrc + αb × Fb × Cb
    Co = co / αo
```
where:
- `αo` is the output alpha
- `αsrc` and `αb` are the source alpha and backdrop alpha
- `Fa` and `Fb` are defined by the operator in use
- `co` is the output color pre-multiplied with the output alpha `αo`
- `Csrc` and `Cb` are　the source color and backdrop color
- `Co` is the output color

Note that the "destination" means the "backdrop", not the "output" in this
context.

The following two images are used as examples below.

| Destination (backdrop)        | Source                    |
|:-----------------------------:|:-------------------------:|
|![destination](assets/blue.png)|![source](assets/green.png)|

## clear
```@example ex
using ColorBlendModes # hide
using Main.CompositingExamples # hide
generate(CompositeClear, BlendNormal) # hide
```
| Result |
|:------:|
|![clear](assets/clear_normal.png)|

```@docs
CompositeClear
```

## copy
```@example ex
generate(CompositeCopy, BlendNormal) # hide
```
| Result |
|:------:|
|![copy](assets/copy_normal.png)|

```@docs
CompositeCopy
```

## destination
```@example ex
generate(CompositeDestination, BlendNormal) # hide
```
| Result |
|:------:|
|![destination](assets/destination_normal.png)|

```@docs
CompositeDestination
```

## source-over
```@example ex
generate(CompositeSourceOver, BlendNormal) # hide
```
| Result | SVG |
|:------:|:---:|
|![source-over](assets/source-over_normal.png)|![source-over_svg](assets/source-over_normal.svg)|

```@docs
CompositeSourceOver
```

## destination-over
```@example ex
generate(CompositeDestinationOver, BlendNormal) # hide
```
| Result | SVG |
|:------:|:---:|
|![destination-over](assets/destination-over_normal.png)|![destination-over_svg](assets/destination-over_normal.svg)|

```@docs
CompositeDestinationOver
```

## source-in
```@example ex
generate(CompositeSourceIn, BlendNormal) # hide
```
| Result | SVG |
|:------:|:---:|
|![source-in](assets/source-in_normal.png)|![source-in_svg](assets/source-in_normal.svg)|

```@docs
CompositeSourceIn
```

## destination-in
```@example ex
generate(CompositeDestinationIn, BlendNormal) # hide
```
| Result | SVG |
|:------:|:---:|
|![destination-in](assets/destination-in_normal.png)|![destination-in_svg](assets/destination-in_normal.svg)|

```@docs
CompositeDestinationIn
```

## source-out
```@example ex
generate(CompositeSourceOut, BlendNormal) # hide
```
| Result | SVG |
|:------:|:---:|
|![source-out](assets/source-out_normal.png)|![source-out_svg](assets/source-out_normal.svg)|

```@docs
CompositeSourceOut
```

## destination-out
```@example ex
generate(CompositeDestinationOut, BlendNormal) # hide
```
| Result | SVG |
|:------:|:---:|
|![destination-out](assets/destination-out_normal.png)|![destination-out_svg](assets/destination-out_normal.svg)|

```@docs
CompositeDestinationOut
```

## source-atop
```@example ex
generate(CompositeSourceAtop, BlendNormal) # hide
```
| Result | SVG |
|:------:|:---:|
|![source-atop](assets/source-atop_normal.png)|![source-atop_svg](assets/source-atop_normal.svg)|

```@docs
CompositeSourceAtop
```

## destination-atop
```@example ex
generate(CompositeDestinationAtop, BlendNormal) # hide
```
| Result | SVG |
|:------:|:---:|
|![destination-atop](assets/destination-atop_normal.png)|![destination-atop_svg](assets/destination-atop_normal.svg)|

```@docs
CompositeDestinationAtop
```

## xor
```@example ex
generate(CompositeXor, BlendNormal) # hide
```
| Result | SVG |
|:------:|:---:|
|![xor](assets/xor_normal.png)|![xor_svg](assets/xor_normal.svg)|

```@docs
CompositeXor
```

## lighter
```@example ex
generate(CompositeLighter, BlendNormal) # hide
```
| Result | SVG |
|:------:|:---:|
|![lighter](assets/lighter_normal.png)|![lighter_svg](assets/lighter_normal.svg)|

```@docs
CompositeLighter
```
