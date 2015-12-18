

FriendAction_privateOfChatRes = {}

--好友私聊
function FriendAction_privateOfChatRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function FriendAction_privateOfChatRes:init()
	
	self.UserChatRecordBO_userChatRecordBO=nil --用户聊天信息

	self.actName = "FriendAction_privateOfChat"
end

function FriendAction_privateOfChatRes:getActName()
	return self.actName
end

--用户聊天信息
function FriendAction_privateOfChatRes:setUserChatRecordBO_userChatRecordBO(UserChatRecordBO_userChatRecordBO)
	self.UserChatRecordBO_userChatRecordBO = UserChatRecordBO_userChatRecordBO
end





function FriendAction_privateOfChatRes:encode(outputStream)
		self.UserChatRecordBO_userChatRecordBO:encode(outputStream)


end

function FriendAction_privateOfChatRes:decode(inputStream)
	    local body = {}
        local userChatRecordBOTemp = UserChatRecordBO:New()
        body.userChatRecordBO=userChatRecordBOTemp:decode(inputStream)

	   return body
end