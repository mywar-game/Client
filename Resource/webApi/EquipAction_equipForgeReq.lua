

EquipAction_equipForgeReq = {}

--锻造
function EquipAction_equipForgeReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function EquipAction_equipForgeReq:init()
	
	self.int_forgeType=0 --1装备锻造3矿石锻造4草药淬炼

	self.int_toolType=0 --道具类型

	self.int_toolId=0 --道具id

	self.int_status=0 --状态：1开始锻造2取消锻造3完成锻造

	self.string_material="" --材料（只有在“其他”里面需要传入）

	self.int_num=0 --数量（默认传入1只有在“其他”里面用户选择输入）

	self.actName = "EquipAction_equipForge"
end

function EquipAction_equipForgeReq:getActName()
	return self.actName
end

--1装备锻造3矿石锻造4草药淬炼
function EquipAction_equipForgeReq:setInt_forgeType(int_forgeType)
	self.int_forgeType = int_forgeType
end
--道具类型
function EquipAction_equipForgeReq:setInt_toolType(int_toolType)
	self.int_toolType = int_toolType
end
--道具id
function EquipAction_equipForgeReq:setInt_toolId(int_toolId)
	self.int_toolId = int_toolId
end
--状态：1开始锻造2取消锻造3完成锻造
function EquipAction_equipForgeReq:setInt_status(int_status)
	self.int_status = int_status
end
--材料（只有在“其他”里面需要传入）
function EquipAction_equipForgeReq:setString_material(string_material)
	self.string_material = string_material
end
--数量（默认传入1只有在“其他”里面用户选择输入）
function EquipAction_equipForgeReq:setInt_num(int_num)
	self.int_num = int_num
end





function EquipAction_equipForgeReq:encode(outputStream)
		outputStream:WriteInt(self.int_forgeType)

		outputStream:WriteInt(self.int_toolType)

		outputStream:WriteInt(self.int_toolId)

		outputStream:WriteInt(self.int_status)

		outputStream:WriteUTFString(self.string_material)

		outputStream:WriteInt(self.int_num)


end

function EquipAction_equipForgeReq:decode(inputStream)
	    local body = {}
		body.forgeType = inputStream:ReadInt()

		body.toolType = inputStream:ReadInt()

		body.toolId = inputStream:ReadInt()

		body.status = inputStream:ReadInt()

		body.material = inputStream:ReadUTFString()

		body.num = inputStream:ReadInt()


	   return body
end