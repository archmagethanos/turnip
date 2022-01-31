using GRUtils

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
    GRUtils.scatter(realRoots, imagRoots, size )

    
    # Formatting
    xlabel("ℜ")
    ylabel("ℑ")
    
    grid(false)
    ylim(-4,4)
    xlim(-4,4)

    title("Plot of Q Polynomial Roots")
    grid(false)

    GRUtils.savefig("plots/q_plot_for_max_" * max_denom * ".svg")
end

function plotQ(rootsDict::Dict{SubString{String}, Vector}, max_denom::String)
    #try
        r,im = makeData(rootsDict)
        createScatter(r,im, max_denom)
        
    #catch e
     #   println("ProcessError: Plotting failed.")
    #end
    
end


