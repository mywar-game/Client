

PackAction_putInStorehouseRes = {}

--存入仓库
function PackAction_putInStorehouseRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PackAction_putInStorehouseRes:init()
	
	self.int_toolType=0 --道具类型

	self.int_toolId=0 --道具id

	self.int_toolNum=0 --道具数量

	self.string_userEquipId="" --用户装备id

	self.string_userGemstoneId="" --用户宝石id

	self.actName = "PackAction_putInStorehouse"
end

function PackAction_putInStorehouseRes:getActName()
	return self.actName
end

--道具类型
function PackAction_putInStorehouseRes:setInt_toolType(int_toolType)
	self.int_toolType = int_toolType
end
--道具id
function PackAction_putInStorehouseRes:setInt_toolId(int_toolId)
	self.int_toolId = int_toolId
end
--道具数量
function PackAction_putInStorehouseRes:setInt_toolNum(int_toolNum)
	self.int_toolNum = int_toolNum
end
--用户装备id
function PackAction_putInStorehouseRes:setString_userEquipId(string_userEquipId)
	self.string_userEquipId = string_userEquipId
end
--用户宝石id
function PackAction_putInStorehouseRes:setString_userGemstoneId(string_userGemstoneId)
	self.string_userGemstoneId = string_userGemstoneId
end





function PackAction_putInStorehouseRes:encode(outputStream)
		outputStream:WriteInt(self.int_toolType)

		outputStream:WriteInt(self.int_toolId)

		outputStream:WriteInt(self.int_toolNum)

		outputStream:WriteUTFString(self.string_userEquipId)

		outputStream:WriteUTFString(self.string_userGemstoneId)


end

function PackAction_putInStorehouseRes:decode(inputStream)
	    local body = {}
		body.toolType = inputStream:ReadInt()

		body.toolId = inputStream:ReadInt()

		body.toolNum = inputStream:ReadInt()

		body.userEquipId = inputStream:ReadUTFString()

		body.userGemstoneId = inputStream:ReadUTFString()


	   return body
end