

ExploreAction_exploreRes = {}

--探索
function ExploreAction_exploreRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ExploreAction_exploreRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --通用奖励对象

	self.int_exploreTimes=0 --剩余探索次数

	self.int_mapId=0 --新的地图id

	self.actName = "ExploreAction_explore"
end

function ExploreAction_exploreRes:getActName()
	return self.actName
end

--通用奖励对象
function ExploreAction_exploreRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end
--剩余探索次数
function ExploreAction_exploreRes:setInt_exploreTimes(int_exploreTimes)
	self.int_exploreTimes = int_exploreTimes
end
--新的地图id
function ExploreAction_exploreRes:setInt_mapId(int_mapId)
	self.int_mapId = int_mapId
end





function ExploreAction_exploreRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)

		outputStream:WriteInt(self.int_exploreTimes)

		outputStream:WriteInt(self.int_mapId)


end

function ExploreAction_exploreRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)
		body.exploreTimes = inputStream:ReadInt()

		body.mapId = inputStream:ReadInt()


	   return body
end