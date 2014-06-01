function cannonClass(name,speed,rotation,lifetime,reload_time,owner)--this is the base gun that contains no guns
	local self = baseClass()
	self.name = name
	self.owner = owner
	self.lifetime = lifetime
	self.speed = speed
	self.reload_time = reload_time
	self.reload = 0
	self.rotation = rotation
	function self.fire(dt)
		self.reload = self.reload - dt
		local go = (KEYBOARD_STATE.get_fireing() == self.name) or (KEYBOARD_STATE.get_fireing() == 'both')
		if self.reload <= 0 and go then
			self.reload = self.reload_time
			local random_v = 50
			local random_r = .05
			local ball = player_cannonball(owner.x,owner.y,2,true,random_v,random_r)
			local vec = add_vectors(self.speed,owner.rotation+self.rotation,self.owner.velocity,self.owner.rotation)--these vec lines add player velocity and gun velocity
			table.insert(DYNAMIC_OBJECTS, ball(vec[1],vec[2]))
		end

	end
	return self
end
function basic_guns(owner)
	local self = {}
	self.guns = {}
	local ballspeed = 400
	local lifetime = 3
	local reload_time = .1
	self.guns.right = cannonClass('right',ballspeed,math.pi/2,lifetime,reload_time,owner)
	self.guns.left = cannonClass('left',ballspeed,math.pi/(-2),lifetime,reload_time,owner)
	return self
end

		