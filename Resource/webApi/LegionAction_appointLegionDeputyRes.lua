

LegionAction_appointLegionDeputyRes = {}

--任命副军团长
function LegionAction_appointLegionDeputyRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_appointLegionDeputyRes:init()
	
	self.string_deputyUserId="" --晋升的用户id

	self.actName = "LegionAction_appointLegionDeputy"
end

function LegionAction_appointLegionDeputyRes:getActName()
	return self.actName
end

--晋升的用户id
function LegionAction_appointLegionDeputyRes:setString_deputyUserId(string_deputyUserId)
	self.string_deputyUserId = string_deputyUserId
end





function LegionAction_appointLegionDeputyRes:encode(outputStream)
		outputStream:WriteUTFString(self.string_deputyUserId)


end

function LegionAction_appointLegionDeputyRes:decode(inputStream)
	    local body = {}
		body.deputyUserId = inputStream:ReadUTFString()


	   return body
end