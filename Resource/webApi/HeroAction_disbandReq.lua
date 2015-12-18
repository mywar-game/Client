

HeroAction_disbandReq = {}

--遣散英雄
function HeroAction_disbandReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_disbandReq:init()
	
	self.string_userHeroId="" --用户英雄id

	self.actName = "HeroAction_disband"
end

function HeroAction_disbandReq:getActName()
	return self.actName
end

--用户英雄id
function HeroAction_disbandReq:setString_userHeroId(string_userHeroId)
	self.string_userHeroId = string_userHeroId
end





function HeroAction_disbandReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_userHeroId)


end

function HeroAction_disbandReq:decode(inputStream)
	    local body = {}
		body.userHeroId = inputStream:ReadUTFString()


	   return body
end