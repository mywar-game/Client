

PkAction_buyChallengeTimesReq = {}

--购买挑战次数
function PkAction_buyChallengeTimesReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_buyChallengeTimesReq:init()
	
	self.actName = "PkAction_buyChallengeTimes"
end

function PkAction_buyChallengeTimesReq:getActName()
	return self.actName
end






function PkAction_buyChallengeTimesReq:encode(outputStream)

end

function PkAction_buyChallengeTimesReq:decode(inputStream)
	    local body = {}

	   return body
end