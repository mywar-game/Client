

UserTaskBO = {}

--用户任务信息
function UserTaskBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserTaskBO:init()
	
	self.int_systemTaskId=0 --系统任务id，可根据该信息从静态数据中获取任务详情

	self.int_finishTimes=0 --已完成次数

	self.int_status=0 --状态0可领取1已领取2已完成3已获得奖励

	self.int_star=0 --任务的星数（只用于日常任务）

	self.actName = "UserTaskBO"
end

function UserTaskBO:getActName()
	return self.actName
end

--系统任务id，可根据该信息从静态数据中获取任务详情
function UserTaskBO:setInt_systemTaskId(int_systemTaskId)
	self.int_systemTaskId = int_systemTaskId
end
--已完成次数
function UserTaskBO:setInt_finishTimes(int_finishTimes)
	self.int_finishTimes = int_finishTimes
end
--状态0可领取1已领取2已完成3已获得奖励
function UserTaskBO:setInt_status(int_status)
	self.int_status = int_status
end
--任务的星数（只用于日常任务）
function UserTaskBO:setInt_star(int_star)
	self.int_star = int_star
end





function UserTaskBO:encode(outputStream)
		outputStream:WriteInt(self.int_systemTaskId)

		outputStream:WriteInt(self.int_finishTimes)

		outputStream:WriteInt(self.int_status)

		outputStream:WriteInt(self.int_star)


end

function UserTaskBO:decode(inputStream)
	    local body = {}
		body.systemTaskId = inputStream:ReadInt()

		body.finishTimes = inputStream:ReadInt()

		body.status = inputStream:ReadInt()

		body.star = inputStream:ReadInt()


	   return body
end