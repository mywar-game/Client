

TaskAction_refreshFiveStarRes = {}

--刷新五星任务
function TaskAction_refreshFiveStarRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function TaskAction_refreshFiveStarRes:init()
	
	self.UserDailyTaskInfoBO_userDailyTaskInfo=nil --五星的日常任务

	self.actName = "TaskAction_refreshFiveStar"
end

function TaskAction_refreshFiveStarRes:getActName()
	return self.actName
end

--五星的日常任务
function TaskAction_refreshFiveStarRes:setUserDailyTaskInfoBO_userDailyTaskInfo(UserDailyTaskInfoBO_userDailyTaskInfo)
	self.UserDailyTaskInfoBO_userDailyTaskInfo = UserDailyTaskInfoBO_userDailyTaskInfo
end





function TaskAction_refreshFiveStarRes:encode(outputStream)
		self.UserDailyTaskInfoBO_userDailyTaskInfo:encode(outputStream)


end

function TaskAction_refreshFiveStarRes:decode(inputStream)
	    local body = {}
        local userDailyTaskInfoTemp = UserDailyTaskInfoBO:New()
        body.userDailyTaskInfo=userDailyTaskInfoTemp:decode(inputStream)

	   return body
end