

ExploreAction_exchangeRes = {}

--兑换英雄
function ExploreAction_exchangeRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ExploreAction_exchangeRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --通用奖励对象

	self.int_integral=0 --用户剩余积分

	self.actName = "ExploreAction_exchange"
end

function ExploreAction_exchangeRes:getActName()
	return self.actName
end

--通用奖励对象
function ExploreAction_exchangeRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end
--用户剩余积分
function ExploreAction_exchangeRes:setInt_integral(int_integral)
	self.int_integral = int_integral
end





function ExploreAction_exchangeRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)

		outputStream:WriteInt(self.int_integral)


end

function ExploreAction_exchangeRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)
		body.integral = inputStream:ReadInt()


	   return body
end