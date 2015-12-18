

UserExploreInfoBO = {}

--用户探索信息对象
function UserExploreInfoBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserExploreInfoBO:init()
	
	self.int_mapId=0 --地图Id

	self.int_integral=0 --积分

	self.int_exploreTimes=0 --剩余探索次数

	self.actName = "UserExploreInfoBO"
end

function UserExploreInfoBO:getActName()
	return self.actName
end

--地图Id
function UserExploreInfoBO:setInt_mapId(int_mapId)
	self.int_mapId = int_mapId
end
--积分
function UserExploreInfoBO:setInt_integral(int_integral)
	self.int_integral = int_integral
end
--剩余探索次数
function UserExploreInfoBO:setInt_exploreTimes(int_exploreTimes)
	self.int_exploreTimes = int_exploreTimes
end





function UserExploreInfoBO:encode(outputStream)
		outputStream:WriteInt(self.int_mapId)

		outputStream:WriteInt(self.int_integral)

		outputStream:WriteInt(self.int_exploreTimes)


end

function UserExploreInfoBO:decode(inputStream)
	    local body = {}
		body.mapId = inputStream:ReadInt()

		body.integral = inputStream:ReadInt()

		body.exploreTimes = inputStream:ReadInt()


	   return body
end