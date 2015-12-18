

GemstoneAction_gemstoneForgeRes = {}

--合成宝石
function GemstoneAction_gemstoneForgeRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function GemstoneAction_gemstoneForgeRes:init()
	
	self.int_status=0 --状态：1开始2取消3完成

	self.CommonGoodsBeanBO_drop=nil --通用奖励对象

	self.list_userGemstoneIdList={} --消耗掉的用户宝石id列表

	self.list_goodsList={} --消耗的道具

	self.int_gold=0 --用户剩余金币

	self.int_money=0 --用户剩余钻石

	self.actName = "GemstoneAction_gemstoneForge"
end

function GemstoneAction_gemstoneForgeRes:getActName()
	return self.actName
end

--状态：1开始2取消3完成
function GemstoneAction_gemstoneForgeRes:setInt_status(int_status)
	self.int_status = int_status
end
--通用奖励对象
function GemstoneAction_gemstoneForgeRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end
--消耗掉的用户宝石id列表
function GemstoneAction_gemstoneForgeRes:setList_userGemstoneIdList(list_userGemstoneIdList)
	self.list_userGemstoneIdList = list_userGemstoneIdList
end
--消耗的道具
function GemstoneAction_gemstoneForgeRes:setList_goodsList(list_goodsList)
	self.list_goodsList = list_goodsList
end
--用户剩余金币
function GemstoneAction_gemstoneForgeRes:setInt_gold(int_gold)
	self.int_gold = int_gold
end
--用户剩余钻石
function GemstoneAction_gemstoneForgeRes:setInt_money(int_money)
	self.int_money = int_money
end





function GemstoneAction_gemstoneForgeRes:encode(outputStream)
		outputStream:WriteInt(self.int_status)

		self.CommonGoodsBeanBO_drop:encode(outputStream)

		
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
		end		outputStream:WriteInt(self.int_gold)

		outputStream:WriteInt(self.int_money)


end

function GemstoneAction_gemstoneForgeRes:decode(inputStream)
	    local body = {}
		body.status = inputStream:ReadInt()

        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)
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
		body.gold = inputStream:ReadInt()

		body.money = inputStream:ReadInt()


	   return body
end