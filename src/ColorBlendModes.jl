module ColorBlendModes

using FixedPointNumbers
using ColorTypes

import Base: parse

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
export blend, keyword

include("types.jl")
include("traits.jl")
include("parse.jl")
include("operations.jl")

end # module
