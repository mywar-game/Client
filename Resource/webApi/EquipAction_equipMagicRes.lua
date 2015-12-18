

EquipAction_equipMagicRes = {}

--装备附魔
function EquipAction_equipMagicRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function EquipAction_equipMagicRes:init()
	
	self.UserEquipBO_userEquipBO=nil --用户装备信息

	self.list_goodsList={} --消耗的道具

	self.int_gold=0 --用户剩余金币

	self.actName = "EquipAction_equipMagic"
end

function EquipAction_equipMagicRes:getActName()
	return self.actName
end

--用户装备信息
function EquipAction_equipMagicRes:setUserEquipBO_userEquipBO(UserEquipBO_userEquipBO)
	self.UserEquipBO_userEquipBO = UserEquipBO_userEquipBO
end
--消耗的道具
function EquipAction_equipMagicRes:setList_goodsList(list_goodsList)
	self.list_goodsList = list_goodsList
end
--用户剩余金币
function EquipAction_equipMagicRes:setInt_gold(int_gold)
	self.int_gold = int_gold
end





function EquipAction_equipMagicRes:encode(outputStream)
		self.UserEquipBO_userEquipBO:encode(outputStream)

		
		self.list_goodsList = self.list_goodsList or {}
		local list_goodsListsize = #self.list_goodsList
		outputStream:WriteInt(list_goodsListsize)
		for list_goodsListi=1,list_goodsListsize do
            self.list_goodsList[list_goodsListi]:encode(outputStream)
		end		outputStream:WriteInt(self.int_gold)


end

function EquipAction_equipMagicRes:decode(inputStream)
	    local body = {}
        local userEquipBOTemp = UserEquipBO:New()
        body.userEquipBO=userEquipBOTemp:decode(inputStream)
		local goodsListTemp = {}
		local goodsListsize = inputStream:ReadInt()
		for goodsListi=1,goodsListsize do
            local entry = GoodsBeanBO:New()
            table.insert(goodsListTemp,entry:decode(inputStream))

		end
		body.goodsList = goodsListTemp
		body.gold = inputStream:ReadInt()


	   return body
end