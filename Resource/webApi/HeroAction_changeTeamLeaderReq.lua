

HeroAction_changeTeamLeaderReq = {}

--更换队长
function HeroAction_changeTeamLeaderReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_changeTeamLeaderReq:init()
	
	self.string_userHeroId="" --更换为队长的用户英雄id

	self.actName = "HeroAction_changeTeamLeader"
end

function HeroAction_changeTeamLeaderReq:getActName()
	return self.actName
end

--更换为队长的用户英雄id
function HeroAction_changeTeamLeaderReq:setString_userHeroId(string_userHeroId)
	self.string_userHeroId = string_userHeroId
end





function HeroAction_changeTeamLeaderReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_userHeroId)


end

function HeroAction_changeTeamLeaderReq:decode(inputStream)
	    local body = {}
		body.userHeroId = inputStream:ReadUTFString()


	   return body
end