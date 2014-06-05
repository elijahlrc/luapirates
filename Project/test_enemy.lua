function enemy_ship(x_pos,y_pos)
	local drag = .01
	local turnspeed = math.pi*.4
	local speed = 1.4

	local self = baseShipClass(x_pos,y_pos,SPRITES.ship2,speed,
								turnspeed,drag,MAX_PLAYER_VELOCITY,
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
	function self.turnToBroadside(dt,x,y)
		--returns nothing, turns ship tword point x,y
		if math.abs((self.rotation%math.pi+math.pi/2)-get_direction(self.x,self.y,x,y))<math.pi/4 then
				self.rotation = self.rotation+self.turn_speed*dt
		else
			self.rotation = self.rotation-self.turn_speed*dt
		end
	end
	function self.move(dt)
		self.goal.x = PLAYER.x
		self.goal.y = PLAYER.y
		self.dirToPlayer = get_direction(self.x,self.y,self.goal.x,self.goal.y)
		self.distanceToPlayer = distance(self.x,self.y,self.goal.x,self.goal.y)
		self.velocity = self.velocity+self.speed
		if self.distanceToPlayer < 500 then
			self.turnToBroadside(dt,self.goal.x,self.goal.y)
		elseif self.distanceToPlayer >= 500 then
			--approch player
			self.rotation = self.rotation+self.turn_speed*shortestAngleDir(self.rotation,self.dirToPlayer)*dt
			--if greater distances let player escape
		end
	end
	function self.fire_guns(dt)
		self.target.x = PLAYER.x
		self.target.y = PLAYER.y
		if math.abs((self.rotation+math.pi*.5) - get_direction(self.x,self.y,self.target.x,self.target.y))<math.pi/8 then
			self.fireing = "right"
		elseif math.abs((self.rotation-math.pi*.5) - get_direction(self.x,self.y,self.target.x,self.target.y))<math.pi/8 then
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



