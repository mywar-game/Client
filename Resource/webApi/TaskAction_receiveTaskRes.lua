

TaskAction_receiveTaskRes = {}

--领取任务奖励
function TaskAction_receiveTaskRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function TaskAction_receiveTaskRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --得到的奖励对象

	self.GoodsBeanBO_goods=nil --上交的道具对象

	self.list_userEquipIdList={} --扣除的用户装备id列表

	self.list_userGemstoneIdList={} --扣除的用户宝石id列表

	self.actName = "TaskAction_receiveTask"
end

function TaskAction_receiveTaskRes:getActName()
	return self.actName
end

--得到的奖励对象
function TaskAction_receiveTaskRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end
--上交的道具对象
function TaskAction_receiveTaskRes:setGoodsBeanBO_goods(GoodsBeanBO_goods)
	self.GoodsBeanBO_goods = GoodsBeanBO_goods
end
--扣除的用户装备id列表
function TaskAction_receiveTaskRes:setList_userEquipIdList(list_userEquipIdList)
	self.list_userEquipIdList = list_userEquipIdList
end
--扣除的用户宝石id列表
function TaskAction_receiveTaskRes:setList_userGemstoneIdList(list_userGemstoneIdList)
	self.list_userGemstoneIdList = list_userGemstoneIdList
end





function TaskAction_receiveTaskRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)

		self.GoodsBeanBO_goods:encode(outputStream)

		
		self.list_userEquipIdList = self.list_userEquipIdList or {}
		local list_userEquipIdListsize = #self.list_userEquipIdList
		outputStream:WriteInt(list_userEquipIdListsize)
		for list_userEquipIdListi=1,list_userEquipIdListsize do
            outputStream:WriteUTFString(self.list_userEquipIdList[list_userEquipIdListi])
		end		
		self.list_userGemstoneIdList = self.list_userGemstoneIdList or {}
		local list_userGemstoneIdListsize = #self.list_userGemstoneIdList
		outputStream:WriteInt(list_userGemstoneIdListsize)
		for list_userGemstoneIdListi=1,list_userGemstoneIdListsize do
            outputStream:WriteUTFString(self.list_userGemstoneIdList[list_userGemstoneIdListi])
		end
end

function TaskAction_receiveTaskRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)
        local goodsTemp = GoodsBeanBO:New()
        body.goods=goodsTemp:decode(inputStream)
		local userEquipIdListTemp = {}
		local userEquipIdListsize = inputStream:ReadInt()
		for userEquipIdListi=1,userEquipIdListsize do
            table.insert(userEquipIdListTemp,inputStream:ReadUTFString())
		end
		body.userEquipIdList = userEquipIdListTemp
		local userGemstoneIdListTemp = {}
		local userGemstoneIdListsize = inputStream:ReadInt()
		for userGemstoneIdListi=1,userGemstoneIdListsize do
            table.insert(userGemstoneIdListTemp,inputStream:ReadUTFString())
		end
		body.userGemstoneIdList = userGemstoneIdListTemp

	   return body
end