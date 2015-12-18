

LegionAction_deposeLegionDeputyRes = {}

--罢免副军团长
function LegionAction_deposeLegionDeputyRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_deposeLegionDeputyRes:init()
	
	self.string_deputyUserId="" --副会长用户id

	self.actName = "LegionAction_deposeLegionDeputy"
end

function LegionAction_deposeLegionDeputyRes:getActName()
	return self.actName
end

--副会长用户id
function LegionAction_deposeLegionDeputyRes:setString_deputyUserId(string_deputyUserId)
	self.string_deputyUserId = string_deputyUserId
end





function LegionAction_deposeLegionDeputyRes:encode(outputStream)
		outputStream:WriteUTFString(self.string_deputyUserId)


end

function LegionAction_deposeLegionDeputyRes:decode(inputStream)
	    local body = {}
		body.deputyUserId = inputStream:ReadUTFString()


	   return body
end