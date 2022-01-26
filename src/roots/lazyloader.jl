using CSV
using Distributed
using DelimitedFiles

function checkValidFile(fname::String)
    return isfile(fname)
end

function getNumAvailProcess()
    return Threads.nthreads()
end

function getFileSizeGB(fname::String)
    size = stat(fname).size / 2^30
    return trunc(Int, size)
end

# returns free memory in GiB
function getFreeMemory()
    x = convert(Int64, Sys.free_memory())
    return convert(Int, round(x/2^30))
end

function joinPath(a, b)
    try
        c = a * b
        return c
    catch
        println("TypeError: Input must be valid String") 
    end
end

function formatter()
end

function wholeLoad(fname::String)

    returnVec = Vector{Any}(undef,2)

    qRootsMatrix, headers = readdlm(fname, ',', BigInt; header=true, use_mmap=true) 
        returnVec[1] = qRootsMatrix; returnVec[2] = headers
        return returnVec

    try
        qRootsMatrix, headers = readdlm(fname, ',', BigInt; header=true, use_mmap=true) 
        returnVec[1] = qRootsMatrix; returnVec[2] = headers
        return returnVec
    catch
        println("LoadError: File not found or of invalid type")
    end

    return returnVec
end

function rowLoad(fname::String)
    return 1
end

function loader(fname::String)
    
    try
        checkValidFile(fname) || error("LoadError: File does not exist.")

        if (getFileSizeGB(fname) <= 0.75 * getFreeMemory()) 
            loader = wholeLoad(fname)
            return loader[1],loader[2]
        end

        rowLoader = rowLoad(fname)
        return rowLoader
    catch e
        println("LoadError: File not supported")
    end
end