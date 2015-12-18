

ChatAction_nearbyOfChatReq = {}

--附近聊天
function ChatAction_nearbyOfChatReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ChatAction_nearbyOfChatReq:init()
	
	self.string_content="" --聊天内容

	self.actName = "ChatAction_nearbyOfChat"
end

function ChatAction_nearbyOfChatReq:getActName()
	return self.actName
end

--聊天内容
function ChatAction_nearbyOfChatReq:setString_content(string_content)
	self.string_content = string_content
end





function ChatAction_nearbyOfChatReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_content)


end

function ChatAction_nearbyOfChatReq:decode(inputStream)
	    local body = {}
		body.content = inputStream:ReadUTFString()


	   return body
end