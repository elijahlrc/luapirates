-- Rectangle collision detection function. --NO ROTATIONS
-- Returns true if two rectangles overlap
-- x1,y1 are the left-top points of the first rectangle, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second rectangle
function collision_rect(x1,y1,w1,h1, x2,y2,w2,h2)
  if x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1 then
  	return true
  end
end

function collision_point(player_x,player_y,tile_x,tile_y)

	-- Based on your current point, it checks all 25 tiles around you to see if your collide with any tiles
	-- If no tiles collide, it returns false, if any one tile collides it returns true

	for i=-2,2 do 
		for j=-2,2 do
			point = TERRAIN_MAP:getPixel(tile_x+i,tile_y+j)
			if point == 1 then

				if collision_rect(
				player_x-PLAYER.get_sprite():getWidth()/2, -- x1
				player_y-PLAYER.get_sprite():getHeight()/2, -- x2
				PLAYER.get_sprite():getWidth(), -- w1
				PLAYER.get_sprite():getHeight(), -- w2
				(tile_x+i)*TILE_SIZE, -- x2
				(tile_y+j)*TILE_SIZE, -- x1
				TILE_SIZE, -- w1
				TILE_SIZE) then -- w2
					return true
				end

			end
		end
	end
	return false
end