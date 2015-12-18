

PrestigeAction_inviteHeroRes = {}

--邀请英雄
function PrestigeAction_inviteHeroRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PrestigeAction_inviteHeroRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --通用奖励对象

	self.int_gold=0 --金币

	self.int_money=0 --钻石

	self.actName = "PrestigeAction_inviteHero"
end

function PrestigeAction_inviteHeroRes:getActName()
	return self.actName
end

--通用奖励对象
function PrestigeAction_inviteHeroRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end
--金币
function PrestigeAction_inviteHeroRes:setInt_gold(int_gold)
	self.int_gold = int_gold
end
--钻石
function PrestigeAction_inviteHeroRes:setInt_money(int_money)
	self.int_money = int_money
end





function PrestigeAction_inviteHeroRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)

		outputStream:WriteInt(self.int_gold)

		outputStream:WriteInt(self.int_money)


end

function PrestigeAction_inviteHeroRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)
		body.gold = inputStream:ReadInt()

		body.money = inputStream:ReadInt()


	   return body
end