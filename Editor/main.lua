require "config"
require "player"
require "keyboard"
require "generation"
require "sprites"
require "weather"

PLAYER = Player(START_X,START_Y,SPRITES.ship,START_ROTATION,PLAYER_SPEED,PLAYER_TURN_SPEED,PLAYER_DRAG,PLAYER_VELOCITY,MAX_PLAYER_VELOCITY)
PLAYER_CAMERA = Player(START_X,START_Y,SPRITES.ship,START_ROTATION,PLAYER_SPEED,PLAYER_TURN_SPEED,PLAYER_DRAG,PLAYER_VELOCITY,MAX_PLAYER_VELOCITY)
KEYBOARD_STATE = Keyboard({})
TERRAIN_MAP = love.image.newImageData("/map/map.png")
--TERRAIN_MAP = generate_map()
STATIC_OBJECTS = {}

NUM = 1
SAVES = 0


function love.keypressed(key)
	KEYBOARD_STATE.add_key(key)
	if key == " " then
		NUM = NUM+1
		if OBJECTS[NUM] == nil then
			NUM = 1
		end
	end
	if key == "f1" then
		TERRAIN_MAP:encode("editedMap"..tostring(SAVES)..".png")
		SAVES = SAVES + 1
	end
	if key == "f2" then
		TERRAIN_MAP = love.image.newImageData("/map/map.png")
	end
end

function love.keyreleased(key)
	KEYBOARD_STATE.remove_key(key)
end

function love.mousepressed(x, y, button)
	if button == 'l' then
		c,h,t = TERRAIN_MAP:getPixel(block_x,block_y)
		TERRAIN_MAP:setPixel(block_x,block_y,1,h,NUM)
	end
end

function love.update(dt)
	PLAYER.update(dt)
	PLAYER_CAMERA.update(dt)
	TILE_BATCH,STATIC_OBJECTS = update_terrain(TILE_BATCH)
end

function love.draw()
	love.graphics.draw(TILE_BATCH,math.floor(-PLAYER_CAMERA.x)+math.floor(WINDOW_WIDTH/2),math.floor(-PLAYER_CAMERA.y)+math.floor(WINDOW_HEIGHT/2))
	for i=1,#STATIC_OBJECTS do
		love.graphics.draw(STATIC_OBJECTS[i][1],STATIC_OBJECTS[i][2]+math.floor(-PLAYER_CAMERA.x)+math.floor(WINDOW_WIDTH/2),STATIC_OBJECTS[i][3]+math.floor(-PLAYER_CAMERA.y)+math.floor(WINDOW_HEIGHT/2))
	end


	local mouse_x,mouse_y = love.mouse.getPosition()
	block_x = math.floor(PLAYER_CAMERA.x/TILE_SIZE)-math.floor((WINDOW_WIDTH/2)/TILE_SIZE)+math.floor(mouse_x/TILE_SIZE)
	block_y = math.floor(PLAYER_CAMERA.y/TILE_SIZE)-math.floor((WINDOW_HEIGHT/2)/TILE_SIZE)+math.floor(mouse_y/TILE_SIZE)
	love.graphics.print("block_x, block_y: "..tostring(block_x)..", "..tostring(block_y), 10, 0)

	love.graphics.draw(OBJECTS[NUM],block_x*TILE_SIZE-PLAYER_CAMERA.x+math.floor(WINDOW_WIDTH/2),block_y*TILE_SIZE-PLAYER_CAMERA.y+math.floor(WINDOW_HEIGHT/2)-OBJECTS[NUM]:getHeight()+TILE_SIZE+16)
end