
function makeWreck(ship)
	local wreck = baseShipClass(ship.x,ship.y,ship.velocity,ship.rotation)
	wreck.set_ship(ship.get_ship())
	wreck = wreck_behavior(wreck,"wreck")
	wreck.name = "wreck"
	wreck.shape.owner = wreck
	wreck.shape.name = "wreck"
	wreck.faction = "wreck"
	ship.shape = nil
	wreck.money = ship.money
	return wreck
end

startingShip = {
	holdsize = 100,
	max_health = 100,
	hp = 100,
	speed = 100,
	turn_speed = PLAYER_TURN_SPEED,
	sprite = SPRITES.ship,
	width= SPRITES.ship:getWidth(),
	height = SPRITES.ship:getHeight(),
	drag = .3,
	inventory = {},
	cannons = {},
	slots = { 
		{	x = 10,
			y = 0,
			ocupied = false,
			position = "left",
			rotation = math.pi/2},
		{	x = 0,
			y = 0,
			ocupied = false,
			position = "left",
			rotation = math.pi/2},
		{	x = -10,
			y = 0,
			ocupied = false,
			position = "left",
			rotation = math.pi/2},
		{	x = 0,
			y = 0,
			ocupied = false,
			position = "right",
			rotation = -1*math.pi/2},
		{	x = -10,
			y = 0,
			ocupied = false,
			position = "right",
			rotation = -1*math.pi/2},
		{	x = 10,
			y = 0,
			ocupied = false,
			position = "right",
			rotation = -1*math.pi/2},-----------------
		{	x = 5,
			y = 0,
			ocupied = false,
			position = "left",
			rotation = math.pi/2},
		{	x = 15,
			y = 0,
			ocupied = false,
			position = "left",
			rotation = math.pi/2},
		{	x = -5,
			y = 0,
			ocupied = false,
			position = "left",
			rotation = math.pi/2},
		{	x = 15,
			y = 0,
			ocupied = false,
			position = "right",
			rotation = -1*math.pi/2},
		{	x = -5,
			y = 0,
			ocupied = false,
			position = "right",
			rotation = -1*math.pi/2},
		{	x = 5,
			y = 0,
			ocupied = false,
			position = "right",
			rotation = -1*math.pi/2}
	}
}
mediumCargoShip = {
	holdsize = 1000,
	max_health = 250,
	hp = 250,
	speed = 50,
	turn_speed = PLAYER_TURN_SPEED*.5,
	sprite = SPRITES.cargo_ship,
	width= SPRITES.cargo_ship:getWidth(),
	height = SPRITES.cargo_ship:getHeight(),
	drag = .3,
	inventory = {},
	cannons = {},
	slots = { 
		{	x = 20,
			y = 0,
			ocupied = false,
			position = "left",
			rotation = math.pi/2},
		{	x = 0,
			y = 0,
			ocupied = false,
			position = "left",
			rotation = math.pi/2},
		{	x = -20,
			y = 0,
			ocupied = false,
			position = "left",
			rotation = math.pi/2},
		{	x = 0,
			y = 0,
			ocupied = false,
			position = "right",
			rotation = -1*math.pi/2},
		{	x = -20,
			y = 0,
			ocupied = false,
			position = "right",
			rotation = -1*math.pi/2},
		{	x = 20,
			y = 0,
			ocupied = false,
			position = "right",
			rotation = -1*math.pi/2}
	}
}
function baseShipClass(x,y,velocity,rotation)
	--[[
	self.move, 
	self.ship_specific_update, 
	self.fire_guns, and
	self.move should be overwriten by calling 
	self.set_ship and 
	self.set_behavior
	--]]

	--------------------------------init--------------------------------
	local self = baseClass()
	self.id = makeID()
	self.rotation = rotation or 0
	self.velocity = velocity or {0,0}
	self.name = "baseSHipClass"
	self.x = x
	self.y = y
	self.dead = false

