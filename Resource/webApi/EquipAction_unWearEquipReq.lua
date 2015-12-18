

EquipAction_unWearEquipReq = {}

--卸下装备
function EquipAction_unWearEquipReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function EquipAction_unWearEquipReq:init()
	
	self.string_userEquipId="" --用户装备id

	self.actName = "EquipAction_unWearEquip"
end

function EquipAction_unWearEquipReq:getActName()
	return self.actName
end

--用户装备id
function EquipAction_unWearEquipReq:setString_userEquipId(string_userEquipId)
	self.string_userEquipId = string_userEquipId
end





function EquipAction_unWearEquipReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_userEquipId)


end

function EquipAction_unWearEquipReq:decode(inputStream)
	    local body = {}
		body.userEquipId = inputStream:ReadUTFString()


	   return body
end