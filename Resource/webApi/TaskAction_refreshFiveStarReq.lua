

TaskAction_refreshFiveStarReq = {}

--刷新五星任务
function TaskAction_refreshFiveStarReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function TaskAction_refreshFiveStarReq:init()
	
	self.actName = "TaskAction_refreshFiveStar"
end

function TaskAction_refreshFiveStarReq:getActName()
	return self.actName
end






function TaskAction_refreshFiveStarReq:encode(outputStream)

end

function TaskAction_refreshFiveStarReq:decode(inputStream)
	    local body = {}

	   return body
end