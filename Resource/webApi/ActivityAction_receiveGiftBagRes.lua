

ActivityAction_receiveGiftBagRes = {}

--领取声望奖励
function ActivityAction_receiveGiftBagRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ActivityAction_receiveGiftBagRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --通用奖励对象

	self.actName = "ActivityAction_receiveGiftBag"
end

function ActivityAction_receiveGiftBagRes:getActName()
	return self.actName
end

--通用奖励对象
function ActivityAction_receiveGiftBagRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end





function ActivityAction_receiveGiftBagRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)


end

function ActivityAction_receiveGiftBagRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)

	   return body
end