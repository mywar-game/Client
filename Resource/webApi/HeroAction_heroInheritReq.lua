

HeroAction_heroInheritReq = {}

--英雄传承
function HeroAction_heroInheritReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_heroInheritReq:init()
	
	self.string_userHeroId="" --传承者

	self.string_targetUserHeroId="" --承受者

	self.actName = "HeroAction_heroInherit"
end

function HeroAction_heroInheritReq:getActName()
	return self.actName
end

--传承者
function HeroAction_heroInheritReq:setString_userHeroId(string_userHeroId)
	self.string_userHeroId = string_userHeroId
end
--承受者
function HeroAction_heroInheritReq:setString_targetUserHeroId(string_targetUserHeroId)
	self.string_targetUserHeroId = string_targetUserHeroId
end





function HeroAction_heroInheritReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_userHeroId)

		outputStream:WriteUTFString(self.string_targetUserHeroId)


end

function HeroAction_heroInheritReq:decode(inputStream)
	    local body = {}
		body.userHeroId = inputStream:ReadUTFString()

		body.targetUserHeroId = inputStream:ReadUTFString()


	   return body
end