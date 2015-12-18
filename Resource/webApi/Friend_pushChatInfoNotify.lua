

Friend_pushChatInfoNotify = {}

--聊天信息推送
function Friend_pushChatInfoNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function Friend_pushChatInfoNotify:init()
	
	self.UserChatRecordBO_userChatRecordBO=nil --用户聊天信息

	self.actName = "Friend_pushChatInfo"
end

function Friend_pushChatInfoNotify:getActName()
	return self.actName
end

--用户聊天信息
function Friend_pushChatInfoNotify:setUserChatRecordBO_userChatRecordBO(UserChatRecordBO_userChatRecordBO)
	self.UserChatRecordBO_userChatRecordBO = UserChatRecordBO_userChatRecordBO
end





function Friend_pushChatInfoNotify:encode(outputStream)
		self.UserChatRecordBO_userChatRecordBO:encode(outputStream)


end

function Friend_pushChatInfoNotify:decode(inputStream)
	    local body = {}
        local userChatRecordBOTemp = UserChatRecordBO:New()
        body.userChatRecordBO=userChatRecordBOTemp:decode(inputStream)

	   return body
end