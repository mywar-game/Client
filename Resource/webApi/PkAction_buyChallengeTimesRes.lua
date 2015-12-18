

PkAction_buyChallengeTimesRes = {}

--购买挑战次数
function PkAction_buyChallengeTimesRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_buyChallengeTimesRes:init()
	
	self.actName = "PkAction_buyChallengeTimes"
end

function PkAction_buyChallengeTimesRes:getActName()
	return self.actName
end






function PkAction_buyChallengeTimesRes:encode(outputStream)

end

function PkAction_buyChallengeTimesRes:decode(inputStream)
	    local body = {}

	   return body
end