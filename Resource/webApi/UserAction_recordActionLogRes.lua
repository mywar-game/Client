

UserAction_recordActionLogRes = {}

--记录打点日志
function UserAction_recordActionLogRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserAction_recordActionLogRes:init()
	
	self.actName = "UserAction_recordActionLog"
end

function UserAction_recordActionLogRes:getActName()
	return self.actName
end






function UserAction_recordActionLogRes:encode(outputStream)

end

function UserAction_recordActionLogRes:decode(inputStream)
	    local body = {}

	   return body
end