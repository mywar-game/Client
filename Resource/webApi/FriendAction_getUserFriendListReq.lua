

FriendAction_getUserFriendListReq = {}

--获取好友列表
function FriendAction_getUserFriendListReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function FriendAction_getUserFriendListReq:init()
	
	self.actName = "FriendAction_getUserFriendList"
end

function FriendAction_getUserFriendListReq:getActName()
	return self.actName
end






function FriendAction_getUserFriendListReq:encode(outputStream)

end

function FriendAction_getUserFriendListReq:decode(inputStream)
	    local body = {}

	   return body
end