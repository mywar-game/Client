

HeroAction_changeTeamLeaderRes = {}

--更换队长
function HeroAction_changeTeamLeaderRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_changeTeamLeaderRes:init()
	
	self.actName = "HeroAction_changeTeamLeader"
end

function HeroAction_changeTeamLeaderRes:getActName()
	return self.actName
end






function HeroAction_changeTeamLeaderRes:encode(outputStream)

end

function HeroAction_changeTeamLeaderRes:decode(inputStream)
	    local body = {}

	   return body
end