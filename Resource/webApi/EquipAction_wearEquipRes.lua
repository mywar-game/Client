

EquipAction_wearEquipRes = {}

--穿戴装备
function EquipAction_wearEquipRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function EquipAction_wearEquipRes:init()
	
	self.list_userEquipBOList={} --用户装备列表

	self.actName = "EquipAction_wearEquip"
end

function EquipAction_wearEquipRes:getActName()
	return self.actName
end

--用户装备列表
function EquipAction_wearEquipRes:setList_userEquipBOList(list_userEquipBOList)
	self.list_userEquipBOList = list_userEquipBOList
end





function EquipAction_wearEquipRes:encode(outputStream)
		
		self.list_userEquipBOList = self.list_userEquipBOList or {}
		local list_userEquipBOListsize = #self.list_userEquipBOList
		outputStream:WriteInt(list_userEquipBOListsize)
		for list_userEquipBOListi=1,list_userEquipBOListsize do
            self.list_userEquipBOList[list_userEquipBOListi]:encode(outputStream)
		end
end

function EquipAction_wearEquipRes:decode(inputStream)
	    local body = {}
		local userEquipBOListTemp = {}
		local userEquipBOListsize = inputStream:ReadInt()
		for userEquipBOListi=1,userEquipBOListsize do
            local entry = UserEquipBO:New()
            table.insert(userEquipBOListTemp,entry:decode(inputStream))

		end
		body.userEquipBOList = userEquipBOListTemp

	   return body
end