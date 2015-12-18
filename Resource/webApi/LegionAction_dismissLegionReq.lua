

LegionAction_dismissLegionReq = {}

--解散公会
function LegionAction_dismissLegionReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_dismissLegionReq:init()
	
	self.actName = "LegionAction_dismissLegion"
end

function LegionAction_dismissLegionReq:getActName()
	return self.actName
end






function LegionAction_dismissLegionReq:encode(outputStream)

end

function LegionAction_dismissLegionReq:decode(inputStream)
	    local body = {}

	   return body
end