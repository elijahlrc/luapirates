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

function portMenu(port)
	paused = true
	local frame = loveframes.Create("frame")
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

	function buyButton(good,price,frame)
		local button = loveframes.Create("button")
		button:SetText("Buy")
		button.OnClick = function(object,x,y)
			if PLAYER.money >= price then
				PLAYER.money = PLAYER.money-price
				PLAYER.addToHold(good)
			end
		end
		return button
	end
	function sellButton(good,price,frame)
		local button = loveframes.Create("button")
		button:SetText("Sell")
		button.OnClick = function(object,x,y)
			if PLAYER.removeFromHold(good) ~= false then
				PLAYER.money = PLAYER.money+price
			end
		end
		return button
	end
	
	local goods = loveframes.Create("grid",frame)
	goods:SetPos(10,100)
	goods:SetSize(780,450)
	goods:SetColumns(#port.prices+1)
	goods:SetRows(5)
	goods:SetCellWidth(80)
	goods:SetCellHeight(30)
	local item = loveframes.Create("text")
	item:SetText("Item:")
	item:SetWidth(70)
	local sellprice =loveframes.Create("text")
	sellprice:SetText("Sell Price:")
	sellprice:SetWidth(70)
	local buyprice = loveframes.Create("text")
	buyprice:SetText("Buy Price:")
	buyprice:SetWidth(70)
	local buy = loveframes.Create("text")
	buy:SetText("Buy:")
	buy:SetWidth(70)
	local sell = loveframes.Create("text")
	sell:SetText("Sell:")
	sell:SetWidth(70)
	goods:AddItem(item      ,1,1)
	goods:AddItem(sellprice ,2,1)
	goods:AddItem(buyprice  ,3,1)
	goods:AddItem(buy       ,4,1)
	goods:AddItem(sell      ,5,1)
	local column = 1
	for key,value in pairs(port.prices) do
		column = column+1
		--row = loveframes.Create("form")
		--row:SetLayoutType("horizontal")
		local name = loveframes.Create("text")
		name:SetText(tostring(key))
		name:SetWidth(70)
		local buyprice = loveframes.Create("text")
		buyprice:SetText(tostring(round(value[1]*1.05,1)))
		buyprice:SetWidth(70)
		local sellprice = loveframes.Create("text")
		sellprice:SetText(tostring(round(value[1],1)))
		sellprice:SetWidth(70)
		local bb = buyButton (key,value[1]*1.05)
		bb:SetWidth(70)
		local sb = sellButton(key,value[1])
		sb:SetWidth(70)
		goods:AddItem(name,1,column)
		goods:AddItem(buyprice,2,column)
		goods:AddItem(sellprice,3,column)
		goods:AddItem(bb,4,column)
		goods:AddItem(sb,5,column)
	end
end