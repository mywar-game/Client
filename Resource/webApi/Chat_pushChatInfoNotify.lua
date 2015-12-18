

Chat_pushChatInfoNotify = {}

--聊天信息推送
function Chat_pushChatInfoNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function Chat_pushChatInfoNotify:init()
	
	self.UserChatRecordBO_userChatRecordBO=nil --用户聊天信息

	self.actName = "Chat_pushChatInfo"
end

function Chat_pushChatInfoNotify:getActName()
	return self.actName
end

--用户聊天信息
function Chat_pushChatInfoNotify:setUserChatRecordBO_userChatRecordBO(UserChatRecordBO_userChatRecordBO)
	self.UserChatRecordBO_userChatRecordBO = UserChatRecordBO_userChatRecordBO
end





function Chat_pushChatInfoNotify:encode(outputStream)
		self.UserChatRecordBO_userChatRecordBO:encode(outputStream)


end

function Chat_pushChatInfoNotify:decode(inputStream)
	    local body = {}
        local userChatRecordBOTemp = UserChatRecordBO:New()
        body.userChatRecordBO=userChatRecordBOTemp:decode(inputStream)

	   return body
end