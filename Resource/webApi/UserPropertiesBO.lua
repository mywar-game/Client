

UserPropertiesBO = {}

--用户属性对象信息
function UserPropertiesBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserPropertiesBO:init()
	
	self.int_key=0 --1人民币、2体力、3活力、4vip经验、5vip等级、6体力下次恢复时间、7活力下次恢复时间

	self.long_value=0 --当前该属性的最新值，客户端覆盖该值即可

	self.actName = "UserPropertiesBO"
end

function UserPropertiesBO:getActName()
	return self.actName
end

--1人民币、2体力、3活力、4vip经验、5vip等级、6体力下次恢复时间、7活力下次恢复时间
function UserPropertiesBO:setInt_key(int_key)
	self.int_key = int_key
end
--当前该属性的最新值，客户端覆盖该值即可
function UserPropertiesBO:setLong_value(long_value)
	self.long_value = long_value
end





function UserPropertiesBO:encode(outputStream)
		outputStream:WriteInt(self.int_key)

		outputStream:WriteLong(self.long_value)


end

function UserPropertiesBO:decode(inputStream)
	    local body = {}
		body.key = inputStream:ReadInt()

		body.value = inputStream:ReadLong()


	   return body
end