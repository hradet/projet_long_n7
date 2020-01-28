# Module
using ProjetN7
# Plots
using Seaborn
pygui(true)
# Data
using CSV, DataFrames

# Include file as we suppose parameters and data come from a GUI
include("load_GUI.jl")

# Global constant
const Δh, H = 1, 365 * 24 # in hours
const nh = length(Δh:Δh:H) # number of h step

# Load GUI parameters
outputGUI = loadGUI()

# Microgrid initialization
ld, pv, liion, controller, grid = ProjetN7.initialization(outputGUI)

# Simulate
ProjetN7.simulate(ld, pv, liion, controller, grid, Δh)

# Plots
subplot(211), plot(ld.power, label="Load")
plot(pv.power, label="PV")
plot(liion.power, label="Liion")
plot(grid.power, label="Grid")
ylabel("Power (kW)")
subplot(212), plot(liion.soc)
xlabel("Hours")
ylabel("SOC (kWh)")
