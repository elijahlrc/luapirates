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

	local reGen = loveframes.Create("button",frame)
	reGen:CenterX()
	reGen:SetY(70)
	reGen:SetText("Regenerate Map")
	reGen.OnClick = function(object)
		love.load()
	end

	local exit = loveframes.Create("button",frame)
	exit:CenterX()
	exit:SetY(100)
	exit:SetText("Exit")
	exit.OnClick = function(object)
		love.event.quit()
	end

end


function inventory_menu(owner)
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

	form = inventory_list(owner,width-100,height-200,frame)

	local exit = loveframes.Create("button",frame)
	exit:CenterX()
	exit:SetY(height-40)
	exit:SetText("Exit")
	exit.OnClick = function(object)
		paused = false
		frame:Remove()
		
	end
end
function slot_choice_menu(owner,item)
	local frame = loveframes.Create("frame")
	frame:SetName("")
	frame:ShowCloseButton(false)
	frame:MakeTop()
	local width = 800
	local height = 650
	frame:SetSize(width,height)
	frame:SetPos(WINDOW_WIDTH/2-width/2,WINDOW_HEIGHT/2-height/2,false)
	local list = loveframes.Create("list")
	list.setName("Slots:")
	list.setSize(790,640)
	list.SetPos(5,5)
	for _,slot in pairs(owner.slots) do 
		local form = love.Create("form")
		local pos_text = love.Create("text")
		pos_text.SetText("Position:")
		form.AddItem(pos_text)
		local pos_text2= love.Create("text")
		pos_text2.SetText("x = "..tostring(slot.x).."  y = "..tostring(slot.y))
		form.AddItem(pos_text2)
		local side_text = love.Create("text")
		side_text.SetText(slot.position)
		form.AddItem(pos_text2)
		local select_button = love.Create("button")
		select_button.SetText("Select")
		select_button.OnClick = function()
			owner.equip(slot,item[1])
			frame:Remove()
		end
	end
end	
function inventory_list(owner,listWidth,listHeight,parent)
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

	for i, item in pairs(owner.inventory) do
		local form = loveframes.Create("form")
		form:SetName("")
		form:SetSize(listWidth,30)
		form:SetLayoutType("horizontal")
		local image = loveframes.Create("image")
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


			local equip_b = loveframes.Create("button")
			equip_b:SetText("Equip/UnEquip")
			equip_b.OnClick = function()
				if  item[1].equipped then
					owner.unequip(item[1].slot)
					used:SetText("Unequipped")
				else
					slot_chioce_menu(owner,item)
					used:SetText("Equipped")
				end
			end
			form:AddItem(equip_b)

		end
		iList:AddItem(form)
	end
end

