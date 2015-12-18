

UserMessageInfoBO = {}

--用户留言信息对象
function UserMessageInfoBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserMessageInfoBO:init()
	
	self.string_userId="" --用户id

	self.string_userName="" --用户名称

	self.string_content="" --留言内容

	self.long_time=0 --留言时间

	self.int_systemHeroId=0 --系统英雄id

	self.actName = "UserMessageInfoBO"
end

function UserMessageInfoBO:getActName()
	return self.actName
end

--用户id
function UserMessageInfoBO:setString_userId(string_userId)
	self.string_userId = string_userId
end
--用户名称
function UserMessageInfoBO:setString_userName(string_userName)
	self.string_userName = string_userName
end
--留言内容
function UserMessageInfoBO:setString_content(string_content)
	self.string_content = string_content
end
--留言时间
function UserMessageInfoBO:setLong_time(long_time)
	self.long_time = long_time
end
--系统英雄id
function UserMessageInfoBO:setInt_systemHeroId(int_systemHeroId)
	self.int_systemHeroId = int_systemHeroId
end





function UserMessageInfoBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)

		outputStream:WriteUTFString(self.string_userName)

		outputStream:WriteUTFString(self.string_content)

		outputStream:WriteLong(self.long_time)

		outputStream:WriteInt(self.int_systemHeroId)


end

function UserMessageInfoBO:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()

		body.userName = inputStream:ReadUTFString()

		body.content = inputStream:ReadUTFString()

		body.time = inputStream:ReadLong()

		body.systemHeroId = inputStream:ReadInt()


	   return body
end