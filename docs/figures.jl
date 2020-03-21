using Colors
using Gadfly
using Random

grad = [RGB24(r/255, 128/255, b/255) for b=255:-1:0, r=0:255]

cm = colormap("Blues",11)
xs = 0:0.01:1

Random.seed!(1234)
n = 8
kf = 18 .^ rand(Float64, n) * 1.5
kf[1] = 0.0
ka1 = rand(Float64, n) * 2
kp1 = rand(Float64, n) * 6
ka2 = rand(Float64, n) * 2
kp2 = rand(Float64, n) * 6
f(x, t) = sum(i->(ka2[i] * t + ka1[i] * (1-t)) * sin(kf[i] * x + (kp2[i] * t + kp1[i] * (1-t))), 1:n)

p = plot(
    Coord.cartesian(ymin=-10, ymax=10),
    Guide.xticks(ticks=nothing), Guide.yticks(ticks=nothing),
    layer(y=f.(xs,0.0),x=xs, Geom.line, Theme(default_color=cm[1])),
    layer(y=f.(xs,0.1),x=xs, Geom.line, Theme(default_color=cm[2])),
    layer(y=f.(xs,0.2),x=xs, Geom.line, Theme(default_color=cm[3])),
    layer(y=f.(xs,0.3),x=xs, Geom.line, Theme(default_color=cm[4])),
    layer(y=f.(xs,0.4),x=xs, Geom.line, Theme(default_color=cm[5])),
    layer(y=f.(xs,0.5),x=xs, Geom.line, Theme(default_color=cm[6])),
    layer(y=f.(xs,0.6),x=xs, Geom.line, Theme(default_color=cm[7])),
    layer(y=f.(xs,0.7),x=xs, Geom.line, Theme(default_color=cm[8])),
    layer(y=f.(xs,0.8),x=xs, Geom.line, Theme(default_color=cm[9])),
    layer(y=f.(xs,0.9),x=xs, Geom.line, Theme(default_color=cm[10])),
    layer(y=f.(xs,1.0),x=xs, Geom.line, Theme(default_color=cm[11])),
)

p |> SVG("waves.svg", 100mm, 100mm)
