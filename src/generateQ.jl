using Polynomials
using Plots
using PolynomialRoots
using ProgressMeter
using BenchmarkTools
using JLD2
using CSV

gr()
#plotlyjs()
begin
	quot(v)=v[1]//v[2]
	vect(r)=[numerator(r),denominator(r)]
end

begin
	remainder(v) = v[1] % v[2]
	flr(v)=numerator(floor(v[1] // v[2]))
	newpair(v) = [v[2], remainder(v)]
	function continued_fraction(v)
		cf=[]
		while remainder(v) != 0
			push!(cf, flr(v))
			v=newpair(v)
		end
		push!(cf, flr(v))
		cf
	end
	function cf_value(cf)
		rev = reverse(cf)
		rat = popfirst!(rev)
		for j in rev
			rat = j+1//rat
		end
		[numerator(rat), denominator(rat)]
	end
end

function center_corner_index(v)
	v[1] == 1 && return [[0,1],[1,0],v[2]]
	center_cf = continued_fraction(v)[1:end-1]
	center = cf_value(center_cf)
	push!(center_cf, 1)
	k2 = cf_value(center_cf)
	corner = k2 - center
	ind = numerator((v[1] - corner[1]) // center[1])
	[center, corner, ind]
end

# testing updating q 
function dQ(v)
		return Polynomial(push!(zeros(BigInt,v[2]), (-1)^v[1]))
end

function Q(v)
		v==[0,1] && return 1
		v==[1,0] && return 0
		v==[1,1] && return 1
		cci=center_corner_index(v)
		c,k,i=cci[1],cci[2],cci[3]
		return ([0 1; -dQ(c) Q(c)]^(i-1) * [Q(k); Q(k+c)])[2]
end

function bigroots(poly)
    PolynomialRoots.roots(convert(Vector{BigInt},coeffs(poly)))
end

function cleanpair(p)
    	r=p[1]//p[2]
    	return [numerator(r), denominator(r)]
end

function fractionline(n)  #fractions in (0,1/2) with denominator n.  
    	top=ceil(n//2)
    	L=[cleanpair([j,n]) for j in 1:top-1 ]
    	return filter(rat-> rat[2]==n ,L)
end

function id(z)
	return z
end

function F64(z)
	return convert(Complex{Float64},z)
end

function generateDiscriminants(rational)
    q2 = Q(rational)^2
    dq  = dQ(rational)
    return (q2 - 4 * dq)
end

function generateQDict(max_denom)
	qDict = Dict{Vector{Int64}, Polynomial{BigInt}}([1,3] => Q([1,3]))

	for key in 4:max_denom
		rats = fractionline(key)
		for rat in rats
			qDict[rat] = Q(rat)
		end
	end
	return qDict
end

function generateDiscriminantsDict(qDict)
	discDict = Dict{Vector{Int64}, Polynomial{BigInt}}([1,3] => generateDiscriminants([1,3]))
	
	for key in collect(keys(qDict))
		discDict[key] = generateDiscriminants(key)
	end
	return discDict
end

function generateRoots(dict)
	setprecision(BigFloat, 1024) do
		n = length(dict)
	
		p = Progress(n, 1, "Generating roots...", 50)

		keysdict = collect(keys(dict))
		rootsDict = Dict{Vector{Int64}, Vector{Complex{BigFloat}}}(keysdict[1] => PolynomialRoots.roots(keysdict[1]))

		@Threads.threads for key in keysdict
			poly = coeffs(dict[key])
			rootsDict[key] = PolynomialRoots.roots(poly)
			next!(p)
		end
	return rootsDict	
	end
end

function keys2string(dict)
	ret_dict = Dict("[1,3]" => PolynomialRoots.roots(coeffs(Q([2,5]))))
	for key in keys(dict)
		ret_dict[string(key)] = dict[key] 
	end
	return ret_dict
end

function generateRootset(rootsdict)
	rootset = []

	denKey = collect(keys(rootsdict))
	n = length(denKey) +2

	p = Progress(n, 1, "Mapping unions...", 50)

	Threads.@threads for key in denKey
        	rootset=union(rootset, map(id,rootsdict[key]))
		next!(p)
	end
	return rootset
end

function runQPlot(rootset, discset, max_denom)

	c1=filter(z->abs2(z)<3, rootset);
	c2=filter(z->abs2(z)<3, discset);

	scatter([c1[j] for j in 1:length(c1)], markersize = .8,markerstrokewidth=0, c = :white, size = (5000,5000), label=false, aspect_ratio=1, framestyle= :none, background_color= :black)
	scatter!([c2[j] for j in 1:length(c1)], markersize = .8,markerstrokewidth=0, c = :red)
	
	savefig("plots/scatter_" * string(max_denom) * ".png");
end

function main(max_denom)
	if isfile("data/roots_" * string(max_denom) * ".jld2")
		r = load("data/roots_" * string(max_denom) * ".jld2")
	else
		q1 = generateQDict(max_denom)
		r = generateRoots(q1)
		r = keys2string(r)
		save("data/roots_" * string(max_denom) * ".jld2", r)
	end

	if isfile("data/disc_roots_" * string(max_denom) * ".jld2")
		rs = load("data/disc_roots_" * string(max_denom) * ".jld2")
	else
		q = generateQDict(max_denom)
		d = generateDiscriminantsDict(q)
		rs = generateRoots(d)
		rs = keys2string(rs)
		save("data/disc_roots_" * string(max_denom) * ".jld2", rs)
	end

	r = generateRootset(r)
	rs = generateRootset(rs)

	runQPlot(r,rs,max_denom)
end

function export2CSV(max_denom)
	r = load("data/roots_" * string(max_denom) * ".jld2")
	rs = load("data/disc_roots_" * string(max_denom) * ".jld2")

	r = generateRootset(r)
	rs = generateRootset(rs)

	c1 = filter(z->abs2(z)<3, r);
	c2 = filter(z->abs2(z)<3, rs);

	CSV.write("data/roots_" * string(max_denom) * ".csv",c1)
	CSV.write("data/disc_" * string(max_denom) * ".csv",c2)
end

function export2CSV(max_denom)
r = load("data/roots_" * string(max_denom) * ".jld2")
rs = load("data/disc_roots_" * string(max_denom) * ".jld2")

r = generateRootset(r)
rs = generateRootset(rs)

c1 = filter(z->abs2(z)<3, r);
c2 = filter(z->abs2(z)<3, rs);

CSV.write("data/roots_" * string(max_denom) * ".csv",c1)
CSV.write("data/disc_" * string(max_denom) * ".csv",c2)
end


export2CSV(420)