#=
    Li-ion battery modelling
 =#

 @with_kw mutable struct GenericBattery
     # Parameters
     capacity::Float64 = 0.
     α_p_ch::Float64 = 1.5
     α_p_dch::Float64 = 1.5
     η_ch::Float64 = 0.8
     η_dch::Float64 = 0.8
     η_self::Float64 = 0.
     α_soc_min::Float64 = 0.2
     α_soc_max::Float64 = 0.8
     lifetime::Float64 = 12.
     # Initial conditions
     soc_ini::Float64 = 0.5
     # Variables
     power::Array{Float64,1}
     soc::Array{Float64,1}
     # Eco
     cost::Float64 = 400.
 end

### Preallocation
 function preallocate!(battery::GenericBattery, nh::Int64)
     battery.power = zeros(nh)
     battery.soc = zeros(nh+1) ; battery.soc[1] .= battery.soc_ini
 end

 ### Operation dynamic
function dynamics(battery::GenericBattery, soc::Float64, u_liion::Float64, Δh::Int64)
     # Control power constraint and correction
     # TODO : Add warnings if the constraints are not fulfilled : power and soc
     # power_dch =
     # power_ch =

     # SoC dynamic
     # soc_next = soc * (1. - battery.η_self * Δh) - (power_ch * battery.η_ch + power_dch / battery.η_dch) * Δh / battery.capacity

     return soc_next, power_ch + power_dch, warnings
end
