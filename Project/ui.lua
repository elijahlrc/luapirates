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
	--frame:SetDraggable(false)
	local width = 800
	local height = 650
	frame:SetSize(width,height)
	frame:SetPos(WINDOW_WIDTH/2-width/2,WINDOW_HEIGHT/2-height/2,false)

	form = inventory_list(items,width,height,frame)

	local exit = loveframes.Create("button",frame)
	exit:CenterX()
	exit:SetY(height-40)
	exit:SetText("Exit")
	exit.OnClick = function(object)
		paused = false
		frame:Remove()
		
	end
end
function inventory_list(items,width,height,parent)
	local listWidth = width-100
	local listHeight = height-200
	local form = loveframes.Create("form",parent)
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
	


	iList = loveframes.Create("list",parent)
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

	local repair = loveframes.Create("button",frame)
	repair:CenterX()
	repair:SetY(height-70)
	repair:SetText("Repair")
	repair.OnClick = function(object)
		local cost = (PLAYER.max_health-PLAYER.hp)*10
		print (cost,PLAYER.money,PLAYER.max_health)
		if PLAYER.money >= cost then
			PLAYER.money = PLAYER.money-cost
			PLAYER.hp = PLAYER.max_health
		end
	end
	function buyButton(good,price)
		local button = loveframes.Create("button")
		button:SetText("Buy")
		button.OnClick = function(object,x,y)
			if PLAYER.money >= price then
				if PLAYER.addToHold(good,1) then
					PLAYER.money = PLAYER.money-price
				end
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

function loot_screen(obj)
	local items = obj.inventory
	local money = obj.money
	local frame = loveframes.Create("frame")
	paused = true
	frame:SetName("")
	frame:ShowCloseButton(false)
	frame:MakeTop()
	frame:SetDraggable(false)
	width = 800
	height = 650
	frame:SetSize(width,height)
	loot_list(items,width,height,frame)

	local take_money = loveframes.Create("button",frame)
	take_money:SetWidth(100)
	take_money:SetText("Take Money:"..tostring(money))
	take_money:SetY(height-80)
	take_money.OnClick = function(object)
		take_money:SetText("Take Money:"..tostring(money))
		PLAYER.money = PLAYER.money + money
		obj.money = 0
		take_money:SetText("Take Money:"..tostring(obj.money))
	end

	local exit = loveframes.Create("button",frame)
	exit:CenterX()
	exit:SetY(height-40)
	exit:SetText("Exit")
	exit.OnClick = function(object)
		paused = false
		frame:Remove()
	end
end

function loot_list(items,width,height,parent)
	local listWidth = width-100
	local listHeight = height-200
	local form = loveframes.Create("form",parent)
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
	used:SetText("Take")
	used:SetWidth(100)
	form:AddItem(used)
	


	iList = loveframes.Create("list",parent)
	iList:SetSize(listWidth,listHeight)
	iList:CenterX()
	iList:SetY(100)

	for i, item in pairs(items) do
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
		form:AddItem(name)
		name:SetText(item[1].name)

		local number = loveframes.Create("text")
		number:SetWidth(50)
		number:SetText(item[2])
		form:AddItem(number)

		local mass = loveframes.Create("text")
		mass:SetWidth(50)
		mass:SetText(item[1].mass)
		form:AddItem(mass)

		local take_button = loveframes.Create("button")
		take_button:SetWidth(100)
		take_button:SetText("Take")
		take_button.OnClick = function(object)
			if PLAYER.addToHold(item[1],1) then
				item[2] = item[2] - 1
				number:SetText(item[2])
				if item[2] == 0 then
					iList:RemoveItem(form)
					items[i] = nil
				end
			end
		end

		form:AddItem(take_button)

		iList:AddItem(form)
	end
end
