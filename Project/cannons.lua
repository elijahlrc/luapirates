function projectile_base_class(sprite,name,x_vel,y_vel,x_pos,y_pos,lifespan) --feel free to add more things
	self = baseClass()
	self.x_velocity = x_vel
	self.y_velocity = y_vel
	self.x_position = x_pos
	self.y_position = y_pos
	self.sprite = sprite
	self.name = name
	self.lifespan = lifespan
	function self.update(dt)
		self.x_position = self.x_position + self.x_velocity*dt
		self.y_position = self.y_position + self.y_velocity*dt
		self.lifespan = self.lifespan - dt
		if self.lifespan <= 0 then
			self = nil
		end
	end
	return self
end

function cannonball_projectile(x_vel,y_vel,x_pos,y_pos,lifespan,player_fired)
	self = projectile_base_class(SPRITES.canonball, "cannonball_projectile", x_vel,y_vel, x_pos,y_pos, lifespan)
	self.shape = Collider:addRectangle(self.x_position,self.y_position,5,5)
	if player_fired then
		Collider:addToGroup("player",self.shape)--makes cannonballs not colide with player
	end
	function self.handle_collisions(dt,othershape,dx,dy)
		--if othershape.name == "PlaYA" then
		--	self = nil
	end
	return self
end
