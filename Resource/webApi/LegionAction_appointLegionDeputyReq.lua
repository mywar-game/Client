

LegionAction_appointLegionDeputyReq = {}

--任命副军团长
function LegionAction_appointLegionDeputyReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_appointLegionDeputyReq:init()
	
	self.string_deputyUserId="" --晋升的用户id

	self.actName = "LegionAction_appointLegionDeputy"
end

function LegionAction_appointLegionDeputyReq:getActName()
	return self.actName
end

--晋升的用户id
function LegionAction_appointLegionDeputyReq:setString_deputyUserId(string_deputyUserId)
	self.string_deputyUserId = string_deputyUserId
end





function LegionAction_appointLegionDeputyReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_deputyUserId)


end

function LegionAction_appointLegionDeputyReq:decode(inputStream)
	    local body = {}
		body.deputyUserId = inputStream:ReadUTFString()


	   return body
end