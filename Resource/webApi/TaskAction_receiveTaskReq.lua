

TaskAction_receiveTaskReq = {}

--领取任务奖励
function TaskAction_receiveTaskReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function TaskAction_receiveTaskReq:init()
	
	self.int_systemTaskId=0 --系统任务id

	self.actName = "TaskAction_receiveTask"
end

function TaskAction_receiveTaskReq:getActName()
	return self.actName
end

--系统任务id
function TaskAction_receiveTaskReq:setInt_systemTaskId(int_systemTaskId)
	self.int_systemTaskId = int_systemTaskId
end





function TaskAction_receiveTaskReq:encode(outputStream)
		outputStream:WriteInt(self.int_systemTaskId)


end

function TaskAction_receiveTaskReq:decode(inputStream)
	    local body = {}
		body.systemTaskId = inputStream:ReadInt()


	   return body
end