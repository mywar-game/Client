

ForcesAction_getCollectFightRewardRes = {}

--获取采集以及打怪的奖励
function ForcesAction_getCollectFightRewardRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_getCollectFightRewardRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --公共物品掉落

	self.actName = "ForcesAction_getCollectFightReward"
end

function ForcesAction_getCollectFightRewardRes:getActName()
	return self.actName
end

--公共物品掉落
function ForcesAction_getCollectFightRewardRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end





function ForcesAction_getCollectFightRewardRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)


end

function ForcesAction_getCollectFightRewardRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)

	   return body
end