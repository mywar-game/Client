

PackAction_extendStorehouseReq = {}

--扩充仓库格子
function PackAction_extendStorehouseReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PackAction_extendStorehouseReq:init()
	
	self.int_extendNum=0 --扩展几个格子

	self.actName = "PackAction_extendStorehouse"
end

function PackAction_extendStorehouseReq:getActName()
	return self.actName
end

--扩展几个格子
function PackAction_extendStorehouseReq:setInt_extendNum(int_extendNum)
	self.int_extendNum = int_extendNum
end





function PackAction_extendStorehouseReq:encode(outputStream)
		outputStream:WriteInt(self.int_extendNum)


end

function PackAction_extendStorehouseReq:decode(inputStream)
	    local body = {}
		body.extendNum = inputStream:ReadInt()


	   return body
end