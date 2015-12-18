

LegionAction_transferLegionLeaderRes = {}

--转让军团长
function LegionAction_transferLegionLeaderRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_transferLegionLeaderRes:init()
	
	self.string_beLeaderUserId="" --转成会长用户id

	self.actName = "LegionAction_transferLegionLeader"
end

function LegionAction_transferLegionLeaderRes:getActName()
	return self.actName
end

--转成会长用户id
function LegionAction_transferLegionLeaderRes:setString_beLeaderUserId(string_beLeaderUserId)
	self.string_beLeaderUserId = string_beLeaderUserId
end





function LegionAction_transferLegionLeaderRes:encode(outputStream)
		outputStream:WriteUTFString(self.string_beLeaderUserId)


end

function LegionAction_transferLegionLeaderRes:decode(inputStream)
	    local body = {}
		body.beLeaderUserId = inputStream:ReadUTFString()


	   return body
end