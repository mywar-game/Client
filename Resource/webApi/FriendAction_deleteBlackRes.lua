

FriendAction_deleteBlackRes = {}

--删除黑名单
function FriendAction_deleteBlackRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function FriendAction_deleteBlackRes:init()
	
	self.actName = "FriendAction_deleteBlack"
end

function FriendAction_deleteBlackRes:getActName()
	return self.actName
end






function FriendAction_deleteBlackRes:encode(outputStream)

end

function FriendAction_deleteBlackRes:decode(inputStream)
	    local body = {}

	   return body
end