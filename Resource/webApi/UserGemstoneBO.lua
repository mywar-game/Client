

UserGemstoneBO = {}

--用户宝石对象
function UserGemstoneBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserGemstoneBO:init()
	
	self.string_userGemstoneId="" --用户宝石唯一id

	self.string_userEquipId="" --宝石镶嵌的用户装备id

	self.int_gemstoneId=0 --系统宝石id

	self.string_attr="" --宝石属性（eg

	self.int_pos=0 --宝石位置

	self.int_storehouseNum=0 --仓库数量为1时，即该装备是在仓库中

	self.actName = "UserGemstoneBO"
end

function UserGemstoneBO:getActName()
	return self.actName
end

--用户宝石唯一id
function UserGemstoneBO:setString_userGemstoneId(string_userGemstoneId)
	self.string_userGemstoneId = string_userGemstoneId
end
--宝石镶嵌的用户装备id
function UserGemstoneBO:setString_userEquipId(string_userEquipId)
	self.string_userEquipId = string_userEquipId
end
--系统宝石id
function UserGemstoneBO:setInt_gemstoneId(int_gemstoneId)
	self.int_gemstoneId = int_gemstoneId
end
--宝石属性（eg
function UserGemstoneBO:setString_attr(string_attr)
	self.string_attr = string_attr
end
--宝石位置
function UserGemstoneBO:setInt_pos(int_pos)
	self.int_pos = int_pos
end
--仓库数量为1时，即该装备是在仓库中
function UserGemstoneBO:setInt_storehouseNum(int_storehouseNum)
	self.int_storehouseNum = int_storehouseNum
end





function UserGemstoneBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_userGemstoneId)

		outputStream:WriteUTFString(self.string_userEquipId)

		outputStream:WriteInt(self.int_gemstoneId)

		outputStream:WriteUTFString(self.string_attr)

		outputStream:WriteInt(self.int_pos)

		outputStream:WriteInt(self.int_storehouseNum)


end

function UserGemstoneBO:decode(inputStream)
	    local body = {}
		body.userGemstoneId = inputStream:ReadUTFString()

		body.userEquipId = inputStream:ReadUTFString()

		body.gemstoneId = inputStream:ReadInt()

		body.attr = inputStream:ReadUTFString()

		body.pos = inputStream:ReadInt()

		body.storehouseNum = inputStream:ReadInt()


	   return body
end