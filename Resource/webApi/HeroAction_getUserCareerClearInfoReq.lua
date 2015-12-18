

HeroAction_getUserCareerClearInfoReq = {}

--获取用户职业解锁信息
function HeroAction_getUserCareerClearInfoReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_getUserCareerClearInfoReq:init()
	
	self.actName = "HeroAction_getUserCareerClearInfo"
end

function HeroAction_getUserCareerClearInfoReq:getActName()
	return self.actName
end






function HeroAction_getUserCareerClearInfoReq:encode(outputStream)

end

function HeroAction_getUserCareerClearInfoReq:decode(inputStream)
	    local body = {}

	   return body
end