

EquipAction_equipForgeRes = {}

--锻造
function EquipAction_equipForgeRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function EquipAction_equipForgeRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --通用奖励对象

	self.int_money=0 --剩余钻石

	self.int_gold=0 --剩余金币

	self.list_goodsList={} --消耗的道具

	self.list_userEquipIdList={} --消耗掉的用户装备id列表

	self.actName = "EquipAction_equipForge"
end

function EquipAction_equipForgeRes:getActName()
	return self.actName
end

--通用奖励对象
function EquipAction_equipForgeRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end
--剩余钻石
function EquipAction_equipForgeRes:setInt_money(int_money)
	self.int_money = int_money
end
--剩余金币
function EquipAction_equipForgeRes:setInt_gold(int_gold)
	self.int_gold = int_gold
end
--消耗的道具
function EquipAction_equipForgeRes:setList_goodsList(list_goodsList)
	self.list_goodsList = list_goodsList
end
--消耗掉的用户装备id列表
function EquipAction_equipForgeRes:setList_userEquipIdList(list_userEquipIdList)
	self.list_userEquipIdList = list_userEquipIdList
end





function EquipAction_equipForgeRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)

		outputStream:WriteInt(self.int_money)

		outputStream:WriteInt(self.int_gold)

		
		self.list_goodsList = self.list_goodsList or {}
		local list_goodsListsize = #self.list_goodsList
		outputStream:WriteInt(list_goodsListsize)
		for list_goodsListi=1,list_goodsListsize do
            self.list_goodsList[list_goodsListi]:encode(outputStream)
		end		
		self.list_userEquipIdList = self.list_userEquipIdList or {}
		local list_userEquipIdListsize = #self.list_userEquipIdList
		outputStream:WriteInt(list_userEquipIdListsize)
		for list_userEquipIdListi=1,list_userEquipIdListsize do
            outputStream:WriteUTFString(self.list_userEquipIdList[list_userEquipIdListi])
		end
end

function EquipAction_equipForgeRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)
		body.money = inputStream:ReadInt()

		body.gold = inputStream:ReadInt()

		local goodsListTemp = {}
		local goodsListsize = inputStream:ReadInt()
		for goodsListi=1,goodsListsize do
            local entry = GoodsBeanBO:New()
            table.insert(goodsListTemp,entry:decode(inputStream))

		end
		body.goodsList = goodsListTemp
		local userEquipIdListTemp = {}
		local userEquipIdListsize = inputStream:ReadInt()
		for userEquipIdListi=1,userEquipIdListsize do
            table.insert(userEquipIdListTemp,inputStream:ReadUTFString())
		end
		body.userEquipIdList = userEquipIdListTemp

	   return body
end