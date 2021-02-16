module ProjetN7

# Packages
using Parameters, JLD, YAML
# Include files
# Assets
include(joinpath("assets","generic_battery.jl"))
include(joinpath("assets","pv.jl"))
include(joinpath("assets","load.jl"))
include(joinpath("assets","grid.jl"))
include(joinpath("assets","microgrid.jl"))
include(joinpath("assets","scenario.jl"))
# Other files
include("utils.jl")
include("controller.jl")
include("evaluate.jl")
export evaluate

end
