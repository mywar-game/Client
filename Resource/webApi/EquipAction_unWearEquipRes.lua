

EquipAction_unWearEquipRes = {}

--卸下装备
function EquipAction_unWearEquipRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function EquipAction_unWearEquipRes:init()
	
	self.UserEquipBO_userEquipBO=nil --用户装备

	self.actName = "EquipAction_unWearEquip"
end

function EquipAction_unWearEquipRes:getActName()
	return self.actName
end

--用户装备
function EquipAction_unWearEquipRes:setUserEquipBO_userEquipBO(UserEquipBO_userEquipBO)
	self.UserEquipBO_userEquipBO = UserEquipBO_userEquipBO
end





function EquipAction_unWearEquipRes:encode(outputStream)
		self.UserEquipBO_userEquipBO:encode(outputStream)


end

function EquipAction_unWearEquipRes:decode(inputStream)
	    local body = {}
        local userEquipBOTemp = UserEquipBO:New()
        body.userEquipBO=userEquipBOTemp:decode(inputStream)

	   return body
end