

FriendAction_addBlackReq = {}

--添加黑名单
function FriendAction_addBlackReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function FriendAction_addBlackReq:init()
	
	self.string_targetUserId="" --对方用户id

	self.actName = "FriendAction_addBlack"
end

function FriendAction_addBlackReq:getActName()
	return self.actName
end

--对方用户id
function FriendAction_addBlackReq:setString_targetUserId(string_targetUserId)
	self.string_targetUserId = string_targetUserId
end





function FriendAction_addBlackReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_targetUserId)


end

function FriendAction_addBlackReq:decode(inputStream)
	    local body = {}
		body.targetUserId = inputStream:ReadUTFString()


	   return body
end