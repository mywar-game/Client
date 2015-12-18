

UserBossRankBO = {}

--世界Boss排行榜对象
function UserBossRankBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserBossRankBO:init()
	
	self.int_rank=0 --排名

	self.string_userName="" --用户名

	self.long_value=0 --值

	self.actName = "UserBossRankBO"
end

function UserBossRankBO:getActName()
	return self.actName
end

--排名
function UserBossRankBO:setInt_rank(int_rank)
	self.int_rank = int_rank
end
--用户名
function UserBossRankBO:setString_userName(string_userName)
	self.string_userName = string_userName
end
--值
function UserBossRankBO:setLong_value(long_value)
	self.long_value = long_value
end





function UserBossRankBO:encode(outputStream)
		outputStream:WriteInt(self.int_rank)

		outputStream:WriteUTFString(self.string_userName)

		outputStream:WriteLong(self.long_value)


end

function UserBossRankBO:decode(inputStream)
	    local body = {}
		body.rank = inputStream:ReadInt()

		body.userName = inputStream:ReadUTFString()

		body.value = inputStream:ReadLong()


	   return body
end