

FriendAction_deleteBlackReq = {}

--删除黑名单
function FriendAction_deleteBlackReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function FriendAction_deleteBlackReq:init()
	
	self.string_userBlackId="" --好友id

	self.actName = "FriendAction_deleteBlack"
end

function FriendAction_deleteBlackReq:getActName()
	return self.actName
end

--好友id
function FriendAction_deleteBlackReq:setString_userBlackId(string_userBlackId)
	self.string_userBlackId = string_userBlackId
end





function FriendAction_deleteBlackReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_userBlackId)


end

function FriendAction_deleteBlackReq:decode(inputStream)
	    local body = {}
		body.userBlackId = inputStream:ReadUTFString()


	   return body
end