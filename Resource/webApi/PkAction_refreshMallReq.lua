

PkAction_refreshMallReq = {}

--荣誉商店刷新
function PkAction_refreshMallReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_refreshMallReq:init()
	
	self.actName = "PkAction_refreshMall"
end

function PkAction_refreshMallReq:getActName()
	return self.actName
end






function PkAction_refreshMallReq:encode(outputStream)

end

function PkAction_refreshMallReq:decode(inputStream)
	    local body = {}

	   return body
end