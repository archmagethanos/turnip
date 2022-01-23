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

function generateRoots(infile::String, filename::String, format::String)
    qRootsMatrix, headers = loadData(infile * ".csv")
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


