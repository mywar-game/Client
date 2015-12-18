

Boss_pushWorldBossDieNotify = {}

--推送世界Boss结束信息
function Boss_pushWorldBossDieNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function Boss_pushWorldBossDieNotify:init()
	
	self.int_status=0 --0Boss死掉了1时间结束了

	self.actName = "Boss_pushWorldBossDie"
end

function Boss_pushWorldBossDieNotify:getActName()
	return self.actName
end

--0Boss死掉了1时间结束了
function Boss_pushWorldBossDieNotify:setInt_status(int_status)
	self.int_status = int_status
end





function Boss_pushWorldBossDieNotify:encode(outputStream)
		outputStream:WriteInt(self.int_status)


end

function Boss_pushWorldBossDieNotify:decode(inputStream)
	    local body = {}
		body.status = inputStream:ReadInt()


	   return body
end