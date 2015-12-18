

UserActivityTaskRewardBO = {}

--用户活跃度奖励对象
function UserActivityTaskRewardBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserActivityTaskRewardBO:init()
	
	self.int_activityTaskRewardId=0 --奖励id

	self.int_status=0 --0不能领取1未领取2已领取

	self.actName = "UserActivityTaskRewardBO"
end

function UserActivityTaskRewardBO:getActName()
	return self.actName
end

--奖励id
function UserActivityTaskRewardBO:setInt_activityTaskRewardId(int_activityTaskRewardId)
	self.int_activityTaskRewardId = int_activityTaskRewardId
end
--0不能领取1未领取2已领取
function UserActivityTaskRewardBO:setInt_status(int_status)
	self.int_status = int_status
end





function UserActivityTaskRewardBO:encode(outputStream)
		outputStream:WriteInt(self.int_activityTaskRewardId)

		outputStream:WriteInt(self.int_status)


end

function UserActivityTaskRewardBO:decode(inputStream)
	    local body = {}
		body.activityTaskRewardId = inputStream:ReadInt()

		body.status = inputStream:ReadInt()


	   return body
end