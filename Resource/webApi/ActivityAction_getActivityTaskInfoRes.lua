

ActivityAction_getActivityTaskInfoRes = {}

--查看用户活跃度信息--小助手
function ActivityAction_getActivityTaskInfoRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ActivityAction_getActivityTaskInfoRes:init()
	
	self.list_userActivityTaskList={} --用户活跃度信息列表

	self.list_rewardLogList={} --领取的奖励日志列表

	self.int_point=0 --用户活跃度

	self.actName = "ActivityAction_getActivityTaskInfo"
end

function ActivityAction_getActivityTaskInfoRes:getActName()
	return self.actName
end

--用户活跃度信息列表
function ActivityAction_getActivityTaskInfoRes:setList_userActivityTaskList(list_userActivityTaskList)
	self.list_userActivityTaskList = list_userActivityTaskList
end
--领取的奖励日志列表
function ActivityAction_getActivityTaskInfoRes:setList_rewardLogList(list_rewardLogList)
	self.list_rewardLogList = list_rewardLogList
end
--用户活跃度
function ActivityAction_getActivityTaskInfoRes:setInt_point(int_point)
	self.int_point = int_point
end





function ActivityAction_getActivityTaskInfoRes:encode(outputStream)
		
		self.list_userActivityTaskList = self.list_userActivityTaskList or {}
		local list_userActivityTaskListsize = #self.list_userActivityTaskList
		outputStream:WriteInt(list_userActivityTaskListsize)
		for list_userActivityTaskListi=1,list_userActivityTaskListsize do
            self.list_userActivityTaskList[list_userActivityTaskListi]:encode(outputStream)
		end		
		self.list_rewardLogList = self.list_rewardLogList or {}
		local list_rewardLogListsize = #self.list_rewardLogList
		outputStream:WriteInt(list_rewardLogListsize)
		for list_rewardLogListi=1,list_rewardLogListsize do
            self.list_rewardLogList[list_rewardLogListi]:encode(outputStream)
		end		outputStream:WriteInt(self.int_point)


end

function ActivityAction_getActivityTaskInfoRes:decode(inputStream)
	    local body = {}
		local userActivityTaskListTemp = {}
		local userActivityTaskListsize = inputStream:ReadInt()
		for userActivityTaskListi=1,userActivityTaskListsize do
            local entry = UserActivityTaskBO:New()
            table.insert(userActivityTaskListTemp,entry:decode(inputStream))

		end
		body.userActivityTaskList = userActivityTaskListTemp
		local rewardLogListTemp = {}
		local rewardLogListsize = inputStream:ReadInt()
		for rewardLogListi=1,rewardLogListsize do
            local entry = UserActivityTaskRewardBO:New()
            table.insert(rewardLogListTemp,entry:decode(inputStream))

		end
		body.rewardLogList = rewardLogListTemp
		body.point = inputStream:ReadInt()


	   return body
end