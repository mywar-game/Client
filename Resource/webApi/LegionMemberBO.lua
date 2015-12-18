

LegionMemberBO = {}

--公会成员对象
function LegionMemberBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionMemberBO:init()
	
	self.string_userId="" --成员用户id

	self.string_userName="" --成员名称

	self.int_level=0 --成员等级

	self.int_status=0 --0离线1在线

	self.int_identity=0 --身份1团长2副团长3普通成员

	self.actName = "LegionMemberBO"
end

function LegionMemberBO:getActName()
	return self.actName
end

--成员用户id
function LegionMemberBO:setString_userId(string_userId)
	self.string_userId = string_userId
end
--成员名称
function LegionMemberBO:setString_userName(string_userName)
	self.string_userName = string_userName
end
--成员等级
function LegionMemberBO:setInt_level(int_level)
	self.int_level = int_level
end
--0离线1在线
function LegionMemberBO:setInt_status(int_status)
	self.int_status = int_status
end
--身份1团长2副团长3普通成员
function LegionMemberBO:setInt_identity(int_identity)
	self.int_identity = int_identity
end





function LegionMemberBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)

		outputStream:WriteUTFString(self.string_userName)

		outputStream:WriteInt(self.int_level)

		outputStream:WriteInt(self.int_status)

		outputStream:WriteInt(self.int_identity)


end

function LegionMemberBO:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()

		body.userName = inputStream:ReadUTFString()

		body.level = inputStream:ReadInt()

		body.status = inputStream:ReadInt()

		body.identity = inputStream:ReadInt()


	   return body
end