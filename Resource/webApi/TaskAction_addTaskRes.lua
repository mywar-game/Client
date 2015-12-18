

TaskAction_addTaskRes = {}

--接受任务
function TaskAction_addTaskRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function TaskAction_addTaskRes:init()
	
	self.actName = "TaskAction_addTask"
end

function TaskAction_addTaskRes:getActName()
	return self.actName
end






function TaskAction_addTaskRes:encode(outputStream)

end

function TaskAction_addTaskRes:decode(inputStream)
	    local body = {}

	   return body
end