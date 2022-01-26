using GRUtils

using Plots

function makeData(rootsDict::Dict)
    realRoot = zeros(0)
    imagRoot = zeros(0)
    prog = ProgressUnknown("Plotting...")
    for vector in values(rootsDict)
        for root in vector
            append!(realRoot, real(root))
            append!(imagRoot, imag(root))
            ProgressMeter.next!(prog)
        end
    end 
    ProgressMeter.finish!(prog)

    return realRoot, imagRoot
end

function createScatter(realRoots::Vector, imagRoots::Vector, max_denom::String)

    size = 30*ones(length(realRoots))
    GRUtils.scatter(realRoots, imagRoots, size)

    
    # Formatting
    xlabel("ℜ")
    ylabel("ℑ")

    GRUtils.grid(false)
    ylim(-3,3)
    xlim(-3,3)

    title("Plot of Q Polynomial Roots")
    grid(false)

    GRUtils.savefig("plots/q_plot_for_max_" * max_denom * ".png")
end

function testPlots(realRoots::Vector, imagRoots::Vector)
    gaston()
    Plots.plot(realRoots, imagRoots, seriestype = :scatter)
    png("plots/test")
end


function plotQ(rootsDict::Dict{SubString{String}, Vector}, max_denom::String)
    #try
        r,im = makeData(rootsDict)
        #createScatter(r,im, max_denom)
        testPlots(r,im)
    #catch e
        #println("ProcessError: Plotting failed.")
    #end
    
end


