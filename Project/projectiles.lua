function colliding_projectile(lifetime,sprite,group,x,y,rot,vel,size)
	local self = baseClass()
	self.name = "projectile"
	self.sprite = sprite
	self.x = x
	self.y = y
	self.velocity = vel
	self.rotation = rot
	self.lifetime = lifetime
	self.shape = Collider:addRectangle(self.x,self.y,size,size)
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
		print("sdfsdfdsf")
		Collider:remove(self.shape)
		self.dead = true
	end
	return self
end
