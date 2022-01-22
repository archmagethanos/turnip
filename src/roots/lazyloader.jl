using CSV
using Distributed

function checkValidFile(fname::String)
    return isfile(fname)
end

function getNumAvailProcess()
    return Threads.nthreads()
end

function getFileSizeGB(fname::String)
        size = stat(fname).size / 1073741824
        return trunc(Integer, size)
end

# returns free memory in GiB
function getFreeMemory()
    return round(Sys.free_memory()/2^30, 0)
end

function joinPath(a, b)
    try
        c = a * b
        return c
    catch
        println("ERROR: Input must be valid String") 
    end
end

function formatter()
end

function wholeLoad(fname::String)
    return 1
end

function rowLoad(fname::String)
    return 1
end

function loader(fname::String)
    try
        checkValidFile(fname) || error("LoadError: File does not exist.")
        getFileSizeGB <= 0.75 * getFreeMemory && wholeLoad(fname)
        rowLoad(fname)
    catch e
        println("File not supported.")
    end
end


#println(checkValidFile("data/q_to_denom_750.csv"))
#println(getFileSizeGB("data/q_to_denom_750.csv"))
filename = "data/q_to_denom_750.csv"

loader("q_to_denom_750.csv")

