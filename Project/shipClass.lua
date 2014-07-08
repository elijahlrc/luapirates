
function makeWreck(ship)
	local wreck = baseShipClass(ship.x,ship.y,ship.sprite,0,0,ship.drag,ship.velocity,ship.rotation,ship.max_health/5,ship.shape,ship.holdsize,ship.max_health)
	wreck.name = "wreck"
	wreck.shape.owner = wreck
	wreck.shape.name = "wreck"
	wreck.faction = "wreck"
	ship.shape = nil
	wreck.inventory = ship.inventory
	wreck.money = ship.money
	return wreck
end
function baseShipClass(x,y,sprite,speed,turn_speed,drag,velocity,rotation,health,shape,holdsize,max_health)
	local self = baseClass()
	function self.init()
		--the folowing if's check if vars are passed into baseShipClass and if not set them to default
		self.bounus = (2.5+math.random())/3
		self.id = makeID()
		self.rotation = rotation or 0
		self.velocity = velocity or {0,0}
		self.max_health = max_health or 100
		self.name = "baseSHipClass"
		self.hp = self.max_health
		self.x = x
		self.y = y
		self.sprite = sprite
		self.speed = speed*self.bounus
		self.turn_speed = turn_speed*self.bounus
		self.drag = drag*self.bounus
		self.cannons = basic_guns(self)
		self.width, self.height = self.sprite:getDimensions( )
		self.money = 100
		self.inventory = {}
		self.holdsize = holdsize
		self.dead = false
		if shape then
			self.shape = shape
			if not self.shape.name then
				error("ship shape given without name, Y U DO THIS!")
			end
		--[[else
			boundingBox = {width = self.sprite:getWidth(),height = self.sprite:getHeight()}
			self.shape = Collider:addRectangle(self.x+1,self.y+1,boundingBox.width-1,boundingBox.height-1)
			self.shape.owner = self --shape containes referance to owner, all interactive shapes must do this
			self.shape.name = "baseShipClass_SHAPE"
			--]]
		end
		
	end
	self.init()


	function self.get_position()
		return self.x,self.y
	end

	function self.get_rotation()
		return self.rotation
	end

	function self.get_sprite()
		return self.sprite
	end

	function self.get_tile_location()
		local tile_x = math.floor(self.x/TILE_SIZE)
		local tile_y = math.floor(self.y/TILE_SIZE)
		return tile_x,tile_y
	end
	function self.move(dt)
		--code for movement overrites this function
		--use turn and accelerate to move
	end
	function self.update(dt)
		self.doMove(dt)
		self.fire_guns(dt)
		if self.hp<0 then
			self.dead = true
			if self.name ~= "wreck" then
				table.insert(SHIPS, makeWreck(self))
			end
		end
	end

	function self.holdSpace()--get space remaining in hold
		local total_mass = 0
		for key,item in pairs(self.inventory) do
			total_mass = total_mass + item[1].mass*item[2]--mass times quantaty
		end
		return self.holdsize - total_mass

	end
	--[[
	following are getters and setters
	addToHold(good, quantaty)
	removeFromHold(good,quantity)
	fire_guns(dt) should be overwriten in generator for whatever ship your generating
	turn(dt,dir) accepts as dir
		"cl" = clockwise
		"cc" = counterclockwise
		"hcl" = half speed clockwise
		"hcc" = half speed counter clockwise
	accelerate(dt,dir) accepts "forward" or "backward" for dir
		
	--]]
	function self.turn(dt,dir) --setter for rotation
		if dir == "cl" then
			self.rotation = self.rotation+self.turn_speed*dt
		elseif dir == "cc" then
			self.rotation = self.rotation-self.turn_speed*dt
		elseif dir == "hcl" then --half speed movement
			self.rotation = self.rotation+self.turn_speed*dt*.5
		elseif dir == "hcc" then
			self.rotation = self.rotation-self.turn_speed*dt*.5
		else 
			error(dir, "not acceptable input to shipClass.turn(dt,dir)")
		end
	end
	function self.accelerate(dt,dir)--setter for velocity
		if dir == "forward" then
			self.velocity = add_vectors(self.velocity[1] , self.velocity[2] ,self.speed*dt   , self.rotation)
		elseif dir == "backward" then 
			self.velocity = add_vectors(self.velocity[1] , self.velocity[2] ,self.speed*-.75*dt, self.rotation)
		else
			error(dir, "not acceptable input to shipClass.accelerate(dt,dir)")
		end
	end
	function self.addToHold(good,quantity)--add instances of the item class to hold
		--[[
		TODO: add items to equipment list/pasive bounus list based on there type
		--]]
		local quantity = quantity or 1
		if good.mass*quantity <= self.holdSpace() then--if space
			local name = good.name
			local found = false
			for i,val in pairs(self.inventory) do
				if val[1].name == name and found ~= true then
					val[2] = val[2]+quantity
					return val[2]
				end
			end
			table.insert(self.inventory, {good,quantity})
			return quantity
		else
			return false--if not enough space return false to signify that adding to hold failed
		end
	end
	function self.removeFromHold(good,quantity)--remove instances of the item class from hold
		--[[
		TODO: Remove items from equipment list/pasive bounus list based on there type
		--]]
		quantity = quantity or 1
		local name = good.name
		for i,val in pairs(self.inventory) do
			if val[1].name == name and val[2]>= quantity then
				val[2] = val[2]-quantity
				if val[2] == 0 then
					self.inventory[i] = nil
					return 0 --if there is nothing left after removal return 0
				end
				return self.inventory[i][2]--other wise return the # left
			end
		end
		return false --if the thing was not in the inventoy return false to signify that removal failed
	end
	function self.toggle_equipt(index)
		print(self.inventory[index][1].equipped)
		self.inventory[index][1].equipped = not self.inventory[index][1].equipped
		print(self.inventory[index][1].equipped)
		self.reCalculateStats()

	end
	function self.reCalculateStats()
		self.cannons = {}
		for i,obj in pairs(self.inventory) do
			if obj[1].type == "equipment" and obj[1].active == true and obj[1].equipped == true then
				table.insert(self.cannons,obj[1])
			end
		end
	end
	function self.fire_guns(dt) --overwrite me
		--code for when to fire wepons and which to fire goes here, overwrite this function in the
		--obj that is fireing, ie player, or test_enemy
	end
	function self.doMove(dt)--the nuts and bolts of moving, should be the same on all ships
		local turn_factor = 2 --affects how much of your momentum you keep when you turn
		local drag_factor = 10
		self.move(dt)
		self.dragForce = {}
		dA = math.min(math.abs(shortAng(self.rotation,self.velocity[2])),math.abs(shortAng(self.rotation+math.pi,self.velocity[2])))
		self.dragForce[1] = -1*self.velocity[1]*(1+drag_factor*dA)*self.drag*dt
		self.dragForce[2] = 1*self.velocity[2]
		self.velocity = add_vectors(self.velocity[1],self.velocity[2],self.velocity[1]*turn_factor*dA*dt,self.rotation)

		self.velocity = add_vectors(self.velocity[1],self.velocity[2],self.dragForce[1],self.dragForce[2])
		self.x = self.x + math.cos(self.velocity[2])*(self.velocity[1]*dt)
		self.y = self.y + math.sin(self.velocity[2])*(self.velocity[1]*dt)
		self.shape:moveTo(self.x,self.y)
		self.shape:setRotation(self.rotation)
	end




		--[[if (self.rotation+math.pi/2)%(2*math.pi)-get_direction(self.x,self.y,x,y)<0 then
				self.rotation = self.rotation+self.turn_speed*dt
		elseif (self.rotation-math.pi/2)%(2*math.pi)-get_direction(self.x,self.y,x,y)<0 then
			self.rotation = self.rotation-self.turn_speed*dt
		end--]]
	
	function self.handle_collisions(dt,othershape,dx,dy)
		--[[
		if othershape is a obj which should damage ship (wepons, etc)
		the code for that should prob go here. Aditionaly docking in ports
		picking up loot, etc might go here.
		--]]
		if self.name == "player" then
			print(othershape.name)
		end
		if othershape.name == "terrain_collider" then
			--self.x = self.x+dx
			--self.y = self.y+dy
			if self.velocity[1] > 20 then
				self.hp = self.hp - distance(0,0,dx,dy)
			end
			local vel_x = dx/dt
			local vel_y = dy/dt
			local vec = {distance(0,0,vel_x,vel_y)*.25,get_direction(0,0,vel_x,vel_y)}
			self.velocity = add_vectors(self.velocity[1],self.velocity[2],vec[1],vec[2])

		elseif othershape.name == "projectile" then
			self.hp = self.hp-10
		elseif othershape.name == "npc_ship" then --needs code for raming
			if self.velocity[1] > 20 then--but wat if the other ship is moving, needs to be fixed but not yet, relitivly low priority
				self.hp = self.hp - distance(0,0,dx,dy)
			end
			local vel_x = dx/dt
			local vel_y = dy/dt
			local vec = {distance(0,0,vel_x,vel_y)*.25,get_direction(0,0,vel_x,vel_y)}
			self.velocity = add_vectors(self.velocity[1],self.velocity[2],vec[1],vec[2])

		elseif othershape.owner.name == "wreck" then
			if self.velocity[1] > 20 then
				self.hp = self.hp - distance(0,0,dx,dy)
			end
			local vel_x = dx/dt
			local vel_y = dy/dt
			self.x = self.x+dx*5
			self.y = self.y+dy*5
			local vec = {distance(0,0,vel_x,vel_y)*.25,get_direction(0,0,vel_x,vel_y)}
			self.velocity = add_vectors(self.velocity[1],self.velocity[2],vec[1],vec[2])
			if self.name == "player" then
				self.velocity[1] = 0
				loot_screen(othershape.owner)
			end
		elseif othershape.owner.name == "town" then 
			self.hp = self.hp - distance(0,0,dx,dy)
			self.velocity[1] = 0
			self.x = self.x+dx*5
			self.y = self.y+dy*5
			if self.name == "player" then
				portMenu(othershape.owner)
			end
		end
	end
	return self
end

