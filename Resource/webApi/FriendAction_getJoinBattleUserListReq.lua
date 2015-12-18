

FriendAction_getJoinBattleUserListReq = {}

--获取可参战用户
function FriendAction_getJoinBattleUserListReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function FriendAction_getJoinBattleUserListReq:init()
	
	self.actName = "FriendAction_getJoinBattleUserList"
end

function FriendAction_getJoinBattleUserListReq:getActName()
	return self.actName
end






function FriendAction_getJoinBattleUserListReq:encode(outputStream)

end

function FriendAction_getJoinBattleUserListReq:decode(inputStream)
	    local body = {}

	   return body
end