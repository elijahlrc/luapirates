local function build_terrain_aray(collider_table)
	--[[

	This code is currently a shitstorm dont try to understand it right now
	It is in a state similar to how genration was once upon a time.
	It also needs simple optimisation done
	TURN BACK NOW, OR ABANDON ALL HOPE

	todo:
	points for bullet shapes could be a small optimisation
	--]]
	local x,y = PLAYER.get_tile_location()
	local coppy_table = {}
	local height, obj
	for i=-4,TILES_ACROSS+4 do
		for j=-4,TILES_DOWN+4 do
			local pixel_x,pixel_y = round(i+x-(TILES_ACROSS/2)),round(j+y-(TILES_DOWN/2))

			if pixel_x < 0 or pixel_x > MAP_SIZE or pixel_y < 0 or pixel_y > MAP_SIZE then
				height = 255
			else
				_,height,obj = TERRAIN_MAP:getPixel(pixel_x,pixel_y)
			end
			if height > 122 and obj ~= 3 then --if its not a doc because there coliders are special
				local pos =  pixel_x.."_"..pixel_y --so that they can referance the city
				if  not collider_table[pos] then
					coppy_table[pos] = Collider:addRectangle(pixel_x*TILE_SIZE,pixel_y*TILE_SIZE, TILE_SIZE,TILE_SIZE)
					coppy_table[pos].name = "terrain_collider"
					Collider:setPassive(coppy_table[pos]) --sets terain rects as passive. Do not create colision callbacks
				else
					coppy_table[pos] = collider_table[pos]
				end
			end
		end
	end
	return coppy_table
end
function instantiate_colisions ()
	HC = require "HardonCollider"
	Collider = HC(100,on_collision)
	--need to instantiate obj for player

end

function update_collisions(dt)
	if not collider_table then
		collider_table = build_terrain_aray({})
	else
		collider_table = build_terrain_aray(collider_table)
	end

	Collider:update(dt)
	-- not sure what else goes here
end

function on_collision(dt, shape_1, shape_2, dx, dy)
	--[[
	------------------
	ALL OBJECTS WHICH ARE HANDLED BY Collider MUST HAVE 
	A "handle_collisions" Method!!!

	I am using a data-driven colision handeling method, that is,
	the obj coliding handel there own colisions. Thats why
	they must have a "handle_colisions" method
	------------------
	--]]
	shape_1.owner.handle_collisions(dt,shape_2,dx,dy)
	if shape_2.owner then
		shape_2.owner.handle_collisions(dt,shape_1,-1*dx,-1*dy)
	end
end
