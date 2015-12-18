

ChatAction_legionOfChatReq = {}

--公会聊天
function ChatAction_legionOfChatReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ChatAction_legionOfChatReq:init()
	
	self.string_content="" --聊天内容

	self.actName = "ChatAction_legionOfChat"
end

function ChatAction_legionOfChatReq:getActName()
	return self.actName
end

--聊天内容
function ChatAction_legionOfChatReq:setString_content(string_content)
	self.string_content = string_content
end





function ChatAction_legionOfChatReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_content)


end

function ChatAction_legionOfChatReq:decode(inputStream)
	    local body = {}
		body.content = inputStream:ReadUTFString()


	   return body
end