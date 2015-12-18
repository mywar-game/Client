

LifeAction_cancelHangupReq = {}

--取消挂机
function LifeAction_cancelHangupReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LifeAction_cancelHangupReq:init()
	
	self.int_category=0 --类别（1矿场2花圃3渔场）

	self.actName = "LifeAction_cancelHangup"
end

function LifeAction_cancelHangupReq:getActName()
	return self.actName
end

--类别（1矿场2花圃3渔场）
function LifeAction_cancelHangupReq:setInt_category(int_category)
	self.int_category = int_category
end





function LifeAction_cancelHangupReq:encode(outputStream)
		outputStream:WriteInt(self.int_category)


end

function LifeAction_cancelHangupReq:decode(inputStream)
	    local body = {}
		body.category = inputStream:ReadInt()


	   return body
end