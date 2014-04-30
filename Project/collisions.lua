function instantiate_colisions ()
	Collider = HC(100,on_collision)
	--need to instantiate obj for both player ship and land
end
function update_collisions(dt)
	Collider:update(dt)
	-- not sure what else goes here
end
function on_collision(dt, shape_1, shape_2, dx, dy)
	--[[
	------------------
	ALL OBJECTS WHICH ARE HANDLED BY Collider MUST HAVE 
	A "handle_collisions" Method!!!

	I am using a data-driven colision handeling method, that is,
	the obj coliding handel there own colisions. Thats why
	they must have a "handle_colisions" method
	------------------
	--]]

	shape_1.handle_collisions(dt,shape_2,dx,dy)
end
