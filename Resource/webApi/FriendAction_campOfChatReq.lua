

FriendAction_campOfChatReq = {}

--阵营聊天
function FriendAction_campOfChatReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function FriendAction_campOfChatReq:init()
	
	self.string_content="" --聊天内容

	self.actName = "FriendAction_campOfChat"
end

function FriendAction_campOfChatReq:getActName()
	return self.actName
end

--聊天内容
function FriendAction_campOfChatReq:setString_content(string_content)
	self.string_content = string_content
end





function FriendAction_campOfChatReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_content)


end

function FriendAction_campOfChatReq:decode(inputStream)
	    local body = {}
		body.content = inputStream:ReadUTFString()


	   return body
end