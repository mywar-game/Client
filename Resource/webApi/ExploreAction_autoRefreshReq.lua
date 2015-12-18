

ExploreAction_autoRefreshReq = {}

--自动刷新
function ExploreAction_autoRefreshReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ExploreAction_autoRefreshReq:init()
	
	self.actName = "ExploreAction_autoRefresh"
end

function ExploreAction_autoRefreshReq:getActName()
	return self.actName
end






function ExploreAction_autoRefreshReq:encode(outputStream)

end

function ExploreAction_autoRefreshReq:decode(inputStream)
	    local body = {}

	   return body
end