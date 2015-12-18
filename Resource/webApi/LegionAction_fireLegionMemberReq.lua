

LegionAction_fireLegionMemberReq = {}

--开除会员
function LegionAction_fireLegionMemberReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_fireLegionMemberReq:init()
	
	self.string_fireUserId="" --开除的用户id

	self.actName = "LegionAction_fireLegionMember"
end

function LegionAction_fireLegionMemberReq:getActName()
	return self.actName
end

--开除的用户id
function LegionAction_fireLegionMemberReq:setString_fireUserId(string_fireUserId)
	self.string_fireUserId = string_fireUserId
end





function LegionAction_fireLegionMemberReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_fireUserId)


end

function LegionAction_fireLegionMemberReq:decode(inputStream)
	    local body = {}
		body.fireUserId = inputStream:ReadUTFString()


	   return body
end