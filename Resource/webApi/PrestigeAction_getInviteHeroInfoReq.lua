

PrestigeAction_getInviteHeroInfoReq = {}

--获取用户酒馆招募英雄的信息
function PrestigeAction_getInviteHeroInfoReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PrestigeAction_getInviteHeroInfoReq:init()
	
	self.actName = "PrestigeAction_getInviteHeroInfo"
end

function PrestigeAction_getInviteHeroInfoReq:getActName()
	return self.actName
end






function PrestigeAction_getInviteHeroInfoReq:encode(outputStream)

end

function PrestigeAction_getInviteHeroInfoReq:decode(inputStream)
	    local body = {}

	   return body
end