

UserLoginRewardBO = {}

--用户登陆奖励对象
function UserLoginRewardBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserLoginRewardBO:init()
	
	self.int_day=0 --天数

	self.int_status=0 --领取状态0未领取1已领取

	self.actName = "UserLoginRewardBO"
end

function UserLoginRewardBO:getActName()
	return self.actName
end

--天数
function UserLoginRewardBO:setInt_day(int_day)
	self.int_day = int_day
end
--领取状态0未领取1已领取
function UserLoginRewardBO:setInt_status(int_status)
	self.int_status = int_status
end





function UserLoginRewardBO:encode(outputStream)
		outputStream:WriteInt(self.int_day)

		outputStream:WriteInt(self.int_status)


end

function UserLoginRewardBO:decode(inputStream)
	    local body = {}
		body.day = inputStream:ReadInt()

		body.status = inputStream:ReadInt()


	   return body
end