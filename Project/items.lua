function ItemBaseClass(value,mass,name,type,standard_dev,icon)
	self = baseClass()
	self.value = value
	self.mass = mass
	self.name = name
	self.type = type
	self.icon = icon or SPRITES.canonball
	if self.type == equipment then
		self.equipped = false
	elseif self.type == "tradegood" then
		if standard_dev == nil then
			standard_dev = selfvalue/10
		end
		self.sDev = standard_dev
	end
	return self
end
TRADEGOODS = {}--list of items
TRADEGOODS.food 	= ItemBaseClass(20,1,	"food",		"tradegood",10)
TRADEGOODS.sugar 	= ItemBaseClass(40,1,	"sugar",	"tradegood",20)
TRADEGOODS.cloth 	= ItemBaseClass(80,1,	"cloth",	"tradegood",25)
TRADEGOODS.tabaco 	= ItemBaseClass(125,1,	"tabaco",	"tradegood",35)



