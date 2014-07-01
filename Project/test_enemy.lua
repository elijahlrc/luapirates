function enemy_ship(x_pos,y_pos,enemy)
	local drag = PLAYER_DRAG
	local turnspeed = PLAYER_TURN_SPEED
	local speed = PLAYER_SPEED
	local self = baseShipClass(x_pos,y_pos,SPRITES.ship2,speed,
								turnspeed,drag,
								PLAYER_VELOCITY,0,100,nil,100,100)

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

	--cargo
	local cargo_options = coppyTable(TRADEGOODS)

	self.addToHold(cargo_options[math.random(#cargo_options)],math.random(self.holdsize-10))


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
		self.line_directions = {}
		DEBUG_TEXT="ALL RAYS MISED"
		self.movemode = "normal"

		

		--Following 5 lines sets target to location in front of player taking into acount player speed
		--and curent ship speed
		local time_to_impact = distance(self.x,self.y,self.enemy.x,self.enemy.y)/self.get_average_gun_speed()
		self.goal.x = self.enemy.x + math.cos(self.enemy.velocity[2])*(self.enemy.velocity[1]*time_to_impact)-
			math.cos(self.velocity[2])*(self.velocity[1]*time_to_impact)
		self.goal.y = self.enemy.y + math.sin(self.enemy.velocity[2])*(self.enemy.velocity[1]*time_to_impact)-
			math.sin(self.velocity[2])*(self.velocity[1]*time_to_impact)


		self.dirToPlayer = get_direction(self.x,self.y,self.goal.x,self.goal.y)
		self.distanceToPlayer = distance(self.x,self.y,self.goal.x,self.goal.y)


		--close check
		local ang = 0
		local rays = self.checkfront(450,ang)
		local left_ray = rays[1]
		local middle_ray = rays[2]
		local right_ray = rays[3]
		
		if middle_ray or right_ray or left_ray then
			while middle_ray and right_ray and left_ray and ang < math.pi do
				DEBUG_TEXT = "SOMTHING HIT"
				ang = ang+math.pi/32
				rays = self.checkfront(450,ang)
				left_ray = rays[1]
				middle_ray = rays[2]
				right_ray = rays[3]
			end
			if ang>=math.pi then
				if left_ray<right_ray then
					self.turn(dt,"cl")
					DEBUG_TEXT = "widened untill RIGHT RAY was shorter"
				else
					self.turn(dt,"cc")
					DEBUG_TEXT = "widened untill LEFT RAY was shorter"
				end
			elseif left_ray == false then
				self.turn(dt,"cc")
				DEBUG_TEXT = "LEFT RAY MISSED"
			elseif right_ray == false then
				self.turn(dt,"cl")
				DEBUG_TEXT = "RIGHT RAY MISSED"
			end
			
			if not middle_ray or middle_ray>300 then
				self.accelerate(dt,"forward")
			elseif middle_ray<100 then
				self.accelerate(dt,"backward")
			end
		--maybe insert a far check as well

		elseif self.distanceToPlayer < 600 then
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
	function self.hit(shape)
		if shape.name == "terrain_collider" or shape.owner.name == "wreck" or shape.owner.name == "town" or (shape.name == "enemy_ship" and shape.owner.id ~= self.id) then
			return true
		else
			return false
		end
	end
	function self.checkfront(size,ang)
		local directions = {(self.rotation-ang) , (self.rotation), (self.rotation+ang)}
		local offset = 	{
						{-1*math.cos(self.rotation+math.pi/2)*self.height/2,-1*math.sin(self.rotation+math.pi/2)*self.height/2},
						{0,0},
						{math.cos(self.rotation+math.pi/2)*self.height/2,math.sin(self.rotation+math.pi/2)*self.height/2}
						}
		local results = {}
		for i=1, #directions do
			local result = self.raycast(self.x+offset[i][1],self.y+offset[i][2],directions[i],size)
			table.insert(results, result)
		end
		return results
	end
	function self.raycast(x,y,dir,size)--need to be redone
		local step = 5
		local dx = math.cos(dir)*step
		local dy = math.sin(dir)*step
		local x_pos = 0
		local y_pos = 0
		local shapes
		for i = 0, round(size/step) do
			shapes = Collider:shapesAt(x+x_pos,y_pos+y)
			for _,shape in pairs(shapes) do
				if self.hit(shape) then
					table.insert(self.line_directions, {dir, x, y, true})
					return i*step
				end
			end
			x_pos = x_pos+dx
			y_pos = y_pos+dy
		end
		table.insert(self.line_directions, {dir, x, y, false})
		return false
	end



	return self
end