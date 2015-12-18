

PkAction_exchangeRes = {}

--兑换商品
function PkAction_exchangeRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_exchangeRes:init()
	
	self.int_honour=0 --剩余荣誉点

	self.CommonGoodsBeanBO_drop=nil --通用奖励对象

	self.actName = "PkAction_exchange"
end

function PkAction_exchangeRes:getActName()
	return self.actName
end

--剩余荣誉点
function PkAction_exchangeRes:setInt_honour(int_honour)
	self.int_honour = int_honour
end
--通用奖励对象
function PkAction_exchangeRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end





function PkAction_exchangeRes:encode(outputStream)
		outputStream:WriteInt(self.int_honour)

		self.CommonGoodsBeanBO_drop:encode(outputStream)


end

function PkAction_exchangeRes:decode(inputStream)
	    local body = {}
		body.honour = inputStream:ReadInt()

        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)

	   return body
end