

TaskAction_getUserDailyTaskInfoReq = {}

--获取用户日常任务信息
function TaskAction_getUserDailyTaskInfoReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function TaskAction_getUserDailyTaskInfoReq:init()
	
	self.actName = "TaskAction_getUserDailyTaskInfo"
end

function TaskAction_getUserDailyTaskInfoReq:getActName()
	return self.actName
end






function TaskAction_getUserDailyTaskInfoReq:encode(outputStream)

end

function TaskAction_getUserDailyTaskInfoReq:decode(inputStream)
	    local body = {}

	   return body
end