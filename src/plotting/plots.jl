using GRUtils


function makeData(rootsDict::Dict)
    realRoot = zeros(0)
    imagRoot = zeros(0)

    for vector in values(rootsDict)
        for root in vector
            append!(realRoot, real(root))
            append!(imagRoot, imag(root))
        end
    end 

    return realRoot, imagRoot
end

function createScatter(realRoots::Vector, imagRoots::Vector, max_denom::String)
    size = 30*ones(length(realRoots))
    color = 1*ones(length(realRoots))
    scatter(realRoots, imagRoots, size, color)
    
    # Formatting
    xlabel("ℜ")
    ylabel("ℑ")
    title("Plot of Q Polynomial Roots")

    savefig("plots/q_plot_for_max_" * max_denom * ".png")
end

function plotQ(rootsDict::Dict{SubString{String}, Vector}, max_denom::String)
    try
        r,im = makeData(rootsDict)
        createScatter(r,im, max_denom)
    catch e
        println("ProcessError: Plotting failed.")
    end
    
end


