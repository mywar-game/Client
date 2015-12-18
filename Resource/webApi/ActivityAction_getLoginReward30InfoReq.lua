

ActivityAction_getLoginReward30InfoReq = {}

--查看每月签到信息
function ActivityAction_getLoginReward30InfoReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ActivityAction_getLoginReward30InfoReq:init()
	
	self.actName = "ActivityAction_getLoginReward30Info"
end

function ActivityAction_getLoginReward30InfoReq:getActName()
	return self.actName
end






function ActivityAction_getLoginReward30InfoReq:encode(outputStream)

end

function ActivityAction_getLoginReward30InfoReq:decode(inputStream)
	    local body = {}

	   return body
end