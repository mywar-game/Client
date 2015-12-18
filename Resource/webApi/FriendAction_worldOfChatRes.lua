

FriendAction_worldOfChatRes = {}

--世界聊天
function FriendAction_worldOfChatRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function FriendAction_worldOfChatRes:init()
	
	self.UserChatRecordBO_userChatRecordBO=nil --用户聊天信息

	self.actName = "FriendAction_worldOfChat"
end

function FriendAction_worldOfChatRes:getActName()
	return self.actName
end

--用户聊天信息
function FriendAction_worldOfChatRes:setUserChatRecordBO_userChatRecordBO(UserChatRecordBO_userChatRecordBO)
	self.UserChatRecordBO_userChatRecordBO = UserChatRecordBO_userChatRecordBO
end





function FriendAction_worldOfChatRes:encode(outputStream)
		self.UserChatRecordBO_userChatRecordBO:encode(outputStream)


end

function FriendAction_worldOfChatRes:decode(inputStream)
	    local body = {}
        local userChatRecordBOTemp = UserChatRecordBO:New()
        body.userChatRecordBO=userChatRecordBOTemp:decode(inputStream)

	   return body
end