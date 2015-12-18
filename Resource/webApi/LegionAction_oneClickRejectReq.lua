

LegionAction_oneClickRejectReq = {}

--一键拒绝
function LegionAction_oneClickRejectReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_oneClickRejectReq:init()
	
	self.actName = "LegionAction_oneClickReject"
end

function LegionAction_oneClickRejectReq:getActName()
	return self.actName
end






function LegionAction_oneClickRejectReq:encode(outputStream)

end

function LegionAction_oneClickRejectReq:decode(inputStream)
	    local body = {}

	   return body
end