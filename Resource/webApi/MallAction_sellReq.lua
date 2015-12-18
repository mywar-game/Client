

MallAction_sellReq = {}

--出售
function MallAction_sellReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MallAction_sellReq:init()
	
	self.string_userEquipId="" --用户装备id

	self.int_toolType=0 --物品类型

	self.int_toolId=0 --物品id

	self.int_toolNum=0 --物品数量

	self.actName = "MallAction_sell"
end

function MallAction_sellReq:getActName()
	return self.actName
end

--用户装备id
function MallAction_sellReq:setString_userEquipId(string_userEquipId)
	self.string_userEquipId = string_userEquipId
end
--物品类型
function MallAction_sellReq:setInt_toolType(int_toolType)
	self.int_toolType = int_toolType
end
--物品id
function MallAction_sellReq:setInt_toolId(int_toolId)
	self.int_toolId = int_toolId
end
--物品数量
function MallAction_sellReq:setInt_toolNum(int_toolNum)
	self.int_toolNum = int_toolNum
end





function MallAction_sellReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_userEquipId)

		outputStream:WriteInt(self.int_toolType)

		outputStream:WriteInt(self.int_toolId)

		outputStream:WriteInt(self.int_toolNum)


end

function MallAction_sellReq:decode(inputStream)
	    local body = {}
		body.userEquipId = inputStream:ReadUTFString()

		body.toolType = inputStream:ReadInt()

		body.toolId = inputStream:ReadInt()

		body.toolNum = inputStream:ReadInt()


	   return body
end