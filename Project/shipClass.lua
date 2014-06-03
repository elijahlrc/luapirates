function baseShipClass(x,y,sprite,speed,turn_speed,drag,max_velocity,velocity,rotation,health,shape)
	local self = baseClass()
	function self.init()
		--the folowing if's check if vars are passed into baseShipClass and if not set them to default
		

		self.rotation = rotation or 0
		self.velocity = velocity or 0
		self.max_velocity = max_velocity
		self.max_health = max_health or 100
		self.name = "baseSHipClass"
		self.hp = self.max_health
		self.x = x
		self.y = y
		self.sprite = sprite
		self.speed = speed
		self.turn_speed = turn_speed
		self.drag = drag
		self.cannons = basic_guns(self)
		if shape then
			self.shape = shape
			if not self.shape.name then
				error("ship shape given without name, Y U DO THIS!")
			end
		--[[else
			boundingBox = {width = self.sprite:getWidth(),height = self.sprite:getHeight()}
			self.shape = Collider:addRectangle(self.x+1,self.y+1,boundingBox.width-1,boundingBox.height-1)
			self.shape.owner = self --shape containes referance to owner, all interactive shapes must do this
			self.shape.name = "baseShipClass_SHAPE"
			--]]
		end
		
	end
	self.init()


	function self.get_position()
		return self.x,self.y
	end

	function self.get_rotation()
		return self.rotation
	end

	function self.get_sprite()
		return self.sprite
	end

	function self.get_tile_location()
		local tile_x = math.floor(self.x/TILE_SIZE)
		local tile_y = math.floor(self.y/TILE_SIZE)
		return tile_x,tile_y
	end
	function self.move(dt)
	end
	function self.update(dt)
		self.move(dt)
		self.fire_guns(dt)
	end
	function self.fire_guns(dt)
		for _,gun in pairs(self.cannons.guns) do
			gun.fire(dt)
		end
	end
	function self.handle_collisions(dt,othershape,dx,dy)
		--[[
		if othershape is a obj which should damage ship (wepons, etc)
		the code for that should prob go here. Aditionaly docking in ports
		picking up loot, etc might go here.
		--]]
		if othershape.name == "terrain_collider" then
			self.x = self.x+dx --curently all colisions result in ship
			self.y = self.y+dy --returning to the position it was before colision
			if  math.abs(self.velocity)>100 then 
				self.hp = self.hp - math.abs(self.velocity)*.05
			elseif  math.abs(self.velocity)>20 then
				self.hp = self.hp - math.abs(self.velocity)*.02
			end
			self.velocity = 0
		elseif othershape.name == "projectile" then
			self.hp = self.hp-5
		end
	end
	return self
end

