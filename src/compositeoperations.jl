module CompositeOperations

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

"""
    CompositeOperation{op}

A type used for specifying the Porter-Duff operator, or the mode of generalized
alpha compositing. The `op` should be a symbol.
"""
struct CompositeOperation{op} end


"""
    CompositeClear

A basic Porter-Duff operator with the fractional terms `Fa = 0; Fb = 0`.
The composite result is completely transparent.
"""
const CompositeClear = CompositeOperation{:clear}()


"""
    CompositeCopy

A basic Porter-Duff operator with the fractional terms `Fa = 1; Fb = 0`.
The composite result is the copy of source.

!!! note
    Even if the source alpha is zero, the color components are not cleared.
"""
const CompositeCopy = CompositeOperation{:copy}()


"""
    CompositeDestination

A basic Porter-Duff operator with the fractional terms `Fa = 0; Fb = 1`.
The composite result is the copy of destination (backdrop).

!!! note
    Even if the destination alpha is zero, the color components are not cleared.
"""
const CompositeDestination = CompositeOperation{:destination}()


"""
    CompositeSourceOver

A basic Porter-Duff operator with the fractional terms `Fa = 1; Fb = 1 - αsrc`.
This means the simple alpha compositing.
"""
const CompositeSourceOver = CompositeOperation{Symbol("source-over")}()


"""
    CompositeDestinationOver

A basic Porter-Duff operator with the fractional terms `Fa = 1 - αb; Fb = 1`.
"""
const CompositeDestinationOver = CompositeOperation{Symbol("destination-over")}()


"""
    CompositeSourceIn

A basic Porter-Duff operator with the fractional terms `Fa = αb; Fb = 0`.
"""
const CompositeSourceIn = CompositeOperation{Symbol("source-in")}()


"""
    CompositeDestinationIn

A basic Porter-Duff operator with the fractional terms `Fa = 0; Fb = αsrc`.
"""
const CompositeDestinationIn = CompositeOperation{Symbol("destination-in")}()


"""
    CompositeSourceOut

A basic Porter-Duff operator with the fractional terms `Fa = 1 - αb; Fb = 0`.
"""
const CompositeSourceOut = CompositeOperation{Symbol("source-out")}()


"""
    CompositeDestinationOut

A basic Porter-Duff operator with the fractional terms `Fa = 0; Fb = 1 - αsrc`.
"""
const CompositeDestinationOut = CompositeOperation{Symbol("destination-out")}()


"""
    CompositeSourceAtop

A basic Porter-Duff operator with the fractional terms `Fa = αb; Fb = 1 - αsrc`.
"""
const CompositeSourceAtop = CompositeOperation{Symbol("source-atop")}()


"""
    CompositeDestinationAtop

A basic Porter-Duff operator with the fractional terms `Fa = 1 - αsrc; Fb = αb`.
"""
const CompositeDestinationAtop = CompositeOperation{Symbol("destination-atop")}()


"""
    CompositeXor

A basic Porter-Duff operator with the fractional terms `Fa = 1 - αb; Fb = 1 - αsrc`.
"""
const CompositeXor = CompositeOperation{:xor}()


"""
    CompositeLighter

A basic Porter-Duff operator with the fractional terms `Fa = 1; Fb = 1`.
"""
const CompositeLighter = CompositeOperation{:lighter}()

end # module