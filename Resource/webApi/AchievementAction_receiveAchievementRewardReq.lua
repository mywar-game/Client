

AchievementAction_receiveAchievementRewardReq = {}

--领取用户成就奖励
function AchievementAction_receiveAchievementRewardReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function AchievementAction_receiveAchievementRewardReq:init()
	
	self.int_achievementId=0 --成就id

	self.actName = "AchievementAction_receiveAchievementReward"
end

function AchievementAction_receiveAchievementRewardReq:getActName()
	return self.actName
end

--成就id
function AchievementAction_receiveAchievementRewardReq:setInt_achievementId(int_achievementId)
	self.int_achievementId = int_achievementId
end





function AchievementAction_receiveAchievementRewardReq:encode(outputStream)
		outputStream:WriteInt(self.int_achievementId)


end

function AchievementAction_receiveAchievementRewardReq:decode(inputStream)
	    local body = {}
		body.achievementId = inputStream:ReadInt()


	   return body
end