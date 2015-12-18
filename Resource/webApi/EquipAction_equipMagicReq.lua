

EquipAction_equipMagicReq = {}

--装备附魔
function EquipAction_equipMagicReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function EquipAction_equipMagicReq:init()
	
	self.string_userEquipId="" --用户装备id

	self.int_reelId=0 --卷轴id

	self.int_status=0 --状态：1开始2取消3完成

	self.actName = "EquipAction_equipMagic"
end

function EquipAction_equipMagicReq:getActName()
	return self.actName
end

--用户装备id
function EquipAction_equipMagicReq:setString_userEquipId(string_userEquipId)
	self.string_userEquipId = string_userEquipId
end
--卷轴id
function EquipAction_equipMagicReq:setInt_reelId(int_reelId)
	self.int_reelId = int_reelId
end
--状态：1开始2取消3完成
function EquipAction_equipMagicReq:setInt_status(int_status)
	self.int_status = int_status
end





function EquipAction_equipMagicReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_userEquipId)

		outputStream:WriteInt(self.int_reelId)

		outputStream:WriteInt(self.int_status)


end

function EquipAction_equipMagicReq:decode(inputStream)
	    local body = {}
		body.userEquipId = inputStream:ReadUTFString()

		body.reelId = inputStream:ReadInt()

		body.status = inputStream:ReadInt()


	   return body
end