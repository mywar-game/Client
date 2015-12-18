

LegionAction_dismissLegionRes = {}

--解散公会
function LegionAction_dismissLegionRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_dismissLegionRes:init()
	
	self.actName = "LegionAction_dismissLegion"
end

function LegionAction_dismissLegionRes:getActName()
	return self.actName
end






function LegionAction_dismissLegionRes:encode(outputStream)

end

function LegionAction_dismissLegionRes:decode(inputStream)
	    local body = {}

	   return body
end