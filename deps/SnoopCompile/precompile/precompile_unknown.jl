function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    precompile(Tuple{Type{NamedTuple{(:stderr,), T} where T<:Tuple}, Tuple{Base.PipeEndpoint}})
end
