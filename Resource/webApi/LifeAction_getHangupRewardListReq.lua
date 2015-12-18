

LifeAction_getHangupRewardListReq = {}

--获取挂机奖励
function LifeAction_getHangupRewardListReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LifeAction_getHangupRewardListReq:init()
	
	self.int_category=0 --的类别（1矿场2花圃3渔场）

	self.string_userHeroId="" --用户英雄id

	self.string_userFriendId="" --用户好友id

	self.actName = "LifeAction_getHangupRewardList"
end

function LifeAction_getHangupRewardListReq:getActName()
	return self.actName
end

--的类别（1矿场2花圃3渔场）
function LifeAction_getHangupRewardListReq:setInt_category(int_category)
	self.int_category = int_category
end
--用户英雄id
function LifeAction_getHangupRewardListReq:setString_userHeroId(string_userHeroId)
	self.string_userHeroId = string_userHeroId
end
--用户好友id
function LifeAction_getHangupRewardListReq:setString_userFriendId(string_userFriendId)
	self.string_userFriendId = string_userFriendId
end





function LifeAction_getHangupRewardListReq:encode(outputStream)
		outputStream:WriteInt(self.int_category)

		outputStream:WriteUTFString(self.string_userHeroId)

		outputStream:WriteUTFString(self.string_userFriendId)


end

function LifeAction_getHangupRewardListReq:decode(inputStream)
	    local body = {}
		body.category = inputStream:ReadInt()

		body.userHeroId = inputStream:ReadUTFString()

		body.userFriendId = inputStream:ReadUTFString()


	   return body
end