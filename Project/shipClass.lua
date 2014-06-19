function baseShipClass(x,y,sprite,speed,turn_speed,drag,velocity,rotation,health,shape)
	local self = baseClass()
	function self.init()
		--the folowing if's check if vars are passed into baseShipClass and if not set them to default
		self.bounus = (4.5+math.random())/5
		ID = ID+1
		self.id = ID
		self.rotation = rotation or 0
		self.velocity = velocity or {0,0}
		self.max_health = max_health or 100
		self.name = "baseSHipClass"
		self.hp = self.max_health
		self.x = x
		self.y = y
		self.sprite = sprite
		self.speed = speed*self.bounus
		self.turn_speed = turn_speed*self.bounus
		self.drag = drag*self.bounus
		self.cannons = basic_guns(self)
		self.width, self.height = self.sprite:getDimensions( )
		self.money = 100
		self.hold = {}
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
		--code for movement overrites this function
		--use turn and accelerate to move
	end
	function self.update(dt)
		self.doMove(dt)
		self.fire_guns(dt)
		if self.hp<0 then
			self.dead = true
		end
	end
	function self.turn(dt,dir) --setter for rotation
		if dir == "cl" then
			self.rotation = self.rotation+self.turn_speed*dt
		elseif dir == "cc" then
			self.rotation = self.rotation-self.turn_speed*dt
		elseif dir == "hcl" then --half speed movement
			self.rotation = self.rotation+self.turn_speed*dt*.5
		elseif dir == "hcc" then
			self.rotation = self.rotation-self.turn_speed*dt*.5
		end
	end
	function self.accelerate(dt,dir)--setter for velocity
		if dir == "forward" then
			self.velocity = add_vectors(self.velocity[1] , self.velocity[2] , self.speed*dt   , self.rotation)
		elseif dir == "backward" then 
			self.velocity = add_vectors(self.velocity[1] , self.velocity[2] ,self.speed*-.75*dt, self.rotation)
		end
	end
	function self.addToHold(good,quantity)
		quantity = quantity or 1
		if self.hold[good] ~= nil then
			self.hold[good] = self.hold[good]+quantity
		else 
			self.hold[good] = quantity
		end
		return self.hold[good]
	end
	function self.removeFromHold(good,quantity)
		quantity = quantity or 1
		if self.hold[good] ~= nil and self.hold[good] >= quantity then
			self.hold[good] = self.hold[good]-quantity
			return self.hold[good]
		end
		return false
	end
	function self.fire_guns(dt) --overwrite me
		--code for when to fire wepons and which to fire goes here, overwrite this function in the
		--obj that is fireing, ie player, or test_enemy
	end
	function self.doMove(dt)
		local turn_factor = 2 --affects how much of your momentum you keep when you turn
		local drag_factor = 10
		self.move(dt)
		self.dragForce = {}
		dA = math.min(math.abs(shortAng(self.rotation,self.velocity[2])),math.abs(shortAng(self.rotation+math.pi,self.velocity[2])))
		self.dragForce[1] = -1*self.velocity[1]*(1+drag_factor*dA)*self.drag*dt
		self.dragForce[2] = 1*self.velocity[2]
		self.velocity = add_vectors(self.velocity[1],self.velocity[2],self.velocity[1]*turn_factor*dA*dt,self.rotation)

		self.velocity = add_vectors(self.velocity[1],self.velocity[2],self.dragForce[1],self.dragForce[2])
		self.x = self.x + math.cos(self.velocity[2])*(self.velocity[1]*dt)
		self.y = self.y + math.sin(self.velocity[2])*(self.velocity[1]*dt)
		self.shape:moveTo(self.x,self.y)
		self.shape:setRotation(self.rotation)
	end
	function self.handle_collisions(dt,othershape,dx,dy)
		--[[
		if othershape is a obj which should damage ship (wepons, etc)
		the code for that should prob go here. Aditionaly docking in ports
		picking up loot, etc might go here.
		--]]
		if othershape.name == "terrain_collider" then
			--self.x = self.x+dx 
			--self.y = self.y+dy
			self.hp = self.hp - distance(0,0,dx,dy)
			local vel_x = dx/dt
			local vel_y = dy/dt
			local vec = {distance(0,0,vel_x,vel_y)*.25,get_direction(0,0,vel_x,vel_y)}
			self.velocity = add_vectors(self.velocity[1],self.velocity[2],vec[1],vec[2])

		elseif othershape.name == "projectile" then
			self.hp = self.hp-5
		elseif othershape.owner.name == "baseSHipClass" then --needs code for raming
			self.hp = self.hp - distance(0,0,dx,dy)
			local vel_x = dx/dt
			local vel_y = dy/dt
			local vec = {distance(0,0,vel_x,vel_y)*.25,get_direction(0,0,vel_x,vel_y)}
			self.velocity = add_vectors(self.velocity[1],self.velocity[2],vec[1],vec[2])
			-- if  math.abs(self.velocity[1])>100 then 
			-- 	self.hp = self.hp - math.abs(self.velocity[1])*.05
			-- elseif  math.abs(self.velocity[1])>20 then
			-- 	self.hp = self.hp - math.abs(self.velocity[1])*.02 
		elseif othershape.owner.name == "town" then 
			self.hp = self.hp - distance(0,0,dx,dy)
			self.velocity[1] = 0
			self.x = self.x+dx*5
			self.y = self.y+dy*5
			if self.name == "player" then
				portMenu(othershape.owner)
			end
		end
	end
	return self
end

