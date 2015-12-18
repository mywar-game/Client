

LegionAction_fireLegionMemberRes = {}

--开除会员
function LegionAction_fireLegionMemberRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_fireLegionMemberRes:init()
	
	self.string_fireUserId="" --开除的用户id

	self.actName = "LegionAction_fireLegionMember"
end

function LegionAction_fireLegionMemberRes:getActName()
	return self.actName
end

--开除的用户id
function LegionAction_fireLegionMemberRes:setString_fireUserId(string_fireUserId)
	self.string_fireUserId = string_fireUserId
end





function LegionAction_fireLegionMemberRes:encode(outputStream)
		outputStream:WriteUTFString(self.string_fireUserId)


end

function LegionAction_fireLegionMemberRes:decode(inputStream)
	    local body = {}
		body.fireUserId = inputStream:ReadUTFString()


	   return body
end