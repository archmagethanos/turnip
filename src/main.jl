include("roots/lazyloader.jl")
include("roots/polyroots.jl")
include("roots/export.jl")
include("plotting/plots.jl")

# LEGACY: implement python call to generate roots
# generateQ = pyimport("src/polynomials/generate_q.py")
println(wd)
function qPolyRootsScript(max_denom::Int; exportType::String="none", plotType::String="none")
    max_denom = string(max_denom)
    infname::String = "data/q_to_denom_" * max_denom * ".csv"
    ofname::String = "data/q_to_roots_" * max_denom

    try 
        qRootsMatrix, headers = loader(infname)
        rootsDict = polyRoots(qRootsMatrix, headers)

        exportType != "none" && exportDict(rootsDict, ofname, exportType)

        plotType != "none" && qPlot(rootsDict, plotType)
        
        println("Successful generation for roots to a maximum of " * max_denom * "!")
    catch e
        println("ProcessError: Failure to run roots generation and export")
    end
    
end

function main()
    qPolyRootsScript(30; "csv", "none")
    qPolyRootsScript(200; "csv", "none")
    #qPolyRootsScript(400; "csv")
end

main()