

PkAction_enterPkReq = {}

--首次进入竞技场
function PkAction_enterPkReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_enterPkReq:init()
	
	self.actName = "PkAction_enterPk"
end

function PkAction_enterPkReq:getActName()
	return self.actName
end






function PkAction_enterPkReq:encode(outputStream)

end

function PkAction_enterPkReq:decode(inputStream)
	    local body = {}

	   return body
end