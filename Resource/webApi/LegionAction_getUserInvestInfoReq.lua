

LegionAction_getUserInvestInfoReq = {}

--获取用户贡献的信息
function LegionAction_getUserInvestInfoReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_getUserInvestInfoReq:init()
	
	self.actName = "LegionAction_getUserInvestInfo"
end

function LegionAction_getUserInvestInfoReq:getActName()
	return self.actName
end






function LegionAction_getUserInvestInfoReq:encode(outputStream)

end

function LegionAction_getUserInvestInfoReq:decode(inputStream)
	    local body = {}

	   return body
end