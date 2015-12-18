

PkAction_getPkRankReq = {}

--查看排行榜
function PkAction_getPkRankReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_getPkRankReq:init()
	
	self.actName = "PkAction_getPkRank"
end

function PkAction_getPkRankReq:getActName()
	return self.actName
end






function PkAction_getPkRankReq:encode(outputStream)

end

function PkAction_getPkRankReq:decode(inputStream)
	    local body = {}

	   return body
end