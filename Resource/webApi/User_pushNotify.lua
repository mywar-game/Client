

User_pushNotify = {}

--角色登录接口
function User_pushNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function User_pushNotify:init()
	
	self.UserBO_userBO=nil --用户对象

	self.list_userTaskList={} --用户任务列表

	self.list_userHeroList={} --用户英雄列表

	self.list_userHeroSkillList={} --用户英雄技能列表

	self.list_userToolList={} --用户道具列表

	self.list_userEquipList={} --用户装备列表

	self.list_userGemstoneList={} --用户宝石列表

	self.list_systemActivityList={} --系统活动列表

	self.list_userOpenSceneIdList={} --用户已开启场景id列表

	self.list_userPrestigeRewardIdList={} --用户已领取声望奖励id列表

	self.map_systemConfig={} --系统配置信息,详情请查看数值表中系统配置表中的定义

	self.int_mailStatus=0 --是否有新邮件1有0没有

	self.int_displayNum=0 --同屏显示人数

	self.string_recordGuideStep="" --记录已走过的所有新手引导的步奏（99999为跳过新手引导）

	self.string_openMaps="" --开启过的地图

	self.int_pkRank=0 --竞技场排名（-1为未进入过竞技场）

	self.int_loginRewardStatus30=0 --每月签到状态0未领取1已领取

	self.long_currentTime=0 --服务器当前时间

	self.string_tips="" --用户弹窗提示

	self.WorldBossInfoBO_bossInfoBO=nil --世界boss的相关信息(空的话boss还未出现)

	self.UserBossInfoBO_userBossInfo=nil --用户boss战的相关信息(空的话用户未攻击过boss)

	self.WeatherInfoBO_weatherInfo=nil --当前天气信息

	self.actName = "User_push"
end

function User_pushNotify:getActName()
	return self.actName
end

--用户对象
function User_pushNotify:setUserBO_userBO(UserBO_userBO)
	self.UserBO_userBO = UserBO_userBO
end
--用户任务列表
function User_pushNotify:setList_userTaskList(list_userTaskList)
	self.list_userTaskList = list_userTaskList
end
--用户英雄列表
function User_pushNotify:setList_userHeroList(list_userHeroList)
	self.list_userHeroList = list_userHeroList
end
--用户英雄技能列表
function User_pushNotify:setList_userHeroSkillList(list_userHeroSkillList)
	self.list_userHeroSkillList = list_userHeroSkillList
end
--用户道具列表
function User_pushNotify:setList_userToolList(list_userToolList)
	self.list_userToolList = list_userToolList
end
--用户装备列表
function User_pushNotify:setList_userEquipList(list_userEquipList)
	self.list_userEquipList = list_userEquipList
end
--用户宝石列表
function User_pushNotify:setList_userGemstoneList(list_userGemstoneList)
	self.list_userGemstoneList = list_userGemstoneList
end
--系统活动列表
function User_pushNotify:setList_systemActivityList(list_systemActivityList)
	self.list_systemActivityList = list_systemActivityList
end
--用户已开启场景id列表
function User_pushNotify:setList_userOpenSceneIdList(list_userOpenSceneIdList)
	self.list_userOpenSceneIdList = list_userOpenSceneIdList
end
--用户已领取声望奖励id列表
function User_pushNotify:setList_userPrestigeRewardIdList(list_userPrestigeRewardIdList)
	self.list_userPrestigeRewardIdList = list_userPrestigeRewardIdList
end
--系统配置信息,详情请查看数值表中系统配置表中的定义
function User_pushNotify:setMap_systemConfig(map_systemConfig)
	self.map_systemConfig = map_systemConfig
end
--是否有新邮件1有0没有
function User_pushNotify:setInt_mailStatus(int_mailStatus)
	self.int_mailStatus = int_mailStatus
end
--同屏显示人数
function User_pushNotify:setInt_displayNum(int_displayNum)
	self.int_displayNum = int_displayNum
end
--记录已走过的所有新手引导的步奏（99999为跳过新手引导）
function User_pushNotify:setString_recordGuideStep(string_recordGuideStep)
	self.string_recordGuideStep = string_recordGuideStep
end
--开启过的地图
function User_pushNotify:setString_openMaps(string_openMaps)
	self.string_openMaps = string_openMaps
end
--竞技场排名（-1为未进入过竞技场）
function User_pushNotify:setInt_pkRank(int_pkRank)
	self.int_pkRank = int_pkRank
end
--每月签到状态0未领取1已领取
function User_pushNotify:setInt_loginRewardStatus30(int_loginRewardStatus30)
	self.int_loginRewardStatus30 = int_loginRewardStatus30
end
--服务器当前时间
function User_pushNotify:setLong_currentTime(long_currentTime)
	self.long_currentTime = long_currentTime
