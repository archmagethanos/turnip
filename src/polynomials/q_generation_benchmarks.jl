using BenchmarkTools

using AMRVW
using PolynomialRoots
using FastPolynomialRoots
using Polynomials


include("generate_q.jl")


function pkgAMRVW(qDict)
    for q in keys(qDict)
        a = convert(Vector{BigFloat}, coeffs(qDict[q]))
        AMRVW.roots(a)
    end
end


function pkgPolynomialRoots(qDict)
    for q in keys(qDict)
        a = convert(Vector{BigInt},coeffs(qDict[q]))
        PolynomialRoots.roots(a);
    end
end

function pkgFastPolynomialRoots(qDict)
    for q in keys(qDict)
        a = convert(Polynomial{Float64},qDict[q])
        a = FastPolynomialRoots.roots(a);
        println(typeof(a))
    end
end


q = generateQDict(100)
#@btime pkgPolynomialRoots(q) #PolyRoots
#@btime pkgAMRVW(q) #AMRVW
pkgFastPolynomialRoots(q) # FastPoly



