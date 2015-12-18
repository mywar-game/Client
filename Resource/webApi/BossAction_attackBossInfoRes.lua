

BossAction_attackBossInfoRes = {}

--发送攻打世界boss的数据
function BossAction_attackBossInfoRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function BossAction_attackBossInfoRes:init()
	
	self.long_currentLife=0 --Boss当前血量

	self.actName = "BossAction_attackBossInfo"
end

function BossAction_attackBossInfoRes:getActName()
	return self.actName
end

--Boss当前血量
function BossAction_attackBossInfoRes:setLong_currentLife(long_currentLife)
	self.long_currentLife = long_currentLife
end





function BossAction_attackBossInfoRes:encode(outputStream)
		outputStream:WriteLong(self.long_currentLife)


end

function BossAction_attackBossInfoRes:decode(inputStream)
	    local body = {}
		body.currentLife = inputStream:ReadLong()


	   return body
end