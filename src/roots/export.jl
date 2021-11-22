using DelimitedFiles
using JLD2
using FileIO

include("polyroots.jl")

# placeholder, this should actually do things
function formatter(x)
    return x
end

function write(rootsDict, formatter, f::IOStream)
    rootsIterable = values(rootsDict)
    rootsFormatted = Iterators.map(formatter, rootsIterable)
    DelimitedFiles.writedlm(f, rootsFormatted)
end

function generateRoots(filename, format)
    qRootsMatrix, headers = loadData("q_to_denom_500.csv")
    roots = polyRoots(qRootsMatrix, headers) # Calculate roots

    if format == "csv"
        println("Exporting Roots to CSV:")
        open("data/" * filename *".csv","w") do f
        write(roots, formatter, f)
        end
    end

    if format == "jld2"
        save("data/" * filename * ".jld2", roots)
    end
    println("Export Successful")
end

generateRoots("q_to_roots_500", "jld2")
