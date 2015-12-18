

TaskAction_dropTaskRes = {}

--放弃任务
function TaskAction_dropTaskRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function TaskAction_dropTaskRes:init()
	
	self.actName = "TaskAction_dropTask"
end

function TaskAction_dropTaskRes:getActName()
	return self.actName
end






function TaskAction_dropTaskRes:encode(outputStream)

end

function TaskAction_dropTaskRes:decode(inputStream)
	    local body = {}

	   return body
end