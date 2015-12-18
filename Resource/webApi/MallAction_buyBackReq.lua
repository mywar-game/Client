

MallAction_buyBackReq = {}

--回购
function MallAction_buyBackReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MallAction_buyBackReq:init()
	
	self.string_buyBackId="" --回购id

	self.actName = "MallAction_buyBack"
end

function MallAction_buyBackReq:getActName()
	return self.actName
end

--回购id
function MallAction_buyBackReq:setString_buyBackId(string_buyBackId)
	self.string_buyBackId = string_buyBackId
end





function MallAction_buyBackReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_buyBackId)


end

function MallAction_buyBackReq:decode(inputStream)
	    local body = {}
		body.buyBackId = inputStream:ReadUTFString()


	   return body
end