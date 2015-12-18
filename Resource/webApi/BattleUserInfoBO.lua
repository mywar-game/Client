

BattleUserInfoBO = {}

--参战好友信息对象
function BattleUserInfoBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function BattleUserInfoBO:init()
	
	self.string_userId="" --好友用户id

	self.string_name="" --好友名称

	self.int_effective=0 --战斗力

	self.int_systemHeroId=0 --好友队长的英雄id

	self.int_isFriend=0 --0非好友1好友

	self.int_level=0 --等级

	self.actName = "BattleUserInfoBO"
end

function BattleUserInfoBO:getActName()
	return self.actName
end

--好友用户id
function BattleUserInfoBO:setString_userId(string_userId)
	self.string_userId = string_userId
end
--好友名称
function BattleUserInfoBO:setString_name(string_name)
	self.string_name = string_name
end
--战斗力
function BattleUserInfoBO:setInt_effective(int_effective)
	self.int_effective = int_effective
end
--好友队长的英雄id
function BattleUserInfoBO:setInt_systemHeroId(int_systemHeroId)
	self.int_systemHeroId = int_systemHeroId
end
--0非好友1好友
function BattleUserInfoBO:setInt_isFriend(int_isFriend)
	self.int_isFriend = int_isFriend
end
--等级
function BattleUserInfoBO:setInt_level(int_level)
	self.int_level = int_level
end





function BattleUserInfoBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)

		outputStream:WriteUTFString(self.string_name)

		outputStream:WriteInt(self.int_effective)

		outputStream:WriteInt(self.int_systemHeroId)

		outputStream:WriteInt(self.int_isFriend)

		outputStream:WriteInt(self.int_level)


end

function BattleUserInfoBO:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()

		body.name = inputStream:ReadUTFString()

		body.effective = inputStream:ReadInt()

		body.systemHeroId = inputStream:ReadInt()

		body.isFriend = inputStream:ReadInt()

		body.level = inputStream:ReadInt()


	   return body
end