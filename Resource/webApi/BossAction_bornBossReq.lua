

BossAction_bornBossReq = {}

--生成世界boss（调试使用）
function BossAction_bornBossReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function BossAction_bornBossReq:init()
	
	self.actName = "BossAction_bornBoss"
end

function BossAction_bornBossReq:getActName()
	return self.actName
end






function BossAction_bornBossReq:encode(outputStream)

end

function BossAction_bornBossReq:decode(inputStream)
	    local body = {}

	   return body
end