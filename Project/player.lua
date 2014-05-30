function Player(x,y,sprite,rotation,speed,turn_speed,drag,velocity,max_velocity)
	--[[
	Player class 
	has a sprite, position, some statistics, eventualy will have things like

	Todo:
	inventory
	itemization
	]]
	
	--these are all public feilds
	--things of the 'self.foo = bar' format
	--private feilds are defined as
	--'local foo = bar'

	local self = baseClass()
	--local self = {}
	self.name = "PlaYA"
	self.x = x
	self.y = y
	self.sprite = sprite
	self.rotation = rotation
	self.speed = speed
	self.turn_speed = turn_speed
	self.drag = drag
	self.velocity = velocity
	self.max_velocity = max_velocity
	self.reload = 0
	--collider
	self.shape = Collider:addRectangle(self.x+2,self.y+2,SHIP_OFFSET_X-4,SHIP_OFFSET_Y-4)
	self.shape.owner = self --shape containes referance to owner, all interactive shapes must do this
	self.shape.name = "PlaYA_shape"
	--player group is the group of objs that should not colide with player
	--things like the players own cannonballs
	--etc
	--None that AOE attacks the player uses tha SHOULD hit the player
	--should not be in "player" group.
	Collider:addToGroup("player",self.shape)

	print("player shape created")
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

	function self.update(dt)
		self.move(dt)
		self.fire(dt)
		if self.reload>0 then
			self.reload = self.reload - dt
		end
	end
	function self.fire(dt)
		if self.reload <= 0 and KEYBOARD_STATE.get_fireing() then
			self.reload = 1
			table.insert(DYNAMIC_OBJECTS, cannonball_projectile(10,self.x,self.y,self.rotation,100,true))
		end
	end
	function self.move(dt)
		--[[
		Hey, Marcel! I need a docstring! (and documentation)
		--]]
		self.before_move_x = self.x
		self.before_move_y = self.y

		self.before_move_velocity = self.velocity

		if KEYBOARD_STATE.get_direction() == "forward" then
			self.velocity = self.velocity+self.speed
		elseif KEYBOARD_STATE.get_direction() == "backward" then
			self.velocity = self.velocity-self.speed
		end

		if KEYBOARD_STATE.get_direction() ~= nil then
			if KEYBOARD_STATE.get_rotation() == "clockwise" then
				self.rotation = self.rotation + (self.turn_speed*dt)/RADIANS
			elseif KEYBOARD_STATE.get_rotation() == "counterclockwise" then
				self.rotation = self.rotation - (self.turn_speed*dt)/RADIANS
			end
		else
			if KEYBOARD_STATE.get_rotation() == "clockwise" then
				self.rotation = self.rotation + (self.turn_speed*dt)/RADIANS
				self.velocity = self.velocity+self.speed
			elseif KEYBOARD_STATE.get_rotation() == "counterclockwise" then
				self.rotation = self.rotation - (self.turn_speed*dt)/RADIANS
				self.velocity = self.velocity+self.speed
			end

		end
		self.velocity = self.velocity - self.velocity*self.drag
		if math.abs(self.velocity) > self.max_velocity then
			self.velocity = self.before_move_velocity
		end
		
		self.x = self.x + math.cos(self.rotation)*(self.velocity*dt)
		self.y = self.y + math.sin(self.rotation)*(self.velocity*dt)
		self.shape:moveTo(self.x,self.y)
		self.shape:setRotation(self.rotation)
	end

	function self.handle_collisions(dt,othershape,dx,dy)
		--[[
		if othershape is a obj which should damage ship (wepons, etc)
		the code for that should prob go here. Aditionaly docking in ports
		picking up loot, etc might go here.
		--]]
		self.x = self.x+dx --curently all colisions result in playerhsip 
		self.y = self.y+dy --returning to the position it was before colision
		self.velocity = 0
	end



	return self
end