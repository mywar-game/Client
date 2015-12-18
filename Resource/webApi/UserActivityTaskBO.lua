

UserActivityTaskBO = {}

--用户职业信息对象
function UserActivityTaskBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserActivityTaskBO:init()
	
	self.int_activityTaskId=0 --活跃度id

	self.int_finishTimes=0 --已完成的次数

	self.int_status=0 --0未完成1完成

	self.actName = "UserActivityTaskBO"
end

function UserActivityTaskBO:getActName()
	return self.actName
end

--活跃度id
function UserActivityTaskBO:setInt_activityTaskId(int_activityTaskId)
	self.int_activityTaskId = int_activityTaskId
end
--已完成的次数
function UserActivityTaskBO:setInt_finishTimes(int_finishTimes)
	self.int_finishTimes = int_finishTimes
end
--0未完成1完成
function UserActivityTaskBO:setInt_status(int_status)
	self.int_status = int_status
end





function UserActivityTaskBO:encode(outputStream)
		outputStream:WriteInt(self.int_activityTaskId)

		outputStream:WriteInt(self.int_finishTimes)

		outputStream:WriteInt(self.int_status)


end

function UserActivityTaskBO:decode(inputStream)
	    local body = {}
		body.activityTaskId = inputStream:ReadInt()

		body.finishTimes = inputStream:ReadInt()

		body.status = inputStream:ReadInt()


	   return body
end