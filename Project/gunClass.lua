function cannonClass(name,speed,rotation,lifetime,reload_time,owner,x_offset,y_offset,projectile)
	--this is a base gun that contains no guns, 
	--so its fire method actualy creates a projectile rather than fireing other guns
	local self = baseClass()
	self.x = x_offset or 0 --these set to 0 if not passed into function, neet trick eh?
	self.y = y_offset or 0-- like using foo(x,y=3) to make y default to 3 in python
	self.name = name       -- i <3 lua
	self.owner = owner
	self.lifetime = lifetime
	self.speed = speed
	self.reload_time = reload_time
	self.reload = 0
	self.rotation = rotation
	self.projectile = projectile or player_cannonball
	function self.fire(dt)
		self.reload = self.reload - dt
		local go = (KEYBOARD_STATE.get_fireing() == self.name) or (KEYBOARD_STATE.get_fireing() == 'both')
		if self.reload <= 0 and go then
			x_off = math.cos(owner.rotation)*self.x +math.cos(owner.rotation)*self.y
			y_off = math.sin(owner.rotation)*self.y+math.sin(owner.rotation)*self.x
			self.reload = self.reload_time
			local random_v = 10
			local random_r = .02
			local ball = self.projectile(owner.x+x_off,owner.y+y_off,2,true,random_v,random_r)
			local vec = add_vectors(self.speed,owner.rotation+self.rotation,self.owner.velocity,self.owner.rotation)--these vec lines add player velocity and gun velocity
			table.insert(DYNAMIC_OBJECTS, ball(vec[1],vec[2]))
		end

	end
	return self
end
function basic_guns(owner)
	--[[
	doesnt even need to be an obj, just has to have a .guns table whith
	guns/somthing with a fire method in it
	--]]
	local self = {}
	self.guns = {}
	local ballspeed = 400
	local lifetime = 3
	local reload_time = .5
	self.guns.right1 = cannonClass('right',ballspeed,math.pi/2,lifetime,reload_time,owner,15,0)
	self.guns.right2 = cannonClass('right',ballspeed,math.pi/2,lifetime,reload_time,owner,0,0)
	self.guns.right3 = cannonClass('right',ballspeed,math.pi/2,lifetime,reload_time,owner,-15,0)
	self.guns.left1 = cannonClass('left',ballspeed,math.pi/-2,lifetime,reload_time,owner,15,0)
	self.guns.left2 = cannonClass('left',ballspeed,math.pi/-2,lifetime,reload_time,owner,0,0)
	self.guns.left3 = cannonClass('left',ballspeed,math.pi/-2,lifetime,reload_time,owner,-15,0)	return self
end

		