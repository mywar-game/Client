

BossAction_leaveRes = {}

--用户离开boss战
function BossAction_leaveRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function BossAction_leaveRes:init()
	
	self.actName = "BossAction_leave"
end

function BossAction_leaveRes:getActName()
	return self.actName
end






function BossAction_leaveRes:encode(outputStream)

end

function BossAction_leaveRes:decode(inputStream)
	    local body = {}

	   return body
end