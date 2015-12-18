

LegionAction_getLegionInfoReq = {}

--查看自己的公会信息
function LegionAction_getLegionInfoReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_getLegionInfoReq:init()
	
	self.actName = "LegionAction_getLegionInfo"
end

function LegionAction_getLegionInfoReq:getActName()
	return self.actName
end






function LegionAction_getLegionInfoReq:encode(outputStream)

end

function LegionAction_getLegionInfoReq:decode(inputStream)
	    local body = {}

	   return body
end