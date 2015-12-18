

TaskAction_commitTaskRes = {}

--提交任务(有些需要客户端提交的任务，如-寻找npc)
function TaskAction_commitTaskRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function TaskAction_commitTaskRes:init()
	
	self.int_systemTaskId=0 --系统任务id

	self.int_status=0 --状态

	self.actName = "TaskAction_commitTask"
end

function TaskAction_commitTaskRes:getActName()
	return self.actName
end

--系统任务id
function TaskAction_commitTaskRes:setInt_systemTaskId(int_systemTaskId)
	self.int_systemTaskId = int_systemTaskId
end
--状态
function TaskAction_commitTaskRes:setInt_status(int_status)
	self.int_status = int_status
end





function TaskAction_commitTaskRes:encode(outputStream)
		outputStream:WriteInt(self.int_systemTaskId)

		outputStream:WriteInt(self.int_status)


end

function TaskAction_commitTaskRes:decode(inputStream)
	    local body = {}
		body.systemTaskId = inputStream:ReadInt()

		body.status = inputStream:ReadInt()


	   return body
end