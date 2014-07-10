--[[
file for projectile genreators, etc. Wepons
--]]

function cannonClass(position,speed,gun_rot,lifetime,reload_time,owner,x_offset,y_offset,sprite,random_rot,random_vel,group,proj_size,cost,mass,name,drag,reload_randomness)
	--[[instances of this class represent guns on the ship
	guns act by inserting particles with certan params into the 
	DYNAMIC OBJECTs table when certan conditions are met, ie reload time and fire pressed
	--]]
	local self = ItemBaseClass(cost,mass,name,"equipment",nil,nil,true,false)
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
	self.drag = drag
	self.reload_randomness = reload_randomness or .15
	function self.fire(dt,fireing)
		self.reload = self.reload - dt
		--local fireing = KEYBOARD_STATE.get_fireing()
		local go = (fireing == self.position) or (fireing == 'both')
		if self.reload <= 0 and go then
			if self.reload_randomness*math.random()<dt then
				self.reload = self.reload_time
				local random_r = random_gauss(0,self.random_rot)--random firespeed and angle
				local random_v = random_gauss(0,self.random_vel)
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
										self.proj_size,
										self.drag))--create proj instance
			end
		end
	end
	return self
end

function scatter_guns(owner,group)
	local guns = {}
	local speed = 650
	local left = -math.pi/2
	local right = math.pi/2
	local reload_time = 1.5
	local lifetime = 1
	local sprite = SPRITES.scaterball
	local random_rot = .15
	local random_vel = 80
	local proj_size = 4
	guns = {
		cannonClass("left", speed,left,lifetime,	reload_time,owner,  -5,0,	sprite,random_rot,random_vel,group,proj_size,1000,3, "Small Scattergun", 500),
		cannonClass("left", speed,left,lifetime,	reload_time,owner,	0,0,	sprite,random_rot,random_vel,group,proj_size,1000,3, "Small Scattergun", 500),
		cannonClass("left", speed,left,lifetime,	reload_time,owner,  5,0,	sprite,random_rot,random_vel,group,proj_size,1000,3, "Small Scattergun", 500),
		cannonClass("right",speed,right,lifetime,	reload_time,owner,  -5,0,	sprite,random_rot,random_vel,group,proj_size,1000,3, "Small Scattergun", 500),
		cannonClass("right",speed,right,lifetime,	reload_time,owner,  0,0,	sprite,random_rot,random_vel,group,proj_size,1000,3, "Small Scattergun", 500),
		cannonClass("right",speed,right,lifetime,	reload_time,owner,  5,0,	sprite,random_rot,random_vel,group,proj_size,1000,3, "Small Scattergun", 500),
		cannonClass("left", speed,left,lifetime,	reload_time,owner,  -10,0,	sprite,random_rot,random_vel,group,proj_size,1000,3, "Small Scattergun", 500),
		cannonClass("right",speed,right,lifetime,	reload_time,owner,  -10,0,	sprite,random_rot,random_vel,group,proj_size,1000,3, "Small Scattergun", 500),
		cannonClass("left", speed,left,lifetime,	reload_time,owner,  10,0,	sprite,random_rot,random_vel,group,proj_size,1000,3, "Small Scattergun", 500),
		cannonClass("right",speed,right,lifetime,	reload_time,owner,  10,0,	sprite,random_rot,random_vel,group,proj_size,1000,3, "Small Scattergun", 500),
		cannonClass("left", speed,left,lifetime,	reload_time,owner,  -5,0,	sprite,random_rot,random_vel,group,proj_size,1000,3, "Small Scattergun", 500),
		cannonClass("left", speed,left,lifetime,	reload_time,owner,	0,0,	sprite,random_rot,random_vel,group,proj_size,1000,3, "Small Scattergun", 500),
		cannonClass("left", speed,left,lifetime,	reload_time,owner,  5,0,	sprite,random_rot,random_vel,group,proj_size,1000,3, "Small Scattergun", 500),
		cannonClass("right",speed,right,lifetime,	reload_time,owner,  -5,0,	sprite,random_rot,random_vel,group,proj_size,1000,3, "Small Scattergun", 500),
		cannonClass("right",speed,right,lifetime,	reload_time,owner,  0,0,	sprite,random_rot,random_vel,group,proj_size,1000,3, "Small Scattergun", 500),
		cannonClass("right",speed,right,lifetime,	reload_time,owner,  5,0,	sprite,random_rot,random_vel,group,proj_size,1000,3, "Small Scattergun", 500),
		cannonClass("left", speed,left,lifetime,	reload_time,owner,  -10,0,	sprite,random_rot,random_vel,group,proj_size,1000,3, "Small Scattergun", 500),
		cannonClass("right",speed,right,lifetime,	reload_time,owner,  -10,0,	sprite,random_rot,random_vel,group,proj_size,1000,3, "Small Scattergun", 500),
		cannonClass("left", speed,left,lifetime,	reload_time,owner,  10,0,	sprite,random_rot,random_vel,group,proj_size,1000,3, "Small Scattergun", 500),
		cannonClass("right",speed,right,lifetime,	reload_time,owner,  10,0,	sprite,random_rot,random_vel,group,proj_size,1000,3, "Small Scattergun", 500),
		}
	return guns
