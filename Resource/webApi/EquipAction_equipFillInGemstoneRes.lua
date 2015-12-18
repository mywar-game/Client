

EquipAction_equipFillInGemstoneRes = {}

--装备镶嵌宝石换宝石、取下宝石
function EquipAction_equipFillInGemstoneRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function EquipAction_equipFillInGemstoneRes:init()
	
	self.list_userGemstoneBOList={} --用户宝石列表信息

	self.actName = "EquipAction_equipFillInGemstone"
end

function EquipAction_equipFillInGemstoneRes:getActName()
	return self.actName
end

--用户宝石列表信息
function EquipAction_equipFillInGemstoneRes:setList_userGemstoneBOList(list_userGemstoneBOList)
	self.list_userGemstoneBOList = list_userGemstoneBOList
end





function EquipAction_equipFillInGemstoneRes:encode(outputStream)
		
		self.list_userGemstoneBOList = self.list_userGemstoneBOList or {}
		local list_userGemstoneBOListsize = #self.list_userGemstoneBOList
		outputStream:WriteInt(list_userGemstoneBOListsize)
		for list_userGemstoneBOListi=1,list_userGemstoneBOListsize do
            self.list_userGemstoneBOList[list_userGemstoneBOListi]:encode(outputStream)
		end
end

function EquipAction_equipFillInGemstoneRes:decode(inputStream)
	    local body = {}
		local userGemstoneBOListTemp = {}
		local userGemstoneBOListsize = inputStream:ReadInt()
		for userGemstoneBOListi=1,userGemstoneBOListsize do
            local entry = UserGemstoneBO:New()
            table.insert(userGemstoneBOListTemp,entry:decode(inputStream))

		end
		body.userGemstoneBOList = userGemstoneBOListTemp

	   return body
end