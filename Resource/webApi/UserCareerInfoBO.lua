

UserCareerInfoBO = {}

--用户职业信息对象
function UserCareerInfoBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserCareerInfoBO:init()
	
	self.int_detailedCareerId=0 --详细职业id

	self.int_level=0 --已打开的层数

	self.actName = "UserCareerInfoBO"
end

function UserCareerInfoBO:getActName()
	return self.actName
end

--详细职业id
function UserCareerInfoBO:setInt_detailedCareerId(int_detailedCareerId)
	self.int_detailedCareerId = int_detailedCareerId
end
--已打开的层数
function UserCareerInfoBO:setInt_level(int_level)
	self.int_level = int_level
end





function UserCareerInfoBO:encode(outputStream)
		outputStream:WriteInt(self.int_detailedCareerId)

		outputStream:WriteInt(self.int_level)


end

function UserCareerInfoBO:decode(inputStream)
	    local body = {}
		body.detailedCareerId = inputStream:ReadInt()

		body.level = inputStream:ReadInt()


	   return body
end