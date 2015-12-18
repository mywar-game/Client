

ChatAction_getChatRecordReq = {}

--获取聊天记录
function ChatAction_getChatRecordReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ChatAction_getChatRecordReq:init()
	
	self.int_type=0 --聊天类型（1世界2阵营3军团4私聊）

	self.actName = "ChatAction_getChatRecord"
end

function ChatAction_getChatRecordReq:getActName()
	return self.actName
end

--聊天类型（1世界2阵营3军团4私聊）
function ChatAction_getChatRecordReq:setInt_type(int_type)
	self.int_type = int_type
end





function ChatAction_getChatRecordReq:encode(outputStream)
		outputStream:WriteInt(self.int_type)


end

function ChatAction_getChatRecordReq:decode(inputStream)
	    local body = {}
		body.type = inputStream:ReadInt()


	   return body
end