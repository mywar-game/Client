

GemstoneAction_gemstoneUpgradeRes = {}

--宝石精炼升级
function GemstoneAction_gemstoneUpgradeRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function GemstoneAction_gemstoneUpgradeRes:init()
	
	self.UserGemstoneBO_userGemstoneBO=nil --用户宝石信息

	self.list_userGemstoneIdList={} --扣除的用户宝石id

	self.list_goodsList={} --消耗的道具

	self.int_status=0 --状态：1开始2取消3完成

	self.int_gold=0 --用户剩余金币

	self.int_money=0 --用户剩余钻石

	self.actName = "GemstoneAction_gemstoneUpgrade"
end

function GemstoneAction_gemstoneUpgradeRes:getActName()
	return self.actName
end

--用户宝石信息
function GemstoneAction_gemstoneUpgradeRes:setUserGemstoneBO_userGemstoneBO(UserGemstoneBO_userGemstoneBO)
	self.UserGemstoneBO_userGemstoneBO = UserGemstoneBO_userGemstoneBO
end
--扣除的用户宝石id
function GemstoneAction_gemstoneUpgradeRes:setList_userGemstoneIdList(list_userGemstoneIdList)
	self.list_userGemstoneIdList = list_userGemstoneIdList
end
--消耗的道具
function GemstoneAction_gemstoneUpgradeRes:setList_goodsList(list_goodsList)
	self.list_goodsList = list_goodsList
end
--状态：1开始2取消3完成
function GemstoneAction_gemstoneUpgradeRes:setInt_status(int_status)
	self.int_status = int_status
end
--用户剩余金币
function GemstoneAction_gemstoneUpgradeRes:setInt_gold(int_gold)
	self.int_gold = int_gold
end
--用户剩余钻石
function GemstoneAction_gemstoneUpgradeRes:setInt_money(int_money)
	self.int_money = int_money
end





function GemstoneAction_gemstoneUpgradeRes:encode(outputStream)
		self.UserGemstoneBO_userGemstoneBO:encode(outputStream)

		
		self.list_userGemstoneIdList = self.list_userGemstoneIdList or {}
		local list_userGemstoneIdListsize = #self.list_userGemstoneIdList
		outputStream:WriteInt(list_userGemstoneIdListsize)
		for list_userGemstoneIdListi=1,list_userGemstoneIdListsize do
            outputStream:WriteUTFString(self.list_userGemstoneIdList[list_userGemstoneIdListi])
		end		
		self.list_goodsList = self.list_goodsList or {}
		local list_goodsListsize = #self.list_goodsList
		outputStream:WriteInt(list_goodsListsize)
		for list_goodsListi=1,list_goodsListsize do
            self.list_goodsList[list_goodsListi]:encode(outputStream)
		end		outputStream:WriteInt(self.int_status)

		outputStream:WriteInt(self.int_gold)

		outputStream:WriteInt(self.int_money)


end

function GemstoneAction_gemstoneUpgradeRes:decode(inputStream)
	    local body = {}
        local userGemstoneBOTemp = UserGemstoneBO:New()
        body.userGemstoneBO=userGemstoneBOTemp:decode(inputStream)
		local userGemstoneIdListTemp = {}
		local userGemstoneIdListsize = inputStream:ReadInt()
		for userGemstoneIdListi=1,userGemstoneIdListsize do
            table.insert(userGemstoneIdListTemp,inputStream:ReadUTFString())
		end
		body.userGemstoneIdList = userGemstoneIdListTemp
		local goodsListTemp = {}
		local goodsListsize = inputStream:ReadInt()
		for goodsListi=1,goodsListsize do
            local entry = GoodsBeanBO:New()
            table.insert(goodsListTemp,entry:decode(inputStream))

		end
		body.goodsList = goodsListTemp
		body.status = inputStream:ReadInt()

		body.gold = inputStream:ReadInt()

		body.money = inputStream:ReadInt()


	   return body
end