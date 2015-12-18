

MallAction_buyInReq = {}

--购买
function MallAction_buyInReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MallAction_buyInReq:init()
	
	self.int_mallId=0 --商品id

	self.actName = "MallAction_buyIn"
end

function MallAction_buyInReq:getActName()
	return self.actName
end

--商品id
function MallAction_buyInReq:setInt_mallId(int_mallId)
	self.int_mallId = int_mallId
end





function MallAction_buyInReq:encode(outputStream)
		outputStream:WriteInt(self.int_mallId)


end

function MallAction_buyInReq:decode(inputStream)
	    local body = {}
		body.mallId = inputStream:ReadInt()


	   return body
end