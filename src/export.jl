using DelimitedFiles
using BenchmarkTools
#using Base.Threads.@spawn

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

function generateRoots()
    qRootsMatrix, headers = loadData("q_to_denom_30.csv")
    roots = polyRoots(qRootsMatrix, headers) # Calculate roots
    println("Exporting Roots to CSV:")
    open("data/q_to_roots_30.csv","w") do f
        write(roots, formatter, f)
    end
end

# @btime generateRoots()
#generateRoots()
