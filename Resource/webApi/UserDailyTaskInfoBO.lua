

UserDailyTaskInfoBO = {}

--用户日常任务对象
function UserDailyTaskInfoBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserDailyTaskInfoBO:init()
	
	self.int_systemTaskId=0 --系统任务id

	self.int_star=0 --星数

	self.int_status=0 --0可领取1已领取2已完成

	self.actName = "UserDailyTaskInfoBO"
end

function UserDailyTaskInfoBO:getActName()
	return self.actName
end

--系统任务id
function UserDailyTaskInfoBO:setInt_systemTaskId(int_systemTaskId)
	self.int_systemTaskId = int_systemTaskId
end
--星数
function UserDailyTaskInfoBO:setInt_star(int_star)
	self.int_star = int_star
end
--0可领取1已领取2已完成
function UserDailyTaskInfoBO:setInt_status(int_status)
	self.int_status = int_status
end





function UserDailyTaskInfoBO:encode(outputStream)
		outputStream:WriteInt(self.int_systemTaskId)

		outputStream:WriteInt(self.int_star)

		outputStream:WriteInt(self.int_status)


end

function UserDailyTaskInfoBO:decode(inputStream)
	    local body = {}
		body.systemTaskId = inputStream:ReadInt()

		body.star = inputStream:ReadInt()

		body.status = inputStream:ReadInt()


	   return body
end