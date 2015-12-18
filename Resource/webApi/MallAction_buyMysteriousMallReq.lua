

MallAction_buyMysteriousMallReq = {}

--购买神秘商店的商品
function MallAction_buyMysteriousMallReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MallAction_buyMysteriousMallReq:init()
	
	self.int_mallId=0 --商品id

	self.actName = "MallAction_buyMysteriousMall"
end

function MallAction_buyMysteriousMallReq:getActName()
	return self.actName
end

--商品id
function MallAction_buyMysteriousMallReq:setInt_mallId(int_mallId)
	self.int_mallId = int_mallId
end





function MallAction_buyMysteriousMallReq:encode(outputStream)
		outputStream:WriteInt(self.int_mallId)


end

function MallAction_buyMysteriousMallReq:decode(inputStream)
	    local body = {}
		body.mallId = inputStream:ReadInt()


	   return body
end