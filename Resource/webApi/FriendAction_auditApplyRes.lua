

FriendAction_auditApplyRes = {}

--审核好友申请
function FriendAction_auditApplyRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function FriendAction_auditApplyRes:init()
	
	self.actName = "FriendAction_auditApply"
end

function FriendAction_auditApplyRes:getActName()
	return self.actName
end






function FriendAction_auditApplyRes:encode(outputStream)

end

function FriendAction_auditApplyRes:decode(inputStream)
	    local body = {}

	   return body
end