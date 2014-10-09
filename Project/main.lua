
--o=0
--O=o


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
	loveframes:  Ui library
	ui:          The ui implimentation
	other code is just instansiation
	]]
	require "config"--order of these things could be changed
	require "baseclass"--and some could be called from within others, not sure if thats good or bad form.
	require "sprites"
	require "utilities"
	require "player"
	require "keyboard"
	require "items"
	require "generation"
	
	Weather = require "weather"
	require "shipClass"
	require "projectiles"
	require "collisions"
	require "gunClass"
	require "test_enemy"
	require "map"
	require "LoveFrames"
	require "ui"
	ID = 0
	function makeID()--this is a troll-as-fuck place for this, what was i thinking
		ID = ID+1
		return ID
	end
	paused = false
	print("Instantiating:")--added all these loading messages so i can feel like we did lots of stuff, yay

	instantiate_colisions()
	print("Colider               Done")
	KEYBOARD_STATE = Keyboard({})
	print("Keyboard              Done")
	WEATHER = Weather(WEATHER_SPEED,STARTING_LIGHT,WEATHER_DIRECTION)
	print("Weather               Done")
	print(" ")
	print("Begining Map Generation")
	print(" ")
	SHIPS = {}
	TOWNS = {}
	DYNAMIC_OBJ = {}
	TERRAIN_MAP = generate_map()
	--print("Loading map from file")
	--TERRAIN_MAP = love.image.newImageData("/map/map.png")--if you do this towns will not actualy get generated
	minimap_image = makemap(TERRAIN_MAP)
	miniMap = minimap(minimap_image)
	print("Generating minimap    Done")
	--make the player always start in water
	local water = 255
	while water>=123 do
		START_X = math.random(2047)
		START_Y = math.random(2047)
		_,water,_ = TERRAIN_MAP:getPixel(START_X,START_Y)
	end
	PLAYER = Player(START_X*TILE_SIZE,START_Y*TILE_SIZE,SPRITES.ship,PLAYER_SPEED,
	PLAYER_TURN_SPEED,PLAYER_DRAG,PLAYER_VELOCITY)
	print("Instantiating Player  Done")
	STATIC_OBJECTS = {} 
	PROJECTILES = {}
	display = ""
	DEBUG_TEXT = ""
	DEBUG_TEXT2 = ""
	table.insert(SHIPS,PLAYER)
	pauseMenu()
	print("Instantiating UI      Done")
	--silly code below
	score = 0
-- 	e1 = enemy_ship(PLAYER.x+math.random(WINDOW_WIDTH)-WINDOW_WIDTH/2,PLAYER.y+math.random(WINDOW_HEIGHT)-WINDOW_HEIGHT/2)
-- 	e2 = enemy_ship(PLAYER.x+math.random(WINDOW_WIDTH)-WINDOW_WIDTH/2,PLAYER.y+math.random(WINDOW_HEIGHT)-WINDOW_HEIGHT/2,e1)
-- 	e1.enemy =e2
-- 	table.insert(SHIPS,e1)
-- 	table.insert(SHIPS,e2)
	print(" ")
	print("Game loaded successfully")
	print(" ")
	print(#PLAYER.cannons)

end
function love.keypressed(key)--,unicode)
	KEYBOARD_STATE.add_key(key)
	if key == 'escape' then
		paused = not paused
		if paused then
			loveframes.SetState("pausemenu")--menus half use loveframes states and half just use logic, needs to be unified one way or the other
		else
			loveframes.SetState("none")
		end
	end
	if key == "i" and loveframes.GetState() ~= "pausemenu" then
		inventory_menu(PLAYER)
	end
	loveframes.keypressed(key, unicode)
end

function love.keyreleased(key)
	KEYBOARD_STATE.remove_key(key)
	loveframes.keyreleased(key)
end

function love.mousepressed(x, y, button)
    loveframes.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    loveframes.mousereleased(x, y, button)
end

