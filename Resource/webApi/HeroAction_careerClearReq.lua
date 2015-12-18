

HeroAction_careerClearReq = {}

--职业解锁
function HeroAction_careerClearReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_careerClearReq:init()
	
	self.int_detailedCareerId=0 --详细职业id

	self.actName = "HeroAction_careerClear"
end

function HeroAction_careerClearReq:getActName()
	return self.actName
end

--详细职业id
function HeroAction_careerClearReq:setInt_detailedCareerId(int_detailedCareerId)
	self.int_detailedCareerId = int_detailedCareerId
end





function HeroAction_careerClearReq:encode(outputStream)
		outputStream:WriteInt(self.int_detailedCareerId)


end

function HeroAction_careerClearReq:decode(inputStream)
	    local body = {}
		body.detailedCareerId = inputStream:ReadInt()


	   return body
end