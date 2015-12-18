

ActivityAction_receiveActivityTaskRewardReq = {}

--领取用户活跃度奖励
function ActivityAction_receiveActivityTaskRewardReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ActivityAction_receiveActivityTaskRewardReq:init()
	
	self.actName = "ActivityAction_receiveActivityTaskReward"
end

function ActivityAction_receiveActivityTaskRewardReq:getActName()
	return self.actName
end






function ActivityAction_receiveActivityTaskRewardReq:encode(outputStream)

end

function ActivityAction_receiveActivityTaskRewardReq:decode(inputStream)
	    local body = {}

	   return body
end