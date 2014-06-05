function distance(x1,y1,x2,y2)
	return math.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2))
end
function get_direction(x1,y1,x2,y2)
	return math.atan2((y2-y1),(x2-x1))
end

function get_vector_components(l1,r1)
	local y = l1*math.sin(r1)
	local x = l1*math.cos(r1)
	return {x,y}
end
function add_vectors(l1,r1,l2,r2)
	local v1 = get_vector_components(l1,r1)
	local v2 = get_vector_components(l2,r2)
	local v3 = {v1[1]+v2[1],v1[2]+v2[2]}
	local l3 = math.sqrt(v3[1]^2 +v3[2]^2)
	local r3 = math.atan2(v3[2],v3[1])
	return {l3,r3}
end
function shortestAngleDir(a1,a2)
	a1 = a1%(2*math.pi)
	a2 = a2%(2*math.pi)
    if math.abs(a1-a2)<math.pi and a1<a2 then
        return 1
    elseif math.abs(a1-a2)>=math.pi and a1>a2 then
        return 1
    else
        return -1
    end
end
