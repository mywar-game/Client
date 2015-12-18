

LegionAction_oneClickRejectRes = {}

--一键拒绝
function LegionAction_oneClickRejectRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_oneClickRejectRes:init()
	
	self.actName = "LegionAction_oneClickReject"
end

function LegionAction_oneClickRejectRes:getActName()
	return self.actName
end






function LegionAction_oneClickRejectRes:encode(outputStream)

end

function LegionAction_oneClickRejectRes:decode(inputStream)
	    local body = {}

	   return body
end