end
function basic_guns(owner,group)--returns table of guns with 4 cannons on each side.
	--[[
	has a guns table whith
	guns/somthing with a fire method in it
	Player and Ship . gun tables should be set equal to this table/class's .guns table
	--]]
	local guns = {}
	local speed = 400
	local left = -math.pi/2
	local right = math.pi/2
	local reload_time = 2.5
	local lifetime = 1.5
	local sprite = SPRITES.canonball
	local random_rot = .05
	local random_vel = 30
	local proj_size = 7

	--[[
	the folowing could also be  done with a gun generator, ie

	"function gen(params)
		function make_gun()
			return cannonClass(params)
		end
		return make_gun
	end"
	this would be cleaner/better and should be implimented, NAAA
	]]
	guns = {
		cannonClass("left", speed,left,lifetime,	reload_time,owner,-10,0,sprite,random_rot,random_vel,group,proj_size,1000,6, "Small Cannon"),
		cannonClass("left", speed,left,lifetime,	reload_time,owner,0,0,	sprite,random_rot,random_vel,group,proj_size,1000,6, "Small Cannon"),
		cannonClass("left", speed,left,lifetime,	reload_time,owner,10,0,	sprite,random_rot,random_vel,group,proj_size,1000,6, "Small Cannon"),
		cannonClass("right",speed,right,lifetime,	reload_time,owner,-10,0,sprite,random_rot,random_vel,group,proj_size,1000,6, "Small Cannon"),
		cannonClass("right",speed,right,lifetime,	reload_time,owner,0,0,	sprite,random_rot,random_vel,group,proj_size,1000,6, "Small Cannon"),
		cannonClass("right",speed,right,lifetime,	reload_time,owner,10,0,	sprite,random_rot,random_vel,group,proj_size,1000,6, "Small Cannon"),
		cannonClass("left", speed,left,lifetime,	reload_time,owner,-20,0,sprite,random_rot,random_vel,group,proj_size,1000,6, "Small Cannon"),
		cannonClass("right",speed,right,lifetime,	reload_time,owner,-20,0,sprite,random_rot,random_vel,group,proj_size,1000,6, "Small Cannon"),
		cannonClass("left", speed,left,lifetime,	reload_time,owner,-10,0,sprite,random_rot,random_vel,group,proj_size,1000,6, "Small Cannon"),
		cannonClass("left", speed,left,lifetime,	reload_time,owner,0,0,	sprite,random_rot,random_vel,group,proj_size,1000,6, "Small Cannon"),
		cannonClass("left", speed,left,lifetime,	reload_time,owner,10,0,	sprite,random_rot,random_vel,group,proj_size,1000,6, "Small Cannon"),
		cannonClass("right",speed,right,lifetime,	reload_time,owner,-10,0,sprite,random_rot,random_vel,group,proj_size,1000,6, "Small Cannon"),
		cannonClass("right",speed,right,lifetime,	reload_time,owner,0,0,	sprite,random_rot,random_vel,group,proj_size,1000,6, "Small Cannon"),
		cannonClass("right",speed,right,lifetime,	reload_time,owner,10,0,	sprite,random_rot,random_vel,group,proj_size,1000,6, "Small Cannon"),
		cannonClass("left", speed,left,lifetime,	reload_time,owner,-20,0,sprite,random_rot,random_vel,group,proj_size,1000,6, "Small Cannon"),
		cannonClass("right",speed,right,lifetime,	reload_time,owner,-20,0,sprite,random_rot,random_vel,group,proj_size,1000,6, "Small Cannon"),

		}
	return guns
end