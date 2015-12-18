

PkAction_getPkFightLogReq = {}

--查看战斗日志
function PkAction_getPkFightLogReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_getPkFightLogReq:init()
	
	self.actName = "PkAction_getPkFightLog"
end

function PkAction_getPkFightLogReq:getActName()
	return self.actName
end






function PkAction_getPkFightLogReq:encode(outputStream)

end

function PkAction_getPkFightLogReq:decode(inputStream)
	    local body = {}

	   return body
end