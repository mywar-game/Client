

UserRankBO = {}

--用户排行榜对象
function UserRankBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserRankBO:init()
	
	self.string_userId="" --用户id

	self.int_rank=0 --排名

	self.string_userName="" --用户名

	self.int_systemHeroId=0 --队长头像

	self.long_value=0 --排行榜的值

	self.string_leginName="" --军团名称

	self.actName = "UserRankBO"
end

function UserRankBO:getActName()
	return self.actName
end

--用户id
function UserRankBO:setString_userId(string_userId)
	self.string_userId = string_userId
end
--排名
function UserRankBO:setInt_rank(int_rank)
	self.int_rank = int_rank
end
--用户名
function UserRankBO:setString_userName(string_userName)
	self.string_userName = string_userName
end
--队长头像
function UserRankBO:setInt_systemHeroId(int_systemHeroId)
	self.int_systemHeroId = int_systemHeroId
end
--排行榜的值
function UserRankBO:setLong_value(long_value)
	self.long_value = long_value
end
--军团名称
function UserRankBO:setString_leginName(string_leginName)
	self.string_leginName = string_leginName
end





function UserRankBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)

		outputStream:WriteInt(self.int_rank)

		outputStream:WriteUTFString(self.string_userName)

		outputStream:WriteInt(self.int_systemHeroId)

		outputStream:WriteLong(self.long_value)

		outputStream:WriteUTFString(self.string_leginName)


end

function UserRankBO:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()

		body.rank = inputStream:ReadInt()

		body.userName = inputStream:ReadUTFString()

		body.systemHeroId = inputStream:ReadInt()

		body.value = inputStream:ReadLong()

		body.leginName = inputStream:ReadUTFString()


	   return body
end