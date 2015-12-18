

UserBuyBackInfoBO = {}

--用户回购信息对象
function UserBuyBackInfoBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserBuyBackInfoBO:init()
	
	self.string_buyBackId="" --回购id

	self.int_toolType=0 --物品类型

	self.int_toolId=0 --物品id

	self.int_toolNum=0 --物品数量

	self.string_equipMainAtrr="" --装备主属性

	self.string_equipSecondaryAttr="" --装备副属性

	self.actName = "UserBuyBackInfoBO"
end

function UserBuyBackInfoBO:getActName()
	return self.actName
end

--回购id
function UserBuyBackInfoBO:setString_buyBackId(string_buyBackId)
	self.string_buyBackId = string_buyBackId
end
--物品类型
function UserBuyBackInfoBO:setInt_toolType(int_toolType)
	self.int_toolType = int_toolType
end
--物品id
function UserBuyBackInfoBO:setInt_toolId(int_toolId)
	self.int_toolId = int_toolId
end
--物品数量
function UserBuyBackInfoBO:setInt_toolNum(int_toolNum)
	self.int_toolNum = int_toolNum
end
--装备主属性
function UserBuyBackInfoBO:setString_equipMainAtrr(string_equipMainAtrr)
	self.string_equipMainAtrr = string_equipMainAtrr
end
--装备副属性
function UserBuyBackInfoBO:setString_equipSecondaryAttr(string_equipSecondaryAttr)
	self.string_equipSecondaryAttr = string_equipSecondaryAttr
end





function UserBuyBackInfoBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_buyBackId)

		outputStream:WriteInt(self.int_toolType)

		outputStream:WriteInt(self.int_toolId)

		outputStream:WriteInt(self.int_toolNum)

		outputStream:WriteUTFString(self.string_equipMainAtrr)

		outputStream:WriteUTFString(self.string_equipSecondaryAttr)


end

function UserBuyBackInfoBO:decode(inputStream)
	    local body = {}
		body.buyBackId = inputStream:ReadUTFString()

		body.toolType = inputStream:ReadInt()

		body.toolId = inputStream:ReadInt()

		body.toolNum = inputStream:ReadInt()

		body.equipMainAtrr = inputStream:ReadUTFString()

		body.equipSecondaryAttr = inputStream:ReadUTFString()


	   return body
end