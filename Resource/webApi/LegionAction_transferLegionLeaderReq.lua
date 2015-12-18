

LegionAction_transferLegionLeaderReq = {}

--转让军团长
function LegionAction_transferLegionLeaderReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_transferLegionLeaderReq:init()
	
	self.string_beLeaderUserId="" --转成副会长用户id

	self.actName = "LegionAction_transferLegionLeader"
end

function LegionAction_transferLegionLeaderReq:getActName()
	return self.actName
end

--转成副会长用户id
function LegionAction_transferLegionLeaderReq:setString_beLeaderUserId(string_beLeaderUserId)
	self.string_beLeaderUserId = string_beLeaderUserId
end





function LegionAction_transferLegionLeaderReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_beLeaderUserId)


end

function LegionAction_transferLegionLeaderReq:decode(inputStream)
	    local body = {}
		body.beLeaderUserId = inputStream:ReadUTFString()


	   return body
end