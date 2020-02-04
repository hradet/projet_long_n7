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
struct Source
    # Parameter
    powerMax::Float64
    # Variables
    power::Array{Float64,1}
end

#-------------------------------------------------------------------------------
#                                  Li-ion
#-------------------------------------------------------------------------------
struct Liion
    # Paramètres
    Erated::Float64
    cRateChMax::Float64
    cRateDchMax::Float64
    ηCh::Float64
    ηDch::Float64
    socMin::Float64
    socMax::Float64
    # Variables
    power::Array{Float64,1}
    soc::Array{Float64,1}
end

# Define a new constructor in order to simplify initialization
function Liion(outputGUI, nh)
    # Paramètres
    Erated = outputGUI.Erated
    cRateChMax = outputGUI.cRateChMax
    cRateDchMax = outputGUI.cRateDchMax
    ηCh = outputGUI.ηCh
    ηDch = outputGUI.ηDch
    socMin = outputGUI.socMin
    socMax = outputGUI.socMax
    # Variables
    power = zeros(nh)
    soc = zeros(nh+1)

    return Liion(Erated,cRateChMax,cRateDchMax,ηCh,ηDch,socMin,socMax,power,soc)
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
    # Paramètres
    C_grid::Array{Float64,1}
    powerMax::Float64
    # Variables
    power::Array{Float64,1}
end

#-------------------------------------------------------------------------------
#                                  Informations
#-------------------------------------------------------------------------------
struct Informations
    h::Int64
    ld::Load
    pv::Source
    liion::Liion
end
