

ExploreAction_refreshMapRes = {}

--刷新地图
function ExploreAction_refreshMapRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ExploreAction_refreshMapRes:init()
	
	self.int_mapId=0 --地图id

	self.int_integral=0 --用户探索积分

	self.int_money=0 --剩余钻石

	self.actName = "ExploreAction_refreshMap"
end

function ExploreAction_refreshMapRes:getActName()
	return self.actName
end

--地图id
function ExploreAction_refreshMapRes:setInt_mapId(int_mapId)
	self.int_mapId = int_mapId
end
--用户探索积分
function ExploreAction_refreshMapRes:setInt_integral(int_integral)
	self.int_integral = int_integral
end
--剩余钻石
function ExploreAction_refreshMapRes:setInt_money(int_money)
	self.int_money = int_money
end





function ExploreAction_refreshMapRes:encode(outputStream)
		outputStream:WriteInt(self.int_mapId)

		outputStream:WriteInt(self.int_integral)

		outputStream:WriteInt(self.int_money)


end

function ExploreAction_refreshMapRes:decode(inputStream)
	    local body = {}
		body.mapId = inputStream:ReadInt()

		body.integral = inputStream:ReadInt()

		body.money = inputStream:ReadInt()


	   return body
end