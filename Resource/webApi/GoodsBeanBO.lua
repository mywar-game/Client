

GoodsBeanBO = {}

--通用奖励对象
function GoodsBeanBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function GoodsBeanBO:init()
	
	self.int_goodsType=0 --奖励物品类型

	self.int_goodsId=0 --奖励物品id

	self.int_goodsNum=0 --奖励物品数量

	self.actName = "GoodsBeanBO"
end

function GoodsBeanBO:getActName()
	return self.actName
end

--奖励物品类型
function GoodsBeanBO:setInt_goodsType(int_goodsType)
	self.int_goodsType = int_goodsType
end
--奖励物品id
function GoodsBeanBO:setInt_goodsId(int_goodsId)
	self.int_goodsId = int_goodsId
end
--奖励物品数量
function GoodsBeanBO:setInt_goodsNum(int_goodsNum)
	self.int_goodsNum = int_goodsNum
end





function GoodsBeanBO:encode(outputStream)
		outputStream:WriteInt(self.int_goodsType)

		outputStream:WriteInt(self.int_goodsId)

		outputStream:WriteInt(self.int_goodsNum)


end

function GoodsBeanBO:decode(inputStream)
	    local body = {}
		body.goodsType = inputStream:ReadInt()

		body.goodsId = inputStream:ReadInt()

		body.goodsNum = inputStream:ReadInt()


	   return body
end