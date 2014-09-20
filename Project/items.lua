function ItemBaseClass(value,mass,name,type,sDev,icon,active,pasive)--class for things that sit in inventories
	self = baseClass()
	self.value = value --base price
	self.mass = mass --how much space is taken up
	self.name = name 
	self.type = type --"tradegood", "equipment", etc
	self.icon = icon or SPRITES.canonball--need some sprite so cannonball by defualt, shoud be overwriten for everything but cannonballs, le

	if active then
		self.active = true
	else
		self.active = false
	end
	if pasive then
		self.pasive = true
	else
		self.pasive = false
	end
	if self.type == "equipment" then
		self.equipped = false
	elseif self.type == "tradegood" then
		if sDev == nil then
			sDev = selfvalue/10
		end
		self.sDev = sDev
	end
	return self
end

function makeItem(value,mass,name,type,sDev,icon,active,pasive)
	local self = {}
	self.value = value
	self.mass = mass
	self.name = name
	self.type = type
	self.sDev = sDev
	self.icon = icon
	self.active = active
	self.pasive = pasive
	function self.make()
		return  ItemBaseClass(value,mass,name,type,sDev,icon,active,pasive)
	end
	return self
end
TRADEGOODS = {}--list of items which citys sell in bulk.
table.insert(TRADEGOODS, makeItem(20,1,	"food",		"tradegood",10))
table.insert(TRADEGOODS, makeItem(40,1,	"sugar",	"tradegood",20))
table.insert(TRADEGOODS, makeItem(80,1,	"cloth",		"tradegood",25))
table.insert(TRADEGOODS, makeItem(125,1,	"tabaco",	"tradegood",35))

EQUIPMENT = {}--list of equipment shipyards cary