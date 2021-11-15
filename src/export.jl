using DelimitedFiles
using BenchmarkTools
include("polyroots.jl")

# This script is responsible for taking the outputted roots from our Q Polynomials 
# and printing to a .csv file. 

# ToDo write formatting for the polynomial



# placeholder, this should actually do things
function formatter(x)
    return x
end

# Print out a dictionary
function write(rootsDict, formatter, f::IOStream)
    rootsIterable = values(rootsDict)
    rootsFormatted = Iterators.map(formatter, rootsIterable)
    DelimitedFiles.writedlm(f, rootsFormatted)
end

# Generate and print out our dictionary 
function generateRoots()
    qRootsMatrix, headers = loadData("q_to_denom_30.csv")
    roots = polyRoots(qRootsMatrix, headers)
    open("data/q_roots_30.csv","w") do f
        write(roots, formatter, f)
    end
end

@btime generateRoots()