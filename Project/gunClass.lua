function cannonClass(position,speed,gun_rot,lifetime,reload_time,owner,x_offset,y_offset,sprite,random_rot,random_vel,group,proj_size,cost,mass,name)
	--[[instances of this class represent guns on the ship
	guns act by inserting particles with certan params into the 
	DYNAMIC OBJECTs table when certan conditions are met, ie reload time and fire pressed
	--]]
	local self = ItemBaseClass(cost,mass,name,"equipment")
	self.x = x_offset or 0 --these set to 0 if not passed into function, neet trick eh?
	self.y = y_offset or 0-- like using foo(x,y=3) to make y default to 3 in python
	self.position = position
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
		--local fireing = KEYBOARD_STATE.get_fireing()
		local go = (fireing == self.position) or (fireing == 'both')
		if self.reload <= 0 and go then
			self.reload = self.reload_time
			local random_r = (math.random()-.5)*self.random_rot--random firespeed and angle
			local random_v = (math.random()-.5)*self.random_vel
			local x_off = math.cos(owner.rotation)*self.x +math.cos(owner.rotation)*self.y--these 2 lines calculate position of gun based on owner rotation
			local y_off = math.sin(owner.rotation)*self.y+math.sin(owner.rotation)*self.x
			local vec = add_vectors(self.speed,owner.rotation+self.rotation,
									self.owner.velocity[1],self.owner.velocity[2])--these vec lines add player velocity and gun velocity
			table.insert(PROJECTILES,
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
	Player and Ship . gun tables should be set equal to this table/class
	--]]
	local self = {}
	self.guns = {}
	self.speed = 450
	local left = -math.pi/2
	local right = math.pi/2
	local reload_time = 1
	local lifetime = 1.5
	local sprite = SPRITES.canonball
	local random_rot = .05
	local random_vel = 30
	local group = group
	local proj_size = 7
	--[[
	the folowing could also be  done with a gun generator, ie

	"function gen(params)
		function make_gun()
			return cannonClass(params)
		end
		return make_gun
	end"
	this would be cleaner/better and should be implimented
	]]
	self.guns = {
		cannonClass("left",self.speed,left,lifetime,	reload_time,owner,-10,0,sprite,random_rot,random_vel,group,proj_size,1000,1, "Small Cannon"),
		cannonClass("left",self.speed,left,lifetime,	reload_time,owner,0,0,	sprite,random_rot,random_vel,group,proj_size,1000,1, "Small Cannon"),
		cannonClass("left",self.speed,left,lifetime,	reload_time,owner,10,0,	sprite,random_rot,random_vel,group,proj_size,1000,1, "Small Cannon"),
		cannonClass("right",self.speed,right,lifetime,	reload_time,owner,-10,0,sprite,random_rot,random_vel,group,proj_size,1000,1, "Small Cannon"),
		cannonClass("right",self.speed,right,lifetime,	reload_time,owner,0,0,	sprite,random_rot,random_vel,group,proj_size,1000,1, "Small Cannon"),
		cannonClass("right",self.speed,right,lifetime,	reload_time,owner,10,0,	sprite,random_rot,random_vel,group,proj_size,1000,1, "Small Cannon"),
		cannonClass("left",self.speed,left,lifetime,	reload_time,owner,-20,0,sprite,random_rot,random_vel,group,proj_size,1000,1, "Small Cannon"),
		cannonClass("right",self.speed,right,lifetime,	reload_time,owner,-20,0,sprite,random_rot,random_vel,group,proj_size,1000,1, "Small Cannon"),

		}
	return self.guns
end