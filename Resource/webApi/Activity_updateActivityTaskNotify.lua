

Activity_updateActivityTaskNotify = {}

--活跃度信息变更推送接口
function Activity_updateActivityTaskNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function Activity_updateActivityTaskNotify:init()
	
	self.list_updateUserActivityTaskList={} --需要更新的用户活跃度信息

	self.int_point=0 --用户活跃度

	self.actName = "Activity_updateActivityTask"
end

function Activity_updateActivityTaskNotify:getActName()
	return self.actName
end

--需要更新的用户活跃度信息
function Activity_updateActivityTaskNotify:setList_updateUserActivityTaskList(list_updateUserActivityTaskList)
	self.list_updateUserActivityTaskList = list_updateUserActivityTaskList
end
--用户活跃度
function Activity_updateActivityTaskNotify:setInt_point(int_point)
	self.int_point = int_point
end





function Activity_updateActivityTaskNotify:encode(outputStream)
		
		self.list_updateUserActivityTaskList = self.list_updateUserActivityTaskList or {}
		local list_updateUserActivityTaskListsize = #self.list_updateUserActivityTaskList
		outputStream:WriteInt(list_updateUserActivityTaskListsize)
		for list_updateUserActivityTaskListi=1,list_updateUserActivityTaskListsize do
            self.list_updateUserActivityTaskList[list_updateUserActivityTaskListi]:encode(outputStream)
		end		outputStream:WriteInt(self.int_point)


end

function Activity_updateActivityTaskNotify:decode(inputStream)
	    local body = {}
		local updateUserActivityTaskListTemp = {}
		local updateUserActivityTaskListsize = inputStream:ReadInt()
		for updateUserActivityTaskListi=1,updateUserActivityTaskListsize do
            local entry = UserActivityTaskRewardBO:New()
            table.insert(updateUserActivityTaskListTemp,entry:decode(inputStream))

		end
		body.updateUserActivityTaskList = updateUserActivityTaskListTemp
		body.point = inputStream:ReadInt()


	   return body
end