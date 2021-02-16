# Distributed energy system
@with_kw mutable struct GlobalParameters
    Δh::Int64 = 1
    nh::Int64 = 8760
end

@with_kw mutable struct Microgrid
    parameters::GlobalParameters = GlobalParameters()
    # Loads
    load_E::Union{Nothing, Load} = nothing
    # Source
    pv::Union{Nothing, Photovoltaic} = nothing
    # Storage
    generic_battery::Union{Nothing, GenericBattery} = nothing
    # Grid
    grid::Union{Nothing, Grid} = nothing
end
