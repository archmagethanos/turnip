using CSV
using Distributed

function checkValidFile(filename::String)
    return isfile(filename)
end

function getNumAvailProcess()
    return Threads.nthreads()
end

function getFileSizeGB(filename::String)
        size = stat(filename).size / 1073741824
        return trunc(Integer, size)
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

#6 Added in use of CSV.Chunks to enable files outside of max memory.
# Returns a blocks object to iterate over
function lazyChunksLoader(fname::String)
    fpath = joinPath("data/", fname)
    if (checkValidFile(fpath))
        try
            numBlock = getFileSizeGB(fname)
            return CSV.Chunks(fpath,tasks=numBlock; transpose = true)
        catch e
            println("File failed to load.")
        end
    else return C_NULL
    end
end

function chunkedRowExporter(chunks::CSV.Chunks)
    for chunk in chunks
        for row in chunk
            println(row)
        end
    end
end

function loader(fname::String)
    chunks = lazyChunksLoader(fname)
    chunkedRowExporter(chunks)
end

loader("foo.csv")

