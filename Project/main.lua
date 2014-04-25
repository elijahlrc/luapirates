--[[
yolololololol im a docstring
]]
function love.load()
	--[[
	config:      is self explanitory
	player:      player class and functions
	keybord:	 handles key event
	generation:	 is a shitstorm of bad code which does perlin noize
	sprites:     imports sprites as well as updates
	HC: 		 colider
	other code is just instansiation
	]]
	require "config"
	require "player"
	require "keyboard"
	require "generation"
	require "sprites"
	require "weather"
	baseClass = require "baseclass"
	HC = require "HardonCollider"
	PLAYER = Player(START_X,START_Y,SPRITES.ship,START_ROTATION,PLAYER_SPEED,
		PLAYER_TURN_SPEED,PLAYER_DRAG,PLAYER_VELOCITY,MAX_PLAYER_VELOCITY)
	PLAYER_CAMERA = Player(START_X,START_Y,SPRITES.ship,START_ROTATION,
		PLAYER_SPEED,PLAYER_TURN_SPEED,PLAYER_DRAG,PLAYER_VELOCITY,
		MAX_PLAYER_VELOCITY)
	KEYBOARD_STATE = Keyboard({})
	WEATHER = Weather(WEATHER_SPEED,STARTING_LIGHT,WEATHER_DIRECTION)
	--TERRAIN_MAP = generate_map()
	TERRAIN_MAP = love.image.newImageData("/map/map.png")
	STATIC_OBJECTS = {}
end
function love.keypressed(key)
	KEYBOARD_STATE.add_key(key)
end

function love.keyreleased(key)
	KEYBOARD_STATE.remove_key(key)
end

function love.update(dt)
	--[[
	update game logic once/frame
	]]
	PLAYER.update(dt)
	PLAYER_CAMERA.update(dt)
	TILE_BATCH,STATIC_OBJECTS = update_terrain(TILE_BATCH)
	WEATHER.update_light(dt)
end

function love.draw()
	--[[
	do graphics procesing and drawing
	]]
	love.graphics.draw(TILE_BATCH,math.floor(-PLAYER_CAMERA.x)+math.floor(WINDOW_WIDTH/2),math.floor(-PLAYER_CAMERA.y)+math.floor(WINDOW_HEIGHT/2))
	for i=1,#STATIC_OBJECTS do
		love.graphics.draw(STATIC_OBJECTS[i][1],STATIC_OBJECTS[i][2]+math.floor(-PLAYER_CAMERA.x)+math.floor(WINDOW_WIDTH/2),STATIC_OBJECTS[i][3]+math.floor(-PLAYER_CAMERA.y)+math.floor(WINDOW_HEIGHT/2))
	end
	love.graphics.draw(PLAYER.sprite,PLAYER.x-PLAYER_CAMERA.x+math.floor(WINDOW_WIDTH/2),PLAYER.y-PLAYER_CAMERA.y+math.floor(WINDOW_HEIGHT/2),PLAYER.rotation,1,1,PLAYER.sprite:getWidth()/2,PLAYER.sprite:getHeight()/2)

	WEATHER.draw_weather()

	local x,y = PLAYER.get_tile_location()
	love.graphics.print(tostring(x)..","..tostring(y), 10, 0)
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 15)
	love.graphics.print('Memory actually used (in kB): ' .. collectgarbage('count'), 10,30)
end