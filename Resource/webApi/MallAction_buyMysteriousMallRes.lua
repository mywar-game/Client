

MallAction_buyMysteriousMallRes = {}

--购买神秘商店的商品
function MallAction_buyMysteriousMallRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MallAction_buyMysteriousMallRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --通用奖励对象

	self.int_money=0 --用户剩余钻石

	self.int_gold=0 --用户剩余金币

	self.actName = "MallAction_buyMysteriousMall"
end

function MallAction_buyMysteriousMallRes:getActName()
	return self.actName
end

--通用奖励对象
function MallAction_buyMysteriousMallRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end
--用户剩余钻石
function MallAction_buyMysteriousMallRes:setInt_money(int_money)
	self.int_money = int_money
end
--用户剩余金币
function MallAction_buyMysteriousMallRes:setInt_gold(int_gold)
	self.int_gold = int_gold
end





function MallAction_buyMysteriousMallRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)

		outputStream:WriteInt(self.int_money)

		outputStream:WriteInt(self.int_gold)


end

function MallAction_buyMysteriousMallRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)
		body.money = inputStream:ReadInt()

		body.gold = inputStream:ReadInt()


	   return body
end