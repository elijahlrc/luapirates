SPRITES = {}

SPRITES.ship = love.graphics.newImage("/sprites/ship.png")
SPRITES.tiles = love.graphics.newImage("/sprites/tiles.png")
SPRITES.canonball = love.graphics.newImage("/sprites/canonball.png")
local tiles_width = SPRITES.tiles:getWidth()
local tiles_height = SPRITES.tiles:getHeight()

TILE_BATCH = love.graphics.newSpriteBatch(SPRITES.tiles, 8192)

TILES = {}

TILES.dirt = love.graphics.newQuad(TILE_SIZE*0,  TILE_SIZE*0, TILE_SIZE, TILE_SIZE, tiles_height, tiles_width)
TILES.grass = love.graphics.newQuad(TILE_SIZE*1,  TILE_SIZE*0, TILE_SIZE, TILE_SIZE, tiles_height, tiles_width)
TILES.sand = love.graphics.newQuad(TILE_SIZE*0,  TILE_SIZE*1+1, TILE_SIZE, TILE_SIZE, tiles_height, tiles_width)
TILES.water = love.graphics.newQuad(TILE_SIZE*1,  TILE_SIZE*1+1, TILE_SIZE, TILE_SIZE, tiles_height, tiles_width)

OBJECTS = {}

----- Static Object List

OBJECTS[1] = love.graphics.newImage("/sprites/tree.png")
OBJECTS[2] = love.graphics.newImage("/sprites/seaweed.png")
OBJECTS[3] = love.graphics.newImage("/sprites/woodplank.png")
OBJECTS[4] = love.graphics.newImage("/sprites/rock.png")

---- End Static Object List

function update_terrain(batch)
	--[[
	could this get a docstring
	]]
	batch:clear()

	local x,y = PLAYER.get_tile_location()
	local height = nil
	local _ = nil
	local objects = {}


	for i=-4,TILES_ACROSS+4 do
		for j=-4,TILES_DOWN+4 do
			local pixel_x,pixel_y = (i+x-(TILES_ACROSS/2)),(j+y-(TILES_DOWN/2))

			if pixel_x < 0 or pixel_x > MAP_SIZE or pixel_y < 0 or pixel_y > MAP_SIZE then
				height = 255
			else
				_,height,object = TERRAIN_MAP:getPixel(pixel_x,pixel_y)
				if object ~= 0 then
					table.insert(objects,{OBJECTS[object],pixel_x*TILE_SIZE,pixel_y*TILE_SIZE-OBJECTS[object]:getHeight()+TILE_SIZE})
				end
			end

			local sprite = get_tile_sprite(height)
			batch:add(sprite,pixel_x*TILE_SIZE,pixel_y*TILE_SIZE)

		end
	end
	return batch,objects
end

function get_tile_sprite(value)
    if value > 127 then
        return TILES.dirt
    elseif value > 124 then
        return TILES.grass
    elseif value > 122 then
        return TILES.sand
    else
        return TILES.water
    end
end