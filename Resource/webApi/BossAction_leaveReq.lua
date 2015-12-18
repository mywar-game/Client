

BossAction_leaveReq = {}

--用户离开boss战
function BossAction_leaveReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function BossAction_leaveReq:init()
	
	self.actName = "BossAction_leave"
end

function BossAction_leaveReq:getActName()
	return self.actName
end






function BossAction_leaveReq:encode(outputStream)

end

function BossAction_leaveReq:decode(inputStream)
	    local body = {}

	   return body
end