

BossAction_startAttackBossReq = {}

--开始攻打世界boss
function BossAction_startAttackBossReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function BossAction_startAttackBossReq:init()
	
	self.int_mapId=0 --地图id

	self.int_x=0 --坐标x

	self.int_y=0 --坐标y

	self.actName = "BossAction_startAttackBoss"
end

function BossAction_startAttackBossReq:getActName()
	return self.actName
end

--地图id
function BossAction_startAttackBossReq:setInt_mapId(int_mapId)
	self.int_mapId = int_mapId
end
--坐标x
function BossAction_startAttackBossReq:setInt_x(int_x)
	self.int_x = int_x
end
--坐标y
function BossAction_startAttackBossReq:setInt_y(int_y)
	self.int_y = int_y
end





function BossAction_startAttackBossReq:encode(outputStream)
		outputStream:WriteInt(self.int_mapId)

		outputStream:WriteInt(self.int_x)

		outputStream:WriteInt(self.int_y)


end

function BossAction_startAttackBossReq:decode(inputStream)
	    local body = {}
		body.mapId = inputStream:ReadInt()

		body.x = inputStream:ReadInt()

		body.y = inputStream:ReadInt()


	   return body
end