require "sprites"

math.randomseed(RANDOM_SEED)

-- Size of Map
local map_scale =11
-- Smoothness
local smoothness = 1
-- Structure Scale/Amount
local structure_scale = 2.1--wat do these do?
local structure_constant = .0150
--Map Resolution
local resolution = 2^map_scale
--Map width,height
local x = resolution
local y = resolution

function generate()
    local list = {}
    local center = {x/2,y/2}
    
    for i=1,x do
    	list[i] = {}
    	for j=1,y do
    		list[i][j] = (12*(i/resolution - .5)^6)+12*(j/resolution - .5)^6
    	end
    end

    return list
end

function perlin(octaves,point_list,temp_list) -- x,y must be powers of 2
	local weight = 0
	for i = octaves,1,-1 do -- this is the main loop, it calls octave and sums it. Changes it to the weights of different resolutions of octives will be done here
		octave(2^(i-1),point_list,temp_list)
		weight = (structure_constant*i^structure_scale)/octaves -- this function finds the weight of each octive
		for a = 1, x do
			for b = 1,y do
				point_list[a][b] = point_list[a][b]+temp_list[a][b]*weight-- adds each iteration of temp_list from octave to point list
			end
		end
    end
end

function octave(octave_resolution,point_list,temp_list)-- takes the resolution and returns a smoothed noise array
	local value = 0
	local res_list = {}
	local oct_res_x
	local oct_res_y
	for y_cord = 1,(resolution/octave_resolution)+2 do
		res_list[y_cord]={}
		for x_cord = 1,(resolution/octave_resolution)+2 do
			table.insert(res_list[y_cord], math.random())
		end
	end
	for y_cord = 1,(resolution/octave_resolution) do -- x_cord is which square, dx is the pixel relitive to x_cord. x_cord*octave_resolution+dx = actual x position
		for x_cord = 1,(resolution/octave_resolution) do
			for oct_res_y = 1, octave_resolution do
				for oct_res_x = 1, octave_resolution do
					value = interpolate(res_list[y_cord][x_cord], res_list[y_cord][x_cord+1], res_list[y_cord+1][x_cord], res_list[y_cord+1][x_cord+1],(oct_res_x/octave_resolution),(oct_res_y/octave_resolution))
					temp_list[(y_cord-1)*octave_resolution + oct_res_y][(x_cord-1)*octave_resolution + oct_res_x]=value --(y_cord-1)*octave_resolution + dy gives actual pixel coridinate of y
				end
			end
		end
	end
end

function interpolate(a,b,c,d,delta_x,delta_y) -- takes 4 points and a delta x and delta y from top left point.
	return a*(1-delta_x)*(1-delta_y)+b*delta_x*(1-delta_y)+c*(1-delta_x)*(delta_y)+d*delta_x*delta_y
end

function smooth(factor,point_list)
	for k=1,factor do
		for i=2,resolution-1 do
			for j=2,resolution-1 do
				local tile_1 = point_list[i+1][j+1]
				local tile_2 = point_list[i+1][j]
				local tile_3 = point_list[i+1][j-1]
				local tile_4 = point_list[i][j-1]
				local tile_5 = point_list[i-1][j-1]
				local tile_6 = point_list[i-1][j]
				local tile_7 = point_list[i-1][j+1]
				local tile_8 = point_list[i][j+1]
				point_list[i][j] = (tile_1+tile_2+tile_3+tile_4+tile_5+tile_6+tile_7+tile_8)/8
			end
		end
	end
end

function generate_map()
    local point_list = generate()
    print("Array 1 Generation    Done")
    local temp_list = generate()
    print("Array 2 Generation    Done")
    perlin(map_scale,point_list,temp_list)
    print("Perlin Noize          Done")
    smooth(smoothness,point_list)
    print("Smothing              Done")
    make_image(point_list)
    print("Image Generation      Done")
    collectgarbage('collect')
    print("Garbage Collection    Done")
    return love.image.newImageData("map.png")
end

