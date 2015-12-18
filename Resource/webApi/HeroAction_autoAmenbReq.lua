

HeroAction_autoAmenbReq = {}

--自动上阵
function HeroAction_autoAmenbReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_autoAmenbReq:init()
	
	self.actName = "HeroAction_autoAmenb"
end

function HeroAction_autoAmenbReq:getActName()
	return self.actName
end






function HeroAction_autoAmenbReq:encode(outputStream)

end

function HeroAction_autoAmenbReq:decode(inputStream)
	    local body = {}

	   return body
end