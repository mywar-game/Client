

Message_pushMessageNotify = {}

--推送跑马灯
function Message_pushMessageNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function Message_pushMessageNotify:init()
	
	self.list_messageList={} --跑马灯消息对象

	self.actName = "Message_pushMessage"
end

function Message_pushMessageNotify:getActName()
	return self.actName
end

--跑马灯消息对象
function Message_pushMessageNotify:setList_messageList(list_messageList)
	self.list_messageList = list_messageList
end





function Message_pushMessageNotify:encode(outputStream)
		
		self.list_messageList = self.list_messageList or {}
		local list_messageListsize = #self.list_messageList
		outputStream:WriteInt(list_messageListsize)
		for list_messageListi=1,list_messageListsize do
            self.list_messageList[list_messageListi]:encode(outputStream)
		end
end

function Message_pushMessageNotify:decode(inputStream)
	    local body = {}
		local messageListTemp = {}
		local messageListsize = inputStream:ReadInt()
		for messageListi=1,messageListsize do
            local entry = MessageBO:New()
            table.insert(messageListTemp,entry:decode(inputStream))

		end
		body.messageList = messageListTemp

	   return body
end