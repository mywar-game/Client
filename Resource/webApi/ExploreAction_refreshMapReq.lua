

ExploreAction_refreshMapReq = {}

--刷新地图
function ExploreAction_refreshMapReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ExploreAction_refreshMapReq:init()
	
	self.actName = "ExploreAction_refreshMap"
end

function ExploreAction_refreshMapReq:getActName()
	return self.actName
end






function ExploreAction_refreshMapReq:encode(outputStream)

end

function ExploreAction_refreshMapReq:decode(inputStream)
	    local body = {}

	   return body
end