#
# -- Julia v1.2.0
#

# Initialization
function initialization(outputGUI)
    #=
    This function allows to construct all the microgrid components
    =#

    # Parameters
    nh = size(outputGUI["ld"].power,1)

    # Load
    ld = Load(outputGUI["ld"].power)

    # Source
    pv = Source(outputGUI["pv"].powerMax, outputGUI["pv"].power)

    # Liion
    liion = Liion(outputGUI["liion"], nh)
    liion.soc[1,1] = outputGUI["liion"].socIni

    # Grid
    grid = Grid(outputGUI["grid"].C_grid,outputGUI["grid"].powerMax,zeros(nh))

    # Controller
    controller = Controller(zeros(nh))

   return ld, pv, liion, controller, grid
end

# Get microgrid informations at each time step
function get_informations(h, ld::Load, pv::Source, liion::Liion)
    #=
    At each time step, this function gives all the informations available to compute
    controls thanks to the controller system
    =#

    x_liion = liion.soc[h]
    w = [ld.power[h] pv.power[h]]
    return Informations(h, x_liion, w)
end

# Simulation
function simulate(ld::Load, pv::Source, liion::Liion, controller::AbstractController, grid::Grid, Δh)
    #=
    The microgrid is simulated thanks to this function
    =#

    # Parameters
    nh = size(ld.power,1) # length of the study

    # We simulate along the horizon
    for h = 1 : nh

        # Get informations
        info = get_informations(h, ld, pv, liion)

        # Compute operation control variables
        controller.u_liion[h] = compute_controls(controller, info)

        # Simulate operation dynamic
        liion.soc[h+1], liion.power[h] = dummy_model(liion, info.x_liion, controller.u_liion[h], Δh)

        # Simulate recourse variable
        grid.power[h] = max(0. , ld.power[h] - pv.power[h]  - liion.power[h])

    end
end

# Dummy Li-ion model
function dummy_model(liion::Liion, x_liion, u_liion, Δh)
    #=
    Here is a dummy model for the battery. You have to code the model you want
    to use at this place
    =#

    soc_next = power = 0

    return soc_next, power
end

# Dummy controller function
function compute_controls(controller::AbstractController, info_op)
    #=
    Here is a dummy controller for the microgrid. You have to code your
    own controller at this place
    =#

    u_liion = 0

    return u_liion
end
