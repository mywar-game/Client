

LegionAction_createLegionReq = {}

--创建军团
function LegionAction_createLegionReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_createLegionReq:init()
	
	self.string_legionName="" --军团名称

	self.int_type=0 --创建军团花费类型，1钻石2金币

	self.actName = "LegionAction_createLegion"
end

function LegionAction_createLegionReq:getActName()
	return self.actName
end

--军团名称
function LegionAction_createLegionReq:setString_legionName(string_legionName)
	self.string_legionName = string_legionName
end
--创建军团花费类型，1钻石2金币
function LegionAction_createLegionReq:setInt_type(int_type)
	self.int_type = int_type
end





function LegionAction_createLegionReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_legionName)

		outputStream:WriteInt(self.int_type)


end

function LegionAction_createLegionReq:decode(inputStream)
	    local body = {}
		body.legionName = inputStream:ReadUTFString()

		body.type = inputStream:ReadInt()


	   return body
end