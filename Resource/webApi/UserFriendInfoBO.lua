

UserFriendInfoBO = {}

--用户好友信息对象
function UserFriendInfoBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserFriendInfoBO:init()
	
	self.int_isOnline=0 --是否在线（0离线1在线）

	self.string_userId="" --好友用户id

	self.string_name="" --好友名称

	self.int_camp=0 --阵营

	self.int_level=0 --等级

	self.int_effective=0 --战斗力

	self.int_systemHeroId=0 --好友队长的英雄id

	self.actName = "UserFriendInfoBO"
end

function UserFriendInfoBO:getActName()
	return self.actName
end

--是否在线（0离线1在线）
function UserFriendInfoBO:setInt_isOnline(int_isOnline)
	self.int_isOnline = int_isOnline
end
--好友用户id
function UserFriendInfoBO:setString_userId(string_userId)
	self.string_userId = string_userId
end
--好友名称
function UserFriendInfoBO:setString_name(string_name)
	self.string_name = string_name
end
--阵营
function UserFriendInfoBO:setInt_camp(int_camp)
	self.int_camp = int_camp
end
--等级
function UserFriendInfoBO:setInt_level(int_level)
	self.int_level = int_level
end
--战斗力
function UserFriendInfoBO:setInt_effective(int_effective)
	self.int_effective = int_effective
end
--好友队长的英雄id
function UserFriendInfoBO:setInt_systemHeroId(int_systemHeroId)
	self.int_systemHeroId = int_systemHeroId
end





function UserFriendInfoBO:encode(outputStream)
		outputStream:WriteInt(self.int_isOnline)

		outputStream:WriteUTFString(self.string_userId)

		outputStream:WriteUTFString(self.string_name)

		outputStream:WriteInt(self.int_camp)

		outputStream:WriteInt(self.int_level)

		outputStream:WriteInt(self.int_effective)

		outputStream:WriteInt(self.int_systemHeroId)


end

function UserFriendInfoBO:decode(inputStream)
	    local body = {}
		body.isOnline = inputStream:ReadInt()

		body.userId = inputStream:ReadUTFString()

		body.name = inputStream:ReadUTFString()

		body.camp = inputStream:ReadInt()

		body.level = inputStream:ReadInt()

		body.effective = inputStream:ReadInt()

		body.systemHeroId = inputStream:ReadInt()


	   return body
end