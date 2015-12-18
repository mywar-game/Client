

TaskAction_addTaskReq = {}

--接受任务
function TaskAction_addTaskReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function TaskAction_addTaskReq:init()
	
	self.int_systemTaskId=0 --系统任务id

	self.int_star=0 --星数

	self.actName = "TaskAction_addTask"
end

function TaskAction_addTaskReq:getActName()
	return self.actName
end

--系统任务id
function TaskAction_addTaskReq:setInt_systemTaskId(int_systemTaskId)
	self.int_systemTaskId = int_systemTaskId
end
--星数
function TaskAction_addTaskReq:setInt_star(int_star)
	self.int_star = int_star
end





function TaskAction_addTaskReq:encode(outputStream)
		outputStream:WriteInt(self.int_systemTaskId)

		outputStream:WriteInt(self.int_star)


end

function TaskAction_addTaskReq:decode(inputStream)
	    local body = {}
		body.systemTaskId = inputStream:ReadInt()

		body.star = inputStream:ReadInt()


	   return body
end