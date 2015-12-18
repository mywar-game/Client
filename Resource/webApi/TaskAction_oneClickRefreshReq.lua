

TaskAction_oneClickRefreshReq = {}

--一键刷新
function TaskAction_oneClickRefreshReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function TaskAction_oneClickRefreshReq:init()
	
	self.actName = "TaskAction_oneClickRefresh"
end

function TaskAction_oneClickRefreshReq:getActName()
	return self.actName
end






function TaskAction_oneClickRefreshReq:encode(outputStream)

end

function TaskAction_oneClickRefreshReq:decode(inputStream)
	    local body = {}

	   return body
end