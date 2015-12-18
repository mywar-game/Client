

FriendAction_privateOfChatReq = {}

--好友私聊
function FriendAction_privateOfChatReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function FriendAction_privateOfChatReq:init()
	
	self.string_userName="" --用户名

	self.string_toUserId="" --私聊的用户id

	self.string_content="" --聊天内容

	self.actName = "FriendAction_privateOfChat"
end

function FriendAction_privateOfChatReq:getActName()
	return self.actName
end

--用户名
function FriendAction_privateOfChatReq:setString_userName(string_userName)
	self.string_userName = string_userName
end
--私聊的用户id
function FriendAction_privateOfChatReq:setString_toUserId(string_toUserId)
	self.string_toUserId = string_toUserId
end
--聊天内容
function FriendAction_privateOfChatReq:setString_content(string_content)
	self.string_content = string_content
end





function FriendAction_privateOfChatReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_userName)

		outputStream:WriteUTFString(self.string_toUserId)

		outputStream:WriteUTFString(self.string_content)


end

function FriendAction_privateOfChatReq:decode(inputStream)
	    local body = {}
		body.userName = inputStream:ReadUTFString()

		body.toUserId = inputStream:ReadUTFString()

		body.content = inputStream:ReadUTFString()


	   return body
end