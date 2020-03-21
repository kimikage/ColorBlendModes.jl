# Blend Modes

If your browser supports the CSS property `mix-blend-mode`, you will see pairs
of images below. The former images are the results of ColorBlendModes, and the
latter images are the results with the CSS.

## normal
```@example ex
using ColorBlendModes # hide
using Main: CompositingExamples # hide
CompositingExamples.generate(BlendNormal) # hide
```
![normal](assets/normal.png)
```@raw html
<div class="mix" style="mix-blend-mode:normal;">
  <div></div><div></div><div></div>
</div>
```

```@docs
BlendNormal
```

## multiply
```@example ex
CompositingExamples.generate(BlendMultiply) # hide
```
![multiply](assets/multiply.png)
```@raw html
<div class="mix" style="mix-blend-mode:multiply;">
  <div></div><div></div><div></div>
</div>
```
```@docs
BlendMultiply
```
## screen
```@example ex
CompositingExamples.generate(BlendScreen) # hide
```
![screen](assets/screen.png)
```@raw html
<div class="mix" style="mix-blend-mode:screen;">
  <div></div><div></div><div></div>
</div>
```
```@docs
BlendScreen
```

## overlay
```@example ex
CompositingExamples.generate(BlendOverlay) # hide
```
![overlay](assets/overlay.png)
```@raw html
<div class="mix" style="mix-blend-mode:overlay;">
  <div></div><div></div><div></div>
</div>
```
```@docs
BlendOverlay
```

## darken
```@example ex
CompositingExamples.generate(BlendDarken) # hide
```
![darken](assets/darken.png)
```@raw html
<div class="mix" style="mix-blend-mode:darken;">
  <div></div><div></div><div></div>
</div>
```
```@docs
BlendDarken
```

## lighten
```@example ex
CompositingExamples.generate(BlendLighten) # hide
```
![lighten](assets/lighten.png)
```@raw html
<div class="mix" style="mix-blend-mode:lighten;">
  <div></div><div></div><div></div>
</div>
```
```@docs
BlendLighten
```

## color-dodge
```@example ex
CompositingExamples.generate(BlendColorDodge) # hide
```
![color-dodge](assets/color-dodge.png)
```@raw html
<div class="mix" style="mix-blend-mode:color-dodge;">
  <div></div><div></div><div></div>
</div>
```
```@docs
BlendColorDodge
```

## color-burn
```@example ex
CompositingExamples.generate(BlendColorBurn) # hide
```
![color-burn](assets/color-burn.png)
```@raw html
<div class="mix" style="mix-blend-mode:color-burn;">
  <div></div><div></div><div></div>
</div>
```
```@docs
BlendColorBurn
```

## hard-light
```@example ex
CompositingExamples.generate(BlendHardLight) # hide
```
![hard-light](assets/hard-light.png)
```@raw html
<div class="mix" style="mix-blend-mode:hard-light;">
  <div></div><div></div><div></div>
</div>
```
```@docs
BlendHardLight
```

## soft-light
```@example ex
CompositingExamples.generate(BlendSoftLight) # hide
```
![soft-light](assets/soft-light.png)
```@raw html
<div class="mix" style="mix-blend-mode:soft-light;">
  <div></div><div></div><div></div>
</div>
```
```@docs
BlendSoftLight
```
## difference
```@example ex
CompositingExamples.generate(BlendDifference) # hide
```
![difference](assets/difference.png)
```@raw html
<div class="mix" style="mix-blend-mode:difference;">
  <div></div><div></div><div></div>
</div>
```
```@docs
BlendDifference
```
## exclusion
```@example ex
CompositingExamples.generate(BlendExclusion) # hide
```
![exclusion](assets/exclusion.png)
```@raw html
<div class="mix" style="mix-blend-mode:exclusion;">
  <div></div><div></div><div></div>
</div>
```
```@docs
BlendExclusion
```
