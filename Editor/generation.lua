require "sprites"

math.randomseed(RANDOM_SEED)

-- Size of Map
local map_scale = 11
-- Smoothness
local smoothness = 1
-- Structure Scale/Amount
local structure_scale = 2.4
local structure_constant = .0090
--Map Resolution
local resolution = 2^map_scale
--Map width,height
local x = resolution
local y = resolution

function distance(x1,y1,x2,y2)
    return math.sqrt((x1-x2)^2+(y1-y2)^2)
end

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
	for i=1,factor do
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
    local temp_list = generate()
    perlin(map_scale,point_list,temp_list)
    smooth(smoothness,point_list)
    make_image(point_list)
    collectgarbage('collect')
    return love.image.newImageData("map.png")
end

function make_image(point_list)
	local map_image = love.image.newImageData("/sprites/blank_map.png")
	for i = 0,x-1 do
		for j = 0,y-1 do
			local value = math.floor(point_list[i+1][j+1]*255)
			local adjacent_value = -1

			if point_list[i+2] ~= nil then
				adjacent_value = math.floor(point_list[i+2][j+1]*255)
			end

			if value > 255 then
				value = 255
			end
			if value < 0 then
				value = 0
			end
			handle_objects(map_image,value,adjacent_value,i,j)
		end
	end

	map_image:encode("map.png")
end

function handle_objects(map_image,value,adjacent_value,i,j)

	if value > 122 then -- Land Objects

		if value > 124 and value < 150 and math.random(100) > 95 and adjacent_value > 124 and adjacent_value < 150 then -- Tree
			map_image:setPixel(i,j,1,value,1)
		
		else -- Default tile
			map_image:setPixel(i,j,1,value,0) 
		end

	elseif value > 100 then

		if value > 111 and value < 119 and math.random(100) > 98 then -- Seaweed
			map_image:setPixel(i,j,0,value,2)

		else -- Default tile
			map_image:setPixel(i,j,0,value,0)
		end



	else
		map_image:setPixel(i,j,0,value,0)
	end
end