

PkAction_refreshMallRes = {}

--荣誉商店刷新
function PkAction_refreshMallRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_refreshMallRes:init()
	
	self.actName = "PkAction_refreshMall"
end

function PkAction_refreshMallRes:getActName()
	return self.actName
end






function PkAction_refreshMallRes:encode(outputStream)

end

function PkAction_refreshMallRes:decode(inputStream)
	    local body = {}

	   return body
end