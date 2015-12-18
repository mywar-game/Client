

ChatAction_legionOfChatRes = {}

--公会聊天
function ChatAction_legionOfChatRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ChatAction_legionOfChatRes:init()
	
	self.UserChatRecordBO_userChatRecordBO=nil --用户聊天信息

	self.actName = "ChatAction_legionOfChat"
end

function ChatAction_legionOfChatRes:getActName()
	return self.actName
end

--用户聊天信息
function ChatAction_legionOfChatRes:setUserChatRecordBO_userChatRecordBO(UserChatRecordBO_userChatRecordBO)
	self.UserChatRecordBO_userChatRecordBO = UserChatRecordBO_userChatRecordBO
end





function ChatAction_legionOfChatRes:encode(outputStream)
		self.UserChatRecordBO_userChatRecordBO:encode(outputStream)


end

function ChatAction_legionOfChatRes:decode(inputStream)
	    local body = {}
        local userChatRecordBOTemp = UserChatRecordBO:New()
        body.userChatRecordBO=userChatRecordBOTemp:decode(inputStream)

	   return body
end