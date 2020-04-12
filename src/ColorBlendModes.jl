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
export CompositeOperation,
       CompositeClear,
       CompositeCopy,
       CompositeDestination,
       CompositeSourceOver,
       CompositeDestinationOver,
       CompositeSourceIn,
       CompositeDestinationIn,
       CompositeSourceOut,
       CompositeDestinationOut,
       CompositeSourceAtop,
       CompositeDestinationAtop,
       CompositeXor,
       CompositeLighter
export blend, keyword

include("types.jl")
include("traits.jl")
include("parse.jl")
include("operations.jl")

end # module
