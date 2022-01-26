include("roots/lazyloader.jl")
include("roots/polyroots.jl")
include("roots/export.jl")
include("plotting/plots.jl")

# LEGACY: implement python call to generate roots
# generateQ = pyimport("src/polynomials/generate_q.py")



function qPolyRootsScript(max_denom::Int; exportType::String, plotType::String)
    max_denom = string(max_denom)
    infname::String = "data/q_to_denom_" * max_denom * ".csv"
    ofname::String = "data/q_to_roots_" * max_denom
     
    qRootsMatrix, headers = loader(infname)
    rootsDict = polyRoots(qRootsMatrix, headers)

    # exportType == "csv" && exportDict(rootsDict, ofname, exportType)

    plotType == "png" && plotQ(rootsDict, max_denom)
        
    println("Successful generation for roots to a maximum of " * max_denom * "! \n")
    #println("ProcessError: Failure to run roots generation and export")
    
end

function main()
    qPolyRootsScript(30; exportType = "csv", plotType = "png")
    qPolyRootsScript(200; exportType = "csv", plotType = "png")
    #qPolyRootsScript(500; exportType = "csv", plotType = "png")
    #qPolyRootsScript(400; exportType = "csv", plotType = "png")
end

main()