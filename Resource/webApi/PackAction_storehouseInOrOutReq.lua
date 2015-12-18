

PackAction_storehouseInOrOutReq = {}

--仓库存入或者取出
function PackAction_storehouseInOrOutReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PackAction_storehouseInOrOutReq:init()
	
	self.int_type=0 --类型1存入仓库0取出

	self.int_toolType=0 --道具类型

	self.int_toolId=0 --道具id

	self.int_toolNum=0 --道具数量

	self.string_userEquipId="" --用户装备id

	self.string_userGemstoneId="" --用户宝石id

	self.actName = "PackAction_storehouseInOrOut"
end

function PackAction_storehouseInOrOutReq:getActName()
	return self.actName
end

--类型1存入仓库0取出
function PackAction_storehouseInOrOutReq:setInt_type(int_type)
	self.int_type = int_type
end
--道具类型
function PackAction_storehouseInOrOutReq:setInt_toolType(int_toolType)
	self.int_toolType = int_toolType
end
--道具id
function PackAction_storehouseInOrOutReq:setInt_toolId(int_toolId)
	self.int_toolId = int_toolId
end
--道具数量
function PackAction_storehouseInOrOutReq:setInt_toolNum(int_toolNum)
	self.int_toolNum = int_toolNum
end
--用户装备id
function PackAction_storehouseInOrOutReq:setString_userEquipId(string_userEquipId)
	self.string_userEquipId = string_userEquipId
end
--用户宝石id
function PackAction_storehouseInOrOutReq:setString_userGemstoneId(string_userGemstoneId)
	self.string_userGemstoneId = string_userGemstoneId
end





function PackAction_storehouseInOrOutReq:encode(outputStream)
		outputStream:WriteInt(self.int_type)

		outputStream:WriteInt(self.int_toolType)

		outputStream:WriteInt(self.int_toolId)

		outputStream:WriteInt(self.int_toolNum)

		outputStream:WriteUTFString(self.string_userEquipId)

		outputStream:WriteUTFString(self.string_userGemstoneId)


end

function PackAction_storehouseInOrOutReq:decode(inputStream)
	    local body = {}
		body.type = inputStream:ReadInt()

		body.toolType = inputStream:ReadInt()

		body.toolId = inputStream:ReadInt()

		body.toolNum = inputStream:ReadInt()

		body.userEquipId = inputStream:ReadUTFString()

		body.userGemstoneId = inputStream:ReadUTFString()


	   return body
end