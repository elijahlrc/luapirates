function pause(do_stuff)
	while paused do
		do_stuff()
	end
	love.update(.001)
end