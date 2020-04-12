
"""
    keyword(mode::BlendMode)
    keyword(op::CompositeOperation)

Return the keyword of `mode` or `op` as a string.

# Example
```jldoctest
julia> keyword(BlendColorDodge)
"color-dodge"

julia> keyword(CompositeSourceOver)
"source-over"
```
"""
keyword(::BlendMode{sym}) where sym = string(sym)
keyword(::CompositeOperation{sym}) where sym = string(sym)
