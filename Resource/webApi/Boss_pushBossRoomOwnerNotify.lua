

Boss_pushBossRoomOwnerNotify = {}

--推送房主信息
function Boss_pushBossRoomOwnerNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function Boss_pushBossRoomOwnerNotify:init()
	
	self.string_userId="" --房主的用户id

	self.actName = "Boss_pushBossRoomOwner"
end

function Boss_pushBossRoomOwnerNotify:getActName()
	return self.actName
end

--房主的用户id
function Boss_pushBossRoomOwnerNotify:setString_userId(string_userId)
	self.string_userId = string_userId
end





function Boss_pushBossRoomOwnerNotify:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)


end

function Boss_pushBossRoomOwnerNotify:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()


	   return body
end