----------------------------function defs--------------------------
	function self.set_ship(ship)
		for key,val in pairs(coppyTable(ship)) do 
			--next 3 lines only necisary if ship table is not a coppy
			--if type(val) == "table" then
			--	self[key] = 
			--else
			self[key] = val
		end
		self.shape = Collider:addPolygon(self.x,self.y+(self.height)/2, --dimond shape
			self.x+(self.width)/2,self.y, 
			self.x+(self.width), self.y+(self.height)/2, 
			self.x+(self.width)/2,self.y+(self.height))
		self.shape.owner = self
		Collider:addToGroup(tostring(self.id),self.shape)--id so that does not colide with own canons, etc
	end
	function self.get_ship()
		local new_ship = {
          		holdsize = self.holdsize,
		max_health = self.max_health,
		hp = self.hp,
		speed = self.speed,
		turn_speed = self.turn_speed,
		sprite = self.sprite,
		width= self.width,
		height = self.height,
		drag = self.drag,
		inventory = coppyTable(self.inventory),
		cannons = coppyTable(self.cannons),
		slots = coppyTable(self.slots)
		}
		return new_ship
	end
	function self.set_behavior(behavior)
		for key,val in pairs(behavior) do
			self[key] = val
		end
	end
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
		--use "turn" and "accelerate" to move
	end
	function self.update(dt)
		self.ship_specific_update(dt)
		self.doMove(dt)
		self.fire_guns(dt)
		if self.hp<0 then
			self.dead = true
			if self.name ~= "wreck" then
				table.insert(SHIPS, makeWreck(self))
			end
		end
	end
	function ship_specific_update(dt)
		--overwrite me in specific ships
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
	function self.getInventory()
		local return_list = {}
		for index,value in pairs(self.inventory) do
			print(value[1].name)
			return_list[index] = {coppyTable(value[1]),value[2]}
		end
		return return_list
	end
	function self.addToHold(good,quantity)--add instances of the item class to hold
		local quantity = quantity or 1
		local gd = good.make()
		if gd.mass*quantity <= self.holdSpace() then--if space
			local name = gd.name
			local found = false
			if gd.obj_type == "tradegood" then
				--local gd = good.make()
				for i,val in pairs(self.inventory) do
					if val[1].name == name and found ~= true then
						found = true
						val[2] = val[2]+quantity
						return val[2]
					end
				end
				if not found then
					table.insert(self.inventory,{gd,quantity})
				end
			else
				for i = 1,quantity do
					local gd = good.make()
					gd.set_owner(self)
					gd.set_group(tostring(self.id))
					table.insert(self.inventory, {gd,1})

				end
			end
			return quantity
		else
			return false--if not enough space return false to signify that adding to hold failed
		end
	end
	function self.removeFromHold(good,quantity)--remove instances of the item class from hold
		--[[
		TODO: Remove items from equipment list/pasive bounus list based on there type
		--]]
		local quantity = quantity or 1
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

	function self.amountInHold(good) --returns how many units of the item are in the hold
		local name = good.name
		for i,val in pairs(self.inventory) do
			if val[1].name == name then
				return val[2]
			end
		end
		return 0
	end

	function self.equip(slot,object)--can only equip equipment type items
		assert(object.obj_type == "equipment")
		if slot.ocupied == false then
			object.equipped = true
			object.set_slot(slot)
			slot.ocupied = object
			self.reCalculateStats()
			return
		else
			return false
		end
	end
	function self.equipAll()
		local invIndex = 1
		if #self.inventory>=1 then
			for i,slot in pairs(self.slots) do
				if not slot.occupied then
					while  (invIndex <= #self.inventory) and (not self.inventory[invIndex][1].obj_type == "equipment") do
						invIndex = invIndex+1
					end
					if invIndex <= #self.inventory then
						self.equip(slot,self.inventory[invIndex][1])
						invIndex = invIndex + 1
					end
				end
			end
		end
	end
					

	function self.unequip(slot)
		if slot.occuped then
			slot.ocupied.equipped = false --set equipment as unequiped
			slot.ocupied.slot = nil
			slot.ocupied.set_slot()--set equipments slot to nil
			slot.ocupied = false
			self.reCalculateStats()
		end
	end
	function self.reCalculateStats()--redo to understand slots
		self.cannons = {}
		for i,slot in pairs(self.slots) do
			if slot.ocupied then
				table.insert(self.cannons,slot.ocupied)
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
			--print(othershape.name)
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


function make_pirate_ship(x,y)
	local shp = npc_ship(x,y,{0,0},0)
	shp.set_ship(startingShip)
	shp = pirate_behavior(shp,"pirate")
	shp.shape.name = "npc_ship"
	shp.name = "pirate"
	local gun_gen
	if math.random()>.99 then
		gun_gen = small_cannon
	else
		gun_gen = scater_gun
	end
	shp.addToHold (gun_gen,10)
	shp.equipAll()
	return shp
end

function make_cargo_ship(x,y)
	local shp = npc_ship(x,y,{0,0},0)
	shp.set_ship(mediumCargoShip)
	shp = trade_behavior (shp,"trader")
	shp.shape.name = "npc_ship"
	shp.name = "cargo"
	local gun_gen
	if math.random()>.2 then
		gun_gen = small_cannon
	elseif math.random()>.2 then
		gun_gen = scater_gun
	else
		return shp
	end
	shp.addToHold (gun_gen,5)
	--[[for key,val in pairs(shp) do
		print (key)
		print(val)
	end
	--]]
	shp.equipAll()
	return shp
end

function npc_ship(x,y,velocity,rotation)--defines a bunch of functions neccicary for ai, still needs behavior and ship to be set using set_behavior() and set_ship()
	local self = baseShipClass(x,y,velocity,rotation)
	self.goal = {}
	self.target = {}
	function self.get_average_gun_speed()
		local total_speed = 0
		for _, cannon in pairs(self.cannons) do
			total_speed	 = total_speed+cannon.speed
		end
		return total_speed/(#self.cannons)
	end
	function self.get_average_gun_range()
		local total_range = 0
		for _,cannon in pairs(self.cannons) do
			total_range = total_range + (cannon.speed * cannon.lifetime * .5)
		end
		return total_range/#self.cannons
	end

	function self.hit(shape)
		if shape.name == "terrain_collider" or shape.name == "playershape" or shape.owner.name == "wreck" or (shape.name == "npc_ship" and shape.owner.id ~= self.id) then
			return true
		else
			return false
		end
	end
	function self.checkfront(size,ang)
		local directions = {(self.rotation-ang) , (self.rotation), (self.rotation+ang)}
		local offset = 	{
						{-1*math.cos(self.rotation+math.pi/2)*self.height,-1*math.sin(self.rotation+math.pi/2)*self.height},
						{0,0},
						{math.cos(self.rotation+math.pi/2)*self.height,math.sin(self.rotation+math.pi/2)*self.height}
						}
		local results = {}
		for i=1, #directions do
			local result = self.raycast(self.x+offset[i][1],self.y+offset[i][2],directions[i],size)
			table.insert(results, result)
		end
		return results
	end
	function self.raycast(x,y,dir,size)--need to be redone
		local step = 10
		local dx = math.cos(dir)*step
		local dy = math.sin(dir)*step
		local x_pos = 0
		local y_pos = 0
		local shapes
		for i = 0, round(size/step) do
			shapes = Collider:shapesAt(round(x+x_pos),round(y_pos+y))
			for _,shape in pairs(shapes) do
				if self.hit(shape) then
					--table.insert(self.line_directions, {dir, x, y, i*step})
					return i*step
				end
			end
			x_pos = x_pos+dx
			y_pos = y_pos+dy
		end
		--table.insert(self.line_directions, {dir, x, y, false})
		return false
	end

	function self.turnToBroadside(dt)
		if math.abs(shortAng(self.rotation+math.pi*.5,self.dirToPlayer)) < (math.pi*.5) then
			self.turn(dt,shortestAngleDir(self.rotation + math.pi*.5 , self.dirToPlayer))
		else
			self.turn(dt,shortestAngleDir(self.rotation - math.pi*.5 , self.dirToPlayer))
		end
	end
	function self.avoid_colisions(dt,range)--returns true if it did something, false if no rays hit.
		local ang = math.pi/32
		local rays = self.checkfront(range,ang)
		local left_ray = rays[1]
		local middle_ray = rays[2]
		local right_ray = rays[3]
		if middle_ray or right_ray or left_ray then
			while right_ray and left_ray and ang < math.pi do
				ang = ang+math.pi/32
				rays = self.checkfront(range,ang)
				left_ray = rays[1]
				middle_ray = rays[2]
				right_ray = rays[3]
			end
			if left_ray == false then
				self.turn(dt,"cc")
			elseif right_ray == false then
				self.turn(dt,"cl")
			elseif ang>=math.pi then
				if left_ray<right_ray then
					self.turn(dt,"cl")
				else
					self.turn(dt,"cc")
				end
			end
			if not middle_ray or middle_ray>300 then
				self.accelerate(dt,"forward")
			elseif middle_ray<100 then
				self.accelerate(dt,"backward")
			end
			return true
		else
			return false
		end
	end
	return self
end
