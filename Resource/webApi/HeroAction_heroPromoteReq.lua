

HeroAction_heroPromoteReq = {}

--英雄进阶
function HeroAction_heroPromoteReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_heroPromoteReq:init()
	
	self.string_userHeroId="" --用户英雄id

	self.int_proSystemHeroId=0 --进阶后的系统英雄id

	self.actName = "HeroAction_heroPromote"
end

function HeroAction_heroPromoteReq:getActName()
	return self.actName
end

--用户英雄id
function HeroAction_heroPromoteReq:setString_userHeroId(string_userHeroId)
	self.string_userHeroId = string_userHeroId
end
--进阶后的系统英雄id
function HeroAction_heroPromoteReq:setInt_proSystemHeroId(int_proSystemHeroId)
	self.int_proSystemHeroId = int_proSystemHeroId
end





function HeroAction_heroPromoteReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_userHeroId)

		outputStream:WriteInt(self.int_proSystemHeroId)


end

function HeroAction_heroPromoteReq:decode(inputStream)
	    local body = {}
		body.userHeroId = inputStream:ReadUTFString()

		body.proSystemHeroId = inputStream:ReadInt()


	   return body
end