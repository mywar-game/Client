

FriendAction_worldOfChatReq = {}

--世界聊天
function FriendAction_worldOfChatReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function FriendAction_worldOfChatReq:init()
	
	self.string_content="" --聊天内容

	self.actName = "FriendAction_worldOfChat"
end

function FriendAction_worldOfChatReq:getActName()
	return self.actName
end

--聊天内容
function FriendAction_worldOfChatReq:setString_content(string_content)
	self.string_content = string_content
end





function FriendAction_worldOfChatReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_content)


end

function FriendAction_worldOfChatReq:decode(inputStream)
	    local body = {}
		body.content = inputStream:ReadUTFString()


	   return body
end