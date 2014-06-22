function enemy_ship(x_pos,y_pos,enemy)
	local drag = PLAYER_DRAG
	local turnspeed = PLAYER_TURN_SPEED
	local speed = PLAYER_SPEED
	local self = baseShipClass(x_pos,y_pos,SPRITES.ship2,speed,
								turnspeed,drag,
								PLAYER_VELOCITY,0,100,nil,50)

	self.shape = Collider:addPolygon(self.x,self.y+self.height/2, --dimond shape
														self.x+self.width/2,self.y, 
														self.x+self.width,self.y+self.height/2, 
														self.x+self.width/2,self.y+self.height)

	self.shape.owner = self --shape containes referance to owner, all interactive shapes must do this
	Collider:addToGroup(tostring(self.id),self.shape)
	self.shape.name = "enemy_ship"
	self.cannons = basic_guns(self,tostring(self.id))
	self.enemy = enemy or PLAYER
	self.goal = {}
	self.target = {}
	self.name = "enemy_ship"
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
	function self.get_average_gun_speed()
		total_speed = 0
		for _, cannon in pairs(self.cannons) do
			total_speed	 = total_speed+cannon.speed
		end
		return total_speed/(#self.cannons)
	end
	function self.move(dt)

		--Following 5 lines sets target to location in front of player taking into acount player speed
		--and curent ship speed
		local time_to_impact = distance(self.x,self.y,self.enemy.x,self.enemy.y)/self.get_average_gun_speed()
		self.goal.x = self.enemy.x + math.cos(self.enemy.velocity[2])*(self.enemy.velocity[1]*time_to_impact)-
		math.cos(self.velocity[2])*(self.velocity[1]*time_to_impact)
		self.goal.y = self.enemy.y + math.sin(self.enemy.velocity[2])*(self.enemy.velocity[1]*time_to_impact)-
		math.sin(self.velocity[2])*(self.velocity[1]*time_to_impact)


		self.dirToPlayer = get_direction(self.x,self.y,self.goal.x,self.goal.y)
		self.distanceToPlayer = distance(self.x,self.y,self.goal.x,self.goal.y)
		
		if self.distanceToPlayer < 600 then
			self.accelerate(dt,"forward")
			self.turnToBroadside(dt)
		elseif self.distanceToPlayer <= 6000 then
			--approch player
			self.accelerate(dt,"forward")
			self.turn(dt,shortestAngleDir(self.rotation,self.dirToPlayer))
			--if greater distances let player escape
		end
	end
	function self.fire_guns(dt)

		local time_to_impact = distance(self.x,self.y,self.enemy.x,self.enemy.y)/self.get_average_gun_speed()

		--trying to predict player location
		self.target.x = self.enemy.x + math.cos(self.enemy.velocity[2])*(self.enemy.velocity[1]*time_to_impact)-
		math.cos(self.velocity[2])*(self.velocity[1]*time_to_impact)
		self.target.y = self.enemy.y + math.sin(self.enemy.velocity[2])*(self.enemy.velocity[1]*time_to_impact)-
		math.sin(self.velocity[2])*(self.velocity[1]*time_to_impact)
		self.dirToPlayer = get_direction(self.x,self.y,self.target.x,self.target.y)
		if math.abs(shortAng(self.dirToPlayer-math.pi*.5 , self.rotation)) < math.pi/8 then
			self.fireing = "right"
		elseif math.abs(shortAng(self.dirToPlayer+math.pi*.5 , self.rotation)) < math.pi/8 then
			self.fireing = "left"
		else
			self.fireing = nil
		end
		for _,gun in pairs(self.cannons) do
			gun.fire(dt,self.fireing)
		end
	end

	return self
end



