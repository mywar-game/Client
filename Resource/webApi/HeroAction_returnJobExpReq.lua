

HeroAction_returnJobExpReq = {}

--职业解锁回退
function HeroAction_returnJobExpReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_returnJobExpReq:init()
	
	self.int_detailedCareerId=0 --详细职业id

	self.actName = "HeroAction_returnJobExp"
end

function HeroAction_returnJobExpReq:getActName()
	return self.actName
end

--详细职业id
function HeroAction_returnJobExpReq:setInt_detailedCareerId(int_detailedCareerId)
	self.int_detailedCareerId = int_detailedCareerId
end





function HeroAction_returnJobExpReq:encode(outputStream)
		outputStream:WriteInt(self.int_detailedCareerId)


end

function HeroAction_returnJobExpReq:decode(inputStream)
	    local body = {}
		body.detailedCareerId = inputStream:ReadInt()


	   return body
end