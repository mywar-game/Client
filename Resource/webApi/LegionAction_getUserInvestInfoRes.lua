

LegionAction_getUserInvestInfoRes = {}

--获取用户贡献的信息
function LegionAction_getUserInvestInfoRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_getUserInvestInfoRes:init()
	
	self.int_status=0 --0未贡献1已贡献

	self.actName = "LegionAction_getUserInvestInfo"
end

function LegionAction_getUserInvestInfoRes:getActName()
	return self.actName
end

--0未贡献1已贡献
function LegionAction_getUserInvestInfoRes:setInt_status(int_status)
	self.int_status = int_status
end





function LegionAction_getUserInvestInfoRes:encode(outputStream)
		outputStream:WriteInt(self.int_status)


end

function LegionAction_getUserInvestInfoRes:decode(inputStream)
	    local body = {}
		body.status = inputStream:ReadInt()


	   return body
end