

PkAction_refreshChallengerReq = {}

--换一批
function PkAction_refreshChallengerReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_refreshChallengerReq:init()
	
	self.actName = "PkAction_refreshChallenger"
end

function PkAction_refreshChallengerReq:getActName()
	return self.actName
end






function PkAction_refreshChallengerReq:encode(outputStream)

end

function PkAction_refreshChallengerReq:decode(inputStream)
	    local body = {}

	   return body
end