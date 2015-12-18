

LuckyAction_getBattleLuckyRewardRes = {}

--获取战斗随机事件
function LuckyAction_getBattleLuckyRewardRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LuckyAction_getBattleLuckyRewardRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --通用掉落对象

	self.actName = "LuckyAction_getBattleLuckyReward"
end

function LuckyAction_getBattleLuckyRewardRes:getActName()
	return self.actName
end

--通用掉落对象
function LuckyAction_getBattleLuckyRewardRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end





function LuckyAction_getBattleLuckyRewardRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)


end

function LuckyAction_getBattleLuckyRewardRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)

	   return body
end