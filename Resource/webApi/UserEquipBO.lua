

UserEquipBO = {}

--用户装备对象
function UserEquipBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserEquipBO:init()
	
	self.string_userId="" --用户编号

	self.string_userEquipId="" --用户装备唯一id

	self.string_userHeroId="" --用户英雄唯一id

	self.int_equipId=0 --系统装备唯一id

	self.string_equipMainAttr="" --装备主属性

	self.string_equipSecondaryAttr="" --装备次级属性

	self.int_pos=0 --用户穿戴的位置

	self.int_holeNum=0 --几个镶孔

	self.string_magicEquipAttr="" --装备附魔的属性

	self.int_storehouseNum=0 --仓库数量为1时，即该装备是在仓库中

	self.actName = "UserEquipBO"
end

function UserEquipBO:getActName()
	return self.actName
end

--用户编号
function UserEquipBO:setString_userId(string_userId)
	self.string_userId = string_userId
end
--用户装备唯一id
function UserEquipBO:setString_userEquipId(string_userEquipId)
	self.string_userEquipId = string_userEquipId
end
--用户英雄唯一id
function UserEquipBO:setString_userHeroId(string_userHeroId)
	self.string_userHeroId = string_userHeroId
end
--系统装备唯一id
function UserEquipBO:setInt_equipId(int_equipId)
	self.int_equipId = int_equipId
end
--装备主属性
function UserEquipBO:setString_equipMainAttr(string_equipMainAttr)
	self.string_equipMainAttr = string_equipMainAttr
end
--装备次级属性
function UserEquipBO:setString_equipSecondaryAttr(string_equipSecondaryAttr)
	self.string_equipSecondaryAttr = string_equipSecondaryAttr
end
--用户穿戴的位置
function UserEquipBO:setInt_pos(int_pos)
	self.int_pos = int_pos
end
--几个镶孔
function UserEquipBO:setInt_holeNum(int_holeNum)
	self.int_holeNum = int_holeNum
end
--装备附魔的属性
function UserEquipBO:setString_magicEquipAttr(string_magicEquipAttr)
	self.string_magicEquipAttr = string_magicEquipAttr
end
--仓库数量为1时，即该装备是在仓库中
function UserEquipBO:setInt_storehouseNum(int_storehouseNum)
	self.int_storehouseNum = int_storehouseNum
end





function UserEquipBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)

		outputStream:WriteUTFString(self.string_userEquipId)

		outputStream:WriteUTFString(self.string_userHeroId)

		outputStream:WriteInt(self.int_equipId)

		outputStream:WriteUTFString(self.string_equipMainAttr)

		outputStream:WriteUTFString(self.string_equipSecondaryAttr)

		outputStream:WriteInt(self.int_pos)

		outputStream:WriteInt(self.int_holeNum)

		outputStream:WriteUTFString(self.string_magicEquipAttr)

		outputStream:WriteInt(self.int_storehouseNum)


end

function UserEquipBO:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()

		body.userEquipId = inputStream:ReadUTFString()

		body.userHeroId = inputStream:ReadUTFString()

		body.equipId = inputStream:ReadInt()

		body.equipMainAttr = inputStream:ReadUTFString()

		body.equipSecondaryAttr = inputStream:ReadUTFString()

		body.pos = inputStream:ReadInt()

		body.holeNum = inputStream:ReadInt()

		body.magicEquipAttr = inputStream:ReadUTFString()

		body.storehouseNum = inputStream:ReadInt()


	   return body
end