

TaskAction_oneClickRefreshRes = {}

--一键刷新
function TaskAction_oneClickRefreshRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function TaskAction_oneClickRefreshRes:init()
	
	self.list_userDailyTaskInfoList={} --用户日常任务列表

	self.actName = "TaskAction_oneClickRefresh"
end

function TaskAction_oneClickRefreshRes:getActName()
	return self.actName
end

--用户日常任务列表
function TaskAction_oneClickRefreshRes:setList_userDailyTaskInfoList(list_userDailyTaskInfoList)
	self.list_userDailyTaskInfoList = list_userDailyTaskInfoList
end





function TaskAction_oneClickRefreshRes:encode(outputStream)
		
		self.list_userDailyTaskInfoList = self.list_userDailyTaskInfoList or {}
		local list_userDailyTaskInfoListsize = #self.list_userDailyTaskInfoList
		outputStream:WriteInt(list_userDailyTaskInfoListsize)
		for list_userDailyTaskInfoListi=1,list_userDailyTaskInfoListsize do
            self.list_userDailyTaskInfoList[list_userDailyTaskInfoListi]:encode(outputStream)
		end
end

function TaskAction_oneClickRefreshRes:decode(inputStream)
	    local body = {}
		local userDailyTaskInfoListTemp = {}
		local userDailyTaskInfoListsize = inputStream:ReadInt()
		for userDailyTaskInfoListi=1,userDailyTaskInfoListsize do
            local entry = UserDailyTaskInfoBO:New()
            table.insert(userDailyTaskInfoListTemp,entry:decode(inputStream))

		end
		body.userDailyTaskInfoList = userDailyTaskInfoListTemp

	   return body
end