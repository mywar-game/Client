

FriendAction_getUserFriendRankListReq = {}

--获取好友排行榜
function FriendAction_getUserFriendRankListReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function FriendAction_getUserFriendRankListReq:init()
	
	self.actName = "FriendAction_getUserFriendRankList"
end

function FriendAction_getUserFriendRankListReq:getActName()
	return self.actName
end






function FriendAction_getUserFriendRankListReq:encode(outputStream)

end

function FriendAction_getUserFriendRankListReq:decode(inputStream)
	    local body = {}

	   return body
end