

PrestigeAction_inviteHeroReq = {}

--邀请英雄
function PrestigeAction_inviteHeroReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PrestigeAction_inviteHeroReq:init()
	
	self.int_systemHeroId=0 --英雄系统id

	self.string_heroName="" --英雄名字

	self.actName = "PrestigeAction_inviteHero"
end

function PrestigeAction_inviteHeroReq:getActName()
	return self.actName
end

--英雄系统id
function PrestigeAction_inviteHeroReq:setInt_systemHeroId(int_systemHeroId)
	self.int_systemHeroId = int_systemHeroId
end
--英雄名字
function PrestigeAction_inviteHeroReq:setString_heroName(string_heroName)
	self.string_heroName = string_heroName
end





function PrestigeAction_inviteHeroReq:encode(outputStream)
		outputStream:WriteInt(self.int_systemHeroId)

		outputStream:WriteUTFString(self.string_heroName)


end

function PrestigeAction_inviteHeroReq:decode(inputStream)
	    local body = {}
		body.systemHeroId = inputStream:ReadInt()

		body.heroName = inputStream:ReadUTFString()


	   return body
end