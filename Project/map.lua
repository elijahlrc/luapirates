function makemap(terrain)
	local map = love.image.newImageData("/sprites/blank_map.png")
	for i = 1, terrain:getWidth()-1 do
		for j=1, terrain:getHeight()-1 do
			_, height, obj =terrain:getPixel(i,j)
			if obj == 0 then--pink and blue
				if height>122 then
					if height+100>255 then
						height = 155
					end
					if (height-3)%10 == 0 then
						if height == 123 then
							map:setPixel(i,j,height-75,height-75,height-75)
						else
							map:setPixel(i,j,height+35,height+25,height+25)
						end
					else
						map:setPixel(i,j,height+100,height+50,height-40)
					end
				else
					if (height-3)%10 == 0 then
						map:setPixel(i,j,height,height,height)
					else
						map:setPixel(i,j,height+10,height+35,height+60)
					end
				end
			elseif obj == 1 then
				map:setPixel(i,j,100,200,100)
			elseif obj == 2 then
				map:setPixel(i,j,50,75,125)
			elseif obj == 3 then
				map:setPixel(i,j,150,100,50)
			elseif obj == 4 then
				map:setPixel(i,j,200,50,50)
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