function projectile_base_class(sprite,name,rotation,velocity,x_pos,y_pos,lifespan) --feel free to add more things
	self = baseClass()
	self.velocity = velocity
	self.rotation = rotation
	self.x = x_pos
	self.y = y_pos
	self.sprite = sprite
	self.name = name
	self.lifespan = lifespan
	function self.update(dt)
		self.x = self.x + self.velocity*dt*math.cos(self.rotation)
		self.y = self.y + self.velocity*dt*math.sin(self.rotation)
		self.lifespan = self.lifespan - dt
		if self.lifespan <= 0 then
			self = nil
		end
	end
	return self
end

function cannonball_projectile(velocity,x_pos,y_pos,rotation,lifespan,player_fired)
	self = projectile_base_class(SPRITES.canonball, "cannonball_projectile", rotation,velocity, x_pos,y_pos, lifespan)
	self.shape = Collider:addRectangle(self.x,self.y,5,5)
	if player_fired then
		Collider:addToGroup("player",self.shape)--makes cannonballs not colide with player
	end
	function self.handle_collisions(dt,othershape,dx,dy)
		--if othershape.name == "PlaYA" then
		--	self = nil
	end
	return self
end
