# Module
using ProjetN7
# Data process
using CSV, DataFrames
# Plot
using Seaborn
# Display figure
pygui(true)

# Include file as we suppose parameters come from a GUI
include("load_GUI.jl")

# Load GUI parameters
outputGUI = loadGUI()

# Microgrid initialization
ld, pv, liion, controller, grid, ω_simu = ProjetN7.initialization(outputGUI)

# Simulation
cost = ProjetN7.simulate(ld, pv, liion, controller, grid, ω_simu, outputGUI["parameters"])

# Plots
ProjetN7.plot_results(ld, pv, liion, grid)
