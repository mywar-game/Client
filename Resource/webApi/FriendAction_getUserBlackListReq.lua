

FriendAction_getUserBlackListReq = {}

--获取黑名单列表
function FriendAction_getUserBlackListReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function FriendAction_getUserBlackListReq:init()
	
	self.actName = "FriendAction_getUserBlackList"
end

function FriendAction_getUserBlackListReq:getActName()
	return self.actName
end






function FriendAction_getUserBlackListReq:encode(outputStream)

end

function FriendAction_getUserBlackListReq:decode(inputStream)
	    local body = {}

	   return body
end