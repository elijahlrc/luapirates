function Player(x,y,sprite,rotation,speed,turn_speed,drag,velocity,max_velocity)
	
	local self = baseShipClass(START_X,START_Y,SPRITES.ship,PLAYER_SPEED,PLAYER_TURN_SPEED,PLAYER_DRAG,MAX_PLAYER_VELOCITY,PLAYER_VELOCITY,START_ROTATION,PLAYER_MAX_HP,shape)
	self.shape = Collider:addRectangle(self.x+2,self.y+2,SHIP_OFFSET_X-4,SHIP_OFFSET_Y-4)
	self.shape.owner = self --shape containes referance to owner, all interactive shapes must do this
	Collider:addToGroup("player",self.shape)
	self.shape.name = "playershape"
	self.reloadRate = PLAYER_RELOAD_RATE
	self.reloadLeft = self.reloadRate
	self.reloadRight = self.reloadRate
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
			self.velocity = self.velocity-self.speed*.3
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
				self.velocity = self.velocity+self.speed*.1
			elseif KEYBOARD_STATE.get_rotation() == "counterclockwise" then
				self.rotation = self.rotation - (self.turn_speed*dt)/RADIANS
				self.velocity = self.velocity+self.speed*.1
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
	function self.update(dt)
		self.move(dt)
		self.fire(dt)
		if self.reloadRight>0 then
			self.reloadRight = self.reloadRight - dt
		end
		if self.reloadLeft>0 then
			self.reloadLeft = self.reloadLeft - dt

		end
	end
	function self.fire(dt)
		local fire = KEYBOARD_STATE.get_fireing()
		if fire then
			if fire == 'both' then
				if self.reloadRight <= 0 then
					local vec = add_vectors(500,self.rotation+math.pi/2,self.velocity,self.rotation)--these vec lines add player velocity and gun velocity
					table.insert(DYNAMIC_OBJECTS, cannonball_projectile(vec[1],self.x,self.y,vec[2],2,true))
					self.reloadRight = self.reloadRate
				end
				if self.reloadLeft <=0 then
					local vec = add_vectors(500,self.rotation-math.pi/2,self.velocity,self.rotation)
					table.insert(DYNAMIC_OBJECTS, cannonball_projectile(vec[1],self.x,self.y,vec[2],2,true))					
					self.reloadLeft = self.reloadRate
				end
			elseif fire == 'right' and self.reloadRight <= 0 then
				local vec = add_vectors(500,self.rotation+math.pi/2,self.velocity,self.rotation)
				table.insert(DYNAMIC_OBJECTS, cannonball_projectile(vec[1],self.x,self.y,vec[2],2,true))
				self.reloadRight = self.reloadRate
			elseif fire == 'left' and self.reloadLeft <= 0  then
					local vec = add_vectors(500,self.rotation-math.pi/2,self.velocity,self.rotation)
					table.insert(DYNAMIC_OBJECTS, cannonball_projectile(vec[1],self.x,self.y,vec[2],2,true))				
					self.reloadLeft = self.reloadRate
			end
		end
	end
	return self
end