function colliding_projectile(lifetime,sprite,group,x,y,rot,vel,size,drag)
	--[[This class handles the projectiles themselves
	Instances of it can and should be added to the projectiles objects table
	--]]
	local self = baseClass()
	self.name = "projectile"
	self.sprite = sprite
	self.width, self.height = self.sprite:getDimensions( )
	self.x = x
	self.y = y
	self.velocity = vel
	self.rotation = rot
	self.lifetime = lifetime
	self.drag = drag--optional parameter
	self.shape = Collider:addRectangle(self.x,self.y,self.width,self.height)--does not yet suport projectile rotation, if you want this feture
																--impliment it
	self.shape.owner = self
	self.group = group
	Collider:addToGroup(self.group,self.shape)--makes cannonballs not colide with there fire-er
	Collider:addToGroup("projectile",self.shape)
	self.shape.name = self.name
	function self.update(dt)
		self.x = self.x + self.velocity*dt*math.cos(self.rotation)
		self.y = self.y + self.velocity*dt*math.sin(self.rotation)
		self.lifetime = self.lifetime - dt
		self.shape:moveTo(self.x,self.y)
		if self.drag then
			self.velocity = self.velocity - self.drag*dt
		end
		if self.lifetime <= 0 then
			Collider:remove(self.shape)
			self.dead = true
		end

	end
	function self.handle_collisions(dt,othershape,dx,dy)
		self.dead = true
	end
	return self
end
