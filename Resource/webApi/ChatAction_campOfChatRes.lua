

ChatAction_campOfChatRes = {}

--阵营聊天
function ChatAction_campOfChatRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ChatAction_campOfChatRes:init()
	
	self.UserChatRecordBO_userChatRecordBO=nil --用户聊天信息

	self.actName = "ChatAction_campOfChat"
end

function ChatAction_campOfChatRes:getActName()
	return self.actName
end

--用户聊天信息
function ChatAction_campOfChatRes:setUserChatRecordBO_userChatRecordBO(UserChatRecordBO_userChatRecordBO)
	self.UserChatRecordBO_userChatRecordBO = UserChatRecordBO_userChatRecordBO
end





function ChatAction_campOfChatRes:encode(outputStream)
		self.UserChatRecordBO_userChatRecordBO:encode(outputStream)


end

function ChatAction_campOfChatRes:decode(inputStream)
	    local body = {}
        local userChatRecordBOTemp = UserChatRecordBO:New()
        body.userChatRecordBO=userChatRecordBOTemp:decode(inputStream)

	   return body
end