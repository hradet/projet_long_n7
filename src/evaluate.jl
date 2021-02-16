# Run function used by the prof
function evaluate(parameters::String, student_file::String)
    # Initialization
    microgrid, controller, scenario = ProjetN7.initialization(parameters, student_file)
    # Simulation
    simulate!(microgrid, controller, scenario)
    # Metrics
    indicators = metrics(microgrid)
    # Save
    save_results(indicators)
end

# Simulation
function simulate!(mg::Microgrid, controller::AbstractController, ω::Scenario)

    # Simulate
    for h in 1:mg.parameters.nh
        # Update operation informations
        informations!(h, mg, ω)

        # Compute operation decision variables
        online_decisions!(h, mg, controller)

        # Compute operation dynamics
        dynamics!(h, mg, controller)

        # Power balance constraint checked for each node
        check!(h, mg)
    end
end

# Update information
function informations!(h::Int64, mg::Microgrid, ω::Scenario)
    # Load
    if !isa(mg.load_E, Nothing)
        mg.load_E.power[h] = ω.load_E[h]
    end
    # Source
    if !isa(mg.pv, Nothing)
        mg.pv.power[h] = mg.pv.powerMax * ω.pv[h]
    end
end

# Compute dynamics
function dynamics!(h::Int64, mg::Microgrid, controller::AbstractController)
    # Storage
    # Compute dynamics if storages are available
    if !isa(mg.generic_battery, Nothing)
        mg.generic_battery.soc[h+1], mg.generic_battery.power[h] = dynamics(mg.generic_battery, mg.generic_battery.soc[h], controller.u.generic_battery[h], mg.parameters.Δh)
    end
end

# Check power balance and constraints at the end of each time step
function check!(h::Int64, mg::Microgrid)
    # TODO
    return nothing
end
