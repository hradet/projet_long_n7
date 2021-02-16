#=
    Loads modelling
 =#

mutable struct Load
     power::Array{Float64,1}
end

### Preallocation
function preallocate!(ld::Load, nh::Int64)
     ld.power = zeros(nh)
end
