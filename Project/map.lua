function makemap(terrain)
	local map = love.image.newImageData("/sprites/blank_map.png")
	for i = 1, terrain:getWidth()-1 do
		for j=1, terrain:getHeight()-1 do
			_, height, obj = terrain:getPixel(i,j)
			if height>122 then
				if height+100>255 then
					height = 155
				end
				if height == 123 then
					map:setPixel(i,j,height-75,height-75,height-75)
				elseif (height-3)%10 == 0 then
					map:setPixel(i,j,height+15,height,height)
				else
					map:setPixel(i,j,height+100,height+50,height-40)
				end
			else
				if height == 122 then
					map:setPixel(i,j,height,height+20,height+80)
				elseif height == 121 then
					map:setPixel(i,j,height+30,height+40,height+60)
				elseif height == 120 then
					map:setPixel(i,j,height+50,height+55,height+60)
				elseif (height-3)%15 == 0 then
					map:setPixel(i,j,height-30,height-30,height-30)
				else
					map:setPixel(i,j,height+90,height+80,height+60)
				end
			end
		end
	end

	for i = 2, terrain:getWidth()-2 do
		for j=2, terrain:getHeight()-2 do
			_, height, obj = terrain:getPixel(i,j)
			local r, g, b = map:getPixel(i,j)
			if obj == 1 then
				if r-80>0 and b-80>0 and g-40>0 then
					map:setPixel(i,j,  r-80  ,g-40 ,b-80)
				end
				local r, g, b = map:getPixel(i+1,j)
				if r-40>0 and b-40>0 and g-30>0 then
					map:setPixel(i+1,j,r-40  ,g-30 ,b-40)
				end
				local r, g, b = map:getPixel(i-1,j)
				if r-40>0 and b-40>0 and g-30>0 then
					map:setPixel(i-1,j,r-40  ,g-30 ,b-40)
				end
				local r, g, b = map:getPixel(i,j+1)
				if r-40>0 and b-40>0 and g-30>0 then
					map:setPixel(i,j+1,r-40  ,g-30 ,b-40)
				end
				local r, g, b = map:getPixel(i,j-1)
				if r-40>0 and b-40>0 and g-30>0 then
					map:setPixel(i,j-1,r-40  ,g-30 ,b-40)
				end
			elseif obj == 2 then
				--map:setPixel(i,j,50,75,125)

			elseif obj == 3 then
				map:setPixel(i,j,150,100,50)
			elseif obj == 4 then
				map:setPixel(i,j,100,100,100)
			elseif obj == 5 then
				map:setPixel(i,j,200,50,50)
			end
		end
	end
	map:encode("player_map.png")
	return map
end
function minimap(map)
	local self = baseClass()
	self.width = MAP_SIZE
	self.height = MAP_SIZE
	self.map = love.graphics.newImage(map)
	local x,y = 0,0
	vertices = {
	{WINDOW_WIDTH-256,WINDOW_HEIGHT-256,--cords of vertex
	0,0
	},
	{WINDOW_WIDTH,WINDOW_HEIGHT-256,
	0,1
	},
	{WINDOW_WIDTH,WINDOW_HEIGHT,
	1,1
	},
	{WINDOW_WIDTH-256,WINDOW_HEIGHT,--cords of vertex
	1,0
	}}
	self.rect = love.graphics.newMesh(vertices,self.map,"fan")
  
	function self.drawmap(x,y)
		local offset = 1/8
		local size = 512
		vertices = {
		{WINDOW_WIDTH-size,WINDOW_HEIGHT-size,--cords of vertex
			x/self.width-offset, y/self.height-offset
		},
		{WINDOW_WIDTH,WINDOW_HEIGHT-size,
			x/self.width+offset, y/self.height-offset
		},
		{WINDOW_WIDTH,WINDOW_HEIGHT,
			x/self.width+offset, y/self.height+offset
		},
		{WINDOW_WIDTH-size,WINDOW_HEIGHT,--cords of vertex
			x/self.width-offset, y/self.height+offset
		}}
		self.rect:setVertices(vertices)
		love.graphics.draw(self.rect,0,0)--drawmap
		love.graphics.draw(OBJECTS[4],WINDOW_WIDTH-size/2,WINDOW_HEIGHT-size/2)
	end
	return self
end