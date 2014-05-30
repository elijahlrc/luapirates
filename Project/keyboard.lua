function Keyboard(queue,direction,rotation)
	--[[
	I need a docstring too
	--]]
	local self = {}

	self.queue = queue
	self.direction = direction
	self.rotation = rotation
	
	function self.remove_key(key)
		for i=1,#self.queue do
			if self.queue[i] == key then
				table.remove(self.queue,i)
			end
		end
	end

	function self.add_key(key)
		table.insert(self.queue,key)
	end

	function self.get_direction()
		self.direction = nil
		for i=#self.queue,1,-1 do
			if self.queue[i] == 'w' then
				return "forward"
			elseif self.queue[i] == 's' then
				return 'backward'
			end
		end
		return self.direction
	end

	function self.get_rotation()
		self.rotation = nil
		for i=#self.queue,1,-1 do
			if self.queue[i] == 'd' then
				return "clockwise"
			elseif self.queue[i] == 'a' then
				return 'counterclockwise'
			end
		end
		return self.rotation
	end
	function self.get_fireing()
		local left
		local right
		for i=#self.queue,1,-1 do
			if self.queue[i] == 'q' then
				left = true
			elseif self.queue[i] == 'e' then
				right = true
			end
		end
		if left and right then
			return 'both'
		elseif left then
			return 'left'
		elseif right then
			return 'right'
		else
			return false
		end

	end
	
	function self.get_queue()
		return self.queue
	end

	return self

end