function make_image(point_list)--this makes the image used to load the map r chanel is curently unused, g is height, b is object
	local map_image = love.image.newImageData("/sprites/blank_map.png")
	for i = 0,x-1 do
		for j = 0,y-1 do
			local value = math.floor(point_list[i+1][j+1]*255)
			if value > 255 then
				value = 255
			end
			if value < 0 then
				value = 0
			end
			handle_terrain(map_image,value,i,j)
		end
	end
	for i = 0,x-1 do
		for j = 0,y-1 do
			local value = math.floor(point_list[i+1][j+1]*255)
			if value > 255 then
				value = 255
			end
			if value < 0 then
				value = 0
			end
			handle_objects(map_image,value,i,j)
		end
	end
	map_image:encode("map.png")
end
function handle_terrain(map_image,value,i,j)
	map_image:setPixel(i,j,0,value,0)
end
function MakeTownStats(size,pos)--makes town prices/goods
	local self = baseClass()
	self.x = pos[1]
	self.y = pos[2]
	self.elapsed = 0
	self.name = "town"
	self.goods = coppyTable(TRADEGOODS)--could be some subset of tradegoods to provide mroe
	self.shipyard_inventory = coppyTable(EQUIPMENT)--town variety
	for i,good in pairs(self.goods) do
		self.goods[i].current_price = self.goods[i].value
		self.goods[i].rate_of_change = 0
	end
	for i,equpm in pairs(self.shipyard_inventory) do
		self.shipyard_inventory[i].current_price = self.shipyard_inventory[i].value
		self.shipyard_inventory[i].rate_of_change = 0

	end
	function self.update(dt) --function for goods to change prices
		self.elapsed = self.elapsed+dt
		if self.elapsed >= 5 then--update prices every 1 sec
			for name, item in pairs(self.goods) do
				item.current_price = math.abs(item.current_price+item.rate_of_change)
				change = random_gauss((item.value-item.current_price)/20,item.sDev)/4
				item.current_price = round(item.current_price+change)
			end
			self.elapsed = 0
		end
	end
	function self.handle_collisions(dt,othershape,dx,dy)--does this need to be here?
	end
	return self
end


function makedock(i,j,map_image,value)--generates doc which changes dirction ocationaly and has a random lenth
	local max_len = math.random(15)+2
	local len = 0
	local points = {}
	local di = 0
	local dj = 0
	local rand_start = math.random(4)
	local ocupied = {}
	local colision_rect
	local town = MakeTownStats(max_len,{i*TILE_SIZE,j*TILE_SIZE})
	table.insert(TOWNS,town)
	while len<max_len do --this while loop makes the doc
		len = len+1
		if i + di + 1 < x and i + di - 1 >0 and j + dj +1 <y and j + dj -1>0 then
			_, points[1] , ocupied[1] = map_image:getPixel(i+di+1,j+dj) -- i+1, i-1 j+1, j-1
			_, points[2] , ocupied[2] = map_image:getPixel(i+di-1,j+dj)
			_, points[3] , ocupied[3] = map_image:getPixel(i+di,j+dj+1)
			_, points[4] , ocupied[4] = map_image:getPixel(i+di,j+dj-1)
			if math.random(8) == 1 then --1 in 8 chance of random turn in doc
				rand_start = math.random(4)
			end


			--folowing block makes sure that next point is in water
			local new_start = 0
			if points[rand_start]>=123 or ocupied[rand_start] ~= 0 then--if its not in water or already there
				new_start = math.random(4)--set direction randomly
				rand_start = new_start
			end

			local done = false
			while done == false and (points[rand_start]>=123 or ocupied[rand_start] ~= 0 ) do--if its still not in water
				if rand_start >= 4 then
					rand_start = 1
				else 
					rand_start = rand_start+1--cicle around untill it is
				end
				if rand_start == new_start then--unless you cant and the point is totaly isolated
					done = true
					len = max_len
					if len == 1 then
						return false
					end
				end
			end


			--end block
			colision_rect = Collider:addRectangle((i+di)*TILE_SIZE,(j+dj)*TILE_SIZE, TILE_SIZE,TILE_SIZE)
			colision_rect.name = "dock_collider"
			colision_rect.owner = town
			Collider:setPassive(colision_rect)
			map_image:setPixel(i+di,j+dj,0,value,3)
			if rand_start == 1 then--makes the doc
				di = di+1
			elseif rand_start == 2 then
				di = di-1
			elseif rand_start == 3 then
				dj = dj+1
			elseif rand_start == 4 then
				dj = dj-1
		
			end
		end
	end
	return max_len
