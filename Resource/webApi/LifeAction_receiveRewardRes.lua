

LifeAction_receiveRewardRes = {}

--领取挂机奖励
function LifeAction_receiveRewardRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LifeAction_receiveRewardRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --掉落物品

	self.UserLifeInfoBO_userLifeInfoBO=nil --挂机信息

	self.actName = "LifeAction_receiveReward"
end

function LifeAction_receiveRewardRes:getActName()
	return self.actName
end

--掉落物品
function LifeAction_receiveRewardRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end
--挂机信息
function LifeAction_receiveRewardRes:setUserLifeInfoBO_userLifeInfoBO(UserLifeInfoBO_userLifeInfoBO)
	self.UserLifeInfoBO_userLifeInfoBO = UserLifeInfoBO_userLifeInfoBO
end





function LifeAction_receiveRewardRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)

		self.UserLifeInfoBO_userLifeInfoBO:encode(outputStream)


end

function LifeAction_receiveRewardRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)
        local userLifeInfoBOTemp = UserLifeInfoBO:New()
        body.userLifeInfoBO=userLifeInfoBOTemp:decode(inputStream)

	   return body
end