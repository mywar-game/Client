

PkMallBO = {}

--荣誉兑换对象
function PkMallBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkMallBO:init()
	
	self.int_mallId=0 --商品id

	self.int_dayBuyNum=0 --每日已购买次数

	self.int_totalBuyNum=0 --总共已购买次数

	self.actName = "PkMallBO"
end

function PkMallBO:getActName()
	return self.actName
end

--商品id
function PkMallBO:setInt_mallId(int_mallId)
	self.int_mallId = int_mallId
end
--每日已购买次数
function PkMallBO:setInt_dayBuyNum(int_dayBuyNum)
	self.int_dayBuyNum = int_dayBuyNum
end
--总共已购买次数
function PkMallBO:setInt_totalBuyNum(int_totalBuyNum)
	self.int_totalBuyNum = int_totalBuyNum
end





function PkMallBO:encode(outputStream)
		outputStream:WriteInt(self.int_mallId)

		outputStream:WriteInt(self.int_dayBuyNum)

		outputStream:WriteInt(self.int_totalBuyNum)


end

function PkMallBO:decode(inputStream)
	    local body = {}
		body.mallId = inputStream:ReadInt()

		body.dayBuyNum = inputStream:ReadInt()

		body.totalBuyNum = inputStream:ReadInt()


	   return body
end