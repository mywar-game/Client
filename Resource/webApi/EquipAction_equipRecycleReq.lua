

EquipAction_equipRecycleReq = {}

--回收
function EquipAction_equipRecycleReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function EquipAction_equipRecycleReq:init()
	
	self.int_toolType=0 --道具类型

	self.int_toolId=0 --道具id

	self.string_userEquipId="" --用户装备id

	self.int_status=0 --状态：1开始分解2取消分解3完成分解

	self.actName = "EquipAction_equipRecycle"
end

function EquipAction_equipRecycleReq:getActName()
	return self.actName
end

--道具类型
function EquipAction_equipRecycleReq:setInt_toolType(int_toolType)
	self.int_toolType = int_toolType
end
--道具id
function EquipAction_equipRecycleReq:setInt_toolId(int_toolId)
	self.int_toolId = int_toolId
end
--用户装备id
function EquipAction_equipRecycleReq:setString_userEquipId(string_userEquipId)
	self.string_userEquipId = string_userEquipId
end
--状态：1开始分解2取消分解3完成分解
function EquipAction_equipRecycleReq:setInt_status(int_status)
	self.int_status = int_status
end





function EquipAction_equipRecycleReq:encode(outputStream)
		outputStream:WriteInt(self.int_toolType)

		outputStream:WriteInt(self.int_toolId)

		outputStream:WriteUTFString(self.string_userEquipId)

		outputStream:WriteInt(self.int_status)


end

function EquipAction_equipRecycleReq:decode(inputStream)
	    local body = {}
		body.toolType = inputStream:ReadInt()

		body.toolId = inputStream:ReadInt()

		body.userEquipId = inputStream:ReadUTFString()

		body.status = inputStream:ReadInt()


	   return body
end