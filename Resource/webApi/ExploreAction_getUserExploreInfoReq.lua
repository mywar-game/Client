

ExploreAction_getUserExploreInfoReq = {}

--获取用户探索信息
function ExploreAction_getUserExploreInfoReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ExploreAction_getUserExploreInfoReq:init()
	
	self.actName = "ExploreAction_getUserExploreInfo"
end

function ExploreAction_getUserExploreInfoReq:getActName()
	return self.actName
end






function ExploreAction_getUserExploreInfoReq:encode(outputStream)

end

function ExploreAction_getUserExploreInfoReq:decode(inputStream)
	    local body = {}

	   return body
end