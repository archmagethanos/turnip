using PolynomialRoots
using DelimitedFiles
using DataFrames

filepath = "data/q_to_denom_30.csv"

qRootsMatrix, headers = readdlm(filepath, ',', Float64; header=true) 
print(qRootsMatrix[:,1])


function polyRoots(qRootsSource, header)
    rootsdf = DataFrame()
    n = size(qRootsSource,1)
    for i in n
        r = roots(qRootsSource[:,i])
        push!(rootsdf, (header[i], r))
    end
    return rootsdf
    @time r
end

roots = polyRoots(qRootsMatrix, headers)
print(roots)