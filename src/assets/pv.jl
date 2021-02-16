#=
    Sources modelling
 =#

@with_kw mutable struct Photovoltaic
    lifetime::Float64 = 20.
    powerMax::Float64 = 0.
    # Variables
    power::Array{Float64,1}
    # Eco
    cost::Float64 = 1000
end

### Preallocation
function preallocate!(pv::Photovoltaic, nh::Int64)
     pv.power = zeros(nh)
 end
