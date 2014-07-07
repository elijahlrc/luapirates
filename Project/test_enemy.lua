function cargo_ship(x_pos,y_pos,faction)
	local drag = PLAYER_DRAG
	local turnspeed = PLAYER_TURN_SPEED*.4
	local speed = PLAYER_SPEED*.6
	local self = npc_ship(x_pos,y_pos,SPRITES.cargo_ship,speed,
								turnspeed,drag,
								{0,0},0,500,nil,1000,500,faction)
	self.shape = Collider:addPolygon(self.x,self.y+self.height/2, --dimond shape
														self.x+self.width/2,self.y, 
														self.x+self.width,self.y+self.height/2, 
														self.x+self.width/2,self.y+self.height)
	self.shape.owner = self
	Collider:addToGroup(tostring(self.id),self.shape)
	self.name = "Cargo_ship"
	self.shape.name = "npc_ship"
	self.cannons = {}
	self.faction = faction

	local cargo_options = coppyTable(TRADEGOODS)--fill hold
	self.addToHold(cargo_options[math.random( #cargo_options )], round(math.abs(random_gauss(self.holdsize/2,self.holdsize/4))))
	while math.random(100)>50 do
		self.addToHold(cargo_options[math.random( #cargo_options )], round(math.abs(random_gauss(self.holdsize/2,self.holdsize/4))))
	end

	local town_counter = 0


	function self.find_target_town()
		local target = TOWNS[math.random(#TOWNS)]
		while distance(target.x,target.y,self.x,self.y)>10000 and town_counter<100 do
			target = TOWNS[math.random(#TOWNS)]
			town_counter = town_counter+1
		end
		print(town_counter)
		return target
	end
	self.target = self.find_target_town()
	local target_timer = 0
	function self.move(dt)
		if target_timer>1000 then
			target_timer = 0
			self.target = self.find_target_town()
		end
		target_timer = target_timer+dt
		if self.avoid_colisions(dt) then
		else
			self.accelerate(dt,"forward")
			self.dirToTarget = get_direction(self.x,self.y,self.target.x,self.target.y)
			self.turn(dt,shortestAngleDir(self.rotation,self.dirToTarget))
		end
	end
	function self.fire_guns(dt)
	end
	return self
end

function pirate_ship (x_pos,y_pos,faction)
	local drag = PLAYER_DRAG
	local turnspeed = PLAYER_TURN_SPEED
	local speed = PLAYER_SPEED*.95
	local self = npc_ship(x_pos,y_pos,SPRITES.ship2,speed,
								turnspeed,drag,
								{0,0},0,100,nil,50,100,faction)
	self.shape = Collider:addPolygon(self.x,self.y+self.height/2, --dimond shape
														self.x+self.width/2,self.y, 
														self.x+self.width,self.y+self.height/2, 
														self.x+self.width/2,self.y+self.height)
	self.shape.owner = self
	Collider:addToGroup(tostring(self.id),self.shape)
	self.name = "pirate_ship"
	self.shape.name = "npc_ship"
	if math.random()>.5 then

		self.cannons = scatter_guns(self,tostring(self.id))
	else
		self.cannons = basic_guns(self,tostring(self.id))
	end

	self.faction = faction
	function self.find_enemy()
		local dist_to_target = 9999999
		for i = 1,#SHIPS do
			if dist_to_target>distance(self.x,self.y,SHIPS[i].x,SHIPS[i].y) then
				if SHIPS[i].faction ~= self.faction then
					dist_to_target = distance(self.x,self.y,SHIPS[i].x,SHIPS[i].y)
					self.enemy = SHIPS[i]
				end
			end
		end
		if not self.enemy then
			self.enemy = PLAYER
		end
	end
	self.find_enemy()

	local cargo_options = coppyTable(TRADEGOODS)--fill hold with 0 to ... items, weighted twords 1. If more items are added by gauss dist then can fit, then 0 will be added instead
	self.addToHold(cargo_options[math.random( #cargo_options )], round(math.abs(random_gauss(self.holdsize/2,self.holdsize/4))))
	while math.random(100)>50 do
		self.addToHold(cargo_options[math.random( #cargo_options )], round(math.abs(random_gauss(self.holdsize/2,self.holdsize/4))))
	end

	--find target
	function self.move(dt)--needs a state system where persistant behavior is coded.
		if self.enemy == nil or self.enemy.dead == true then
			self.find_enemy()
		end
		self.line_directions = {}
		self.move_state = "normal"

		

		--Following 5 lines sets target to location in front of player taking into acount player speed
		--and curent ship speed
		local time_to_impact = distance(self.x,self.y,self.enemy.x,self.enemy.y)/self.get_average_gun_speed()
		self.goal.x = self.enemy.x + math.cos(self.enemy.velocity[2])*(self.enemy.velocity[1]*time_to_impact)-
			math.cos(self.velocity[2])*(self.velocity[1]*time_to_impact)
		self.goal.y = self.enemy.y + math.sin(self.enemy.velocity[2])*(self.enemy.velocity[1]*time_to_impact)-
			math.sin(self.velocity[2])*(self.velocity[1]*time_to_impact)


		self.dirToPlayer = get_direction(self.x,self.y,self.goal.x,self.goal.y)
		self.distanceToPlayer = distance(self.x,self.y,self.goal.x,self.goal.y)



	
		--maybe insert a far check as well
		if self.avoid_colisions(dt) then
		elseif self.distanceToPlayer < self.get_average_gun_range() then
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
function npc_ship(x,y,sprite,speed,turn_speed,drag,velocity,rotation,health,shape,holdsize,max_health,faction)
	local self = baseShipClass(x,y,sprite,speed,
								turn_speed,drag,
								velocity,0,health,nil,holdsize,max_health)
	--[[
	self.shape = Collider:addPolygon(self.x,self.y+self.height/2, --dimond shape
														self.x+self.width/2,self.y, 
														self.x+self.width,self.y+self.height/2, 
														self.x+self.width/2,self.y+self.height)

	self.shape.owner = self --shape containes referance to owner, all interactive shapes must do this
	Collider:addToGroup(tostring(self.id),self.shape)
	self.shape.name = "npc_ship"
	self.name = "npc_ship"
	--]]
	self.goal = {}
	self.target = {}
	function self.get_average_gun_speed()
		total_speed = 0
		for _, cannon in pairs(self.cannons) do
			total_speed	 = total_speed+cannon.speed
		end
		return total_speed/(#self.cannons)
	end
	function self.get_average_gun_range()
		total_range = 0
		for _,cannon in pairs(self.cannons) do
			total_range = total_range + (cannon.speed * cannon.lifetime * .5)
		end
		return total_range/#self.cannons
	end

	function self.hit(shape)
		if shape.name == "terrain_collider" or shape.owner.name == "wreck" or (shape.name == "npc_ship" and shape.owner.id ~= self.id) then
			return true
		else
			return false
		end
	end
	function self.checkfront(size,ang)
		local directions = {(self.rotation-ang) , (self.rotation), (self.rotation+ang)}
		local offset = 	{
						{-1*math.cos(self.rotation+math.pi/2)*self.height,-1*math.sin(self.rotation+math.pi/2)*self.height},
						{0,0},
						{math.cos(self.rotation+math.pi/2)*self.height,math.sin(self.rotation+math.pi/2)*self.height}
						}
		local results = {}
		for i=1, #directions do
			local result = self.raycast(self.x+offset[i][1],self.y+offset[i][2],directions[i],size)
			table.insert(results, result)
		end
		return results
	end
	function self.raycast(x,y,dir,size)--need to be redone
		local step = 20
		local dx = math.cos(dir)*step
		local dy = math.sin(dir)*step
		local x_pos = 0
		local y_pos = 0
		local shapes
		for i = 0, round(size/step) do
			shapes = Collider:shapesAt(round(x+x_pos),round(y_pos+y))
			for _,shape in pairs(shapes) do
				if self.hit(shape) then
					--table.insert(self.line_directions, {dir, x, y, i*step})
					return i*step
				end
			end
			x_pos = x_pos+dx
			y_pos = y_pos+dy
		end
		--table.insert(self.line_directions, {dir, x, y, false})
		return false
	end

	function self.turnToBroadside(dt)
		if math.abs(shortAng(self.rotation+math.pi*.5,self.dirToPlayer)) < (math.pi*.5) then
			self.turn(dt,shortestAngleDir(self.rotation + math.pi*.5 , self.dirToPlayer))
		else
			self.turn(dt,shortestAngleDir(self.rotation - math.pi*.5 , self.dirToPlayer))
		end
	end
	function self.avoid_colisions(dt)--returns true if it did something, false if no rays hit.
		local ang = math.pi/32
		local rays = self.checkfront(450,ang)
		local left_ray = rays[1]
		local middle_ray = rays[2]
		local right_ray = rays[3]
		if middle_ray or right_ray or left_ray then
			while right_ray and left_ray and ang < math.pi do
				ang = ang+math.pi/32
				rays = self.checkfront(450,ang)
				left_ray = rays[1]
				middle_ray = rays[2]
				right_ray = rays[3]
			end
			if left_ray == false then
				self.turn(dt,"cc")
			elseif right_ray == false then
				self.turn(dt,"cl")
			elseif ang>=math.pi then
				if left_ray<right_ray then
					self.turn(dt,"cl")
				else
					self.turn(dt,"cc")
				end
			end
			if not middle_ray or middle_ray>300 then
				self.accelerate(dt,"forward")
			elseif middle_ray<100 then
				self.accelerate(dt,"backward")
			end
			return true
		else
			return false
		end
	end
	return self
end
