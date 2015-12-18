

FriendAction_applyFriendRes = {}

--申请添加好友
function FriendAction_applyFriendRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function FriendAction_applyFriendRes:init()
	
	self.actName = "FriendAction_applyFriend"
end

function FriendAction_applyFriendRes:getActName()
	return self.actName
end






function FriendAction_applyFriendRes:encode(outputStream)

end

function FriendAction_applyFriendRes:decode(inputStream)
	    local body = {}

	   return body
end