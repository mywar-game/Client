

ExploreAction_exchangeReq = {}

--兑换英雄
function ExploreAction_exchangeReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ExploreAction_exchangeReq:init()
	
	self.int_systemHeroId=0 --英雄系统id

	self.actName = "ExploreAction_exchange"
end

function ExploreAction_exchangeReq:getActName()
	return self.actName
end

--英雄系统id
function ExploreAction_exchangeReq:setInt_systemHeroId(int_systemHeroId)
	self.int_systemHeroId = int_systemHeroId
end





function ExploreAction_exchangeReq:encode(outputStream)
		outputStream:WriteInt(self.int_systemHeroId)


end

function ExploreAction_exchangeReq:decode(inputStream)
	    local body = {}
		body.systemHeroId = inputStream:ReadInt()


	   return body
end