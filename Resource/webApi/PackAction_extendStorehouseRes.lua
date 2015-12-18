

PackAction_extendStorehouseRes = {}

--扩充仓库格子
function PackAction_extendStorehouseRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PackAction_extendStorehouseRes:init()
	
	self.int_extendNum=0 --扩展几个格子

	self.int_money=0 --用户剩余钻石

	self.actName = "PackAction_extendStorehouse"
end

function PackAction_extendStorehouseRes:getActName()
	return self.actName
end

--扩展几个格子
function PackAction_extendStorehouseRes:setInt_extendNum(int_extendNum)
	self.int_extendNum = int_extendNum
end
--用户剩余钻石
function PackAction_extendStorehouseRes:setInt_money(int_money)
	self.int_money = int_money
end





function PackAction_extendStorehouseRes:encode(outputStream)
		outputStream:WriteInt(self.int_extendNum)

		outputStream:WriteInt(self.int_money)


end

function PackAction_extendStorehouseRes:decode(inputStream)
	    local body = {}
		body.extendNum = inputStream:ReadInt()

		body.money = inputStream:ReadInt()


	   return body
end