end
--用户弹窗提示
function User_pushNotify:setString_tips(string_tips)
	self.string_tips = string_tips
end
--世界boss的相关信息(空的话boss还未出现)
function User_pushNotify:setWorldBossInfoBO_bossInfoBO(WorldBossInfoBO_bossInfoBO)
	self.WorldBossInfoBO_bossInfoBO = WorldBossInfoBO_bossInfoBO
end
--用户boss战的相关信息(空的话用户未攻击过boss)
function User_pushNotify:setUserBossInfoBO_userBossInfo(UserBossInfoBO_userBossInfo)
	self.UserBossInfoBO_userBossInfo = UserBossInfoBO_userBossInfo
end
--当前天气信息
function User_pushNotify:setWeatherInfoBO_weatherInfo(WeatherInfoBO_weatherInfo)
	self.WeatherInfoBO_weatherInfo = WeatherInfoBO_weatherInfo
end





function User_pushNotify:encode(outputStream)
		self.UserBO_userBO:encode(outputStream)

		
		self.list_userTaskList = self.list_userTaskList or {}
		local list_userTaskListsize = #self.list_userTaskList
		outputStream:WriteInt(list_userTaskListsize)
		for list_userTaskListi=1,list_userTaskListsize do
            self.list_userTaskList[list_userTaskListi]:encode(outputStream)
		end		
		self.list_userHeroList = self.list_userHeroList or {}
		local list_userHeroListsize = #self.list_userHeroList
		outputStream:WriteInt(list_userHeroListsize)
		for list_userHeroListi=1,list_userHeroListsize do
            self.list_userHeroList[list_userHeroListi]:encode(outputStream)
		end		
		self.list_userHeroSkillList = self.list_userHeroSkillList or {}
		local list_userHeroSkillListsize = #self.list_userHeroSkillList
		outputStream:WriteInt(list_userHeroSkillListsize)
		for list_userHeroSkillListi=1,list_userHeroSkillListsize do
            self.list_userHeroSkillList[list_userHeroSkillListi]:encode(outputStream)
		end		
		self.list_userToolList = self.list_userToolList or {}
		local list_userToolListsize = #self.list_userToolList
		outputStream:WriteInt(list_userToolListsize)
		for list_userToolListi=1,list_userToolListsize do
            self.list_userToolList[list_userToolListi]:encode(outputStream)
		end		
		self.list_userEquipList = self.list_userEquipList or {}
		local list_userEquipListsize = #self.list_userEquipList
		outputStream:WriteInt(list_userEquipListsize)
		for list_userEquipListi=1,list_userEquipListsize do
            self.list_userEquipList[list_userEquipListi]:encode(outputStream)
		end		
		self.list_userGemstoneList = self.list_userGemstoneList or {}
		local list_userGemstoneListsize = #self.list_userGemstoneList
		outputStream:WriteInt(list_userGemstoneListsize)
		for list_userGemstoneListi=1,list_userGemstoneListsize do
            self.list_userGemstoneList[list_userGemstoneListi]:encode(outputStream)
		end		
		self.list_systemActivityList = self.list_systemActivityList or {}
		local list_systemActivityListsize = #self.list_systemActivityList
		outputStream:WriteInt(list_systemActivityListsize)
		for list_systemActivityListi=1,list_systemActivityListsize do
            self.list_systemActivityList[list_systemActivityListi]:encode(outputStream)
		end		
		self.list_userOpenSceneIdList = self.list_userOpenSceneIdList or {}
		local list_userOpenSceneIdListsize = #self.list_userOpenSceneIdList
		outputStream:WriteInt(list_userOpenSceneIdListsize)
		for list_userOpenSceneIdListi=1,list_userOpenSceneIdListsize do
            outputStream:WriteInt(self.list_userOpenSceneIdList[list_userOpenSceneIdListi])
		end		
		self.list_userPrestigeRewardIdList = self.list_userPrestigeRewardIdList or {}
		local list_userPrestigeRewardIdListsize = #self.list_userPrestigeRewardIdList
		outputStream:WriteInt(list_userPrestigeRewardIdListsize)
		for list_userPrestigeRewardIdListi=1,list_userPrestigeRewardIdListsize do
            outputStream:WriteInt(self.list_userPrestigeRewardIdList[list_userPrestigeRewardIdListi])
		end		
		self.map_systemConfig = self.map_systemConfig or {}
		local map_systemConfigsize = 0
		for k,v in pairs(self.map_systemConfig) do
			map_systemConfigsize = map_systemConfigsize + 1
		end
		outputStream:WriteInt(map_systemConfigsize)
		for k,v in pairs(self.map_systemConfig) do
			outputStream:WriteUTFString(k)
			outputStream:WriteUTFString(v)

		end		outputStream:WriteInt(self.int_mailStatus)

		outputStream:WriteInt(self.int_displayNum)

		outputStream:WriteUTFString(self.string_recordGuideStep)

		outputStream:WriteUTFString(self.string_openMaps)

		outputStream:WriteInt(self.int_pkRank)

		outputStream:WriteInt(self.int_loginRewardStatus30)

		outputStream:WriteLong(self.long_currentTime)

		outputStream:WriteUTFString(self.string_tips)

		self.WorldBossInfoBO_bossInfoBO:encode(outputStream)

		self.UserBossInfoBO_userBossInfo:encode(outputStream)

		self.WeatherInfoBO_weatherInfo:encode(outputStream)


