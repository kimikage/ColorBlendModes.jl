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


## source-over
```@example ex
using ColorBlendModes # hide
using Main: CompositingExamples # hide
CompositingExamples.generate(CompositeSourceOver, BlendNormal) # hide
```
| Result | SVG |
|:------:|:---:|
|![source-over](assets/source-over_normal.png)|![source-over_svg](assets/source-over_normal.svg)|

```@docs
CompositeSourceOver
```

## source-atop
```@example ex
CompositingExamples.generate(CompositeSourceAtop, BlendNormal) # hide
```
| Result | SVG |
|:------:|:---:|
|![source-atop](assets/source-atop_normal.png)|![source-atop_svg](assets/source-atop_normal.svg)|

```@docs
CompositeSourceAtop
```
