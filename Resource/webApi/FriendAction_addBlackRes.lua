

FriendAction_addBlackRes = {}

--添加黑名单
function FriendAction_addBlackRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function FriendAction_addBlackRes:init()
	
	self.actName = "FriendAction_addBlack"
end

function FriendAction_addBlackRes:getActName()
	return self.actName
end






function FriendAction_addBlackRes:encode(outputStream)

end

function FriendAction_addBlackRes:decode(inputStream)
	    local body = {}

	   return body
end