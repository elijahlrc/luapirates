function pauseMenu()
	local frame = loveframes.Create("frame")
	frame:Center()
	frame:SetState("pausemenu")
	frame:ShowCloseButton(false)
	frame:MakeTop()
	frame:SetDraggable(false)
	local width = 200
	local height = 300
	frame:SetSize(width,height)

	local resume = loveframes.Create("button",frame)
	resume:SetText("Resume")
	resume:CenterX()
	resume:SetY(40)
	resume.OnClick = function(object)
		paused = false
		loveframes.SetState("none")
	end

	local exit = loveframes.Create("button",frame)
	exit:CenterX()
	exit:SetY(70)
	exit:SetText("Exit")
	exit.OnClick = function(object)
		love.event.quit()
	end

end



function inventory(items)
	paused = true
	local frame = loveframes.Create("frame")
	frame:SetName("")
	frame:ShowCloseButton(false)
	frame:MakeTop()
	frame:SetDraggable(false)
	local width = 800
	local height = 650
	frame:SetSize(width,height)
	frame:SetPos(WINDOW_WIDTH/2-width/2,WINDOW_HEIGHT/2-height/2,false)
	local listWidth = width-100
	local listHeight = height-200
	local form = loveframes.Create("form",frame)
	form:SetY(50)
	form:SetSize(listWidth,30)
	form:CenterX()
	form:SetName("")
	form:SetLayoutType("horizontal")
	

	local image = loveframes.Create("text")
	image:SetWidth(50)
	image:SetText("")
	form:AddItem(image)
		
	local name = loveframes.Create("text")
	name:SetWidth(200)
	name:SetText("Name:")
	form:AddItem(name)

	local number = loveframes.Create("text")
	number:SetWidth(50)
	number:SetText("Quantity:")
	form:AddItem(number)

	local mass = loveframes.Create("text")
	mass:SetWidth(50)
	mass:SetText("Mass:")
	form:AddItem(mass)

	local used = loveframes.Create("text")
	used:SetText("Equiped?")
	used:SetWidth(100)
	form:AddItem(used)
	

	local exit = loveframes.Create("button",frame)
	exit:CenterX()
	exit:SetY(height-40)
	exit:SetText("Exit")
	exit.OnClick = function(object)
		paused = false
		frame:Remove()
	end
	iList = loveframes.Create("list",frame)
	iList:SetSize(listWidth,listHeight)
	iList:CenterX()
	iList:SetY(100)

	for _, item in pairs(items) do
		local form = loveframes.Create("form")
		form:SetName("")
		form:SetSize(listWidth,30)
		form:SetLayoutType("horizontal")
		local image = loveframes.Create("image")
		print(type(item))
		print(type(item[1]))
		for i,j in pairs(item[1]) do
			print(i,j)
		end
		image:SetImage(item[1].icon)
		image_x,image_y = image:GetImageSize()
		image:SetScale(30/image_x,30/image_y)
		image:SetSize(50,30)
		form:AddItem(image)
		
		local name = loveframes.Create("text")
		name:SetWidth(200)
		name:SetText(item[1].name)
		form:AddItem(name)

		local number = loveframes.Create("text")
		number:SetWidth(50)
		number:SetText(item[2])
		form:AddItem(number)

		local mass = loveframes.Create("text")
		mass:SetWidth(50)
		mass:SetText(item[1].mass)
		form:AddItem(mass)

		if item[1].type == "equipment" then
			local used = loveframes.Create("text")
			if item[1].equipped then
				used:SetText("Equipped")
			else
				used:SetText("Unequipped")
			end
			used:SetWidth(100)
			form:AddItem(used)
		end
		iList:AddItem(form)
	end
end
			
function portMenu(port)
	paused = true
	local frame = loveframes.Create("frame")
	frame:SetName("")
	frame:ShowCloseButton(false)
	frame:MakeTop()
	frame:SetDraggable(false)
	local width = 800
	local height = 650
	frame:SetSize(width,height)
	frame:SetPos(WINDOW_WIDTH/2-width/2,WINDOW_HEIGHT/2-height/2,false)--had to manualy center, dont know why
	
	local exit = loveframes.Create("button",frame)
	exit:CenterX()
	exit:SetY(height-40)
	exit:SetText("Exit")
	exit.OnClick = function(object)
		paused = false
		frame:Remove()
	end

	function buyButton(good,price)
		local button = loveframes.Create("button")
		button:SetText("Buy")
		button.OnClick = function(object,x,y)
			if PLAYER.money >= price then
				PLAYER.money = PLAYER.money-price
				PLAYER.addToHold(good,1)
			end
		end
		return button
	end
	function sellButton(good,price)
		local button = loveframes.Create("button")
		button:SetText("Sell")
		button.OnClick = function(object,x,y)
			if PLAYER.removeFromHold(good,1) ~= false then
				PLAYER.money = PLAYER.money+price
			end
		end
		return button
	end
	
	local goods = loveframes.Create("grid",frame)
	goods:SetPos(10,100)
	goods:SetSize(780,450)
	goods:SetColumns(#port.goods+1)
	goods:SetRows(5)
	goods:SetCellWidth(60)
	goods:SetCellHeight(20)
	local item = loveframes.Create("text")
	item:SetText("Item:")
	item:SetWidth(60)
	local sellprice =loveframes.Create("text")
	sellprice:SetText("Sell Price:")
	sellprice:SetWidth(60)
	local buyprice = loveframes.Create("text")
	buyprice:SetText("Buy Price:")
	buyprice:SetWidth(60)
	local buy = loveframes.Create("text")
	buy:SetText("Buy:")
	buy:SetWidth(60)
	local sell = loveframes.Create("text")
	sell:SetText("Sell:")
	sell:SetWidth(60)
	goods:AddItem(item      ,1,1)
	goods:AddItem(sellprice ,1,2)
	goods:AddItem(buyprice  ,1,3)
	goods:AddItem(buy       ,1,4)
	goods:AddItem(sell      ,1,5)
	local column = 1
	for key,good in pairs(port.goods) do
		column = column+1
		--row = loveframes.Create("form")
		--row:SetLayoutType("horizontal")
		local name = loveframes.Create("text")
		name:SetText(good.name)
		name:SetWidth(60)
		local buyprice = loveframes.Create("text")
		buyprice:SetText(tostring(good.current_price*1.05,1))
		buyprice:SetWidth(60)
		local sellprice = loveframes.Create("text")
		sellprice:SetText(tostring(good.current_price,1))
		sellprice:SetWidth(60)
		local bb = buyButton (good,good.current_price*1.05)
		bb:SetWidth(60)
		local sb = sellButton(good,good.current_price)
		sb:SetWidth(60)
		goods:AddItem(name,column,1)
		
		goods:AddItem(sellprice,column,2)
		goods:AddItem(buyprice, column,3)
		goods:AddItem(bb,column,4)
		goods:AddItem(sb,column,5)
	end
end