function love.update(dt)
	--[[
	update game logic once/frame
	]]

	--temp code to gen fun enemies
	if not paused then
		TILE_BATCH,STATIC_OBJECTS = update_terrain(TILE_BATCH)
		WEATHER.update_light(dt)
		update_collisions(dt)


		
		if #SHIPS <= 10 and math.random()<dt then 
			if math.random(100)<50 then
				table.insert(SHIPS,make_cargo_ship(PLAYER.x+math.random(WINDOW_WIDTH*2)-WINDOW_WIDTH,PLAYER.y+math.random(WINDOW_HEIGHT*2)-WINDOW_HEIGHT))
			elseif math.random(100)<50 then
				table.insert(SHIPS,make_pirate_ship(PLAYER.x+math.random(WINDOW_WIDTH*2)-WINDOW_WIDTH,PLAYER.y+math.random(WINDOW_HEIGHT*2)-WINDOW_HEIGHT,"pirate"))
			end
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
				if SHIPS[i].shape ~= nil then--shape set to nil if wreck is using shape
					Collider:remove(SHIPS[i].shape)
				end
				table.remove(SHIPS,i)
			end
		end
		for i = #DYNAMIC_OBJ,1,-1 do
			DYNAMIC_OBJ[i].update(dt)
			if DYNAMIC_OBJ[i].dead then
				Collider:remove(DYNAMIC_OBJ[i].shape)
				table.remove(DYNAMIC_OBJ,i)
			end
		end
		for _,town in pairs(TOWNS) do
			town.update(dt)

		end
		if PLAYER.dead then
			love.load()
		end
	end
	loveframes.update(dt)
end

function love.draw()
	--[[
	define draw functions 
	do graphics procesing and drawing
	]]
	local xOffset = math.floor(-PLAYER.x)+math.floor(WINDOW_WIDTH/2)
	local yOffset = math.floor(-PLAYER.y)+math.floor(WINDOW_HEIGHT/2)
	love.graphics.draw(TILE_BATCH,xOffset,yOffset)
	for i=1,#STATIC_OBJECTS do--batchme, batch everything since they can be dynaimc?
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
		-- if obj.line_directions then
		-- 	for j = 1, #obj.line_directions do
		-- 		dir = obj.line_directions[j][1]
		-- 		local ray_x = obj.line_directions[j][2]
		-- 		local ray_y = obj.line_directions[j][3]
		-- 		if obj.line_directions[j][4] then
		-- 			love.graphics.setColor(255,50,50)
		-- 			len = obj.line_directions[j][4]
		-- 		else
		-- 			love.graphics.setColor(255,255,255)
		-- 			len = 450
		-- 		end
		-- 		love.graphics.line(ray_x+xOffset,ray_y+yOffset, ray_x+math.cos(dir)*len+xOffset, ray_y+yOffset + math.sin(dir)*len)
		-- 	end
		-- end
	end
	for i = 1, #DYNAMIC_OBJ do
		local obj = DYNAMIC_OBJ[i]
		love.graphics.draw(obj.sprite,obj.x+xOffset,obj.y+yOffset,obj.rotation,1,1,obj.width/2,obj.height/2)
	end
	WEATHER.draw_weather()
	miniMap.drawmap(PLAYER.x,PLAYER.y)
	local x,y = PLAYER.get_tile_location()

	miniMap.drawmap(x,y)--debug info below
	love.graphics.print(tostring(x)..","..tostring(y), 10, 0)
	love.graphics.print("ship at"..tostring(PLAYER.shape:center()), 10, 50)
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 15)
	love.graphics.print('Memory actually used (in kB): ' .. collectgarbage('count'), 10,30)
	love.graphics.print("PLAYER HP "..math.ceil(PLAYER.hp),10,60,0,3,3)
	love.graphics.print("Speed:"..round(score,1),10,90,0,3,3)
	love.graphics.print("Money: "..round(PLAYER.money,2),10,120,0,3,3)


	loveframes.draw()
end