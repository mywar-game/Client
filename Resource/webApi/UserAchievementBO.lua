

UserAchievementBO = {}

--用户成就对象
function UserAchievementBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserAchievementBO:init()
	
	self.int_achievementId=0 --成就id

	self.int_finishTimes=0 --完成次数

	self.int_status=0 --状态0未完成1已完成2已领取

	self.long_time=0 --更新时间

	self.actName = "UserAchievementBO"
end

function UserAchievementBO:getActName()
	return self.actName
end

--成就id
function UserAchievementBO:setInt_achievementId(int_achievementId)
	self.int_achievementId = int_achievementId
end
--完成次数
function UserAchievementBO:setInt_finishTimes(int_finishTimes)
	self.int_finishTimes = int_finishTimes
end
--状态0未完成1已完成2已领取
function UserAchievementBO:setInt_status(int_status)
	self.int_status = int_status
end
--更新时间
function UserAchievementBO:setLong_time(long_time)
	self.long_time = long_time
end





function UserAchievementBO:encode(outputStream)
		outputStream:WriteInt(self.int_achievementId)

		outputStream:WriteInt(self.int_finishTimes)

		outputStream:WriteInt(self.int_status)

		outputStream:WriteLong(self.long_time)


end

function UserAchievementBO:decode(inputStream)
	    local body = {}
		body.achievementId = inputStream:ReadInt()

		body.finishTimes = inputStream:ReadInt()

		body.status = inputStream:ReadInt()

		body.time = inputStream:ReadLong()


	   return body
end