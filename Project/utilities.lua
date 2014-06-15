function distance(x1,y1,x2,y2)
	return math.sqrt((x1-x2)^2+(y1-y2)^2)
end
function get_direction(x1,y1,x2,y2)
	return math.atan2((y2-y1),(x2-x1))
end
function dotProduct(l1,r1,l2,r2)
	local v1 = get_vector_components(l1,r1)
	local v2 = get_vector_components(l2,r2)
	return v1[1]*v2[1]+v2[2]*v2[2]
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
	local short_ang = shortAng(a1,a2)
    if short_ang>0 then
    	return "cl"
    elseif short_ang<0 then
    	return "cc"
    else
    	return "0"
    end
end
function shortAng(a2,a1)
    return math.atan2(math.sin(a1-a2),math.cos(a1-a2))--DEEEEEEP magic
end
function round(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))--more magic
end

function random_gauss(center,varyance)
   local standard_normal =  math.sqrt(-2 * math.log(math.random())) * math.cos(2 * math.pi * math.random()) / 2
   return standard_normal*varyance + center
end