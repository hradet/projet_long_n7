#
# -- Julia v1.2.0
#

#-------------------------------------------------------------------------------
#                                  Initialization
#-------------------------------------------------------------------------------
function initialization(outputGUI)
    #=
    This function initialize the microgrid with the GUI parameters
    =#

    # Parameters
    nh = length(outputGUI["parameters"].Δh:outputGUI["parameters"].Δh:outputGUI["parameters"].H)

    # Scenarios
    ω_simu = Scenarios(outputGUI["scenarios"], nh)

    # Load
    ld = Load(zeros(nh))

    # Solar
    pv = Solar(outputGUI["pv"].peakPower, zeros(nh))

    # Liion
    liion = Liion(outputGUI["liion"], nh)
    liion.soc[1,1] = outputGUI["liion"].soc_ini
    liion.soh[1,1] = outputGUI["liion"].soh_ini

    # Grid
    grid = Grid(outputGUI["grid"],nh)

    # Controller
    controller = Controller()
    controller.u = zeros(nh)

   return ld, pv, liion, controller, grid, ω_simu
end

#-------------------------------------------------------------------------------
#                                  Simulation
#-------------------------------------------------------------------------------
function simulate(ld::Load, pv::Solar, liion::Liion, controller::AbstractController,
    grid::Grid, ω::Scenarios, parameters::NamedTuple)
    #=
    The microgrid is simulated thanks to this function
    =#

    # Parameters
    nh = size(ld.power,1) # length of the study

    # Simulation over the horizon
    for h in 1:nh

        # At each time step, we update the available informations from scenarios ω
        update_informations(h, ld, pv, liion, grid, ω)

        # Compute operation decision variables
        compute_decisions(h, ld, pv, liion, grid, controller)

        # Compute operation dynamics
        compute_dynamics(h, liion, controller, parameters.Δh)

        # Power balance
        power_balance(h, ld, pv, liion, grid)

    end

    # At the end of the simulation, economical indicators are computed
    cost = compute_cost(ld, pv, liion, grid, parameters)

    return cost
end

#-------------------------------------------------------------------------------
#                              Update informations
#-------------------------------------------------------------------------------
function update_informations(h::Int64, ld::Load, pv::Solar, liion::Liion,
    grid::Grid, ω::Scenarios)
    # Energy demand and production
    ld.power[h] = ω.ld[h]
    pv.power[h] = pv.peakPower * ω.pv[h]
    # Electricity tariff
    grid.c_grid_in[h] = ω.c_grid_in[h]
    grid.c_grid_out[h] = ω.c_grid_out[h]
end

#-------------------------------------------------------------------------------
#                              Compute decisions
#-------------------------------------------------------------------------------
function compute_decisions(h::Int64, ld::Load, pv::Solar, liion::Liion,
     grid::Grid, controller::AbstractController)
    #=
    Here is a simple rule based controller for the microgrid.
    =#
    controller.u[h] = ld.power[h] - pv.power[h]
end

#-------------------------------------------------------------------------------
#                              Compute dynamics
#-------------------------------------------------------------------------------
function compute_dynamics(h::Int64, liion::Liion, controller::AbstractController,
     Δh::Int64)
    # Compute the dynamic with the model you chose
    liion.soc[h+1], liion.soh[h+1], liion.power[h] = linear_model(liion, (soc = liion.soc[h], soh = liion.soh[h]), controller.u[h], Δh)
end

# Li-ion linear model
function linear_model(liion::Liion, x_liion::NamedTuple, u_liion::Float64,
    Δh::Int64)
    #=
    Here is a simple linear model for the battery
    INPUT :
            x_liion = (soc, soh) tuple of states
            u_liion = power decision in kW
    OUTPUT :
            soc_next
            soh_next
            power = the real battery power in kW
    =#

    # Power constraint and correction
    0 <= u_liion <= liion.α_p_dch * liion.Erated ? power_dch = u_liion : power_dch = 0
    0 <= -u_liion <= liion.α_p_ch * liion.Erated ? power_ch = u_liion : power_ch = 0

    # SoC dynamic
    soc_next = x_liion.soc * (1 - liion.η_self * Δh) - (power_ch * liion.η_ch + power_dch / liion.η_dch) * Δh / liion.Erated

    # SoH dynamic
    soh_next = x_liion.soh - (power_dch - power_ch) * Δh / (2 * liion.nCycle * liion.dod * liion.Erated)

    # SoC and SoH constraints and corrections
    overshoot = (round(soc_next;digits=3) < liion.α_soc_min) || (round(soc_next;digits=3) > liion.α_soc_max) || (soh_next < 0)

    overshoot ? soc_next = max(x_liion.soc * (1 - liion.η_self), liion.α_soc_min) : nothing
    overshoot ? soh_next = x_liion.soh : nothing
    overshoot ? power_ch = power_dch = 0 : nothing
    return soc_next, soh_next, power_ch + power_dch
end

#-------------------------------------------------------------------------------
#                              Power balance
#-------------------------------------------------------------------------------
function power_balance(h::Int64, ld::Load, pv::Solar, liion::Liion, grid::Grid)
    grid.power[h] = ld.power[h] - pv.power[h]  - liion.power[h]
end

#-------------------------------------------------------------------------------
#                              Compute cost
#-------------------------------------------------------------------------------
function compute_cost(ld::Load, pv::Solar, liion::Liion, grid::Grid,
     parameters::NamedTuple)
    #=
    Here is a dummy function to compute economical indicators.
    =#
    capex = opex = npv = 0.
    return Cost(capex, opex, npv)
end

#-------------------------------------------------------------------------------
#                              Plot
#-------------------------------------------------------------------------------
function plot_results(ld::Load, pv::Solar, liion::Liion, grid::Grid)
    Seaborn.set(context="notebook",style="ticks",palette="muted", font="serif", font_scale=1.5)
    figure("Results")
    subplot(311), plot(ld.power, linestyle="--", linewidth=2, color= "black", label="LOAD")
    plot(pv.power, linewidth=2, color= "sandybrown",  label="PV")
    plot(liion.power, linewidth=2, color= "forestgreen",  label="LIION")
    plot(grid.power, linewidth=2, color= "gray",  label="GRID")
    ylabel("POWER (kW)", weight="black", size = "large"), yticks(weight = "black", size = "medium")
    xticks(weight="bold", size = "medium")
    legend(fontsize="medium", edgecolor="inherit", ncol=4)
    subplot(312), plot(liion.soc * 100, linewidth=2, color= "forestgreen")
    xticks(weight="bold", size = "medium")
    ylabel("SOC (%)", weight="black", size = "large"), yticks(weight = "black", size = "medium")
    subplot(313), plot(liion.soh * 100, linewidth=2, color= "forestgreen")
    xlabel("HOURS", weight="black", size = "large"), xticks(weight="bold", size = "medium")
    ylabel("SOH (%)", weight="black", size = "large"), yticks(weight = "black", size = "medium")
end
