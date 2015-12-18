

WeatherInfoBO = {}

--天气信息对象
function WeatherInfoBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function WeatherInfoBO:init()
	
	self.int_mapId=0 --地图id

	self.int_groupId=0 --组合id

	self.int_type=0 --类型

	self.long_endTime=0 --结束时间（时间戳）

	self.actName = "WeatherInfoBO"
end

function WeatherInfoBO:getActName()
	return self.actName
end

--地图id
function WeatherInfoBO:setInt_mapId(int_mapId)
	self.int_mapId = int_mapId
end
--组合id
function WeatherInfoBO:setInt_groupId(int_groupId)
	self.int_groupId = int_groupId
end
--类型
function WeatherInfoBO:setInt_type(int_type)
	self.int_type = int_type
end
--结束时间（时间戳）
function WeatherInfoBO:setLong_endTime(long_endTime)
	self.long_endTime = long_endTime
end





function WeatherInfoBO:encode(outputStream)
		outputStream:WriteInt(self.int_mapId)

		outputStream:WriteInt(self.int_groupId)

		outputStream:WriteInt(self.int_type)

		outputStream:WriteLong(self.long_endTime)


end

function WeatherInfoBO:decode(inputStream)
	    local body = {}
		body.mapId = inputStream:ReadInt()

		body.groupId = inputStream:ReadInt()

		body.type = inputStream:ReadInt()

		body.endTime = inputStream:ReadLong()


	   return body
end