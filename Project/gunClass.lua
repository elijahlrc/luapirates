function cannonClass(name,speed,gun_rot,lifetime,reload_time,owner,x_offset,y_offset,sprite,random_rot,random_vel,group,proj_size)
	local self = baseClass()
	self.x = x_offset or 0 --these set to 0 if not passed into function, neet trick eh?
	self.y = y_offset or 0-- like using foo(x,y=3) to make y default to 3 in python
	self.name = name
	self.reload_time = reload_time
	self.speed = speed
	self.rotation = gun_rot
	self.lifetime = lifetime
	self.reload = 0
	self.sprite = sprite
	self.random_rot = random_rot
	self.random_vel = random_vel
	self.group = group
	self.owner = owner
	self.proj_size = proj_size
	function self.fire(dt,fireing)
		self.reload = self.reload - dt
		local fireing = KEYBOARD_STATE.get_fireing()
		local go = (fireing == self.name) or (fireing == 'both')
		if self.reload <= 0 and go then
			self.reload = self.reload_time
			local random_r = (math.random()-.5)*self.random_rot--random firespeed and angle
			local random_v = (math.random()-.5)*self.random_vel
			local x_off = math.cos(owner.rotation)*self.x +math.cos(owner.rotation)*self.y--these 2 lines calculate position of gun based on owner rotation
			local y_off = math.sin(owner.rotation)*self.y+math.sin(owner.rotation)*self.x
			local vec = add_vectors(self.speed,owner.rotation+self.rotation,
									self.owner.velocity,self.owner.rotation)--these vec lines add player velocity and gun velocity
			table.insert(DYNAMIC_OBJECTS,
				colliding_projectile(self.lifetime,
									self.sprite,
									self.group,
									self.owner.x+x_off,
									self.owner.y+y_off,
									vec[2]+random_r,
									vec[1]+random_v,
									self.proj_size))--create proj instance
		end

	end
	return self
end


function basic_guns(owner,group)
	--[[
	doesnt even need to be an obj, just has to have a .guns table whith
	guns/somthing with a fire method in it
	--]]
	local self = {}
	self.guns = {}
	local speed = 300
	local left = -math.pi/2
	local right = math.pi/2
	local reload_time = .2
	local lifetime = 3
	local sprite = SPRITES.canonball
	local random_rot = .05
	local random_vel = 10
	local group = group
	local proj_size = 7
	self.guns = {cannonClass("left",speed,left,lifetime,reload_time,owner,-10,0,sprite,random_rot,random_vel,group,proj_size),
		cannonClass("left",speed,left,lifetime,reload_time,owner,0,0,sprite,random_rot,random_vel,group,proj_size),
		cannonClass("left",speed,left,lifetime,reload_time,owner,10,0,sprite,random_rot,random_vel,group,proj_size),
		cannonClass("right",speed,right,lifetime,reload_time,owner,-10,0,sprite,random_rot,random_vel,group,proj_size),
		cannonClass("right",speed,right,lifetime,reload_time,owner,0,0,sprite,random_rot,random_vel,group,proj_size),
		cannonClass("right",speed,right,lifetime,reload_time,owner,10,0,sprite,random_rot,random_vel,group,proj_size),
		cannonClass("left",speed,left,lifetime,reload_time,owner,-20,0,sprite,random_rot,random_vel,group,proj_size),
		cannonClass("left",speed,left,lifetime,reload_time,owner,-30,0,sprite,random_rot,random_vel,group,proj_size),
		cannonClass("left",speed,left,lifetime,reload_time,owner,20,0,sprite,random_rot,random_vel,group,proj_size),
		cannonClass("right",speed,right,lifetime,reload_time,owner,-20,0,sprite,random_rot,random_vel,group,proj_size),
		cannonClass("right",speed,right,lifetime,reload_time,owner,-30,0,sprite,random_rot,random_vel,group,proj_size),
		cannonClass("right",speed,right,lifetime,reload_time,owner,20,0,sprite,random_rot,random_vel,group,proj_size)}
	return self
end