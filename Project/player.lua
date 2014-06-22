function Player(x,y,sprite,rotation,speed,turn_speed,drag,velocity,max_velocity)
	
	local self = baseShipClass(x,y,SPRITES.ship,PLAYER_SPEED,PLAYER_TURN_SPEED,PLAYER_DRAG,PLAYER_VELOCITY,START_ROTATION,PLAYER_MAX_HP,nil,100,100)
	self.shape = Collider:addPolygon(self.x+2,self.y+self.height/2, self.x+self.width/2,self.y+2, self.x+self.width-2,self.y+self.height/2, self.x+self.width/2,self.y+self.height-2)
	Collider:addToGroup(tostring(self.id),self.shape)
	self.shape.name = "playershape"
	local gun_set =basic_guns(self,tostring(self.id))
	for i,obj in pairs(gun_set) do
		obj.equipped = true
		table.insert(self.inventory,{obj,1})
	end
	self.cannons = gun_set
	self.shape.owner = self --shape containes referance to owner, all interactive shapes must do this
	self.name = "player"
	function self.fire_guns(dt)
		self.fireing = KEYBOARD_STATE.get_fireing()
		for _,gun in pairs(self.cannons) do
			gun.fire(dt,self.fireing)
		end
	end
	function self.move(dt)
		score = round(self.velocity[1],1)
		local dir = KEYBOARD_STATE.get_direction()
		local rot = KEYBOARD_STATE.get_rotation()
		if dir == "forward" then
			self.accelerate(dt,"forward")
		elseif dir == "backward" then
			self.accelerate(dt,"backward")
		end
		if rot == "clockwise" then
			self.turn(dt,"cl")
		elseif rot == "counterclockwise" then
			self.turn(dt,"cc")
		end
	end
	--[[function self.fire(dt)
		local fire = KEYBOARD_STATE.get_fireing()
		if fire then
			if fire == 'both' then
				if self.reloadRight <= 0 then
					local vec = add_vectors(500,self.rotation+math.pi/2,self.velocity[1],self.rotation)--these vec lines add player velocity and gun velocity
					table.insert(DYNAMIC_OBJECTS, cannonball_projectile(vec[1],self.x,self.y,vec[2],2,true))
					self.reloadRight = self.reloadRate
				end
				if self.reloadLeft <=0 then
					local vec = add_vectors(500,self.rotation-math.pi/2,self.velocity[1],self.rotation)
					table.insert(DYNAMIC_OBJECTS, cannonball_projectile(vec[1],self.x,self.y,vec[2],2,true))					
					self.reloadLeft = self.reloadRate
				end
			elseif fire == 'right' and self.reloadRight <= 0 then
				local vec = add_vectors(500,self.rotation+math.pi/2,self.velocity[1],self.rotation)
				table.insert(DYNAMIC_OBJECTS, cannonball_projectile(vec[1],self.x,self.y,vec[2],2,true))
				self.reloadRight = self.reloadRate
			elseif fire == 'left' and self.reloadLeft <= 0  then
					local vec = add_vectors(500,self.rotation-math.pi/2,self.velocity[1],self.rotation)
					table.insert(DYNAMIC_OBJECTS, cannonball_projectile(vec[1],self.x,self.y,vec[2],2,true))				
					self.reloadLeft = self.reloadRate
			end
		end
	end--]]
	return self
end