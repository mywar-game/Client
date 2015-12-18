

AchievementAction_getUserAchievementInfoRes = {}

--获取用户成就系统信息
function AchievementAction_getUserAchievementInfoRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function AchievementAction_getUserAchievementInfoRes:init()
	
	self.list_userAchievementList={} --用户成就列表

	self.actName = "AchievementAction_getUserAchievementInfo"
end

function AchievementAction_getUserAchievementInfoRes:getActName()
	return self.actName
end

--用户成就列表
function AchievementAction_getUserAchievementInfoRes:setList_userAchievementList(list_userAchievementList)
	self.list_userAchievementList = list_userAchievementList
end





function AchievementAction_getUserAchievementInfoRes:encode(outputStream)
		
		self.list_userAchievementList = self.list_userAchievementList or {}
		local list_userAchievementListsize = #self.list_userAchievementList
		outputStream:WriteInt(list_userAchievementListsize)
		for list_userAchievementListi=1,list_userAchievementListsize do
            self.list_userAchievementList[list_userAchievementListi]:encode(outputStream)
		end
end

function AchievementAction_getUserAchievementInfoRes:decode(inputStream)
	    local body = {}
		local userAchievementListTemp = {}
		local userAchievementListsize = inputStream:ReadInt()
		for userAchievementListi=1,userAchievementListsize do
            local entry = UserAchievementBO:New()
            table.insert(userAchievementListTemp,entry:decode(inputStream))

		end
		body.userAchievementList = userAchievementListTemp

	   return body
end