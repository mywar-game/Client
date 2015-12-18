

ActivityAction_getActivityTaskInfoReq = {}

--查看用户活跃度信息--小助手
function ActivityAction_getActivityTaskInfoReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ActivityAction_getActivityTaskInfoReq:init()
	
	self.actName = "ActivityAction_getActivityTaskInfo"
end

function ActivityAction_getActivityTaskInfoReq:getActName()
	return self.actName
end






function ActivityAction_getActivityTaskInfoReq:encode(outputStream)

end

function ActivityAction_getActivityTaskInfoReq:decode(inputStream)
	    local body = {}

	   return body
end