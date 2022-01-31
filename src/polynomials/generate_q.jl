using Polynomials
using ContinuedFractions



quot(v)=v[1]//v[2]
vect(r)=[numerator(r),denominator(r)]


remainder(v)=v[1]%v[2]
flr(v)=numerator(floor(v[1]//v[2]))
newpair(v)=[v[2],remainder(v)]
function continued_fraction(v)
	cf=[]
	while remainder(v)!=0
			push!(cf,flr(v))
			v=newpair(v)
	end
	push!(cf,flr(v))
	cf
end

function cf_value(cf)
	rev=reverse(cf)
	rat=popfirst!(rev)
    for j in rev
		rat=j+1//rat
	end
	[numerator(rat),denominator(rat)]
end

function center_corner_index(v)
	v[1]==1 && return [[0,1],[1,0],v[2]]
	center_cf=continued_fraction(v)[1:end-1]
	center=cf_value(center_cf)
	push!(center_cf,1)
	k2=cf_value(center_cf)
	corner=k2-center
	ind=numerator((v[1]-corner[1])//center[1])
	[center,corner,ind]
end

begin
	function dQ(v)
		return Polynomial(push!(zeros(Int64,v[2]), (-1)^v[1]))
	end
	function Q(v)
		v==[0,1] && return 1
		v==[1,0] && return 0
		v==[1,1] && return 1
		cci=center_corner_index(v)
		c,k,i=cci[1],cci[2],cci[3]
		return ([0 1; -dQ(c) Q(c)]^(i-1) * [Q(k); Q(k+c)])[2]
	end
end


