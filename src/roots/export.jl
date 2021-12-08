using DelimitedFiles
using JLD2
using FileIO

include("polyroots.jl")

# placeholder, this should actually do things
function formatter(x)   
    # string(x)
    # filter(x -> !isspace(x), x)
    # chop(roots,head=0,tail=1)
    return x
end

function write(rootsDict, formatter, f::IOStream)
    rootsIterable = values(rootsDict)
    rootsFormatted = Iterators.map(formatter, rootsIterable)
    DelimitedFiles.writedlm(f, rootsFormatted)
end

function generateRoots(importFilename, exportFilename, format)

    qRootsMatrix, headers = loadData(importFilename)
    roots = polyRoots(qRootsMatrix, headers) # Calculate roots

    if format == "csv"
        println("Exporting Roots to CSV:")
        open("data/" * exportFilename *".csv","w") do f
        write(roots, formatter, f)
        end
    end

    if format == "jld2"
        save("data/" * exportFilename * ".jld2", roots)
    end
    println("Export Successful")
end

generateRoots("q_to_denom_850.csv","q_to_roots_850", "csv")
