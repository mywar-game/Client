

HeroAction_disbandRes = {}

--遣散英雄
function HeroAction_disbandRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_disbandRes:init()
	
	self.actName = "HeroAction_disband"
end

function HeroAction_disbandRes:getActName()
	return self.actName
end






function HeroAction_disbandRes:encode(outputStream)

end

function HeroAction_disbandRes:decode(inputStream)
	    local body = {}

	   return body
end