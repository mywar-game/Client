

PkAction_resetWaitingTimeRes = {}

--重置等待时间
function PkAction_resetWaitingTimeRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_resetWaitingTimeRes:init()
	
	self.actName = "PkAction_resetWaitingTime"
end

function PkAction_resetWaitingTimeRes:getActName()
	return self.actName
end






function PkAction_resetWaitingTimeRes:encode(outputStream)

end

function PkAction_resetWaitingTimeRes:decode(inputStream)
	    local body = {}

	   return body
end