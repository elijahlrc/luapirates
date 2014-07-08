function ItemBaseClass(value,mass,name,type,standard_dev,icon,active,pasive)--class for things that sit in inventories
	self = baseClass()
	self.value = value --base price
	self.mass = mass --how much space is taken up
	self.name = name 
	self.type = type --"tradegood", "equipment", etc
	self.icon = icon or SPRITES.canonball--need some sprite so cannonball by defualt, shoud be overwriten for everything but cannonballs, lel
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
		if standard_dev == nil then
			standard_dev = selfvalue/10
		end
		self.sDev = standard_dev
	end
	return self
end
TRADEGOODS = {}--list of items which citys sell in bulk.
table.insert(TRADEGOODS, ItemBaseClass(20,1,	"food",		"tradegood",10))
table.insert(TRADEGOODS, ItemBaseClass(40,1,	"sugar",	"tradegood",20))
table.insert(TRADEGOODS, ItemBaseClass(80,1,	"cloth",	"tradegood",25))
table.insert(TRADEGOODS, ItemBaseClass(125,1,	"tabaco",	"tradegood",35))




