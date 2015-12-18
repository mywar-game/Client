

EquipAction_wearEquipReq = {}

--穿戴装备
function EquipAction_wearEquipReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function EquipAction_wearEquipReq:init()
	
	self.string_userHeroId="" --要穿戴的英雄id

	self.string_userEquipId="" --用户装备id

	self.int_pos=0 --位置

	self.actName = "EquipAction_wearEquip"
end

function EquipAction_wearEquipReq:getActName()
	return self.actName
end

--要穿戴的英雄id
function EquipAction_wearEquipReq:setString_userHeroId(string_userHeroId)
	self.string_userHeroId = string_userHeroId
end
--用户装备id
function EquipAction_wearEquipReq:setString_userEquipId(string_userEquipId)
	self.string_userEquipId = string_userEquipId
end
--位置
function EquipAction_wearEquipReq:setInt_pos(int_pos)
	self.int_pos = int_pos
end





function EquipAction_wearEquipReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_userHeroId)

		outputStream:WriteUTFString(self.string_userEquipId)

		outputStream:WriteInt(self.int_pos)


end

function EquipAction_wearEquipReq:decode(inputStream)
	    local body = {}
		body.userHeroId = inputStream:ReadUTFString()

		body.userEquipId = inputStream:ReadUTFString()

		body.pos = inputStream:ReadInt()


	   return body
end