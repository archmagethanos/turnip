using Distributed
@everywhere begin
    using PolynomialRoots
    using DoubleFloats
    using SparseArrays
    using Test
    include("polyroots.jl")  
end
using BenchmarkTools

@everywhere qRootsSource, headers = loadData("q_to_denom_30.csv")
global prootsdict = Dict(headers[1]=>[], headers[2]=>[1+0im], headers[3]=>[1+0im], headers[4]=>[0+0im], headers[5]=>[0+0im])
# Our program takes an input of a .csv file of formatted vectors with the first row devoted to the header, 
# a string representation of the rational vector composing the polynomial. The program exports the resulting
# roots to a csv in the same directory. 

addprocs(2)

@everywhere begin
    function removeZero(vec)
        n = length(vec)
        ind = 0
        
        for i in vec 
            if i == 0 
            ind += 1
            end
        end

        trimvec = Vector{Float64}(undef,n-ind)

        for i in 1:(n-ind)
            trimvec[i] = vec[i+ind]
        end
        return trimvec
    end
end
@test removeZero([0,0,1,1]) == [1,1]

@everywhere begin
    function polyRootS(n)
        q = removeZero(qRootsSource[:,n])
        r = roots(q)
        h = headers[n]
        fin = [h,r]
        return fin
    end
end

function parPolyRoots()
    n = size(qRootsSource, 2)
    r = pmap(x->polyRootS(x) ? error("failed") : x, 6:20; on_error=identity)
end

#@btime roots = polyRoots(qRootsMatrix, headers) # Calculate roots


parPolyRoots()

# println(prootsdict)

