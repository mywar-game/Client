

PkAction_exchangeReq = {}

--兑换商品
function PkAction_exchangeReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_exchangeReq:init()
	
	self.int_mallId=0 --商品id

	self.actName = "PkAction_exchange"
end

function PkAction_exchangeReq:getActName()
	return self.actName
end

--商品id
function PkAction_exchangeReq:setInt_mallId(int_mallId)
	self.int_mallId = int_mallId
end





function PkAction_exchangeReq:encode(outputStream)
		outputStream:WriteInt(self.int_mallId)


end

function PkAction_exchangeReq:decode(inputStream)
	    local body = {}
		body.mallId = inputStream:ReadInt()


	   return body
end