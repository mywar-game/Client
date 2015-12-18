

ChatAction_worldOfChatRes = {}

--世界聊天
function ChatAction_worldOfChatRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ChatAction_worldOfChatRes:init()
	
	self.UserChatRecordBO_userChatRecordBO=nil --用户聊天信息

	self.actName = "ChatAction_worldOfChat"
end

function ChatAction_worldOfChatRes:getActName()
	return self.actName
end

--用户聊天信息
function ChatAction_worldOfChatRes:setUserChatRecordBO_userChatRecordBO(UserChatRecordBO_userChatRecordBO)
	self.UserChatRecordBO_userChatRecordBO = UserChatRecordBO_userChatRecordBO
end





function ChatAction_worldOfChatRes:encode(outputStream)
		self.UserChatRecordBO_userChatRecordBO:encode(outputStream)


end

function ChatAction_worldOfChatRes:decode(inputStream)
	    local body = {}
        local userChatRecordBOTemp = UserChatRecordBO:New()
        body.userChatRecordBO=userChatRecordBOTemp:decode(inputStream)

	   return body
end