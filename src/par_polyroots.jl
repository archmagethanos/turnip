using Distributed
@everywhere begin
    using PolynomialRoots
    using DoubleFloats
    using SparseArrays
end

using BenchmarkTools

include("polyroots.jl")

# Our program takes an input of a .csv file of formatted vectorrs with the first row devoted to the header, 
# a string representation of the rational vector composing the polynomial. The program exports the resulting
# roots to a csv in the same directory. 

addprocs(2)

global qRootsSource, headers = loadData("q_to_denom_30.csv")
global prootsdict = Dict(headers[1]=>[], headers[2]=>[1+0im], headers[3]=>[1+0im], headers[4]=>[0+0im])

function removeZero(vec)
    ind = 1
    n = length(vec)
    for entry in 1:n
        if (a[ind] != 0) 
            ind = entry
        end
    end

    trimvec = vec{Float64}(undef, n-ind)
    
    for i in 1:n-ind
        trimvec[i] = vec[i +ind]
    end
    return trimvec
end

@everywhere begin
    function polyRootS(n)
        if get(prootsdict, headers[n], 0) == 0
            r = roots(qRootsSource[:,n])
            pxrootsdict[headers[n]] = r
            println("suck my ass")
         end  
    end
end

function parPolyRoots()
    n = size(qRootsSource, 2)
    pmap(x -> polyRootS(n) ? error("Not found") : x, 1:n; on_error=identity)
end

#@btime roots = polyRoots(qRootsMatrix, headers) # Calculate roots

#println("Start Parallel test")
#parPolyRoots()
#println("End Par test")

# polyRootS(5)
# println(prootsdict)

a = [0.0,0.0,1.0,1.0]
b = removeZero(a)
println(b)