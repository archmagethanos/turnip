using PolynomialRoots
using DelimitedFiles
using DoubleFloats
using ProgressBars
using Base.Threads
using ProgressMeter

# using BenchmarkTools

# Our program takes an input of a .csv file of formatted vectors with the first row devoted to the header, 
# a string representation of the rational vector composing the polynomial. The program exports the resulting
# roots to a csv in the same directory. 


function loadData(filename)
    datadirpath = "data/"
    filepath = joinPath(datadirpath, filename)
<<<<<<< HEAD
    if (isfile(filepath))
        try
            qRootsMatrix, headers = readdlm(filepath, ',', Float64; header=true, use_mmap=true) 
            return qRootsMatrix, headers
        catch
            println("ERROR: File not found or of invalid type.")
        end
=======
    try
        qRootsMatrix, headers = readdlm(filepath, ',', BigInt; header=true, use_mmap=true) 
        return qRootsMatrix, headers
    catch
        println("ERROR: File not found or of invalid type.")
>>>>>>> 87f3f9a211ec88f580d4e1f265b7e197fca7e777
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
<<<<<<< HEAD
    p = Progress(length)
    # Threads.@threads for n in ProgressBar(1:length)
    Threads.@threads for n in 1:length
=======

    p = Progress(length, .1, "Calculating roots...", 50)

    Threads.@threads for n in 1:length 
>>>>>>> 87f3f9a211ec88f580d4e1f265b7e197fca7e777
        if get(rootsdict, headers[n], 0) == 0
           q = qRootsSource[:,n] 
           q = removeZero(q)
           r = roots(q)
           rootsdict[headers[n]] = r
<<<<<<< HEAD
=======

>>>>>>> 87f3f9a211ec88f580d4e1f265b7e197fca7e777
           next!(p)
        end
    end 
    
    println("Roots Generation Complete.") 
    return rootsdict
end 



<<<<<<< HEAD

# qRootsMatrix, headers = loadData("q_to_denom_30.csv")

# polyRoots(qRootsMatrix, headers) # Calculate roots
=======
qRootsMatrix, headers = loadData("q_to_denom_200.csv")

>>>>>>> 87f3f9a211ec88f580d4e1f265b7e197fca7e777

