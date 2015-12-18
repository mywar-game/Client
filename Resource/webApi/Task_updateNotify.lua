

Task_updateNotify = {}

--任务状态变更推送接口
function Task_updateNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function Task_updateNotify:init()
	
	self.list_updateUserTaskList={} --需要更新的用户任务信息，不存在就添加，存在就覆盖

	self.actName = "Task_update"
end

function Task_updateNotify:getActName()
	return self.actName
end

--需要更新的用户任务信息，不存在就添加，存在就覆盖
function Task_updateNotify:setList_updateUserTaskList(list_updateUserTaskList)
	self.list_updateUserTaskList = list_updateUserTaskList
end





function Task_updateNotify:encode(outputStream)
		
		self.list_updateUserTaskList = self.list_updateUserTaskList or {}
		local list_updateUserTaskListsize = #self.list_updateUserTaskList
		outputStream:WriteInt(list_updateUserTaskListsize)
		for list_updateUserTaskListi=1,list_updateUserTaskListsize do
            self.list_updateUserTaskList[list_updateUserTaskListi]:encode(outputStream)
		end
end

function Task_updateNotify:decode(inputStream)
	    local body = {}
		local updateUserTaskListTemp = {}
		local updateUserTaskListsize = inputStream:ReadInt()
		for updateUserTaskListi=1,updateUserTaskListsize do
            local entry = UserTaskBO:New()
            table.insert(updateUserTaskListTemp,entry:decode(inputStream))

		end
		body.updateUserTaskList = updateUserTaskListTemp

	   return body
end