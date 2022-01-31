using Distributed
@everywhere begin
    using PolynomialRoots
    using Test
    include("polyroots.jl")  
end
using BenchmarkTools


addprocs();
nworkers()

@everywhere const qRootsMatrix, headers = loadData("q_to_denom_30.csv")

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
    function polyRootS(n,qmat=qRootsMatrix, head=headers)
        q = removeZero(qmat[:,n])
        r = roots(q)
        h = head[n]
        #prootsdict[h] = r
        fin = [h,r]
        return fin
    end
end

function parPolyRoots()
    #n = size(qRootsSource, 2)
    qRootsMatrix, headers = loadData("q_to_denom_30.csv")
    #pmap(polyRootS, 6:n; on_error=identity)
end



println("Parallel time")
@btime parPolyRoots()


