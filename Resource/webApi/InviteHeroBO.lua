

InviteHeroBO = {}

--酒馆英雄对象
function InviteHeroBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function InviteHeroBO:init()
	
	self.int_systemHeroId=0 --系统英雄id

	self.string_heroName="" --英雄名称

	self.actName = "InviteHeroBO"
end

function InviteHeroBO:getActName()
	return self.actName
end

--系统英雄id
function InviteHeroBO:setInt_systemHeroId(int_systemHeroId)
	self.int_systemHeroId = int_systemHeroId
end
--英雄名称
function InviteHeroBO:setString_heroName(string_heroName)
	self.string_heroName = string_heroName
end





function InviteHeroBO:encode(outputStream)
		outputStream:WriteInt(self.int_systemHeroId)

		outputStream:WriteUTFString(self.string_heroName)


end

function InviteHeroBO:decode(inputStream)
	    local body = {}
		body.systemHeroId = inputStream:ReadInt()

		body.heroName = inputStream:ReadUTFString()


	   return body
end