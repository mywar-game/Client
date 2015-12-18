

FriendAction_applyFriendReq = {}

--申请添加好友
function FriendAction_applyFriendReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function FriendAction_applyFriendReq:init()
	
	self.string_targetUserId="" --对方用户id

	self.string_name="" --用户名

	self.actName = "FriendAction_applyFriend"
end

function FriendAction_applyFriendReq:getActName()
	return self.actName
end

--对方用户id
function FriendAction_applyFriendReq:setString_targetUserId(string_targetUserId)
	self.string_targetUserId = string_targetUserId
end
--用户名
function FriendAction_applyFriendReq:setString_name(string_name)
	self.string_name = string_name
end





function FriendAction_applyFriendReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_targetUserId)

		outputStream:WriteUTFString(self.string_name)


end

function FriendAction_applyFriendReq:decode(inputStream)
	    local body = {}
		body.targetUserId = inputStream:ReadUTFString()

		body.name = inputStream:ReadUTFString()


	   return body
end