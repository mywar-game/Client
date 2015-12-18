

BossAction_reliveRes = {}

--复活
function BossAction_reliveRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function BossAction_reliveRes:init()
	
	self.int_money=0 --用户剩余钻石

	self.actName = "BossAction_relive"
end

function BossAction_reliveRes:getActName()
	return self.actName
end

--用户剩余钻石
function BossAction_reliveRes:setInt_money(int_money)
	self.int_money = int_money
end





function BossAction_reliveRes:encode(outputStream)
		outputStream:WriteInt(self.int_money)


end

function BossAction_reliveRes:decode(inputStream)
	    local body = {}
		body.money = inputStream:ReadInt()


	   return body
end