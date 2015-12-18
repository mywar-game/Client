

Boss_pushWorldBossInfoNotify = {}

--推送世界Boss信息
function Boss_pushWorldBossInfoNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function Boss_pushWorldBossInfoNotify:init()
	
	self.WorldBossInfoBO_worldBossInfoBO=nil --世界boss信息

	self.actName = "Boss_pushWorldBossInfo"
end

function Boss_pushWorldBossInfoNotify:getActName()
	return self.actName
end

--世界boss信息
function Boss_pushWorldBossInfoNotify:setWorldBossInfoBO_worldBossInfoBO(WorldBossInfoBO_worldBossInfoBO)
	self.WorldBossInfoBO_worldBossInfoBO = WorldBossInfoBO_worldBossInfoBO
end





function Boss_pushWorldBossInfoNotify:encode(outputStream)
		self.WorldBossInfoBO_worldBossInfoBO:encode(outputStream)


end

function Boss_pushWorldBossInfoNotify:decode(inputStream)
	    local body = {}
        local worldBossInfoBOTemp = WorldBossInfoBO:New()
        body.worldBossInfoBO=worldBossInfoBOTemp:decode(inputStream)

	   return body
end