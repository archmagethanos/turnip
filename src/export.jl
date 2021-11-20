using DelimitedFiles

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
    qRootsMatrix, headers = loadData("q_to_denom_500.csv")
    roots = polyRoots(qRootsMatrix, headers) # Calculate roots
    println("Exporting Roots to CSV:")
    open("data/q_to_roots_500.csv","w") do f
        write(roots, formatter, f)
    end
    println("Export Successful")
end

generateRoots()
