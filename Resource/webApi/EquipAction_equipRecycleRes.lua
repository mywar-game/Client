

EquipAction_equipRecycleRes = {}

--回收
function EquipAction_equipRecycleRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function EquipAction_equipRecycleRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --通用奖励对象

	self.string_userEquipId="" --用户装备id

	self.int_gold=0 --用户剩余金币

	self.actName = "EquipAction_equipRecycle"
end

function EquipAction_equipRecycleRes:getActName()
	return self.actName
end

--通用奖励对象
function EquipAction_equipRecycleRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end
--用户装备id
function EquipAction_equipRecycleRes:setString_userEquipId(string_userEquipId)
	self.string_userEquipId = string_userEquipId
end
--用户剩余金币
function EquipAction_equipRecycleRes:setInt_gold(int_gold)
	self.int_gold = int_gold
end





function EquipAction_equipRecycleRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)

		outputStream:WriteUTFString(self.string_userEquipId)

		outputStream:WriteInt(self.int_gold)


end

function EquipAction_equipRecycleRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)
		body.userEquipId = inputStream:ReadUTFString()

		body.gold = inputStream:ReadInt()


	   return body
end