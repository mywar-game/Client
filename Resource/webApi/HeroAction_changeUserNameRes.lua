

HeroAction_changeUserNameRes = {}

--更改昵称
function HeroAction_changeUserNameRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_changeUserNameRes:init()
	
	self.actName = "HeroAction_changeUserName"
end

function HeroAction_changeUserNameRes:getActName()
	return self.actName
end






function HeroAction_changeUserNameRes:encode(outputStream)

end

function HeroAction_changeUserNameRes:decode(inputStream)
	    local body = {}

	   return body
end