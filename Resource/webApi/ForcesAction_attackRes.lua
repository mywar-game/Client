

ForcesAction_attackRes = {}

--攻击关卡
function ForcesAction_attackRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_attackRes:init()
	
	self.list_userEquipList={} --好友装备列表

	self.list_goodsList={} --即将获得的物品

	self.actName = "ForcesAction_attack"
end

function ForcesAction_attackRes:getActName()
	return self.actName
end

--好友装备列表
function ForcesAction_attackRes:setList_userEquipList(list_userEquipList)
	self.list_userEquipList = list_userEquipList
end
--即将获得的物品
function ForcesAction_attackRes:setList_goodsList(list_goodsList)
	self.list_goodsList = list_goodsList
end





function ForcesAction_attackRes:encode(outputStream)
		
		self.list_userEquipList = self.list_userEquipList or {}
		local list_userEquipListsize = #self.list_userEquipList
		outputStream:WriteInt(list_userEquipListsize)
		for list_userEquipListi=1,list_userEquipListsize do
            self.list_userEquipList[list_userEquipListi]:encode(outputStream)
		end		
		self.list_goodsList = self.list_goodsList or {}
		local list_goodsListsize = #self.list_goodsList
		outputStream:WriteInt(list_goodsListsize)
		for list_goodsListi=1,list_goodsListsize do
            self.list_goodsList[list_goodsListi]:encode(outputStream)
		end
end

function ForcesAction_attackRes:decode(inputStream)
	    local body = {}
		local userEquipListTemp = {}
		local userEquipListsize = inputStream:ReadInt()
		for userEquipListi=1,userEquipListsize do
            local entry = UserEquipBO:New()
            table.insert(userEquipListTemp,entry:decode(inputStream))

		end
		body.userEquipList = userEquipListTemp
		local goodsListTemp = {}
		local goodsListsize = inputStream:ReadInt()
		for goodsListi=1,goodsListsize do
            local entry = GoodsBeanBO:New()
            table.insert(goodsListTemp,entry:decode(inputStream))

		end
		body.goodsList = goodsListTemp

	   return body
end