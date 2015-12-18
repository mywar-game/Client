

ChatAction_worldOfChatReq = {}

--世界聊天
function ChatAction_worldOfChatReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ChatAction_worldOfChatReq:init()
	
	self.string_content="" --聊天内容

	self.actName = "ChatAction_worldOfChat"
end

function ChatAction_worldOfChatReq:getActName()
	return self.actName
end

--聊天内容
function ChatAction_worldOfChatReq:setString_content(string_content)
	self.string_content = string_content
end





function ChatAction_worldOfChatReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_content)


end

function ChatAction_worldOfChatReq:decode(inputStream)
	    local body = {}
		body.content = inputStream:ReadUTFString()


	   return body
end