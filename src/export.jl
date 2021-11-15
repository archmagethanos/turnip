using DelimitedFiles
using BenchmarkTools
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
    qRootsMatrix, headers = loadData("q_to_denom_200.csv")
    roots = polyRoots(qRootsMatrix, headers)
    open("data/q_roots_200.csv","w") do f
        write(roots, formatter, f)
    end
end

@btime generateRoots()