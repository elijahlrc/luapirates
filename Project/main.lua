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
	require "utilities"
	require "config"
	require "player"
	require "keyboard"
	require "generation"
	require "sprites"
	Weather = require "weather"
	require "baseclass"
	require "shipClass"
	require "cannons"
	require "collisions"
	require "gunClass"
	instantiate_colisions()
	PLAYER = Player(START_X,START_Y,SPRITES.ship,START_ROTATION,PLAYER_SPEED,
	PLAYER_TURN_SPEED,PLAYER_DRAG,PLAYER_VELOCITY,MAX_PLAYER_VELOCITY)
	--PLAYER_CAMERA = Player(START_X,START_Y,SPRITES.ship,START_ROTATION,
	--	PLAYER_SPEED,PLAYER_TURN_SPEED,PLAYER_DRAG,PLAYER_VELOCITY,
	--	MAX_PLAYER_VELOCITY)
	KEYBOARD_STATE = Keyboard({})
	WEATHER = Weather(WEATHER_SPEED,STARTING_LIGHT,WEATHER_DIRECTION)
	--TERRAIN_MAP = generate_map()
	TERRAIN_MAP = love.image.newImageData("/map/map.png")
	STATIC_OBJECTS = {}
	DYNAMIC_OBJECTS = {}
	--Colision detection: (from collisions)
	
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
	for i = #DYNAMIC_OBJECTS, 1,-1 do
		DYNAMIC_OBJECTS[i].update(dt)
		if DYNAMIC_OBJECTS[i].dead then
			table.remove(DYNAMIC_OBJECTS,i)
		end
	end

	PLAYER.update(dt)
	--PLAYER_CAMERA.update(dt)
	TILE_BATCH,STATIC_OBJECTS = update_terrain(TILE_BATCH)
	WEATHER.update_light(dt)
	update_collisions(dt)
end

function love.draw()
	--[[
	define draw functions 
	do graphics procesing and drawing
	]]
	local xOffset = math.floor(-PLAYER.x)+math.floor(WINDOW_WIDTH/2)
	local yOffset = math.floor(-PLAYER.y)+math.floor(WINDOW_HEIGHT/2)
	love.graphics.draw(TILE_BATCH,xOffset,yOffset)
	for i=1,#STATIC_OBJECTS do
		local obj = STATIC_OBJECTS[i]
		love.graphics.draw(obj[1],obj[2]+xOffset,obj[3]+yOffset)
	end
	for i = 1, #DYNAMIC_OBJECTS do
		local obj = DYNAMIC_OBJECTS[i]
		love.graphics.draw(obj.sprite,obj.x+xOffset,obj.y+yOffset,obj.rotation,1,1,obj.sprite:getWidth()/2,obj.sprite:getWidth()/2)
	end
	love.graphics.draw(PLAYER.sprite,math.floor(WINDOW_WIDTH/2),math.floor(WINDOW_HEIGHT/2),PLAYER.rotation,1,1,PLAYER.sprite:getWidth()/2,PLAYER.sprite:getHeight()/2)
	PLAYER.shape:draw("fill")
	WEATHER.draw_weather()

	local x,y = PLAYER.get_tile_location()
	love.graphics.print(tostring(x)..","..tostring(y), 10, 0)
	love.graphics.print("ship at"..tostring(PLAYER.shape:center()), 10, 50)
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 15)
	love.graphics.print('Memory actually used (in kB): ' .. collectgarbage('count'), 10,30)
	love.graphics.print("PLAYER HP "..math.ceil(PLAYER.hp),10,60,0,3,3)
end