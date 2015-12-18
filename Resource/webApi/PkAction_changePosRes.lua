

PkAction_changePosRes = {}

--上阵、下阵防守阵营
function PkAction_changePosRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_changePosRes:init()
	
	self.actName = "PkAction_changePos"
end

function PkAction_changePosRes:getActName()
	return self.actName
end






function PkAction_changePosRes:encode(outputStream)

end

function PkAction_changePosRes:decode(inputStream)
	    local body = {}

	   return body
end