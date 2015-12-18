

TaskAction_toolOpenTaskReq = {}

--道具开启任务
function TaskAction_toolOpenTaskReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function TaskAction_toolOpenTaskReq:init()
	
	self.int_toolId=0 --道具id

	self.actName = "TaskAction_toolOpenTask"
end

function TaskAction_toolOpenTaskReq:getActName()
	return self.actName
end

--道具id
function TaskAction_toolOpenTaskReq:setInt_toolId(int_toolId)
	self.int_toolId = int_toolId
end





function TaskAction_toolOpenTaskReq:encode(outputStream)
		outputStream:WriteInt(self.int_toolId)


end

function TaskAction_toolOpenTaskReq:decode(inputStream)
	    local body = {}
		body.toolId = inputStream:ReadInt()


	   return body
end