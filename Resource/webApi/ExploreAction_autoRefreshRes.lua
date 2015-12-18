

ExploreAction_autoRefreshRes = {}

--自动刷新
function ExploreAction_autoRefreshRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ExploreAction_autoRefreshRes:init()
	
	self.int_mapId=0 --地图Id

	self.int_stop=0 --是否停止1是0否

	self.int_integral=0 --用户探索积分

	self.int_cost=0 --花费钻石

	self.int_mon=0 --剩余钻石数

	self.actName = "ExploreAction_autoRefresh"
end

function ExploreAction_autoRefreshRes:getActName()
	return self.actName
end

--地图Id
function ExploreAction_autoRefreshRes:setInt_mapId(int_mapId)
	self.int_mapId = int_mapId
end
--是否停止1是0否
function ExploreAction_autoRefreshRes:setInt_stop(int_stop)
	self.int_stop = int_stop
end
--用户探索积分
function ExploreAction_autoRefreshRes:setInt_integral(int_integral)
	self.int_integral = int_integral
end
--花费钻石
function ExploreAction_autoRefreshRes:setInt_cost(int_cost)
	self.int_cost = int_cost
end
--剩余钻石数
function ExploreAction_autoRefreshRes:setInt_mon(int_mon)
	self.int_mon = int_mon
end





function ExploreAction_autoRefreshRes:encode(outputStream)
		outputStream:WriteInt(self.int_mapId)

		outputStream:WriteInt(self.int_stop)

		outputStream:WriteInt(self.int_integral)

		outputStream:WriteInt(self.int_cost)

		outputStream:WriteInt(self.int_mon)


end

function ExploreAction_autoRefreshRes:decode(inputStream)
	    local body = {}
		body.mapId = inputStream:ReadInt()

		body.stop = inputStream:ReadInt()

		body.integral = inputStream:ReadInt()

		body.cost = inputStream:ReadInt()

		body.mon = inputStream:ReadInt()


	   return body
end