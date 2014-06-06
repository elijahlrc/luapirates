function enemy_ship(x_pos,y_pos)
	local drag = PLAYER_DRAG
	local turnspeed = PLAYER_TURN_SPEED
	local speed = PLAYER_SPEED

	local self = baseShipClass(x_pos,y_pos,SPRITES.ship2,speed,
								turnspeed,drag,
								PLAYER_VELOCITY,0,100)

	self.name = "enemyShip"
	self.shape = Collider:addPolygon(self.x,self.y+self.height/2, --dimond shape
														self.x+self.width/2,self.y, 
														self.x+self.width,self.y+self.height/2, 
														self.x+self.width/2,self.y+self.height)

	self.shape.owner = self --shape containes referance to owner, all interactive shapes must do this
	Collider:addToGroup(tostring(self.id),self.shape)
	self.shape.name = "enemy_ship"
	self.cannons = basic_guns(self,tostring(self.id))
	self.goal = {}
	self.target = {}
	function self.turnToBroadside(dt)
		if math.abs(shortAng(self.rotation+math.pi*.5,self.dirToPlayer)) < (math.pi*.5) then
			self.turn(dt,shortestAngleDir(self.rotation + math.pi*.5 , self.dirToPlayer))
		else
			self.turn(dt,shortestAngleDir(self.rotation - math.pi*.5 , self.dirToPlayer))
		end
	end


		--[[if (self.rotation+math.pi/2)%(2*math.pi)-get_direction(self.x,self.y,x,y)<0 then
				self.rotation = self.rotation+self.turn_speed*dt
		elseif (self.rotation-math.pi/2)%(2*math.pi)-get_direction(self.x,self.y,x,y)<0 then
			self.rotation = self.rotation-self.turn_speed*dt
		end--]]
	function self.move(dt)

		--Following 5 lines sets target to location in front of player taking into acount player speed
		--and curent ship speed
		local time_to_impact = distance(self.x,self.y,PLAYER.x,PLAYER.y)/self.cannons.speed
		self.goal.x = PLAYER.x + math.cos(PLAYER.rotation)*(PLAYER.velocity[1]*time_to_impact)-
		(math.cos(self.rotation)*(self.velocity[1]*time_to_impact))
		self.goal.y = PLAYER.y + math.sin(PLAYER.rotation)*(PLAYER.velocity[1]*time_to_impact)-
		(math.cos(self.rotation)*(self.velocity[1]*time_to_impact))


		self.dirToPlayer = get_direction(self.x,self.y,self.goal.x,self.goal.y)
		self.distanceToPlayer = distance(self.x,self.y,self.goal.x,self.goal.y)
		
		if self.distanceToPlayer < 800 then
			self.accelerate(dt,"forward")
			self.turnToBroadside(dt)
		elseif self.distanceToPlayer <= 3000 then
			--approch player
			self.accelerate(dt,"forward")
			self.turn(dt,shortestAngleDir(self.rotation,self.dirToPlayer))
			--if greater distances let player escape
		end
	end
	function self.fire_guns(dt)
		local time_to_impact = distance(self.x,self.y,PLAYER.x,PLAYER.y)/self.cannons.speed
		self.target.x = PLAYER.x + math.cos(PLAYER.rotation)*(PLAYER.velocity[1]*time_to_impact)-
		(math.cos(self.rotation)*(self.velocity[1]*time_to_impact))
		self.target.y = PLAYER.y + math.sin(PLAYER.rotation)*(PLAYER.velocity[1]*time_to_impact)-
		(math.cos(self.rotation)*(self.velocity[1]*time_to_impact))
		self.dirToPlayer = get_direction(self.x,self.y,self.target.x,self.target.y)
		if math.abs(shortAng(self.dirToPlayer-math.pi*.5 , self.rotation)) < math.pi/16 then
			self.fireing = "right"
		elseif math.abs(shortAng(self.dirToPlayer+math.pi*.5 , self.rotation)) < math.pi/16 then
			self.fireing = "left"
		else
			self.fireing = nil
		end
		for _,gun in pairs(self.cannons.guns) do
			gun.fire(dt,self.fireing)
		end
	end

	return self
end



