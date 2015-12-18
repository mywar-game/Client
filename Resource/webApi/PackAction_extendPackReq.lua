

PackAction_extendPackReq = {}

--扩展背包
function PackAction_extendPackReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PackAction_extendPackReq:init()
	
	self.int_extendNum=0 --扩展几个格子

	self.actName = "PackAction_extendPack"
end

function PackAction_extendPackReq:getActName()
	return self.actName
end

--扩展几个格子
function PackAction_extendPackReq:setInt_extendNum(int_extendNum)
	self.int_extendNum = int_extendNum
end





function PackAction_extendPackReq:encode(outputStream)
		outputStream:WriteInt(self.int_extendNum)


end

function PackAction_extendPackReq:decode(inputStream)
	    local body = {}
		body.extendNum = inputStream:ReadInt()


	   return body
end