end
function maketown(i,j,size,map_image,value)--makes town positions and graphics, not statistics or items or stores or anythang
	local size = 0
	local rad = math.sqrt(max_size)
	local di = 0
	local dj = 0
	local val
	local counter = max_size*8
	while size<max_size  and counter > 0 do
		counter = counter-1
		di = round(random_gauss(0,rad))
		dj = round(random_gauss(0,rad))
		if i+di>0 and i+di<x and j+dj>0 and j+dj<y then
			_, val, ocupied = map_image:getPixel(i+di,j+dj)
			if val >= 123 and ocupied == 0 then
				size = size+1
				map_image:setPixel(i+di,j+dj,0,value,5)
			end
		end
	end
end
function makeforest(i,j,map_image,value,max_size)
	local size = 0
	local rad = math.sqrt(max_size)
	local di = 0
	local dj = 0
	local val
	while size<max_size do
		size = size+1
		di = round(random_gauss(0,rad*4))
		dj = round(random_gauss(0,rad*4))
		if i+di>0 and i+di<x and j+dj>0 and j+dj<y then
			_, val, ocupied = map_image:getPixel(i+di,j+dj)
			if val > 123 and ocupied == 0 then
				map_image:setPixel(i+di,j+dj,0,val,1)
			end
			if math.random(max_size) ==1 and max_size>10 then
				makeforest(i+di,j+dj,map_image,val,math.random(max_size)*1.5)
			end
		end
	end
end
function handle_objects(map_image,value,i,j)--generates towns, forests, seaweed, docs, etc
	local height
	local obj
	_,_,ocupied = map_image:getPixel(i,j)
	if value > 111 and value < 119 and ocupied == 0 and math.random(100) > 95 then -- Seaweed
		map_image:setPixel(i,j,0,value,2)
	end
	if value>135 and value <= 180 and ocupied == 0 and math.random(1000) < 5 then -- Tree
		local max_size = math.abs(random_gauss(100,100))
		makeforest(i,j,map_image,value,max_size)
	end
	if value >122 and value <= 127 and math.random(1000)<3 then
		--max_size = math.abs(random_gauss(50,50))
		--makeboulderfeild(i,j,map_image,value,max_size)
	end
	if value > 122 and value <= 123 and ocupied == 0 and math.random(10000)<20 then --doc and city generation code, this 20/10000 does not tell the whole story
		max_size = makedock(i,j,map_image,value)  									-- because sometimes the city is cancled because its not near h2o
		--now generating towns
		if max_size then--max_size is set to 0 if the town is cancled
			max_size = math.abs(random_gauss(max_size*5,10))
			maketown(i,j,max_size,map_image,value)
		end
	end
end





	--[[
	local _
	local full
	_,_,full = map_image:getPixel(i,j)
	if full == 255 or full == 0 then
		map_image:setPixel(i,j,0,value,0)--set as default
	end
	if value < 122 then
		if value > 111 and value < 119 and math.random(100) > 95 then -- Seaweed
			map_image:setPixel(i,j,0,value,2)
		end
	elseif (value > 122) and (value <= 123) and math.random(100)>98 then --docs
		makeTown(i,j,map_image)
	elseif value < 150 and math.random(100) > 95 and adjacent_value > 124 and adjacent_value < 150 then -- Tree
		map_image:setPixel(i,j,0,value,1)--tree
	end
end--]]
