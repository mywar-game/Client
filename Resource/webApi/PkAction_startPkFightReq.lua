

PkAction_startPkFightReq = {}

--开始竞技场战斗
function PkAction_startPkFightReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_startPkFightReq:init()
	
	self.string_targetUserId="" --挑战的用户id

	self.actName = "PkAction_startPkFight"
end

function PkAction_startPkFightReq:getActName()
	return self.actName
end

--挑战的用户id
function PkAction_startPkFightReq:setString_targetUserId(string_targetUserId)
	self.string_targetUserId = string_targetUserId
end





function PkAction_startPkFightReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_targetUserId)


end

function PkAction_startPkFightReq:decode(inputStream)
	    local body = {}
		body.targetUserId = inputStream:ReadUTFString()


	   return body
end