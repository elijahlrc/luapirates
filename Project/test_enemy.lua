function trade_behavior(self,faction)--this is a behavior, should used like ship.set_behavor(cargo_ship("pirate"))
	self.name = "Cargo_ship"
	self.cannons = {}
	self.faction = faction
	
	self.town_counter = 0
	self.target_timer = 1000
	function self.find_target_town()
		local target = TOWNS[math.random(#TOWNS)]
		while distance(target.x,target.y,self.x,self.y)>10000 and self.town_counter<100 do
			local target = TOWNS[math.random(#TOWNS)]
			self.town_counter = self.town_counter+1
		end
		print(self.town_counter)
		return target
	end
	function self.move(dt)

		if self.avoid_colisions(dt,600) then
		else
			self.accelerate(dt,"forward")
			self.dirToTarget = get_direction(self.x,self.y,self.target.x,self.target.y)
			self.turn(dt,shortestAngleDir(self.rotation,self.dirToTarget))
		end
	end
	function self.fire_guns(dt)
		--somthing about checking if a ship is hostile and if it is fireing if it happens to be hittable?
	end
	function self.ship_specific_update(dt)
		if self.target_timer>=1000 then
			self.target_timer = 0
			self.target = self.find_target_town()
		end
		self.target_timer = self.target_timer+dt
	end
	return self
end
function wreck_behavior(self,faction)
	self.name = "wreck"
	self.faction = faction
	function self.move(dt)
	end
	function self.fire_guns(dt)
	end
	function self.ship_specific_update(dt)
	end
	return self
end
function pirate_behavior(self,faction)--this is a behavior, should used like ship.set_behavor(pirate_ship("pirate"))
	self.name = "pirate_ship"	
	--fix me!

	--gota equip them now
	--end fix me


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
	 function self.ship_specific_update()
		if self.enemy == nil or self.enemy.dead == true then
			self.find_enemy()
		end
	end
	function self.move(dt)--needs a state system where persistant behavior is coded.
		
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
		if self.avoid_colisions(dt,500) then
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
	function self.fire_guns (dt)

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
