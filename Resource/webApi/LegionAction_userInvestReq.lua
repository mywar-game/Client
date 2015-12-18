

LegionAction_userInvestReq = {}

--用户捐献
function LegionAction_userInvestReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_userInvestReq:init()
	
	self.int_id=0 --捐献的id

	self.actName = "LegionAction_userInvest"
end

function LegionAction_userInvestReq:getActName()
	return self.actName
end

--捐献的id
function LegionAction_userInvestReq:setInt_id(int_id)
	self.int_id = int_id
end





function LegionAction_userInvestReq:encode(outputStream)
		outputStream:WriteInt(self.int_id)


end

function LegionAction_userInvestReq:decode(inputStream)
	    local body = {}
		body.id = inputStream:ReadInt()


	   return body
end