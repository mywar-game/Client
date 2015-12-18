

PkChallengerBO = {}

--可挑战者对象
function PkChallengerBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkChallengerBO:init()
	
	self.string_userId="" --用户id

	self.string_challengerName="" --可挑战者名称

	self.int_systemHeroId=0 --系统英雄id

	self.int_rank=0 --排名

	self.int_power=0 --总装等

	self.actName = "PkChallengerBO"
end

function PkChallengerBO:getActName()
	return self.actName
end

--用户id
function PkChallengerBO:setString_userId(string_userId)
	self.string_userId = string_userId
end
--可挑战者名称
function PkChallengerBO:setString_challengerName(string_challengerName)
	self.string_challengerName = string_challengerName
end
--系统英雄id
function PkChallengerBO:setInt_systemHeroId(int_systemHeroId)
	self.int_systemHeroId = int_systemHeroId
end
--排名
function PkChallengerBO:setInt_rank(int_rank)
	self.int_rank = int_rank
end
--总装等
function PkChallengerBO:setInt_power(int_power)
	self.int_power = int_power
end





function PkChallengerBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)

		outputStream:WriteUTFString(self.string_challengerName)

		outputStream:WriteInt(self.int_systemHeroId)

		outputStream:WriteInt(self.int_rank)

		outputStream:WriteInt(self.int_power)


end

function PkChallengerBO:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()

		body.challengerName = inputStream:ReadUTFString()

		body.systemHeroId = inputStream:ReadInt()

		body.rank = inputStream:ReadInt()

		body.power = inputStream:ReadInt()


	   return body
end