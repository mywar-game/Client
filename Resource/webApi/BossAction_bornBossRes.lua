

BossAction_bornBossRes = {}

--生成世界boss（调试使用）
function BossAction_bornBossRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function BossAction_bornBossRes:init()
	
	self.actName = "BossAction_bornBoss"
end

function BossAction_bornBossRes:getActName()
	return self.actName
end






function BossAction_bornBossRes:encode(outputStream)

end

function BossAction_bornBossRes:decode(inputStream)
	    local body = {}

	   return body
end