

PkAction_startPkFightRes = {}

--开始竞技场战斗
function PkAction_startPkFightRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_startPkFightRes:init()
	
	self.list_userHeroList={} --用户防守方英雄列表

	self.list_userEquipList={} --用户装备列表

	self.actName = "PkAction_startPkFight"
end

function PkAction_startPkFightRes:getActName()
	return self.actName
end

--用户防守方英雄列表
function PkAction_startPkFightRes:setList_userHeroList(list_userHeroList)
	self.list_userHeroList = list_userHeroList
end
--用户装备列表
function PkAction_startPkFightRes:setList_userEquipList(list_userEquipList)
	self.list_userEquipList = list_userEquipList
end





function PkAction_startPkFightRes:encode(outputStream)
		
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
end

function PkAction_startPkFightRes:decode(inputStream)
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

	   return body
end