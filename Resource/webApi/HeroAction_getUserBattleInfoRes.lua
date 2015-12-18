

HeroAction_getUserBattleInfoRes = {}

--获取用户阵容信息
function HeroAction_getUserBattleInfoRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function HeroAction_getUserBattleInfoRes:init()
	
	self.list_userHeroList={} --用户英雄列表

	self.list_userEquipList={} --英雄装备列表

	self.list_userGemstoneList={} --用户宝石列表

	self.UserBO_user=nil --用户对象

	self.actName = "HeroAction_getUserBattleInfo"
end

function HeroAction_getUserBattleInfoRes:getActName()
	return self.actName
end

--用户英雄列表
function HeroAction_getUserBattleInfoRes:setList_userHeroList(list_userHeroList)
	self.list_userHeroList = list_userHeroList
end
--英雄装备列表
function HeroAction_getUserBattleInfoRes:setList_userEquipList(list_userEquipList)
	self.list_userEquipList = list_userEquipList
end
--用户宝石列表
function HeroAction_getUserBattleInfoRes:setList_userGemstoneList(list_userGemstoneList)
	self.list_userGemstoneList = list_userGemstoneList
end
--用户对象
function HeroAction_getUserBattleInfoRes:setUserBO_user(UserBO_user)
	self.UserBO_user = UserBO_user
end





function HeroAction_getUserBattleInfoRes:encode(outputStream)
		
		self.list_userHeroList = self.list_userHeroList or {}
		local list_userHeroListsize = #self.list_userHeroList
		outputStream:WriteInt(list_userHeroListsize)
		for list_userHeroListi=1,list_userHeroListsize do
            self.list_userHeroList[list_userHeroListi]:encode(outputStream)
		end		
		self.list_userEquipList = self.list_userEquipList or {}
		local list_userEquipListsize = #self.list_userEquipList
		outputStream:WriteInt(list_userEquipListsize)
		for list_userEquipListi=1,list_userEquipListsize do
            self.list_userEquipList[list_userEquipListi]:encode(outputStream)
		end		
		self.list_userGemstoneList = self.list_userGemstoneList or {}
		local list_userGemstoneListsize = #self.list_userGemstoneList
		outputStream:WriteInt(list_userGemstoneListsize)
		for list_userGemstoneListi=1,list_userGemstoneListsize do
            self.list_userGemstoneList[list_userGemstoneListi]:encode(outputStream)
		end		self.UserBO_user:encode(outputStream)


end

function HeroAction_getUserBattleInfoRes:decode(inputStream)
	    local body = {}
		local userHeroListTemp = {}
		local userHeroListsize = inputStream:ReadInt()
		for userHeroListi=1,userHeroListsize do
            local entry = UserHeroBO:New()
            table.insert(userHeroListTemp,entry:decode(inputStream))

		end
		body.userHeroList = userHeroListTemp
		local userEquipListTemp = {}
		local userEquipListsize = inputStream:ReadInt()
		for userEquipListi=1,userEquipListsize do
            local entry = UserEquipBO:New()
            table.insert(userEquipListTemp,entry:decode(inputStream))

		end
		body.userEquipList = userEquipListTemp
		local userGemstoneListTemp = {}
		local userGemstoneListsize = inputStream:ReadInt()
		for userGemstoneListi=1,userGemstoneListsize do
            local entry = UserGemstoneBO:New()
            table.insert(userGemstoneListTemp,entry:decode(inputStream))

		end
		body.userGemstoneList = userGemstoneListTemp
        local userTemp = UserBO:New()
        body.user=userTemp:decode(inputStream)

	   return body
end