function baseClass()
	--[[
	base class has no real point at this time
	could be usefull later (except providing error handeling for handle_collisions)

	]]
	local self = {}
	self.name = "BASE_CLASS_NAME"
	--local private_value = "no one can see me!"

	--function self.foo() --this returns a private value
	--	return private_value
	
	function self.handle_collisions(dt,shape2,dx,dy)
		error("attempted to collide a class with no handle_collisions method")
	end
	return self
end
