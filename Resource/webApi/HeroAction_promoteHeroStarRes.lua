

HeroAction_promoteHeroStarRes = {}

--升星
function HeroAction_promoteHeroStarRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_promoteHeroStarRes:init()
	
	self.UserHeroBO_userHeroBO=nil --用户英雄

	self.int_gold=0 --用户剩余金币

	self.int_money=0 --用户剩余钻石

	self.list_goodsList={} --消耗的道具

	self.actName = "HeroAction_promoteHeroStar"
end

function HeroAction_promoteHeroStarRes:getActName()
	return self.actName
end

--用户英雄
function HeroAction_promoteHeroStarRes:setUserHeroBO_userHeroBO(UserHeroBO_userHeroBO)
	self.UserHeroBO_userHeroBO = UserHeroBO_userHeroBO
end
--用户剩余金币
function HeroAction_promoteHeroStarRes:setInt_gold(int_gold)
	self.int_gold = int_gold
end
--用户剩余钻石
function HeroAction_promoteHeroStarRes:setInt_money(int_money)
	self.int_money = int_money
end
--消耗的道具
function HeroAction_promoteHeroStarRes:setList_goodsList(list_goodsList)
	self.list_goodsList = list_goodsList
end





function HeroAction_promoteHeroStarRes:encode(outputStream)
		self.UserHeroBO_userHeroBO:encode(outputStream)

		outputStream:WriteInt(self.int_gold)

		outputStream:WriteInt(self.int_money)

		
		self.list_goodsList = self.list_goodsList or {}
		local list_goodsListsize = #self.list_goodsList
		outputStream:WriteInt(list_goodsListsize)
		for list_goodsListi=1,list_goodsListsize do
            self.list_goodsList[list_goodsListi]:encode(outputStream)
		end
end

function HeroAction_promoteHeroStarRes:decode(inputStream)
	    local body = {}
        local userHeroBOTemp = UserHeroBO:New()
        body.userHeroBO=userHeroBOTemp:decode(inputStream)
		body.gold = inputStream:ReadInt()

		body.money = inputStream:ReadInt()

		local goodsListTemp = {}
		local goodsListsize = inputStream:ReadInt()
		for goodsListi=1,goodsListsize do
            local entry = GoodsBeanBO:New()
            table.insert(goodsListTemp,entry:decode(inputStream))

		end
		body.goodsList = goodsListTemp

	   return body
end