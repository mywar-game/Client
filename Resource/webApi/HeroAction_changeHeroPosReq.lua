

HeroAction_changeHeroPosReq = {}

--英雄上阵
function HeroAction_changeHeroPosReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_changeHeroPosReq:init()
	
	self.string_userHeroId="" --用户英雄唯一id

	self.int_pos=0 --要上到的位置，如果为0则表示该英雄下阵

	self.actName = "HeroAction_changeHeroPos"
end

function HeroAction_changeHeroPosReq:getActName()
	return self.actName
end

--用户英雄唯一id
function HeroAction_changeHeroPosReq:setString_userHeroId(string_userHeroId)
	self.string_userHeroId = string_userHeroId
end
--要上到的位置，如果为0则表示该英雄下阵
function HeroAction_changeHeroPosReq:setInt_pos(int_pos)
	self.int_pos = int_pos
end





function HeroAction_changeHeroPosReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_userHeroId)

		outputStream:WriteInt(self.int_pos)


end

function HeroAction_changeHeroPosReq:decode(inputStream)
	    local body = {}
		body.userHeroId = inputStream:ReadUTFString()

		body.pos = inputStream:ReadInt()


	   return body
end