

EquipAction_equipFillInGemstoneReq = {}

--装备镶嵌宝石换宝石、取下宝石
function EquipAction_equipFillInGemstoneReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function EquipAction_equipFillInGemstoneReq:init()
	
	self.string_userEquipId="" --用户装备id

	self.string_userGemstoneId="" --用户宝石id

	self.int_pos=0 --镶嵌的位置(0取下,1号位，装备有几个空就几个位置)

	self.actName = "EquipAction_equipFillInGemstone"
end

function EquipAction_equipFillInGemstoneReq:getActName()
	return self.actName
end

--用户装备id
function EquipAction_equipFillInGemstoneReq:setString_userEquipId(string_userEquipId)
	self.string_userEquipId = string_userEquipId
end
--用户宝石id
function EquipAction_equipFillInGemstoneReq:setString_userGemstoneId(string_userGemstoneId)
	self.string_userGemstoneId = string_userGemstoneId
end
--镶嵌的位置(0取下,1号位，装备有几个空就几个位置)
function EquipAction_equipFillInGemstoneReq:setInt_pos(int_pos)
	self.int_pos = int_pos
end





function EquipAction_equipFillInGemstoneReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_userEquipId)

		outputStream:WriteUTFString(self.string_userGemstoneId)

		outputStream:WriteInt(self.int_pos)


end

function EquipAction_equipFillInGemstoneReq:decode(inputStream)
	    local body = {}
		body.userEquipId = inputStream:ReadUTFString()

		body.userGemstoneId = inputStream:ReadUTFString()

		body.pos = inputStream:ReadInt()


	   return body
end