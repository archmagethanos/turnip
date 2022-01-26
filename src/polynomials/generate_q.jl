using Polynomials
using ContinuedFractions


function corner()
    #def corner(c): # Left and right corners of Triangle(c)
    p, q, left, right, s = c[0], c[1], x, x, 1
    while left==x or right==x: 
        if left==x and  ((p*s-1)%q)==0:  left=vector([(p*s-1)/q,s])
        if right==x and ((p*s+1)%q)==0:  right=vector([(p*s+1)/q,s])
        s+=1
    return [left, right]
end

function listQ()
end

function dQ()
end

function Q()
end

