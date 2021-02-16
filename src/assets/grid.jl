#=
    Elec grid modelling
 =#

@with_kw mutable struct Grid
     # Parameters
     powerMax::Float64 = 36.
     # Variables
     power::Array{Float64,1}
     cost_in::Array{Float64,1}
     cost_out::Array{Float64,1}
end

### Preallocation
function preallocate!(grid::Grid, nh::Int64)
     grid.power = zeros(nh)
     grid.cost_in = zeros(nh)
     grid.cost_out = zeros(nh)
end
