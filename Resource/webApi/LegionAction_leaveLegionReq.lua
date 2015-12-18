

LegionAction_leaveLegionReq = {}

--离开公会
function LegionAction_leaveLegionReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_leaveLegionReq:init()
	
	self.actName = "LegionAction_leaveLegion"
end

function LegionAction_leaveLegionReq:getActName()
	return self.actName
end






function LegionAction_leaveLegionReq:encode(outputStream)

end

function LegionAction_leaveLegionReq:decode(inputStream)
	    local body = {}

	   return body
end