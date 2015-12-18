

WorldBossInfoBO = {}

--世界Boss信息
function WorldBossInfoBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function WorldBossInfoBO:init()
	
	self.long_maxLife=0 --boss最大生命值

	self.long_currentLife=0 --boss当前生命值

	self.long_openTime=0 --开启时间

	self.long_continueTimes=0 --持续时间

	self.int_bossLevel=0 --boss等级

	self.int_mapId=0 --地图id

	self.actName = "WorldBossInfoBO"
end

function WorldBossInfoBO:getActName()
	return self.actName
end

--boss最大生命值
function WorldBossInfoBO:setLong_maxLife(long_maxLife)
	self.long_maxLife = long_maxLife
end
--boss当前生命值
function WorldBossInfoBO:setLong_currentLife(long_currentLife)
	self.long_currentLife = long_currentLife
end
--开启时间
function WorldBossInfoBO:setLong_openTime(long_openTime)
	self.long_openTime = long_openTime
end
--持续时间
function WorldBossInfoBO:setLong_continueTimes(long_continueTimes)
	self.long_continueTimes = long_continueTimes
end
--boss等级
function WorldBossInfoBO:setInt_bossLevel(int_bossLevel)
	self.int_bossLevel = int_bossLevel
end
--地图id
function WorldBossInfoBO:setInt_mapId(int_mapId)
	self.int_mapId = int_mapId
end





function WorldBossInfoBO:encode(outputStream)
		outputStream:WriteLong(self.long_maxLife)

		outputStream:WriteLong(self.long_currentLife)

		outputStream:WriteLong(self.long_openTime)

		outputStream:WriteLong(self.long_continueTimes)

		outputStream:WriteInt(self.int_bossLevel)

		outputStream:WriteInt(self.int_mapId)


end

function WorldBossInfoBO:decode(inputStream)
	    local body = {}
		body.maxLife = inputStream:ReadLong()

		body.currentLife = inputStream:ReadLong()

		body.openTime = inputStream:ReadLong()

		body.continueTimes = inputStream:ReadLong()

		body.bossLevel = inputStream:ReadInt()

		body.mapId = inputStream:ReadInt()


	   return body
end