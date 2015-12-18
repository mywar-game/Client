

PkAction_pkFightReq = {}

--竞技场战斗
function PkAction_pkFightReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_pkFightReq:init()
	
	self.string_targetUserId="" --挑战的用户id

	self.actName = "PkAction_pkFight"
end

function PkAction_pkFightReq:getActName()
	return self.actName
end

--挑战的用户id
function PkAction_pkFightReq:setString_targetUserId(string_targetUserId)
	self.string_targetUserId = string_targetUserId
end





function PkAction_pkFightReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_targetUserId)


end

function PkAction_pkFightReq:decode(inputStream)
	    local body = {}
		body.targetUserId = inputStream:ReadUTFString()


	   return body
end