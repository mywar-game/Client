

UserLegionInfoBO = {}

--用户军团信息对象
function UserLegionInfoBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserLegionInfoBO:init()
	
	self.string_legionId="" --军团id

	self.int_contribution=0 --用户贡献度

	self.int_identity=0 --军团身份1成员2副团长3军团长

	self.actName = "UserLegionInfoBO"
end

function UserLegionInfoBO:getActName()
	return self.actName
end

--军团id
function UserLegionInfoBO:setString_legionId(string_legionId)
	self.string_legionId = string_legionId
end
--用户贡献度
function UserLegionInfoBO:setInt_contribution(int_contribution)
	self.int_contribution = int_contribution
end
--军团身份1成员2副团长3军团长
function UserLegionInfoBO:setInt_identity(int_identity)
	self.int_identity = int_identity
end





function UserLegionInfoBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_legionId)

		outputStream:WriteInt(self.int_contribution)

		outputStream:WriteInt(self.int_identity)


end

function UserLegionInfoBO:decode(inputStream)
	    local body = {}
		body.legionId = inputStream:ReadUTFString()

		body.contribution = inputStream:ReadInt()

		body.identity = inputStream:ReadInt()


	   return body
end