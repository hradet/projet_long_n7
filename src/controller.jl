abstract type AbstractController end

# Preallocate abstract controller
function preallocate!(controller::AbstractController, nh::Int64)
    controller.u = (liion = zeros(nh), )
end

# StudentController
mutable struct StudentController <: AbstractController
    u::NamedTuple
    StudentController() = new()
end

# Dummy controller
mutable struct Dummy <: AbstractController
    u::NamedTuple
    Dummy() = new()
end

### Offline
function offline_decisions!(mg::Microgrid, controller::Dummy, ω::Scenario)
    # Preallocation
    preallocate!(controller, mg.parameters.nh)
    return controller
end

### Online
function online_decisions!(h::Int64, mg::Microgrid, controller::Dummy)
    return controller
end
