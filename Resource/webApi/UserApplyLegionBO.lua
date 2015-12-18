

UserApplyLegionBO = {}

--用户申请信息
function UserApplyLegionBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserApplyLegionBO:init()
	
	self.string_userId="" --用户id

	self.string_userName="" --用户名

	self.int_level=0 --等级

	self.int_effective=0 --战斗力

	self.actName = "UserApplyLegionBO"
end

function UserApplyLegionBO:getActName()
	return self.actName
end

--用户id
function UserApplyLegionBO:setString_userId(string_userId)
	self.string_userId = string_userId
end
--用户名
function UserApplyLegionBO:setString_userName(string_userName)
	self.string_userName = string_userName
end
--等级
function UserApplyLegionBO:setInt_level(int_level)
	self.int_level = int_level
end
--战斗力
function UserApplyLegionBO:setInt_effective(int_effective)
	self.int_effective = int_effective
end





function UserApplyLegionBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_userId)

		outputStream:WriteUTFString(self.string_userName)

		outputStream:WriteInt(self.int_level)

		outputStream:WriteInt(self.int_effective)


end

function UserApplyLegionBO:decode(inputStream)
	    local body = {}
		body.userId = inputStream:ReadUTFString()

		body.userName = inputStream:ReadUTFString()

		body.level = inputStream:ReadInt()

		body.effective = inputStream:ReadInt()


	   return body
end