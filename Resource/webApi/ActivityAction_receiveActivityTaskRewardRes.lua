

ActivityAction_receiveActivityTaskRewardRes = {}

--领取用户活跃度奖励
function ActivityAction_receiveActivityTaskRewardRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ActivityAction_receiveActivityTaskRewardRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --通用掉落对象

	self.actName = "ActivityAction_receiveActivityTaskReward"
end

function ActivityAction_receiveActivityTaskRewardRes:getActName()
	return self.actName
end

--通用掉落对象
function ActivityAction_receiveActivityTaskRewardRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end





function ActivityAction_receiveActivityTaskRewardRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)


end

function ActivityAction_receiveActivityTaskRewardRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)

	   return body
end