

UserPkInfoBO = {}

--用户竞技场信息对象
function UserPkInfoBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserPkInfoBO:init()
	
	self.int_rank=0 --排名

	self.int_challengeTimes=0 --剩余挑战次数

	self.long_remainderTime=0 --剩余可挑战时间

	self.actName = "UserPkInfoBO"
end

function UserPkInfoBO:getActName()
	return self.actName
end

--排名
function UserPkInfoBO:setInt_rank(int_rank)
	self.int_rank = int_rank
end
--剩余挑战次数
function UserPkInfoBO:setInt_challengeTimes(int_challengeTimes)
	self.int_challengeTimes = int_challengeTimes
end
--剩余可挑战时间
function UserPkInfoBO:setLong_remainderTime(long_remainderTime)
	self.long_remainderTime = long_remainderTime
end





function UserPkInfoBO:encode(outputStream)
		outputStream:WriteInt(self.int_rank)

		outputStream:WriteInt(self.int_challengeTimes)

		outputStream:WriteLong(self.long_remainderTime)


end

function UserPkInfoBO:decode(inputStream)
	    local body = {}
		body.rank = inputStream:ReadInt()

		body.challengeTimes = inputStream:ReadInt()

		body.remainderTime = inputStream:ReadLong()


	   return body
end