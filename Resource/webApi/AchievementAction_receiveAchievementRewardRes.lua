

AchievementAction_receiveAchievementRewardRes = {}

--领取用户成就奖励
function AchievementAction_receiveAchievementRewardRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function AchievementAction_receiveAchievementRewardRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --得到的奖励对象

	self.actName = "AchievementAction_receiveAchievementReward"
end

function AchievementAction_receiveAchievementRewardRes:getActName()
	return self.actName
end

--得到的奖励对象
function AchievementAction_receiveAchievementRewardRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end





function AchievementAction_receiveAchievementRewardRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)


end

function AchievementAction_receiveAchievementRewardRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)

	   return body
end