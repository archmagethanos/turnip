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

function exportDict(inDict::Dict, filename::String, format::String)
    try
        if format == "csv"
            println("Exporting Roots to CSV:")
            open("data/" * filename *".csv","w") do f
            write(inDict, formatter, f)
            end
        end

        if format == "jld2"
            save("data/" * filename * ".jld2", roots)
        end
        
        return 1
    catch e
        println("ProcessError: Export unsuccessful")
        return -1
    end
end


