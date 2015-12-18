

ChatAction_getChatRecordRes = {}

--获取聊天记录
function ChatAction_getChatRecordRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ChatAction_getChatRecordRes:init()
	
	self.list_userChatRecordList={} --用户聊天信息

	self.actName = "ChatAction_getChatRecord"
end

function ChatAction_getChatRecordRes:getActName()
	return self.actName
end

--用户聊天信息
function ChatAction_getChatRecordRes:setList_userChatRecordList(list_userChatRecordList)
	self.list_userChatRecordList = list_userChatRecordList
end





function ChatAction_getChatRecordRes:encode(outputStream)
		
		self.list_userChatRecordList = self.list_userChatRecordList or {}
		local list_userChatRecordListsize = #self.list_userChatRecordList
		outputStream:WriteInt(list_userChatRecordListsize)
		for list_userChatRecordListi=1,list_userChatRecordListsize do
            self.list_userChatRecordList[list_userChatRecordListi]:encode(outputStream)
		end
end

function ChatAction_getChatRecordRes:decode(inputStream)
	    local body = {}
		local userChatRecordListTemp = {}
		local userChatRecordListsize = inputStream:ReadInt()
		for userChatRecordListi=1,userChatRecordListsize do
            local entry = UserChatRecordBO:New()
            table.insert(userChatRecordListTemp,entry:decode(inputStream))

		end
		body.userChatRecordList = userChatRecordListTemp

	   return body
end