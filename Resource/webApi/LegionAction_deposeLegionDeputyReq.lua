

LegionAction_deposeLegionDeputyReq = {}

--罢免副军团长
function LegionAction_deposeLegionDeputyReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_deposeLegionDeputyReq:init()
	
	self.string_deputyUserId="" --副会长用户id

	self.actName = "LegionAction_deposeLegionDeputy"
end

function LegionAction_deposeLegionDeputyReq:getActName()
	return self.actName
end

--副会长用户id
function LegionAction_deposeLegionDeputyReq:setString_deputyUserId(string_deputyUserId)
	self.string_deputyUserId = string_deputyUserId
end





function LegionAction_deposeLegionDeputyReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_deputyUserId)


end

function LegionAction_deposeLegionDeputyReq:decode(inputStream)
	    local body = {}
		body.deputyUserId = inputStream:ReadUTFString()


	   return body
end