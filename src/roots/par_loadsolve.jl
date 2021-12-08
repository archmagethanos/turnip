using ProgressMeter

struct QPoly
    a::String
    b::Vector{Float64}

function readFileLines(fileName::String)
    file = open(fileName,"r")

    seekend(file)
    fileSize = position(file)

    seekstart(file)
    p = Progress(fileSize, 1)   # minimum update interval: 1 second
    while !eof(file)
        line = readline(file)
        

        update!(p, position(file))
    end
end

readtest = readFileLines("data/q_to_denom_35.csv")