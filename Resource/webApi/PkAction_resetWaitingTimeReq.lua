

PkAction_resetWaitingTimeReq = {}

--重置等待时间
function PkAction_resetWaitingTimeReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_resetWaitingTimeReq:init()
	
	self.actName = "PkAction_resetWaitingTime"
end

function PkAction_resetWaitingTimeReq:getActName()
	return self.actName
end






function PkAction_resetWaitingTimeReq:encode(outputStream)

end

function PkAction_resetWaitingTimeReq:decode(inputStream)
	    local body = {}

	   return body
end