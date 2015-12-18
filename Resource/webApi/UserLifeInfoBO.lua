

UserLifeInfoBO = {}

--用户生活信息对象
function UserLifeInfoBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserLifeInfoBO:init()
	
	self.int_category=0 --类别（1挖矿2花圃3钓鱼）

	self.int_status=0 --状态（0未创建1未挂机2正在挂机）

	self.string_userId="" --用户编号

	self.string_userHeroId1="" --用户英雄唯一id

	self.string_userHeroId2="" --用户英雄唯一id

	self.string_userHeroId3="" --用户英雄唯一id

	self.string_userFriendId="" --用户好友id

	self.string_userFriendName="" --用户好友名称

	self.int_friendSystemHeroId=0 --好友队长英雄id

	self.long_remainderTime=0 --剩余时间

	self.CommonGoodsBeanBO_drop=nil --现在的收益

	self.actName = "UserLifeInfoBO"
end

function UserLifeInfoBO:getActName()
	return self.actName
end

--类别（1挖矿2花圃3钓鱼）
function UserLifeInfoBO:setInt_category(int_category)
	self.int_category = int_category
end
--状态（0未创建1未挂机2正在挂机）
function UserLifeInfoBO:setInt_status(int_status)
	self.int_status = int_status
end
--用户编号
function UserLifeInfoBO:setString_userId(string_userId)
	self.string_userId = string_userId
end
--用户英雄唯一id
function UserLifeInfoBO:setString_userHeroId1(string_userHeroId1)
	self.string_userHeroId1 = string_userHeroId1
end
--用户英雄唯一id
function UserLifeInfoBO:setString_userHeroId2(string_userHeroId2)
	self.string_userHeroId2 = string_userHeroId2
end
--用户英雄唯一id
function UserLifeInfoBO:setString_userHeroId3(string_userHeroId3)
	self.string_userHeroId3 = string_userHeroId3
end
--用户好友id
function UserLifeInfoBO:setString_userFriendId(string_userFriendId)
	self.string_userFriendId = string_userFriendId
end
--用户好友名称
function UserLifeInfoBO:setString_userFriendName(string_userFriendName)
	self.string_userFriendName = string_userFriendName
end
--好友队长英雄id
function UserLifeInfoBO:setInt_friendSystemHeroId(int_friendSystemHeroId)
	self.int_friendSystemHeroId = int_friendSystemHeroId
end
--剩余时间
function UserLifeInfoBO:setLong_remainderTime(long_remainderTime)
	self.long_remainderTime = long_remainderTime
end
--现在的收益
function UserLifeInfoBO:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end





function UserLifeInfoBO:encode(outputStream)
		outputStream:WriteInt(self.int_category)

		outputStream:WriteInt(self.int_status)

		outputStream:WriteUTFString(self.string_userId)

		outputStream:WriteUTFString(self.string_userHeroId1)

		outputStream:WriteUTFString(self.string_userHeroId2)

		outputStream:WriteUTFString(self.string_userHeroId3)

		outputStream:WriteUTFString(self.string_userFriendId)

		outputStream:WriteUTFString(self.string_userFriendName)

		outputStream:WriteInt(self.int_friendSystemHeroId)

		outputStream:WriteLong(self.long_remainderTime)

		self.CommonGoodsBeanBO_drop:encode(outputStream)


end

function UserLifeInfoBO:decode(inputStream)
	    local body = {}
		body.category = inputStream:ReadInt()

		body.status = inputStream:ReadInt()

		body.userId = inputStream:ReadUTFString()

		body.userHeroId1 = inputStream:ReadUTFString()

		body.userHeroId2 = inputStream:ReadUTFString()

		body.userHeroId3 = inputStream:ReadUTFString()

		body.userFriendId = inputStream:ReadUTFString()

		body.userFriendName = inputStream:ReadUTFString()

		body.friendSystemHeroId = inputStream:ReadInt()

		body.remainderTime = inputStream:ReadLong()

        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)

	   return body
end