

TaskAction_toolOpenTaskRes = {}

--道具开启任务
function TaskAction_toolOpenTaskRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function TaskAction_toolOpenTaskRes:init()
	
	self.int_systemTaskId=0 --系统任务id

	self.actName = "TaskAction_toolOpenTask"
end

function TaskAction_toolOpenTaskRes:getActName()
	return self.actName
end

--系统任务id
function TaskAction_toolOpenTaskRes:setInt_systemTaskId(int_systemTaskId)
	self.int_systemTaskId = int_systemTaskId
end





function TaskAction_toolOpenTaskRes:encode(outputStream)
		outputStream:WriteInt(self.int_systemTaskId)


end

function TaskAction_toolOpenTaskRes:decode(inputStream)
	    local body = {}
		body.systemTaskId = inputStream:ReadInt()


	   return body
end