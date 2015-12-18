

TaskAction_commitTaskReq = {}

--提交任务(有些需要客户端提交的任务，如-寻找npc)
function TaskAction_commitTaskReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function TaskAction_commitTaskReq:init()
	
	self.int_systemTaskId=0 --系统任务id

	self.int_times=0 --完成次数

	self.actName = "TaskAction_commitTask"
end

function TaskAction_commitTaskReq:getActName()
	return self.actName
end

--系统任务id
function TaskAction_commitTaskReq:setInt_systemTaskId(int_systemTaskId)
	self.int_systemTaskId = int_systemTaskId
end
--完成次数
function TaskAction_commitTaskReq:setInt_times(int_times)
	self.int_times = int_times
end





function TaskAction_commitTaskReq:encode(outputStream)
		outputStream:WriteInt(self.int_systemTaskId)

		outputStream:WriteInt(self.int_times)


end

function TaskAction_commitTaskReq:decode(inputStream)
	    local body = {}
		body.systemTaskId = inputStream:ReadInt()

		body.times = inputStream:ReadInt()


	   return body
end