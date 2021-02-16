# Initialization function
function initialization(parameters::String, student_file::String)
    #TODO
    ## Get parameters from the parameter file
    Δh, nh = 1, 8760
    # idx = ...

    ## Include student file
    include("student_file.jl")
    ## Build student controller and preallocate
    controller = StudentController()
    preallocate!(controller, nh)

    ## Build scenario from the database
    # data = load(joinpath("data", "data.jld"))
    # load_E = data["load_E"][idx]
    # pv = data.pv[idx]
    # grid = (cost_in = data.grid.cost_in[idx], cost_out = data.grid.cost_out[idx])
    scenario = Scenario(zeros(nh), zeros(nh), (cost_in = zeros(nh), cost_out = zeros(nh)))

    ## Build microgrid
    # if parameters.battery.flag
    #   generic_battery = GenericBattery(capacity = battery_size)
    # end
    #

    # preallocate!(generic_battery, nh)
    # ...
    # Microgrid
    microgrid = Microgrid()

    return microgrid, controller, scenario
end

# Metrics
function metrics(mg::Microgrid)
    #TODO
    return nothing
end

# Save function
function save_results(indicators)
    #TODO
end
