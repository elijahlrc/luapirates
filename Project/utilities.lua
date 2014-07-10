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
              local mult = 10^(idp or 0)
              return math.floor((num*mult+.5))/mult
end

function random_gauss(center,varyance)
   local standard_normal =  math.sqrt(-2 * math.log(math.random())) * math.cos(2 * math.pi * math.random()) / 2
   return standard_normal*varyance + center
end
function coppyTable(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[coppyTable(orig_key)] = coppyTable(orig_value)
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end