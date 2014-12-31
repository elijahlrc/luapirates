--[[
file for projectile genreators, etc. Wepons
--]]

function cannonClass(speed,lifetime,reload_time,sprite,random_rot,random_vel,proj_size,cost,mass,name,drag,reload_randomness)
	--[[instances of this class represent guns on the ship
	guns act by inserting particles with certan params into the 
	DYNAMIC OBJECTs table when certan conditions are met, ie reload time and fire pressedt
	--]]
	local self = ItemBaseClass(cost,mass,name,"equipment",nil,nil,true,false)
	self.position = position
	self.reload_time = reload_time
	self.speed = speed
	self.lifetime = lifetime
	self.reload = 0
	self.sprite = sprite
	self.random_rot = random_rot
	self.random_vel = random_vel
	self.group = group
	--[[self.owner = ownr
	oh noze, cannons, and all tables that contain them can no longer be copied.
	solution is to make owner a private var
	--]]
	local owner
	--[[need more of these everywhere
	local vars are good, some of above vars could be local?
	--]]
	self.proj_size = proj_size
	self.drag = drag or 0
	self.reload_randomness = reload_randomness or .15
	function self.set_owner(new_owner)
		owner = new_owner
	end
	function self.set_slot(new_slot) --equipment type obj must have set_slot()
		if new_slot then
			self.set_loc(new_slot.x,new_slot.y)
			self.position = new_slot.position --slots must have position set to left or right
			self.rotation = new_slot.rotation
		else
			self.set_loc(nil,nil)
			self.position = nil
			self.rotation = nil
		end
	end
	function self.set_group(new_group)
		self.group = new_group
	end
	function self.set_loc(x_loc,y_loc)
		self.x = x_loc
		self.y = y_loc
	end
	function self.fire(dt,fireing)--before this is called an owner and a slot must be set.
		self.reload = self.reload - dt
		--local fireing = KEYBOARD_STATE.get_fireing()
		local go = (fireing == self.position) or (fireing == 'both')
		if self.reload <= 0 and go then
			if self.reload_randomness*math.random()<dt then
				self.reload = self.reload_time
				local random_r = random_gauss(0,self.random_rot)--random firespeed and angle
				local random_v = random_gauss(0,self.random_vel)
				local rot = owner.get_rotation()
				local x_off = math.cos(rot)*self.x +math.cos(rot)*self.y--these 2 lines calculate position of gun based on owner rotation
				local y_off = math.sin(rot)*self.y+math.sin(rot)*self.x
				local vec = add_vectors(self.speed,rot+self.rotation, owner.velocity[1], owner.velocity[2])--these vec lines add player velocity and gun velocity
				table.insert(PROJECTILES,
					colliding_projectile(self.lifetime,
										self.sprite,
										self.group,
										owner.x+x_off,
										owner.y+y_off,
										vec[2]+random_r,
										vec[1]+random_v,
										self.proj_size,
										self.drag))--create proj instance
			end
		end
	end
	return self
end
local function make_cannons(speed,lifetime,reload_time,sprite,random_rot,random_vel,proj_size,value,mass,name,drag,reload_randomness)
	local self = baseClass()
	self.position = position
	self.sprite = sprite
	self.reload_randomness = reload_randomness or .15
	self.name = name
	self.mass = mass
	self.value = value--must be named current price even though it is static
	
	function self.make()
		print ("made a cannon")
		local cannon = cannonClass(speed,lifetime,reload_time,sprite,random_rot,random_vel,proj_size,cost,mass,name,drag,reload_randomness)
		return cannon
	end
	return self
end
small_cannon = make_cannons(400,1.5,2,SPRITES.canonball, math.pi/32,25,7,1000,3,"small cannon",0,.3)
scater_gun = make_cannons(600,.75,1.5,SPRITES.scaterball, math.pi/16,100,5,1000,2,"scater gun",300,.3)

table.insert(EQUIPMENT,small_cannon)
table.insert(EQUIPMENT,scater_gun)

