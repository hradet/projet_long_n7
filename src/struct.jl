#
# -- Julia v1.2.0
#

# Load
struct Load
    # Variables
    power
end

# Source
struct Source
    # Parameter
    powerMax
    # Variables
    power
end

# Liion
struct Liion
    # Paramètres
    Erated
    cRateChMax
    cRateDchMax
    ηCh
    ηDch
    socMin
    socMax
    # Variables
    power
    soc
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

# Controller
abstract type AbstractController end
struct Controller <: AbstractController
    u_liion
end

# Grid
struct Grid
    # Paramètres
    C_grid
    powerMax
    # Variables
    power
end

# Informations
struct Informations
    h
    x_liion
    w
end
