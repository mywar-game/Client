

ActivityAction_receiveLoginReward30Res = {}

--领取每月签到奖励
function ActivityAction_receiveLoginReward30Res:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ActivityAction_receiveLoginReward30Res:init()
	
	self.CommonGoodsBeanBO_drop=nil --得到的奖励对象

	self.actName = "ActivityAction_receiveLoginReward30"
end

function ActivityAction_receiveLoginReward30Res:getActName()
	return self.actName
end

--得到的奖励对象
function ActivityAction_receiveLoginReward30Res:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end





function ActivityAction_receiveLoginReward30Res:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)


end

function ActivityAction_receiveLoginReward30Res:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)

	   return body
end