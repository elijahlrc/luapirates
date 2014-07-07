SPRITES = {}

SPRITES.ship = love.graphics.newImage("/sprites/ship.png")
SPRITES.ship2 = love.graphics.newImage("/sprites/ship2.png")
SPRITES.cargo_ship = love.graphics.newImage("/sprites/cargo.png")
SPRITES.tiles = love.graphics.newImage("/sprites/tiles.png")
SPRITES.canonball = love.graphics.newImage("/sprites/cannonBall.png")
SPRITES.scaterball = love.graphics.newImage('/sprites/smallBall.png')
SPRITES.house = love.graphics.newImage('/sprites/house.png')
local tiles_width = SPRITES.tiles:getWidth()
local tiles_height = SPRITES.tiles:getHeight()

TILE_BATCH = love.graphics.newSpriteBatch(SPRITES.tiles, 8192)

TILES = {}

TILES.dirt = love.graphics.newQuad(TILE_SIZE*0,  TILE_SIZE*0, TILE_SIZE, TILE_SIZE, tiles_height, tiles_width)
TILES.grass = love.graphics.newQuad(TILE_SIZE*1,  TILE_SIZE*0, TILE_SIZE, TILE_SIZE, tiles_height, tiles_width)
TILES.sand = love.graphics.newQuad(TILE_SIZE*0,  TILE_SIZE*1, TILE_SIZE, TILE_SIZE, tiles_height, tiles_width)
TILES.deep_water = love.graphics.newQuad(TILE_SIZE*1,  TILE_SIZE*1, TILE_SIZE, TILE_SIZE, tiles_height, tiles_width)
TILES.sand_grass = love.graphics.newQuad(TILE_SIZE*2,  TILE_SIZE*0, TILE_SIZE, TILE_SIZE, tiles_height, tiles_width)
TILES.grass_dirt = love.graphics.newQuad(TILE_SIZE*2,  TILE_SIZE*1, TILE_SIZE, TILE_SIZE, tiles_height, tiles_width)
TILES.shallow_water = love.graphics.newQuad(TILE_SIZE*0,  TILE_SIZE*2, TILE_SIZE, TILE_SIZE, tiles_height, tiles_width)
TILES.dark_water = love.graphics.newQuad(TILE_SIZE*1,  TILE_SIZE*2, TILE_SIZE, TILE_SIZE, tiles_height, tiles_width)
TILES.medium_water = love.graphics.newQuad(TILE_SIZE*2,  TILE_SIZE*2, TILE_SIZE, TILE_SIZE, tiles_height, tiles_width)
GRUNGEMAP = love.graphics.newImage("/sprites/Grungemap.png")



OBJECTS = {}

----- Static Object List

OBJECTS[1] = love.graphics.newImage("/sprites/tree.png")
OBJECTS[2] = love.graphics.newImage("/sprites/seaweed.png")
OBJECTS[3] = love.graphics.newImage("/sprites/woodplank.png")
OBJECTS[4] = love.graphics.newImage("/sprites/rock.png")
OBJECTS[5] = love.graphics.newImage('/sprites/house.png')
---- End Static Object List

function update_terrain(batch)
	--[[
	could this get a docstring
	]]
	batch:clear()

	local x,y = PLAYER.get_tile_location()
	local height
	local _
	local objects = {}


	for i=-4,TILES_ACROSS+4 do
		for j=-4,TILES_DOWN+4 do
			local pixel_x,pixel_y = round(i+x-(TILES_ACROSS/2)),round(j+y-(TILES_DOWN/2))

			if pixel_x < 0 or pixel_x > MAP_SIZE-1 or pixel_y < 0 or pixel_y > MAP_SIZE-1 then
				height = 255
			else
				_, height, object = TERRAIN_MAP:getPixel(pixel_x,pixel_y)
				if object ~= 0 and OBJECTS[object] then
					local obj = {OBJECTS[object],pixel_x*TILE_SIZE,pixel_y*TILE_SIZE-OBJECTS[object]:getHeight()+TILE_SIZE}
					table.insert(objects,obj)
				end
			end

			local sprite = get_tile_sprite(height)
			batch:add(sprite,pixel_x*TILE_SIZE,pixel_y*TILE_SIZE)

		end
	end
	return batch,objects
end

function get_tile_sprite(value)
    if value > 130 then
        return TILES.dirt
    elseif value>129 then
    	return TILES.grass_dirt
    elseif value > 127 then
        return TILES.grass
    elseif value> 124 then
    	return TILES.sand_grass
    elseif value > 122 then
        return TILES.sand
    elseif value>121 then
    	return TILES.shallow_water
    elseif value>120 then
    	return TILES.medium_water
    elseif value>118 then
    	return TILES.deep_water
    else
        return TILES.dark_water
    end
end

