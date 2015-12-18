

ActivityAction_receiveGiftBagReq = {}

--领取声望奖励
function ActivityAction_receiveGiftBagReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ActivityAction_receiveGiftBagReq:init()
	
	self.string_code="" --礼包码

	self.actName = "ActivityAction_receiveGiftBag"
end

function ActivityAction_receiveGiftBagReq:getActName()
	return self.actName
end

--礼包码
function ActivityAction_receiveGiftBagReq:setString_code(string_code)
	self.string_code = string_code
end





function ActivityAction_receiveGiftBagReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_code)


end

function ActivityAction_receiveGiftBagReq:decode(inputStream)
	    local body = {}
		body.code = inputStream:ReadUTFString()


	   return body
end