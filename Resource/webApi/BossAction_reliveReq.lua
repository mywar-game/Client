

BossAction_reliveReq = {}

--复活
function BossAction_reliveReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function BossAction_reliveReq:init()
	
	self.actName = "BossAction_relive"
end

function BossAction_reliveReq:getActName()
	return self.actName
end






function BossAction_reliveReq:encode(outputStream)

end

function BossAction_reliveReq:decode(inputStream)
	    local body = {}

	   return body
end