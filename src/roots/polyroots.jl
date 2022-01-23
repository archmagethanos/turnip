using PolynomialRoots
using DelimitedFiles
using DoubleFloats
using ProgressBars
using Base.Threads

# using BenchmarkTools

# Our program takes an input of a .csv file of formatted vectorrs with the first row devoted to the header, 
# a string representation of the rational vector composing the polynomial. The program exports the resulting
# roots to a csv in the same directory. 


function loadData(filename)
    datadirpath = "data/"
    filepath = joinPath(datadirpath, filename)
    try
        qRootsMatrix, headers = readdlm(filepath, ',', BigInt; header=true, use_mmap) 
        return qRootsMatrix, headers
    catch
        println("ERROR: File not found or of invalid type.")
    end
end

function joinPath(a, b)
    try
        c = a * b
        return c
    catch
        println("ERROR: Input must be valid String") 
    end
end

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

# Function takes in a matrix of roots, and their respective headers returning a dictionary (hashmap)
# of the roots keyed on headers. 
function polyRoots(qRootsSource, headers)
    length = Int(size(qRootsSource,2))
    rootsdict = Dict(headers[1]=>[], headers[2]=>[1+0im], headers[3]=>[1+0im], headers[4]=>[0+0im])

    Threads.@threads for n in ProgressBar(1:length)  
        if get(rootsdict, headers[n], 0) == 0
           q = qRootsSource[:,n] 
           q = removeZero(q)
           r = roots(q)
           rootsdict[headers[n]] = r
        end
    end 
    println("Roots Generation Complete.") 
    return rootsdict
end 



qRootsMatrix, headers = loadData("q_to_denom_200.csv")


