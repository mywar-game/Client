

LuckyAction_getBattleLuckyRewardReq = {}

--获取战斗随机事件
function LuckyAction_getBattleLuckyRewardReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LuckyAction_getBattleLuckyRewardReq:init()
	
	self.actName = "LuckyAction_getBattleLuckyReward"
end

function LuckyAction_getBattleLuckyRewardReq:getActName()
	return self.actName
end






function LuckyAction_getBattleLuckyRewardReq:encode(outputStream)

end

function LuckyAction_getBattleLuckyRewardReq:decode(inputStream)
	    local body = {}

	   return body
end