function Player(x,y,sprite,speed,turn_speed,drag,velocity,max_velocity)
	
	local self = baseShipClass(x,y,{0,0},0)
	self.set_ship(startingShip)
	self.shape.name = "playershape"
	self.hp = 10000
	self.addToHold(small_cannon,10)
	self.faction  = "independent"
	self.shape.owner = self --shape containes referance to owner, all interactive shapes must do this
	self.name = "player"
	self.reCalculateStats()
	self.money = 1000
	self.equipAll()
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
	function self.ship_specific_update(dt)
	end
	return self
end