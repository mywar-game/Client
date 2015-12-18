

UserChatRecordBO = {}

--用户聊天内容对象
function UserChatRecordBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserChatRecordBO:init()
	
	self.string_userId="" --发言的用户id

	self.string_userName="" --发言用户名

	self.string_targetUserId="" --目标用户id

	self.string_targetUserName="" --目标用户名

	self.string_content="" --聊天内容

	self.int_type=0 --聊天类型(1世界2阵营3军团4私聊)

	self.actName = "UserChatRecordBO"
end

function UserChatRecordBO:getActName()
	return self.actName
end

--发言的用户id
function UserChatRecordBO:setString_userId(string_userId)
	self.string_userId = string_userId
end
--发言用户名
function UserChatRecordBO:setString_userName(string_userName)
	self.string_userName = string_userName
end
--目标用户id
function UserChatRecordBO:setString_targetUserId(string_targetUserId)
	self.string_targetUserId = string_targetUserId
end
--目标用户名
function UserChatRecordBO:setString_targetUserName(string_targetUserName)
	self.string_targetUserName = string_targetUserName
end
--聊天内容
function UserChatRecordBO:setString_content(string_content)
	self.string_content = string_content
end
--聊天类型(1世界2阵营3军团4私聊)
function UserChatRecordBO:setInt_type(int_type)
	self.int_type = int_type
end





function UserChatRecordBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)

		outputStream:WriteUTFString(self.string_userName)

		outputStream:WriteUTFString(self.string_targetUserId)

		outputStream:WriteUTFString(self.string_targetUserName)

		outputStream:WriteUTFString(self.string_content)

		outputStream:WriteInt(self.int_type)


end

function UserChatRecordBO:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()

		body.userName = inputStream:ReadUTFString()

		body.targetUserId = inputStream:ReadUTFString()

		body.targetUserName = inputStream:ReadUTFString()

		body.content = inputStream:ReadUTFString()

		body.type = inputStream:ReadInt()


	   return body
end