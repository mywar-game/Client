

CommonGoodsBeanBO = {}

--通用奖励对象列表
function CommonGoodsBeanBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function CommonGoodsBeanBO:init()
	
	self.list_goodsList={} --奖励对象列表,如money，金币，经验，道具等等

	self.list_heroList={} --获得的英雄列表

	self.list_heroSkillList={} --获得的英雄技能列表(包括团长技能)

	self.list_equipList={} --获得装备列表

	self.list_gemstoneList={} --获得用户宝石列表

	self.actName = "CommonGoodsBeanBO"
end

function CommonGoodsBeanBO:getActName()
	return self.actName
end

--奖励对象列表,如money，金币，经验，道具等等
function CommonGoodsBeanBO:setList_goodsList(list_goodsList)
	self.list_goodsList = list_goodsList
end
--获得的英雄列表
function CommonGoodsBeanBO:setList_heroList(list_heroList)
	self.list_heroList = list_heroList
end
--获得的英雄技能列表(包括团长技能)
function CommonGoodsBeanBO:setList_heroSkillList(list_heroSkillList)
	self.list_heroSkillList = list_heroSkillList
end
--获得装备列表
function CommonGoodsBeanBO:setList_equipList(list_equipList)
	self.list_equipList = list_equipList
end
--获得用户宝石列表
function CommonGoodsBeanBO:setList_gemstoneList(list_gemstoneList)
	self.list_gemstoneList = list_gemstoneList
end





function CommonGoodsBeanBO:encode(outputStream)
		
		self.list_goodsList = self.list_goodsList or {}
		local list_goodsListsize = #self.list_goodsList
		outputStream:WriteInt(list_goodsListsize)
		for list_goodsListi=1,list_goodsListsize do
            self.list_goodsList[list_goodsListi]:encode(outputStream)
		end		
		self.list_heroList = self.list_heroList or {}
		local list_heroListsize = #self.list_heroList
		outputStream:WriteInt(list_heroListsize)
		for list_heroListi=1,list_heroListsize do
            self.list_heroList[list_heroListi]:encode(outputStream)
		end		
		self.list_heroSkillList = self.list_heroSkillList or {}
		local list_heroSkillListsize = #self.list_heroSkillList
		outputStream:WriteInt(list_heroSkillListsize)
		for list_heroSkillListi=1,list_heroSkillListsize do
            self.list_heroSkillList[list_heroSkillListi]:encode(outputStream)
		end		
		self.list_equipList = self.list_equipList or {}
		local list_equipListsize = #self.list_equipList
		outputStream:WriteInt(list_equipListsize)
		for list_equipListi=1,list_equipListsize do
            self.list_equipList[list_equipListi]:encode(outputStream)
		end		
		self.list_gemstoneList = self.list_gemstoneList or {}
		local list_gemstoneListsize = #self.list_gemstoneList
		outputStream:WriteInt(list_gemstoneListsize)
		for list_gemstoneListi=1,list_gemstoneListsize do
            self.list_gemstoneList[list_gemstoneListi]:encode(outputStream)
		end
end

function CommonGoodsBeanBO:decode(inputStream)
	    local body = {}
		local goodsListTemp = {}
		local goodsListsize = inputStream:ReadInt()
		for goodsListi=1,goodsListsize do
            local entry = GoodsBeanBO:New()
            table.insert(goodsListTemp,entry:decode(inputStream))

		end
		body.goodsList = goodsListTemp
		local heroListTemp = {}
		local heroListsize = inputStream:ReadInt()
		for heroListi=1,heroListsize do
            local entry = UserHeroBO:New()
            table.insert(heroListTemp,entry:decode(inputStream))

		end
		body.heroList = heroListTemp
		local heroSkillListTemp = {}
		local heroSkillListsize = inputStream:ReadInt()
		for heroSkillListi=1,heroSkillListsize do
            local entry = UserHeroSkillBO:New()
            table.insert(heroSkillListTemp,entry:decode(inputStream))

		end
		body.heroSkillList = heroSkillListTemp
		local equipListTemp = {}
		local equipListsize = inputStream:ReadInt()
		for equipListi=1,equipListsize do
            local entry = UserEquipBO:New()
            table.insert(equipListTemp,entry:decode(inputStream))

		end
		body.equipList = equipListTemp
		local gemstoneListTemp = {}
		local gemstoneListsize = inputStream:ReadInt()
		for gemstoneListi=1,gemstoneListsize do
            local entry = UserGemstoneBO:New()
            table.insert(gemstoneListTemp,entry:decode(inputStream))

		end
		body.gemstoneList = gemstoneListTemp

	   return body
end