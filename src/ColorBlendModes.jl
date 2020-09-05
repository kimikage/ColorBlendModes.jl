module ColorBlendModes

using FixedPointNumbers
using ColorTypes

import Base: parse

export blend, keyword

include("blendmodes.jl")
include("compositeoperations.jl")

using .BlendModes
using .CompositeOperations

# re-export
for name in names(ColorBlendModes.BlendModes)
    @eval export $name
end
for name in names(ColorBlendModes.CompositeOperations)
    @eval export $name
end

include("types.jl")
include("traits.jl")
include("parse.jl")
include("operations.jl")

end # module
