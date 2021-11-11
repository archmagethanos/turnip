using PolynomialRoots
using DelimitedFiles

filepath = "data/q_to_denom_30.csv"

qRootsMatrix, headers = readdlm(filepath, ',', Float64; header=true) 
#print(qRootsMatrix[:,3])

function polyRoots(qRootsSource, header)
    rootsdict = Dict{String, Vector{Int64}}
    n = 1
    for col in eachcol(qRootsSource)
        #print(col)
        r = roots(col)
        rootsdict[header[n]] => r
        n += 1
    end
    @time r
    return rootsdict
end

roots = polyRoots(qRootsMatrix, headers)
print(roots)