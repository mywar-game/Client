

PrestigeAction_rewardRes = {}

--领取声望奖励
function PrestigeAction_rewardRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PrestigeAction_rewardRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --通用奖励对象

	self.actName = "PrestigeAction_reward"
end

function PrestigeAction_rewardRes:getActName()
	return self.actName
end

--通用奖励对象
function PrestigeAction_rewardRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end





function PrestigeAction_rewardRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)


end

function PrestigeAction_rewardRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)

	   return body
end