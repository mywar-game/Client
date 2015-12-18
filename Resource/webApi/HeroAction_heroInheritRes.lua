

HeroAction_heroInheritRes = {}

--英雄传承
function HeroAction_heroInheritRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_heroInheritRes:init()
	
	self.list_userHeroList={} --用户英雄列表

	self.int_gold=0 --用户剩余金币

	self.int_money=0 --用户剩余钻石

	self.list_goodsList={} --消耗的道具

	self.actName = "HeroAction_heroInherit"
end

function HeroAction_heroInheritRes:getActName()
	return self.actName
end

--用户英雄列表
function HeroAction_heroInheritRes:setList_userHeroList(list_userHeroList)
	self.list_userHeroList = list_userHeroList
end
--用户剩余金币
function HeroAction_heroInheritRes:setInt_gold(int_gold)
	self.int_gold = int_gold
end
--用户剩余钻石
function HeroAction_heroInheritRes:setInt_money(int_money)
	self.int_money = int_money
end
--消耗的道具
function HeroAction_heroInheritRes:setList_goodsList(list_goodsList)
	self.list_goodsList = list_goodsList
end





function HeroAction_heroInheritRes:encode(outputStream)
		
		self.list_userHeroList = self.list_userHeroList or {}
		local list_userHeroListsize = #self.list_userHeroList
		outputStream:WriteInt(list_userHeroListsize)
		for list_userHeroListi=1,list_userHeroListsize do
            self.list_userHeroList[list_userHeroListi]:encode(outputStream)
		end		outputStream:WriteInt(self.int_gold)

		outputStream:WriteInt(self.int_money)

		
		self.list_goodsList = self.list_goodsList or {}
		local list_goodsListsize = #self.list_goodsList
		outputStream:WriteInt(list_goodsListsize)
		for list_goodsListi=1,list_goodsListsize do
            self.list_goodsList[list_goodsListi]:encode(outputStream)
		end
end

function HeroAction_heroInheritRes:decode(inputStream)
	    local body = {}
		local userHeroListTemp = {}
		local userHeroListsize = inputStream:ReadInt()
		for userHeroListi=1,userHeroListsize do
            local entry = UserHeroBO:New()
            table.insert(userHeroListTemp,entry:decode(inputStream))

		end
		body.userHeroList = userHeroListTemp
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