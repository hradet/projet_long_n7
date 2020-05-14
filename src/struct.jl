#
# -- Julia v1.2.0
#
#-------------------------------------------------------------------------------
#                                  Abstract type
#-------------------------------------------------------------------------------
abstract type AbstractController end

#-------------------------------------------------------------------------------
#                                  Load
#-------------------------------------------------------------------------------
struct Load
    # Variables
    power::Array{Float64,1}
end


#-------------------------------------------------------------------------------
#                                  Solar panels
#-------------------------------------------------------------------------------
struct Solar
    # Parameters
    peakPower::Float64
    # Variables
    power::Array{Float64,1}
end


#-------------------------------------------------------------------------------
#                                  Li-ion
#-------------------------------------------------------------------------------
struct Liion
    # Parameters
    Erated::Float64
    α_p_ch::Float64
    α_p_dch::Float64
    η_ch::Float64
    η_dch::Float64
    η_self::Float64
    α_soc_min::Float64
    α_soc_max::Float64
    nCycle::Float64
    dod::Float64
    # Variables
    power::Array{Float64,1}
    soc::Array{Float64,1}
    soh::Array{Float64,1}
end

# Define a new constructor in order to simplify initialization
function Liion(outputGUI, nh)
    # Parameters
    Erated = outputGUI.Erated
    α_p_ch = outputGUI.α_p_ch
    α_p_dch = outputGUI.α_p_dch
    η_ch = outputGUI.η_ch
    η_dch = outputGUI.η_dch
    η_self = outputGUI.η_self
    α_soc_min = outputGUI.α_soc_min
    α_soc_max = outputGUI.α_soc_max
    nCycle = outputGUI.nCycle
    dod = outputGUI.dod
    # Variables
    power = zeros(nh)
    soc = zeros(nh+1)
    soh = zeros(nh+1)
    return Liion(Erated,α_p_ch,α_p_dch,η_ch,η_dch,η_self,α_soc_min,α_soc_max,nCycle,dod,power,soc,soh)
end

#-------------------------------------------------------------------------------
#                                  Controller
#-------------------------------------------------------------------------------
mutable struct Controller <: AbstractController
    π::Function
    u::Array{Float64,1}
    Controller() = new()
end

#-------------------------------------------------------------------------------
#                                  Grid
#-------------------------------------------------------------------------------
struct Grid
    # Parameters
    powerMax::Float64
    c_grid_in::Array{Float64,1}
    c_grid_out::Array{Float64,1}
    # Variables
    power::Array{Float64,1}
end

function Grid(outputGUI, nh)
    # Parameters
    powerMax = outputGUI.powerMax
    # Variables
    c_grid_in = zeros(nh)
    c_grid_out = zeros(nh)
    power = zeros(nh)
    return Grid(powerMax,c_grid_in,c_grid_out,power)
end

#-------------------------------------------------------------------------------
#                                  Scenarios
#-------------------------------------------------------------------------------
mutable struct Scenarios
    # Demand
    ld
    # Production
    pv
    # Electricity tariff
    c_grid_in
    c_grid_out
end

function Scenarios(outputGUI, nh)
    # Demand
    ld = outputGUI.ld[1:nh]
    # Production
    pv = outputGUI.pv[1:nh]
    # Electricity tariff
    c_grid_in = outputGUI.c_grid_in[1:nh]
    c_grid_out = outputGUI.c_grid_out[1:nh]
    return Scenarios(ld,pv,c_grid_in,c_grid_out)
end

#-------------------------------------------------------------------------------
#                                  Cost
#-------------------------------------------------------------------------------
mutable struct Cost
    capex
    opex
    npv
end
