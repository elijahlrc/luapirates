function Weather(speed,light,direction)

	local self = {}
	self.speed = speed
	self.light = light
	self.direction = direction

	function self.update_light(dt)
		if self.direction == "up" then

			self.light = self.light+self.speed*dt
			if self.light >= 255 then
				self.light = 255
				self.direction = "down"
			end

		else
			
			self.light = self.light-self.speed*dt
			if self.light < 0 then
				self.light = 0
				self.direction = "up"
			end

		end

	end

	function self.draw_weather()
		love.graphics.setColor(5,5,10,self.light)
		love.graphics.rectangle("fill",0,0,WINDOW_WIDTH,WINDOW_HEIGHT)
		love.graphics.setColor(255,255,255,255)

	end

	return self

end