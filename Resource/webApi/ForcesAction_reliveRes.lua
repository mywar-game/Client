

ForcesAction_reliveRes = {}

--复活
function ForcesAction_reliveRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_reliveRes:init()
	
	self.int_gold=0 --用户剩余金币

	self.int_money=0 --用户剩余钻石

	self.actName = "ForcesAction_relive"
end

function ForcesAction_reliveRes:getActName()
	return self.actName
end

--用户剩余金币
function ForcesAction_reliveRes:setInt_gold(int_gold)
	self.int_gold = int_gold
end
--用户剩余钻石
function ForcesAction_reliveRes:setInt_money(int_money)
	self.int_money = int_money
end





function ForcesAction_reliveRes:encode(outputStream)
		outputStream:WriteInt(self.int_gold)

		outputStream:WriteInt(self.int_money)


end

function ForcesAction_reliveRes:decode(inputStream)
	    local body = {}
		body.gold = inputStream:ReadInt()

		body.money = inputStream:ReadInt()


	   return body
end