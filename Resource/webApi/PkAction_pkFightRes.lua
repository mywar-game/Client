

PkAction_pkFightRes = {}

--竞技场战斗
function PkAction_pkFightRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_pkFightRes:init()
	
	self.actName = "PkAction_pkFight"
end

function PkAction_pkFightRes:getActName()
	return self.actName
end






function PkAction_pkFightRes:encode(outputStream)

end

function PkAction_pkFightRes:decode(inputStream)
	    local body = {}

	   return body
end