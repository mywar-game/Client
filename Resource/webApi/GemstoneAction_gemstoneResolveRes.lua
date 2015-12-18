

GemstoneAction_gemstoneResolveRes = {}

--宝石分解
function GemstoneAction_gemstoneResolveRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function GemstoneAction_gemstoneResolveRes:init()
	
	self.int_status=0 --状态：1开始2取消3完成

	self.CommonGoodsBeanBO_drop=nil --通用奖励对象

	self.int_gold=0 --用户剩余金币

	self.int_money=0 --用户剩余钻石

	self.list_userGemstoneIdList={} --被分解的用户宝石id列表

	self.actName = "GemstoneAction_gemstoneResolve"
end

function GemstoneAction_gemstoneResolveRes:getActName()
	return self.actName
end

--状态：1开始2取消3完成
function GemstoneAction_gemstoneResolveRes:setInt_status(int_status)
	self.int_status = int_status
end
--通用奖励对象
function GemstoneAction_gemstoneResolveRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end
--用户剩余金币
function GemstoneAction_gemstoneResolveRes:setInt_gold(int_gold)
	self.int_gold = int_gold
end
--用户剩余钻石
function GemstoneAction_gemstoneResolveRes:setInt_money(int_money)
	self.int_money = int_money
end
--被分解的用户宝石id列表
function GemstoneAction_gemstoneResolveRes:setList_userGemstoneIdList(list_userGemstoneIdList)
	self.list_userGemstoneIdList = list_userGemstoneIdList
end





function GemstoneAction_gemstoneResolveRes:encode(outputStream)
		outputStream:WriteInt(self.int_status)

		self.CommonGoodsBeanBO_drop:encode(outputStream)

		outputStream:WriteInt(self.int_gold)

		outputStream:WriteInt(self.int_money)

		
		self.list_userGemstoneIdList = self.list_userGemstoneIdList or {}
		local list_userGemstoneIdListsize = #self.list_userGemstoneIdList
		outputStream:WriteInt(list_userGemstoneIdListsize)
		for list_userGemstoneIdListi=1,list_userGemstoneIdListsize do
            outputStream:WriteUTFString(self.list_userGemstoneIdList[list_userGemstoneIdListi])
		end
end

function GemstoneAction_gemstoneResolveRes:decode(inputStream)
	    local body = {}
		body.status = inputStream:ReadInt()

        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)
		body.gold = inputStream:ReadInt()

		body.money = inputStream:ReadInt()

		local userGemstoneIdListTemp = {}
		local userGemstoneIdListsize = inputStream:ReadInt()
		for userGemstoneIdListi=1,userGemstoneIdListsize do
            table.insert(userGemstoneIdListTemp,inputStream:ReadUTFString())
		end
		body.userGemstoneIdList = userGemstoneIdListTemp

	   return body
end