

LegionAction_getLegionListReq = {}

--查看公会列表
function LegionAction_getLegionListReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_getLegionListReq:init()
	
	self.actName = "LegionAction_getLegionList"
end

function LegionAction_getLegionListReq:getActName()
	return self.actName
end






function LegionAction_getLegionListReq:encode(outputStream)

end

function LegionAction_getLegionListReq:decode(inputStream)
	    local body = {}

	   return body
end