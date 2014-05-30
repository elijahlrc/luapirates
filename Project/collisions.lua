local function build_terrain_aray(collider_table)
	local x,y = PLAYER.get_tile_location()
	for i=-4,TILES_ACROSS+4 do
		for j=-4,TILES_DOWN+4 do
			local pixel_x,pixel_y = (i+x-(TILES_ACROSS/2)),(j+y-(TILES_DOWN/2))

			if pixel_x < 0 or pixel_x > MAP_SIZE or pixel_y < 0 or pixel_y > MAP_SIZE then
				height = 255
			else
				_,height,_ = TERRAIN_MAP:getPixel(pixel_x,pixel_y)
			end
			if height>122 then
				local pos =  pixel_x.."_"..pixel_y
				if  not collider_table[pos] then
					collider_table[pos] = Collider:addRectangle(pixel_x*TILE_SIZE,pixel_y*TILE_SIZE, TILE_SIZE,TILE_SIZE)
					collider_table[pos].name = "terrain_collider"
					Collider:setPassive(collider_table[pos]) --sets terain rects as passive. Do not create colision callbacks
					
				end
			end
		end
	end
	return collider_table
end
function instantiate_colisions ()
	HC = require "HardonCollider"
	Collider = HC(100,on_collision)
	--need to instantiate obj for both player ship and land

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
	print(shape_2.name)
	shape_1.owner.handle_collisions(dt,shape_2,dx,dy)
end
