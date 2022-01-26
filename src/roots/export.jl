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

<<<<<<< HEAD
function generateRoots(importFilename, exportFilename, format)

    qRootsMatrix, headers = loadData(importFilename)
    roots = polyRoots(qRootsMatrix, headers) # Calculate roots

    if format == "csv"
        println("Exporting Roots to CSV:")
        open("data/" * exportFilename *".csv","w") do f
        write(roots, formatter, f)
=======
function exportDict(inDict::Dict, filename::String, format::String)
    try
        if format == "csv"
            println("Exporting Roots to CSV:")
            open("data/" * filename *".csv","w") do f
            write(inDict, formatter, f)
            end
>>>>>>> 87f3f9a211ec88f580d4e1f265b7e197fca7e777
        end

<<<<<<< HEAD
    if format == "jld2"
        save("data/" * exportFilename * ".jld2", roots)
=======
        if format == "jld2"
            save("data/" * filename * ".jld2", roots)
        end
        
        return 1
    catch e
        println("ProcessError: Export unsuccessful")
        return -1
>>>>>>> 87f3f9a211ec88f580d4e1f265b7e197fca7e777
    end
end

<<<<<<< HEAD
generateRoots("q_to_denom_850.csv","q_to_roots_850", "csv")
=======

>>>>>>> 87f3f9a211ec88f580d4e1f265b7e197fca7e777
