

TaskAction_getUserDailyTaskInfoRes = {}

--获取用户日常任务信息
function TaskAction_getUserDailyTaskInfoRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function TaskAction_getUserDailyTaskInfoRes:init()
	
	self.int_remainderTimes=0 --剩余次数

	self.list_userDailyTaskInfoList={} --用户日常任务列表

	self.actName = "TaskAction_getUserDailyTaskInfo"
end

function TaskAction_getUserDailyTaskInfoRes:getActName()
	return self.actName
end

--剩余次数
function TaskAction_getUserDailyTaskInfoRes:setInt_remainderTimes(int_remainderTimes)
	self.int_remainderTimes = int_remainderTimes
end
--用户日常任务列表
function TaskAction_getUserDailyTaskInfoRes:setList_userDailyTaskInfoList(list_userDailyTaskInfoList)
	self.list_userDailyTaskInfoList = list_userDailyTaskInfoList
end





function TaskAction_getUserDailyTaskInfoRes:encode(outputStream)
		outputStream:WriteInt(self.int_remainderTimes)

		
		self.list_userDailyTaskInfoList = self.list_userDailyTaskInfoList or {}
		local list_userDailyTaskInfoListsize = #self.list_userDailyTaskInfoList
		outputStream:WriteInt(list_userDailyTaskInfoListsize)
		for list_userDailyTaskInfoListi=1,list_userDailyTaskInfoListsize do
            self.list_userDailyTaskInfoList[list_userDailyTaskInfoListi]:encode(outputStream)
		end
end

function TaskAction_getUserDailyTaskInfoRes:decode(inputStream)
	    local body = {}
		body.remainderTimes = inputStream:ReadInt()

		local userDailyTaskInfoListTemp = {}
		local userDailyTaskInfoListsize = inputStream:ReadInt()
		for userDailyTaskInfoListi=1,userDailyTaskInfoListsize do
            local entry = UserDailyTaskInfoBO:New()
            table.insert(userDailyTaskInfoListTemp,entry:decode(inputStream))

		end
		body.userDailyTaskInfoList = userDailyTaskInfoListTemp

	   return body
end