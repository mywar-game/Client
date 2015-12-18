

UserBossInfoBO = {}

--用户boss战的相关信息
function UserBossInfoBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserBossInfoBO:init()
	
	self.string_userId="" --用户id

	self.int_status=0 --用户的状态0死亡1活着2已复活

	self.long_dieTime=0 --用户的死亡时间（时间戳）

	self.actName = "UserBossInfoBO"
end

function UserBossInfoBO:getActName()
	return self.actName
end

--用户id
function UserBossInfoBO:setString_userId(string_userId)
	self.string_userId = string_userId
end
--用户的状态0死亡1活着2已复活
function UserBossInfoBO:setInt_status(int_status)
	self.int_status = int_status
end
--用户的死亡时间（时间戳）
function UserBossInfoBO:setLong_dieTime(long_dieTime)
	self.long_dieTime = long_dieTime
end





function UserBossInfoBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)

		outputStream:WriteInt(self.int_status)

		outputStream:WriteLong(self.long_dieTime)


end

function UserBossInfoBO:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()

		body.status = inputStream:ReadInt()

		body.dieTime = inputStream:ReadLong()


	   return body
end