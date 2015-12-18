

Boss_pushWorldBossCurrentLifeNotify = {}

--推送世界Boss当前血量
function Boss_pushWorldBossCurrentLifeNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function Boss_pushWorldBossCurrentLifeNotify:init()
	
	self.long_currentLife=0 --Boss当前血量

	self.actName = "Boss_pushWorldBossCurrentLife"
end

function Boss_pushWorldBossCurrentLifeNotify:getActName()
	return self.actName
end

--Boss当前血量
function Boss_pushWorldBossCurrentLifeNotify:setLong_currentLife(long_currentLife)
	self.long_currentLife = long_currentLife
end





function Boss_pushWorldBossCurrentLifeNotify:encode(outputStream)
		outputStream:WriteLong(self.long_currentLife)


end

function Boss_pushWorldBossCurrentLifeNotify:decode(inputStream)
	    local body = {}
		body.currentLife = inputStream:ReadLong()


	   return body
end