end

function User_pushNotify:decode(inputStream)
	    local body = {}
        local userBOTemp = UserBO:New()
        body.userBO=userBOTemp:decode(inputStream)
		local userTaskListTemp = {}
		local userTaskListsize = inputStream:ReadInt()
		for userTaskListi=1,userTaskListsize do
            local entry = UserTaskBO:New()
            table.insert(userTaskListTemp,entry:decode(inputStream))

		end
		body.userTaskList = userTaskListTemp
		local userHeroListTemp = {}
		local userHeroListsize = inputStream:ReadInt()
		for userHeroListi=1,userHeroListsize do
            local entry = UserHeroBO:New()
            table.insert(userHeroListTemp,entry:decode(inputStream))

		end
		body.userHeroList = userHeroListTemp
		local userHeroSkillListTemp = {}
		local userHeroSkillListsize = inputStream:ReadInt()
		for userHeroSkillListi=1,userHeroSkillListsize do
            local entry = UserHeroSkillBO:New()
            table.insert(userHeroSkillListTemp,entry:decode(inputStream))

		end
		body.userHeroSkillList = userHeroSkillListTemp
		local userToolListTemp = {}
		local userToolListsize = inputStream:ReadInt()
		for userToolListi=1,userToolListsize do
            local entry = UserToolBO:New()
            table.insert(userToolListTemp,entry:decode(inputStream))

		end
		body.userToolList = userToolListTemp
		local userEquipListTemp = {}
		local userEquipListsize = inputStream:ReadInt()
		for userEquipListi=1,userEquipListsize do
            local entry = UserEquipBO:New()
            table.insert(userEquipListTemp,entry:decode(inputStream))

		end
		body.userEquipList = userEquipListTemp
		local userGemstoneListTemp = {}
		local userGemstoneListsize = inputStream:ReadInt()
		for userGemstoneListi=1,userGemstoneListsize do
            local entry = UserGemstoneBO:New()
            table.insert(userGemstoneListTemp,entry:decode(inputStream))

		end
		body.userGemstoneList = userGemstoneListTemp
		local systemActivityListTemp = {}
		local systemActivityListsize = inputStream:ReadInt()
		for systemActivityListi=1,systemActivityListsize do
            local entry = SystemActivityBO:New()
            table.insert(systemActivityListTemp,entry:decode(inputStream))

		end
		body.systemActivityList = systemActivityListTemp
		local userOpenSceneIdListTemp = {}
		local userOpenSceneIdListsize = inputStream:ReadInt()
		for userOpenSceneIdListi=1,userOpenSceneIdListsize do
            table.insert(userOpenSceneIdListTemp,inputStream:ReadInt())
		end
		body.userOpenSceneIdList = userOpenSceneIdListTemp
		local userPrestigeRewardIdListTemp = {}
		local userPrestigeRewardIdListsize = inputStream:ReadInt()
		for userPrestigeRewardIdListi=1,userPrestigeRewardIdListsize do
            table.insert(userPrestigeRewardIdListTemp,inputStream:ReadInt())
		end
		body.userPrestigeRewardIdList = userPrestigeRewardIdListTemp
	    
		local systemConfigTemp = {}
		local systemConfigsize = inputStream:ReadInt()
		for i=1,systemConfigsize do
		  local key = inputStream:ReadUTFString()
          systemConfigTemp[key] = (inputStream:ReadUTFString())
		end
		body.systemConfig = systemConfigTemp		body.mailStatus = inputStream:ReadInt()

		body.displayNum = inputStream:ReadInt()

		body.recordGuideStep = inputStream:ReadUTFString()

		body.openMaps = inputStream:ReadUTFString()

		body.pkRank = inputStream:ReadInt()

		body.loginRewardStatus30 = inputStream:ReadInt()

		body.currentTime = inputStream:ReadLong()

		body.tips = inputStream:ReadUTFString()

        local bossInfoBOTemp = WorldBossInfoBO:New()
        body.bossInfoBO=bossInfoBOTemp:decode(inputStream)
        local userBossInfoTemp = UserBossInfoBO:New()
        body.userBossInfo=userBossInfoTemp:decode(inputStream)
        local weatherInfoTemp = WeatherInfoBO:New()
        body.weatherInfo=weatherInfoTemp:decode(inputStream)

	   return body
end