function trade_goods_list(goods_list,frame,x_p,y_p,width,height)
	function buyButton(good,price,quant)
		local button = loveframes.Create("button")
		button:SetText("Buy "..tostring(quant))
		button.OnClick = function(object,x,y)
			if PLAYER.money >= price*quant then
				if PLAYER.addToHold(good,quant) then
					PLAYER.money = PLAYER.money-price*quant
				end
			end
		end
		return button
	end
	function sellButton(good,price,quant)
		local button = loveframes.Create("button")
		button:SetText("Sell "..tostring(quant))
		button.OnClick = function(object,x,y)
			if PLAYER.removeFromHold(good,quant) ~= false then
				PLAYER.money = PLAYER.money+price*quant
			end
		end
		return button
	end
	
	local goods = loveframes.Create("list",frame)
	--FOLOWING BLOCK IS TRADE GOODS:
	goods:SetPos(x_p,y_p+60)
	goods:SetSize(width,height)
	goods:SetDisplayType("vertical")
	local item = loveframes.Create("text")
	item:SetText("Item:")
	item:SetWidth(50)
	local sellprice =loveframes.Create("text")
	sellprice:SetText("Sell Price:")
	sellprice:SetWidth(40)
	local buyprice = loveframes.Create("text")
	buyprice:SetText("Buy Price:")
	buyprice:SetWidth(40)
	local buy = loveframes.Create("text")
	buy:SetText("Buy:")
	buy:SetWidth(45)
	local sell = loveframes.Create("text")
	sell:SetText("Sell:")
	sell:SetWidth(45)
	local buy_10 = loveframes.Create("text")
	buy_10:SetText("Buy 10:")
	buy_10:SetWidth(45)
	local sell_10 = loveframes.Create("text")
	sell_10:SetText("Sell 10:")
	sell_10:SetWidth(45)
	local row = loveframes.Create("form",frame)
	row:SetLayoutType("horizontal")
	row:SetName("")
	row:AddItem(item)
	row:AddItem(sellprice)
	row:AddItem(buyprice)
	row:AddItem(buy)
	row:AddItem(sell)
	row:AddItem(buy_10)
	row:AddItem(sell_10)
	row:SetPos(x_p,y_p)
	row:SetSize(width,60)
	for key,good in pairs(goods_list)  do
		row = loveframes.Create("form")
		row:SetLayoutType("horizontal")
		row:SetName("")
		local name = loveframes.Create("text")
		name:SetText(good.name)
		name:SetWidth(50)
		local buyprice = loveframes.Create("text")
		buyprice:SetText(tostring(round(good.current_price*1.05,1)))
		buyprice:SetWidth(40)
		local sellprice = loveframes.Create("text")
		sellprice:SetText(tostring(round(good.current_price,1)))
		sellprice:SetWidth(40)
		local b10b = buyButton (good,good.current_price*1.05,10)
		b10b:SetWidth(45)
		local s10b = sellButton(good,good.current_price,10)
		s10b:SetWidth(45)
		local bb = buyButton (good,good.current_price*1.05,1)
		bb:SetWidth(45)
		local sb = sellButton(good,good.current_price,1)
		sb:SetWidth(45)
		

		row:AddItem(name)
		row:AddItem(sellprice)
		row:AddItem(buyprice)
		row:AddItem(b10b)
		row:AddItem(s10b)
		row:AddItem(bb)
		row:AddItem(sb)

		goods:AddItem(row)
	end
	return goods
end		
function portMenu(port)
	--could be changed to use tabs if the menu gets to cluttered
	--window could also be made larger.
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
		if PLAYER.hp < PLAYER.max_health then
			local hp_restored = math.min((PLAYER.max_health-PLAYER.hp), math.floor(PLAYER.money/10))  -- repairs either to max or as much as you can afford
			local cost = hp_restored*10
			print (cost,PLAYER.money,PLAYER.max_health)
			PLAYER.money = PLAYER.money-cost
			PLAYER.hp = PLAYER.hp + hp_restored
		end
	end
	trade_goods_list(port.goods,frame,5    ,30,390,450)
	trade_goods_list(port.shipyard_inventory,frame,405,30,390,450)

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
	take_money:SetX(75)
	take_money.OnClick = function(object)
		take_money:SetText("Take Money:"..tostring(money))
		PLAYER.money = PLAYER.money + money
		obj.money = 0
		take_money:SetText("Take Money:"..tostring(obj.money))
	end

	local scuttle = loveframes.Create("button",frame)
	scuttle:SetWidth(100)
	scuttle:SetText("Scuttle")
	scuttle:CenterX()
	scuttle:SetY(height-100)
	scuttle.OnClick = function(object)
		obj.dead = true
		paused = false
		frame:Remove()
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
		local take_10 = loveframes.Create("button")
		take_10:SetWidth(100)
		take_10:SetText("Take 10")
		take_10.OnClick = function(object)
			if item[2]>=10 and PLAYER.addToHold(item[1],10) then
				item[2] = item[2] - 10
				number:SetText(item[2])
				if item[2] == 0 then
					iList:RemoveItem(form)
					items[i] = nil
				end
			end
		end
		form:AddItem(take_10)
		

		iList:AddItem(form)
	end
end
