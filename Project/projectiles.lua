function projectile_base_class(sprite,name,rotation,velocity,x_pos,y_pos,lifespan) --feel free to add more things
	self = baseClass()
	self.name = "projectile_base_class"
	self.velocity = velocity
	self.rotation = rotation
	self.x = x_pos
	self.y = y_pos
	self.sprite = sprite
	self.name = name
	self.lifespan = lifespan
	function self.update(dt)
		self.check = self.check-dt
		self.x = self.x + self.velocity*dt*math.cos(self.rotation)
		self.y = self.y + self.velocity*dt*math.sin(self.rotation)
		self.lifespan = self.lifespan - dt
		if self.lifespan <= 0 then
			self.dead = true
		end
	end
	return self
end

function cannonball_projectile(velocity,x_pos,y_pos,rotation,lifespan,player_fired)
	local self = projectile_base_class(SPRITES.canonball, "cannonball_projectile", rotation,velocity, x_pos,y_pos, lifespan)
	self.shape = Collider:addRectangle(self.x,self.y,5,5)
	self.shape.owner = self
	if player_fired then
		Collider:addToGroup("player",self.shape)--makes cannonballs not colide with player
	end
	function self.update(dt)
		self.x = self.x + self.velocity*dt*math.cos(self.rotation)
		self.y = self.y + self.velocity*dt*math.sin(self.rotation)
		self.lifespan = self.lifespan - dt
		self.shape:moveTo(self.x,self.y)
		if self.lifespan <= 0 then
			Collider:remove(self.shape)
			self.dead = true
		end

	end
	function self.handle_collisions(dt,othershape,dx,dy)
		Collider:remove(self.shape)
		self.dead = true
	end
	return self
end

function player_cannonball(x,y,lifespan,player_fired,random_v,random_r)
	function ball(speed,dir)
		local rand_v = math.random()*random_v-(random_v/2)
		local rand_r = math.random()*random_r-(random_r/2)
		self = cannonball_projectile(speed+rand_v,x,y,dir+rand_r,lifespan,player_fired)
		return self
	end
	return ball
end
