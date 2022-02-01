using Polynomials
using Plots
using PolynomialRoots
using ProgressMeter

#= struct ContinuedFraction{T}
	quotients::Vector{T}
	ContinuedFraction{T}(qs::Vector{T}) where {T<:Integer} = new{T}(qs)
end

quotients(cf::ContinuedFraction) = cf.quotients
eltype(it::ContinuedFraction{T}) where {T} = T

function Base.Rational(cf::ContinuedFraction)
    qs = quotients(cf)
    isempty(qs) && return 0 // 1
    length(qs) == 1 && return qs[1] // 1

    remainder = qs[2:end]
    rat = Rational(ContinuedFraction(remainder))
    (qs[1] * rat.num + rat.den) // rat.num
end

function ContinuedFraction(rat::Rational{T}) where {T<:Integer}
    a = div(rat.num, rat.den)
    a * rat.den == rat.num && return ContinuedFraction(T[a])  # Exact!

    cf = ContinuedFraction(rat.den//(rat.num - a*rat.den))
    pushfirst!(quotients(cf), a) # insert at index 1
    cf
end =#
# Begin Eric

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


q = Q([1,100])
println(typeof(q))

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

rootsdict = Dict([(D, Dict([(rat[1], [rat, -1]) for rat in fractionline(D)])) for D in 3:100]);

@showprogress for den in keys(rootsdict)
    for num in keys(rootsdict[den])
        rootsdict[den][num][2]=bigroots(Q([num,den]))
    end
end

function id(z)
	return z
end

function F64(z)
	return convert(Complex{Float64},z)
end

function generateRootset()
	rootset = []
	@showprogress for den in keys(rootsdict)
    	for num in keys(rootsdict[den])
        	rootset=union(rootset, map(id,rootsdict[den][num][2]))
    	end
	end
	return rootset
end
rootset = generateRootset()

c1=filter(z->abs2(z)<3, rootset);

scatter([c1[j] for j in 1:length(c1)], mode="markers", markersize = 1,markerstrokewidth=0, c = :blue, size = (5000,5000), label=false, aspect_ratio=1, framestyle= :none)

savefig("plots/ericScatter.png")
savefig("plots/plots.svg")