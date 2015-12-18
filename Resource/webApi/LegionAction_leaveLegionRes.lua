

LegionAction_leaveLegionRes = {}

--离开公会
function LegionAction_leaveLegionRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_leaveLegionRes:init()
	
	self.actName = "LegionAction_leaveLegion"
end

function LegionAction_leaveLegionRes:getActName()
	return self.actName
end






function LegionAction_leaveLegionRes:encode(outputStream)

end

function LegionAction_leaveLegionRes:decode(inputStream)
	    local body = {}

	   return body
end