

TaskAction_dropTaskReq = {}

--放弃任务
function TaskAction_dropTaskReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function TaskAction_dropTaskReq:init()
	
	self.int_systemTaskId=0 --系统任务id

	self.actName = "TaskAction_dropTask"
end

function TaskAction_dropTaskReq:getActName()
	return self.actName
end

--系统任务id
function TaskAction_dropTaskReq:setInt_systemTaskId(int_systemTaskId)
	self.int_systemTaskId = int_systemTaskId
end





function TaskAction_dropTaskReq:encode(outputStream)
		outputStream:WriteInt(self.int_systemTaskId)


end

function TaskAction_dropTaskReq:decode(inputStream)
	    local body = {}
		body.systemTaskId = inputStream:ReadInt()


	   return body
end