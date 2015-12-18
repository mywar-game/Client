

Achievement_updateNotify = {}

--成就信息变更推送接口
function Achievement_updateNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function Achievement_updateNotify:init()
	
	self.list_updateUserAchievementList={} --需要更新的用户成就信息

	self.actName = "Achievement_update"
end

function Achievement_updateNotify:getActName()
	return self.actName
end

--需要更新的用户成就信息
function Achievement_updateNotify:setList_updateUserAchievementList(list_updateUserAchievementList)
	self.list_updateUserAchievementList = list_updateUserAchievementList
end





function Achievement_updateNotify:encode(outputStream)
		
		self.list_updateUserAchievementList = self.list_updateUserAchievementList or {}
		local list_updateUserAchievementListsize = #self.list_updateUserAchievementList
		outputStream:WriteInt(list_updateUserAchievementListsize)
		for list_updateUserAchievementListi=1,list_updateUserAchievementListsize do
            self.list_updateUserAchievementList[list_updateUserAchievementListi]:encode(outputStream)
		end
end

function Achievement_updateNotify:decode(inputStream)
	    local body = {}
		local updateUserAchievementListTemp = {}
		local updateUserAchievementListsize = inputStream:ReadInt()
		for updateUserAchievementListi=1,updateUserAchievementListsize do
            local entry = UserAchievementBO:New()
            table.insert(updateUserAchievementListTemp,entry:decode(inputStream))

		end
		body.updateUserAchievementList = updateUserAchievementListTemp

	   return body
end