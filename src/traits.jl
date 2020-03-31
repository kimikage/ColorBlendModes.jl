
keyword(::BlendMode{sym}) where sym = string(sym)
keyword(::CompositeOperation{sym}) where sym = string(sym)
