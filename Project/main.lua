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
	require "projectiles"
	require "collisions"
	require "gunClass"
	require "test_enemy"
	ID = 0


	KEYBOARD_STATE = Keyboard({})
	WEATHER = Weather(WEATHER_SPEED,STARTING_LIGHT,WEATHER_DIRECTION)
	TERRAIN_MAP = generate_map()
	instantiate_colisions()
	--trying to make the player always start in water
    _, water, _ = TERRAIN_MAP:getPixel(math.random(2048),math.random(2048))
	while water>=123 do
		START_X = math.random(2048)
		START_Y = math.random(2048)
		_,water,_ = TERRAIN_MAP:getPixel(START_X,START_Y)
	end

	PLAYER = Player(START_X*TILE_SIZE,START_Y*TILE_SIZE,SPRITES.ship,START_ROTATION,PLAYER_SPEED,
	PLAYER_TURN_SPEED,PLAYER_DRAG,PLAYER_VELOCITY)
	--TERRAIN_MAP = love.image.newImageData("/map/map.png")
	STATIC_OBJECTS = {} 
	PROJECTILES = {}
	SHIPS = {}
	display = ""
	table.insert(SHIPS,PLAYER)
	--silly code below
	score = 0
-- 	e1 = enemy_ship(PLAYER.x+math.random(WINDOW_WIDTH)-WINDOW_WIDTH/2,PLAYER.y+math.random(WINDOW_HEIGHT)-WINDOW_HEIGHT/2)
-- 	e2 = enemy_ship(PLAYER.x+math.random(WINDOW_WIDTH)-WINDOW_WIDTH/2,PLAYER.y+math.random(WINDOW_HEIGHT)-WINDOW_HEIGHT/2,e1)
-- 	e1.enemy =e2
-- 	table.insert(SHIPS,e1)
-- 	table.insert(SHIPS,e2)
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

	--temp code to gen fun enemies
	TILE_BATCH,STATIC_OBJECTS = update_terrain(TILE_BATCH)
	WEATHER.update_light(dt)
	update_collisions(dt)


	if PLAYER.dead then
		love.load()
	end
	if #SHIPS <2 then
		table.insert(SHIPS,enemy_ship(PLAYER.x+math.random(WINDOW_WIDTH)-WINDOW_WIDTH/2,PLAYER.y+math.random(WINDOW_HEIGHT)-WINDOW_HEIGHT/2))
	end
	for i = #PROJECTILES, 1,-1 do
		PROJECTILES[i].update(dt)
		if PROJECTILES[i].dead then
			Collider:remove(PROJECTILES[i].shape)
			table.remove(PROJECTILES,i)
		end
	end
	for i = #SHIPS, 1,-1 do
		SHIPS[i].update(dt)
		if SHIPS[i].dead then
			Collider:remove(SHIPS[i].shape)
			table.remove(SHIPS,i)
		end
	end
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
	for i = 1, #PROJECTILES do
		local obj = PROJECTILES[i]
		love.graphics.draw(obj.sprite,obj.x+xOffset,obj.y+yOffset,obj.rotation,1,1,obj.width/2,obj.height/2)
	end
	for i = 1, #SHIPS do
		local obj = SHIPS[i]
		love.graphics.draw(obj.sprite,obj.x+xOffset,obj.y+yOffset,obj.rotation,1,1,obj.width/2,obj.height/2)
	end
	WEATHER.draw_weather()

	local x,y = PLAYER.get_tile_location()
	love.graphics.print(tostring(x)..","..tostring(y), 10, 0)
	love.graphics.print("ship at"..tostring(PLAYER.shape:center()), 10, 50)
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 15)
	love.graphics.print('Memory actually used (in kB): ' .. collectgarbage('count'), 10,30)
	love.graphics.print("PLAYER HP "..math.ceil(PLAYER.hp),10,60,0,3,3)
	love.graphics.print("Speed:"..score,10,90,0,3,3)
end