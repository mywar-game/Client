-- 数据管理
require("DataTranslater")
require("StaticDataManager")
require("LabelChStr")

DataManager = { }

local _systemUserPushConfig = {}
local _fightHeroId = 1 --战斗英雄Id
local _userBO = { }-- 用户对象
local _userTaskList = { } -- 用户任务列表
local _userHeroMap = { }-- 用户英雄列表映射表([SystemID])
local _userDismissHeroMap = {}--被遣散的英雄列表
local _userToolList = { } -- 用户道具列表
local _userEquipList = { }-- 用户持有道具列表([userEquipId])
local _userHeroSkillList = { } -- 用户英雄技能列表
local _userGemstoneList = {} --宝石列表
local _systemConfig = { } -- 系统配置信息
local _userBigForcesList = { }--大关卡信息(缓存所有关卡信息[大关卡][])
local _userLifeInfoBO = { } -- 用户生活技能

local _client_system_time = 0 -- 服务器push到达客户端时间
local _server_system_time = 0 -- 服务器系统时间
local _receiveTaskNpc -- 当前接受的任务
local _email_list = { }-- 当前邮件列表
local _user_openMap_List = {}--玩家开放的地图ID

local _recordGuideStep = {} --当前完成的新手引导步
local _userTileMapInfo = {x=0,y=0,sceneId=0}--用户地图中的信息

local _userWindowTips = {} --用户弹窗提示
local _userBossInfoBO = {} --用户boss战的相关信息
local _worldBossInfoBo = {} --世界BOSS信息
local _worldBossHurtRank = {} --世界Boss的排行榜
local _worldBossStatus = 2 --世界Boss的状态
local _worldBossRoomOwner = 0 --是否为房主

local _fightData = {} --战斗统计
--缓存的可接任务列表
local _currentTaskList

--仓库的道具 武器 防具
local _repertory_store_equip = {}
local _repertory_store_tool = {}
local _repertory_store_stone = {}
local _cache_msg = { [1] = { }, [2] = { }, [3] = { }, [4] = { }, [5] = { } }-- 世界/阵营/公会/私聊聊天
--缓存的sceneId
local _cache_curSceneId
--保存当前开放的系统活动
local _systemActivityList = {}

--保存当前玩家本次玩游戏的时间
--current_weather   0 表示天气还没初始化   1 表示正常天气，  2 下雪，  3 下雨, 4 雷暴雨
local _game_time = {current_play_time = 0, current_weather = 0, current_weather_start_time = 0}
local _scene_weather = {[1004] = {1, 3, 4}, [1005] = {1}
					, [1007] = {1, 3, 4}, [1009] = {1, 2}
					, [1011] = {1, 3, 4}, [1013] = {1, 3, 4}
					, [1016] = {1}, [2004] = {1, 3, 4}
					, [2005] = {1}, [2007] = {1, 3, 4}
					, [2009] = {1}, [2011] = {1, 3, 4}
					, [2013] = {1}, [2015] = {1, 3, 4}}

--保存玩家上次获得的武器，道具， 宝石
local _last_get_equip = {}
local _last_get_tool = {}
local _last_get_stone = {}

local _chat_msg_colors = {
    { cc.c3b(0x56, 0x9d, 0xd7), cc.c3b(0x9c, 0x54, 0x00) },
    { cc.c3b(0x23, 0x8e, 0x23), cc.c3b(0x23, 0x8e, 0x23) },
    { cc.c3b(0xE4, 0x78, 0x33), cc.c3b(0xE4, 0x78, 0x33) },
    { cc.c3b(0xff, 0x00, 0xff), cc.c3b(0xff, 0x00, 0xff) },
	{ cc.c3b(0x56, 0x9d, 0xd7), cc.c3b(0xff, 0xff, 0xff) }
}-- 聊天颜色

function DataManager.init()
    -- 从本地取数据
    StaticDataManager.init()
end

function DataManager.getWeatherList(sceneId)
	return _scene_weather[sceneId]
end

function DataManager.setGameTime(times)
	_game_time.current_play_time = times
end

function DataManager.getGameTime()
	return _game_time.current_play_time
end

function DataManager.setWeatherStartTime(times)
	_game_time.current_weather_start_time = times
end

function DataManager.getWeatherStartTime()
	return _game_time.current_weather_start_time
end

function DataManager.setCurrentWeather(weather)
	_game_time.current_weather = weather
end

function DataManager.getCurrentWeather()
	return _game_time.current_weather
end

function DataManager.systemUserPushConfig()
	return _systemUserPushConfig
end

-- 是否开启调试，服务器的每个响应都返回ack
function DataManager.isOpenAck()
    return _systemConfig and _systemConfig.is_open_ack
end

-- 保存服务器系统时间
function DataManager.saveServerSystemTimeAtStart(server_system_time)
    _server_system_time = server_system_time
    _client_system_time = os.time() * 1000
end

-- 读取服务器系统时间
function DataManager.getServerSystemTimeAtStart()
    return _server_system_time
end

-- 获取当前系统时间   相对于 服务器系统的时间
function DataManager.getServerSystemTimeNow()
    if _server_system_time == 0 then return 0 end

    local now = _server_system_time -(_client_system_time - os.time() * 1000)
    return now
end

-- 读取服务器系统时间
function DataManager.getClientSystemTimeAtStart()
    return _client_system_time
end

--获取已完成新手引导数据
function DataManager.getRecordGuideStep()
	return _recordGuideStep
end
-- 这个_recordGuideStep 数据是 总推推送过来的只有登陆的时候推送一次。
-- 增加这个方法的目的是为了我保存 当前的记录。
function DataManager.setRecordGuideStep(temp)
	 _recordGuideStep = temp
end

-- 推送用户信息
function DataManager.setUserPush(msgObj)
    -- 用户对象
    _userBO = msgObj.body.userBO
    -- 用户任务列表
    _userTaskList = DataTranslater.tranTaskList(msgObj.body.userTaskList)
    -- 用户英雄列表
    _userHeroMap,_userDismissHeroMap = DataTranslater.tranHeroList(msgObj.body.userHeroList)
    -- 用户道具列表
    _userToolList, _repertory_store_tool = DataTranslater.tranToolList(msgObj.body.userToolList)
    -- 用户英雄技能列表
    _userHeroSkillList = DataTranslater.tranHeroSkillList(msgObj.body.userHeroSkillList)
    --用户装备
    _userEquipList, _repertory_store_equip = DataTranslater.tranEquipList(msgObj.body.userEquipList)
	--宝石
	_userGemstoneList, _repertory_store_stone = DataTranslater.tranGemstoneList(msgObj.body.userGemstoneList)
    -- 系统配置信息
    _systemConfig = msgObj.body.systemConfig
    --用户已开放的地图
	_user_openMap_List = DataTranslater.tranOpenMap(msgObj.body.openMaps)
	--将数据解析好
	_recordGuideStep = Split(msgObj.body.recordGuideStep,",")

	_systemActivityList = msgObj.body.systemActivityList
	
	--用户弹窗提示
	_userWindowTips = Split(msgObj.body.tips,",")
	
	--保存服务器发来的游戏配置信息
	_systemUserPushConfig.mailStatus = msgObj.body.mailStatus or 0
	
	--世界boss的相关信息
	_worldBossInfoBo = msgObj.body.bossInfoBO
	_userBossInfoBO = msgObj.body.userBossInfo
	_worldBossRoomOwner = 0 --设置不是房主
	
	--配置任务
	DataManager.setRangeTaskList()
	DataManager.saveServerSystemTimeAtStart(msgObj.body.currentTime)
	
end

function DataManager.setUserMidNightPush(msgObj)
	DataManager.saveServerSystemTimeAtStart(msgObj.body.systemTime)
end

function DataManager.getSystemActivityList()
	return _systemActivityList
end

function DataManager.getUserBO()
    return _userBO
end

function DataManager.replaceGold(goldNum)
    _userBO.gold = goldNum
end
function DataManager.addGold(addNum)
    _userBO.gold = addNum + _userBO.gold
end
function DataManager.replaceMoney(moneyNum)
    _userBO.money = moneyNum
end

function DataManager.addMoney(addNum)
    _userBO.money = _userBO.money + addNum
end

function DataManager.replaceStar(userHeroBo)
   _userHeroMap[userHeroBo.systemHeroId].star = userHeroBo.star
end

function DataManager.updateUserProperties(msgObj)
    for k, v in pairs(msgObj.body.userPropertiesList) do
        -- 1人民币、2体力、3活力、4vip经验、5vip等级、6体力下次恢复时间、7活力下次恢复时间
        if v.key == 1 then
            _userBO.money = v.value
        elseif v.key == 2 then
            _userBO.power = v.value
        elseif v.key == 3 then
            _userBO.activity = v.value
        elseif v.key == 4 then
            _userBO.vipExp = v.value
        elseif v.key == 5 then
            _userBO.vipLevel = v.value
        elseif v.key == 6 then
            _userBO.powerResumTime = v.value
        elseif v.key == 7 then
            _userBO.activityResumTime = v.value
        end
    end
end

-- 用户英雄映射表
function DataManager.getUserHeroMap()
    return _userHeroMap
end

-- 替换上阵
function DataManager.replaceBattleHero(heroList)
    for k, v in pairs(heroList) do
        if _userHeroMap[v.userHeroId] then
            _userHeroMap[v.userHeroId].pos = v.pos
            _userHeroMap[v.userHeroId].isTeamLeader = v.isTeamLeader
        end
    end
end

-- 可上阵的英雄
function DataManager.getCanBattleHeroList(heroType)
    local heroList = {}
    for k, v in pairs(_userHeroMap) do
		if heroType == StaticField.standId0 then --全部
			table.insert(heroList,DeepCopy(v))
		elseif heroType == StaticField.standId1 then  --肉盾
			table.insert(heroList,DeepCopy(v))
		elseif heroType == StaticField.standId4 then --治疗
			table.insert(heroList,DeepCopy(v))
		else --输出
			table.insert(heroList,DeepCopy(v))
		end
    end
	
	local function sortColor(a,b)
		return a.heroColor > b.heroColor
	end
	table.sort(heroList,sortColor)
	
    return heroList
end

-- 用户英雄上阵位置
function DataManager.getCurrentBattlePos(battleNum)
    local idx = 0
    local flag = true
    for i = 2, battleNum+1 do
        flag = true
        for k,v in pairs(_userHeroMap) do
            if v.pos == i then
                flag = false
            end
        end
        if flag then
            idx = i
            break
        end
    end
    return idx
end

-- 查看阵容
function DataManager.getSelectHeroInfo(systemHeroId)
	local idx = 0
	for k,v in pairs(_userHeroMap)do
		idx = idx + 1
		if k == systemHeroId then
			break
		end
	end
	return idx
end

-- 用户英雄上阵
function DataManager.getUserHeroBattlePos(battleNum)	
    local heroList = {}
	local tempList = {}
	for k = 1,battleNum do
		table.insert(heroList,{systemHeroId = -1})
    end
	
	for k,v in pairs(_userHeroMap)do
		if v.pos > 1 then
			heroList[v.pos-1] = v
		end
	end

    return heroList
end

-- 用户英雄上阵(同时为其加入装备))
function DataManager.getUserHeroBattleList()
    local heroList = {}
    for k,v in pairs(_userHeroMap) do
        if v.pos > 0 then
			local hero = DeepCopy(v)
            hero.equips = DataManager.getUserHeroEquipList(v.userHeroId)
            table.insert(heroList, hero)
        end
    end
    return heroList
end

-- 用户英雄场景
function DataManager.getSceneHero()
    for k, v in pairs(_userHeroMap) do
        if v.isTeamLeader == 1 then
            return v
        end
    end
	return nil
end

--更换用户英雄队长
function DataManager.changeTeamLeader(userData)
    for k, v in pairs(_userHeroMap) do
        if userData.systemHeroId == v.systemHeroId then
            v.isTeamLeader = 1
        else
            v.isTeamLeader = 0
        end
    end
end

-- 更新英雄列表
function DataManager.updateHeroList(heroList)
    if heroList then
        for k, v in pairs(heroList) do
            local nextHero = DataTranslater.tranHero(v)
            --特殊处理 (如果 战斗中英雄升级)
            if _userHeroMap[v.userHeroId] 
               and LayerManager.isPanelActive("FightUIPanel") 
               and nextHero.level > _userHeroMap[v.userHeroId].level then
               FightUIPanel_HeroLevelUp(nextHero)
            end
            _userHeroMap[v.userHeroId] = nextHero
        end
    end
end

-- 用户英雄技能列表
function DataManager.getUserHeroSkillList()
	local function sortSkillId(a,b)
		return a.skillId < b.skillId
	end
	table.sort(_userHeroSkillList,sortSkillId)
    return _userHeroSkillList
end

-- 用户英雄技能位置
function DataManager.getUserHeroSkillPos()
    for i = 31, 33 do
        local flag = true
        for k, v in pairs(_userHeroSkillList) do
            if v.pos == i then
                flag = false
                break
            end
        end
        if flag then
            return i
        end
    end
    return -1
end

-- 用户英雄技能更新
function DataManager.updateUserHeroSkill(updateHeroSkillPosList)
    for k, v in pairs(updateHeroSkillPosList) do
        for m, n in pairs(_userHeroSkillList) do
            if v.userHeroSkillId == n.userHeroSkillId then
                n.pos = v.pos
                break
            end
        end
    end
end
-- 添加用户团长技能
function DataManager.addUserHeroSkill(userHeroSkill)
    table.insert(_userHeroSkillList, DataTranslater.tranHeroSkill(userHeroSkill))
end
-- 更新团长技能等级和经验
function DataManager.updateUserHeroSkillLevelAndExp(userHeroSkillId, skillLevel, skillExp)
    for m, n in pairs(_userHeroSkillList) do
        if n.userHeroSkillId == userHeroSkillId then
            n.skillLevel = skillLevel
            n.skillExp = skillExp
            break
        end
    end
end

-- 根据用户团长技能id查找团长技能
function DataManager.getHeadSkillById(systemHeroSkillId)
    for k, v in pairs(_userHeroSkillList) do
        if v.systemHeroSkillId == systemHeroSkillId then
            return v
        end
    end
    return nil
end
-- 团长技能学习配置信息
function DataManager.getHeadSkillConfigById(systemHeroSkillId)
    return StaticDataManager.getSystemHeroSkillConfig(systemHeroSkillId)
end
-- 用户团长技能
function DataManager.getFightHeadSkillList()
    local headSkill = { }
    for k, v in pairs(_userHeroSkillList) do
        if v.pos > 0 then
            headSkill[v.pos] = DeepCopy(v)
        end
    end
    return headSkill
end

-- 更新团长技能列表
function DataManager.updateHeadSkillList(skillList)
    if skillList then
        for k, v in pairs(skillList) do
            table.insert(_userHeroSkillList, DataTranslater.tranHeroSkill(v))
        end
    end
end

-- 用户任务
function DataManager.getUserTaskList()
	local temp1 = {}
	local temp2 = {}
	local temp3 = {}
	local temp4 = {}
	for k,v in pairs(_userTaskList)do
		if v.status == GameField.taskStatus0 and v.taskType == GameField.taskType1 then
			table.insert(temp1,DeepCopy(v))
		elseif v.status == GameField.taskStatus1 or v.status == GameField.taskStatus2 then--已领取--已完成
			if v.taskType == GameField.taskType1 then
				table.insert(temp2,DeepCopy(v)) --主线
			elseif v.taskType == GameField.taskType2 then
				table.insert(temp3,DeepCopy(v)) --支线
			elseif v.taskType == GameField.taskType3 then
				table.insert(temp4,DeepCopy(v)) --日线
			end
		end
	end
	return temp1,temp2,temp3,temp4
end

-- 用户任务
function DataManager.getMainlineTask()
	--优先完成 
	--再此已接受
	--最后未接受
	local function foundTrackTask(taskList)
		for k,v in pairs(taskList) do
			if v.taskType == GameField.taskType1 and 
			   v.status == GameField.taskStatus2 then
				return v
			end
			
			if v.taskType == GameField.taskType2 and 
			   v.status == GameField.taskStatus2 then
				return v
			end
			
			if v.taskType == GameField.taskType3 and 
			  v.status == GameField.taskStatus2 then
				return v
			end
		end
		
		for k,v in pairs(taskList)do
			if v.taskType == GameField.taskType1 and 
			  v.status == GameField.taskStatus1 then
				return v
			end
			
			if v.taskType == GameField.taskType2 and 
			   v.status == GameField.taskStatus1 then
				return v
			end
			
			if v.taskType == GameField.taskType3 and 
			   v.status == GameField.taskStatus1 then
				return v
			end
		end
		for k,v in pairs(taskList)do
			if v.taskType == GameField.taskType1 and 
			   v.status == GameField.taskStatus0 and
			   v.limitMinLevel <= _userBO.level then
				return v
			end
			
			if v.taskType == GameField.taskType2 and 
			   v.status == GameField.taskStatus0 and
			   v.limitMinLevel <= _userBO.level then
				return v
			end
		end
		return nil
	end

	local task = foundTrackTask(_userTaskList)
	if not task then
		task = foundTrackTask(DataManager.getBranchTaskList())
	end
	return task
end

-- 用户任务
function DataManager.getUserTaskId(systemTaskId)
    for k, v in pairs(_userTaskList) do
        if v.systemTaskId == systemTaskId then
            return v
        end
    end
    return nil
end

function DataManager.getNpcTaskList(sceneId,npcId)
	local function checkNpcTask(tempList,taskList) 
		for k, v in pairs(taskList) do
			if v.taskType ~= GameField.taskType3 then
				local flag = false
				local receiveTaskNpc = Split(v.receiveTaskNpc, ",")
				local handinTaskNpc = Split(v.handinTaskNpc, ",")
				local taskPara = TaskLibrary.conversionPara(v.taskPara)
				if tonumber(receiveTaskNpc[1]) == sceneId and 
				   tonumber(receiveTaskNpc[2]) == npcId and
				   (v.status == GameField.taskStatus0 or 
					v.status == GameField.taskStatus1) then
					flag = true
				end
				
				if tonumber(handinTaskNpc[1]) == sceneId and
				   tonumber(handinTaskNpc[2]) == npcId and
				   v.status == GameField.taskStatus2 then
					flag = true
				end
				
				if flag then
					table.insert(tempList,DeepCopy(v))
				end
			end
		end
	end
	
	local otherTask = {}
	local data = StaticDataManager.getSystemTask()
	for k,v in pairs(data)do
		if(v.limitMinLevel <= _userBO.level and v.limitMaxLevel >= _userBO.level) and 
		  (v.taskType == GameField.taskType2) then
			local flag = DataManager.isCheckTaskId(v.systemTaskId)
			if not flag then
				table.insert(otherTask,DeepCopy(v))
			end
		end
	end
	
	local tempList = {}
	checkNpcTask(tempList,_userTaskList)
	checkNpcTask(tempList,otherTask)
	
	table.sort(tempList,function(a,b) 
		return a.taskType < b.taskType
	end)
	
	return tempList
end

function DataManager.getHaveNpcTask(sceneId, npcId)
	--用户已有任务优先
    local function retIfFound(taskList)
        for k, v in pairs(taskList) do
			local flag = false
            local receiveTaskNpc = Split(v.receiveTaskNpc, ",")
            local handinTaskNpc = Split(v.handinTaskNpc, ",")
			if tonumber(receiveTaskNpc[1]) == sceneId and 
			   tonumber(receiveTaskNpc[2]) == npcId and
			   (v.status == GameField.taskStatus0 or 
			    v.status == GameField.taskStatus1) then
			   return v
			end
			
			if tonumber(handinTaskNpc[1]) == sceneId and
			   tonumber(handinTaskNpc[2]) == npcId and
			   v.status == GameField.taskStatus2 then
				return v
			end
        end
        return nil
    end
	
    --日常和支线
    local retData = retIfFound(_userTaskList)
    if not retData then
		local branchTask = DataManager.getBranchTaskList(false)
		retData = retIfFound(branchTask) 
	end
	
    if not retData then 
		local dailyTask = DataManager.getDailyTaskList(false)
		retData = retIfFound(dailyTask) 
	end
    return retData
end

function DataManager.getAcceptedTask()
    local tempTask = { }
    for k, v in pairs(_userTaskList) do
        if v.status == GameField.taskStatus1 or v.status == GameField.taskStatus2 then
            table.insert(tempTask, v)
        end
    end
    return tempTask
end

-- 用户道具
function DataManager.getUserToolList()
    return _userToolList
end

-- 更新用户道具
function DataManager.updateUserTool(tool)
	if tool.goodsNum > 0 then
		table.insert(_last_get_tool, {toolId = tool.goodsId})
	end
    local flag = true
    for k, v in pairs(_userToolList) do
        if v.toolId == tool.goodsId then
            v.toolNum = v.toolNum + tool.goodsNum
            if v.toolNum <= 0 then
                table.remove(_userToolList, k)
            end
            flag = false
            break
        end
    end

    if flag then
        table.insert(_userToolList, DataTranslater.tranTool({ toolId = tool.goodsId, toolNum = tool.goodsNum }))
    end
end
-- 减道具
function DataManager.reduceUserTool(toolId, reduceToolNum)
    local flag = true
    for k, v in pairs(_userToolList) do
        if v.toolId == toolId then
            v.toolNum = v.toolNum - reduceToolNum
            if v.toolNum <= 0 then
                table.remove(_userToolList, k)
            end
            break
        end
    end
end
-- 获取用户指定道具数量
function DataManager.getUserToolNum(toolId)
    for k, v in pairs(_userToolList) do
        if v.toolId == toolId then
            return v.toolNum
        end
    end
    return nil
end

-- 获取用户指定道具数量
function DataManager.getUserTool(toolId)
    for k, v in pairs(_userToolList) do
        if v.toolId == toolId then
			return DeepCopy(v)
        end
    end
    return nil
end


function DataManager.getUserPlayerId()
    return _userBO.userId
end

function DataManager.resetBgMusicPlayedStatus()
    
end

--获取有序用户英雄表
function DataManager.getUserHeroList()	
    local retList = {}
    for k, v in pairs(_userHeroMap) do
        table.insert(retList,v)
    end
	retList = DataManager.getSortHeroList(retList)
    return retList
end

--通过用户userHeroId查找英雄
function DataManager.getUserHeroId(userHeroId)
   return _userHeroMap[userHeroId]
end

function DataManager.setUserHeroId(userHeroId, userHeroMap)
	_userHeroMap[userHeroId].userId = userHeroMap.userId
	_userHeroMap[userHeroId].userHeroId = userHeroMap.userHeroId
	_userHeroMap[userHeroId].systemHeroId = userHeroMap.systemHeroId
	_userHeroMap[userHeroId].level = userHeroMap.level
	_userHeroMap[userHeroId].exp = userHeroMap.exp
	_userHeroMap[userHeroId].effective = userHeroMap.effective
	_userHeroMap[userHeroId].isScene = userHeroMap.isScene
	_userHeroMap[userHeroId].pos = userHeroMap.pos
	_userHeroMap[userHeroId].isTeamLeader = userHeroMap.isTeamLeader
	_userHeroMap[userHeroId].status = userHeroMap.status
	_userHeroMap[userHeroId].star = userHeroMap.star
	_userHeroMap[userHeroId].heroName = userHeroMap.heroName

end

-- 英雄
function DataManager.getStaticSystemHeroId(systemHeroId)
    return StaticDataManager.getSystemHeroId(systemHeroId)
end

-- 英雄属性
function DataManager.getSystemHeroAttributeId(systemHeroId,level,showAttr)
    return DataTranslater.tranHeroAttr(systemHeroId,level,showAttr)
end

-- 英雄伤害
function DataManager.getSystemHeroHateId(hateId)
    return StaticDataManager.getSystemHateValueId(hateId)
end

-- 能源掉落
function DataManager.getSystemDropEnergyNum(num)
    local dropNum = 0
    local data = StaticDataManager.getSystemDropEnergy()
    for k = 2, #data do
        if data[k].dropPro >= num and num >= data[k - 1].dropPro then
            dropNum = v.dropNum
            break
        end
    end
    if dropNum == 0 and data[1].dropPro >= num then
        dropNum = data[1].dropNum
    end
    return dropNum
end

-- boss
function DataManager.getSystemMonsterId(monsterId)
    return StaticDataManager.getSystemMonsterId(monsterId)
end

-- boss属性
function DataManager.getSystemMonsterAttributeId(monsterId)
    return StaticDataManager.getSystemMonsterAttributeId(monsterId)
end

-- 技能
function DataManager.getSystemSkillId(skillId)
    return StaticDataManager.getSystemSkillId(skillId)
end

-- 技能效果
function DataManager.getSystemSkillEffectId(skillId)
    local effect = { }
    local data = StaticDataManager.getSystemSkillEffect()
    for k, v in pairs(data) do
        if v.skillId == skillId then
            table.insert(effect, v)
        end
    end
    return effect
end

-- 技能效果
function DataManager.getSystemSkillEffect(effectId)
    local data = StaticDataManager.getSystemSkillEffect()
    for k, v in pairs(data) do
        if v.skillEffectId == effectId then
            return DeepCopy(v)
        end
    end
    return nil
end

-- 技能定义
function DataManager.getSystemSkillEffectDefineId(defineId)
    return StaticDataManager.getSystemSkillEffectDefineId(defineId)
end

-- 公式参数
function DataManager.getSystemFormulaParaId(formulaId)
    return StaticDataManager.getSystemFormulaParaId(formulaId)
end

-- 地图
function DataManager.getSystemMapId(mapId)
    return StaticDataManager.getSystemMapId(mapId)
end

function DataManager.getSystemMap()
    return StaticDataManager.getSystemMap()
end

-- 小关卡
function DataManager.getSystemMapForces(mapId)
    local forces = { }
    local data = StaticDataManager.getSystemForces()
    for k, v in pairs(data) do
        if v.mapId == mapId and v.forcesCategory ~= GameField.forcesCategory2 then
			table.insert(forces, DeepCopy(v))
        end
    end
    return forces
end

-- 地图中的关卡
function DataManager.getSystemMapForcesId(forcesId)
    local data = StaticDataManager.getSystemForces()
    for k, v in pairs(data) do
        if v.forcesId == forcesId then
            return DeepCopy(v)
        end
    end
    return nil
end

-- 技能表
function DataManager.getSystemHeroSkillId(heroSkillId,level)
    local data = StaticDataManager.getSystemHeroSkillId()
    for k, v in pairs(data) do
        if v.systemHeroSkillId == heroSkillId and v.skillLevel == level then
            return DeepCopy(v)
        end
    end
    return nil
end

-- 技能表
function DataManager.getHeadHeroSkillList()
    local temp = {}
    local data = StaticDataManager.getSystemHeroSkillId()
    for k,v in pairs(data) do
        if v.needCrystal > 0 and v.skillLevel == 1 then
            table.insert(temp,DeepCopy(v))
        end
    end
	
	local function sortSkillId(a,b)
		return a.skillId < b.skillId
	end
	
	table.sort(temp,sortSkillId)
    
	return temp
end

-- 世界地图
function DataManager.getSystemSceneId(sceneId)
    return StaticDataManager.getSystemSceneId(sceneId)
end

-- npc
function DataManager.getSystemMapNpc(mapId)
    local npc = { }
    local data = StaticDataManager.getSystemNpc()
    for k, v in pairs(data) do
        if v.mapId == mapId then
            table.insert(npc, DeepCopy(v))
        end
    end
    return npc
end

-- 传送点
function DataManager.getSystemMapTransfer(mapId)
    local transfer = { }
    local data = StaticDataManager.getSystemTransfer()
    for k, v in pairs(data) do
        if v.mapId == mapId then
            table.insert(transfer, DeepCopy(v))
        end
    end
    return transfer
end

-- 掉落表
function DataManager.getSystemForcesDropTool(forcesId)
    local drop = { }
    local data = StaticDataManager.getSystemForcesDropTool()
    for k, v in pairs(data) do
        if v.forcesId == forcesId then
            table.insert(drop,DeepCopy(v))
        end
    end
    return drop
end

-- 怪物表
function DataManager.getSystemForcesMonster(forcesId, forcesType)
    local drop = { }
    local data = StaticDataManager.getSystemForcesMonster()
    for k, v in pairs(data) do
        if v.forcesId == forcesId and v.forcesType == forcesType then
            return DeepCopy(v)
        end
    end
    return nil
end

-- 道具
function DataManager.getSystemTool(toolId)
    return StaticDataManager.getSystemTool(toolId)
end
-- 获取指定类型的用户道具列表
function DataManager.getUserToolListByType(toolType)
    local result = {}
    for k,v in pairs(_userToolList) do
        if v.type == toolType and v.toolNum > 0 then
            table.insert(result, DeepCopy(v))
        end
    end
    return result
end

function DataManager.getSystemTeamExp(level)
	local extLevel = level or _userBO.level
    local teamExp1 = StaticDataManager.getSystemTeamExp(extLevel)
	local teamExp2 = StaticDataManager.getSystemTeamExp(extLevel + 1)	
    return teamExp1,teamExp2
end

function DataManager.getSystemBattleNum()
    local systemTeamExp = StaticDataManager.getSystemTeamExp(_userBO.level+1)
    return systemTeamExp.battleNum
end

function DataManager.getRandomName()
    return StaticDataManager.getRandomName()
end

function DataManager.setUserBoName(name)
	if nil ~= name then
		_userBO.roleName = name
	end
end

function DataManager.getSystemTaskId(taskId)
	local data = StaticDataManager.getSystemTask()
	return data[taskId]
end

--检查任务
function DataManager.isCheckTaskId(systemTaskId)
	for k,v in pairs(_userTaskList)do
		if v.systemTaskId == systemTaskId then
			return true
		end
	end
	return false
end

function DataManager.setRangeTaskList()	
	_currentTaskList = {}
	local data = StaticDataManager.getSystemTask()
	for k,v in pairs(data)do
		if v.limitMinLevel <= _userBO.level and v.limitMaxLevel >= _userBO.level and v.camp == _userBO.camp then
			table.insert(_currentTaskList,DeepCopy(v))
		end
	end
end
--获取可接日常任务
function DataManager.getOtherTaskList(taskType)
	local temp = {}
	for k,v in pairs(_currentTaskList)do
		if v.taskType == taskType then
			local flag = DataManager.isCheckTaskId(v.systemTaskId)
			if not flag then
				table.insert(temp,DeepCopy(v))
			end
		end
	end
	return temp
end

function DataManager.getDailyTaskList(stopReFresh)
	return DataManager.getOtherTaskList(GameField.taskType3)
	--[[
    if not stopReFresh or ( stopReFresh and not _dailyTaskList ) then--只有取消关闭刷新和数据为空的时候会重新请求
	    local temp = {}
	    local data = StaticDataManager.getSystemTask()
	    for k,v in pairs(data)do
		    if v.limitMinLevel <= _userBO.level and v.limitMaxLevel >= _userBO.level and 
		       v.taskType == GameField.taskType3 and v.camp == _userBO.camp then
				local flag = DataManager.isCheckTaskId(v.systemTaskId)
				if not flag then
					table.insert(temp,DeepCopy(v))
				end
		    end
	    end
        _dailyTaskList = temp
    end
	return _dailyTaskList]]
end

--获取可接支线任务
function DataManager.getBranchTaskList(stopReFresh)
	return DataManager.getOtherTaskList(GameField.taskType2)
	--[[
    if not stopReFresh or (stopReFresh and not _branchTaskList) then--只有取消关闭刷新和数据为空的时候会重新请求
	    local temp = {}
	    local data = StaticDataManager.getSystemTask()
	    for k,v in pairs(data) do
		    if v.limitMinLevel <= _userBO.level and v.limitMaxLevel >= _userBO.level and 
		       v.taskType == GameField.taskType2 and v.camp == _userBO.camp then
			   local flag = DataManager.isCheckTaskId(v.systemTaskId)
				if not flag then
					table.insert(temp,DeepCopy(v))
				end
		    end
	    end
        _branchTaskList = temp
    end
	return _branchTaskList]]
end

--更新
function DataManager.updateTask(userTaskList)
    for k, v in pairs(userTaskList) do
        local flag = true
        for m,n in pairs(_userTaskList) do
            if v.systemTaskId == n.systemTaskId then
                flag = false
                --容错处理删除可能出现的未接任务
                if (v.status == GameField.taskStatus0 and n.taskType ~= GameField.taskType1) then 
				    table.remove(_userTaskList,m)
                else
					n.star = v.star
                    n.status = v.status
                    n.finishTimes = v.finishTimes
                end
                break
            end
        end
        if flag then
            table.insert(_userTaskList, DataTranslater.tranTask(v))
        end
    end
end

function DataManager.updateSingleTask(systemTaskId,status)
	for k,v in pairs(_userTaskList) do
		if v.systemTaskId == systemTaskId then
			v.status = status
			break
		end
	end
end

function DataManager.updateGoodsList(goodsList)
	goodsList = goodsList or {}
	
	for k, v in pairs(goodsList) do
		if v.goodsType == GameField.money then
			-- 钱
			_userBO.money = _userBO.money + v.goodsNum
		elseif v.goodsType == GameField.gold then
			-- 金币
			_userBO.gold = _userBO.gold + v.goodsNum
		elseif v.goodsType == GameField.exp then
			-- 经验
			_userBO.exp = _userBO.exp + v.goodsNum
		elseif v.goodsType == GameField.heroExp then
		
		elseif v.goodsType == GameField.hero then
			-- 英雄
		elseif v.goodsType == GameField.power then
			-- 体力
			--_userBO.power = _userBO.power + v.goodsNum
		elseif v.goodsType == GameField.activity then
			-- 活力
			--_userBO.activity = _userBO.activity + v.goodsNum
		elseif v.goodsType == GameField.level then --用户等级
			 _userBO.level = _userBO.level + v.goodsNum
		elseif v.goodsType == GameField.jobExp then
			-- 声望
			_userBO.jobExp = _userBO.jobExp + v.goodsNum
		elseif v.goodsType == GameField.prestigeLevel then
			-- 声望等级
			_userBO.prestigeLevel = _userBO.prestigeLevel + v.goodsNum
		elseif v.goodsType == GameField.honour then
			-- 荣誉
			_userBO.honour = _userBO.honour + v.goodsNum
		elseif v.goodsType == GameField.packExtendTimes then
			-- 背包扩展次数
			_userBO.packExtendTimes = _userBO.packExtendTimes + v.goodsNum
		elseif v.goodsType == GameField.tool then
			-- 道具
			DataManager.updateUserTool(v)
		end
	end
end

-- 接受任务
function DataManager.setReceiveTaskNpc(receiveTaskNpc)
    _receiveTaskNpc = receiveTaskNpc
end

function DataManager.getReceiveTaskNpc()
    return _receiveTaskNpc
end

-- 系统配置
function DataManager.getSystemConfig()
    return _systemConfig
end

-- 声望招募
function DataManager.getSystemIniviteHero()
    local tempArray = {}
    local prestigeIniviteHero = StaticDataManager.getSystemInviteHero()
    for k, v in pairs(prestigeIniviteHero) do
        if (_userBO.camp == v.camp or v.camp == GameField.Camp_all) and --联盟或者部落，和全部
		    _userBO.level >= v.level then
            local systemHero = DataManager.getStaticSystemHeroId(v.systemHeroId)
            systemHero.level = v.level
            systemHero.camp = v.camp
			systemHero.needGold = v.needGold
            table.insert(tempArray,systemHero)
        end
    end
	
    local function sortCareerId(a,b)
		return a.careerId < b.careerId
    end
    table.sort(tempArray,sortCareerId)

    return tempArray
end
--[[
function DataManager.getSystemIniviteHero()
    local tempArray = {}
    local prestigeIniviteHero = StaticDataManager.getSystemInviteHero()
    for k, v in pairs(prestigeIniviteHero) do
        if _userBO.camp == v.camp 
            and v.needVipLevel <= _userBO.level + 1
            and not _userHeroMap[v.systemHeroId]
            and ((v.isInvite == 1) or ((v.isInvite == 0) and _userDismissHeroMap[v.systemHeroId])) then
            --同时找出已遣散英雄
            local systemHero = DataManager.getStaticSystemHeroId(v.systemHeroId)
            systemHero.showFlag = false
			systemHero.selectIndex = 0
            systemHero.needPrestige = v.needPrestige
            systemHero.needLevel = v.needLevel
            systemHero.needVipLevel = v.needVipLevel
            systemHero.needGold = v.needGold
            systemHero.needDiamond = v.needDiamond
            systemHero.isInvite = v.isInvite
            systemHero.recallGold = v.recallGold
            if _userDismissHeroMap[v.systemHeroId] then
				systemHero.showFlag = true
                systemHero.level = _userDismissHeroMap[v.systemHeroId].level
            end
            table.insert(tempArray,systemHero)
        end
    end

    local function sortLevel(a, b)
        if a.needVipLevel ~= b.needVipLevel then
            return a.needVipLevel < b.needVipLevel
        else
            return a.needPrestige < b.needPrestige
        end
    end
    table.sort(tempArray, sortLevel)
	
    return tempArray
end

-- 声望奖励(deprecated)
function DataManager.getSystemPrestigeRewards()
    local tempArray = { }
    local prestigeRewards = StaticDataManager.getSystemPrestigeRewards()
    for k, v in pairs(prestigeRewards) do
        if v.level <= _userBO.prestigeLevel + 1 then
            local systemHero = DataManager.getStaticSystemHeroId(v.rewards)
            systemHero.showFlag = false
            systemHero.rewardsId = v.id
            systemHero.prestigeLevel = v.level
            table.insert(tempArray, systemHero)
        end
    end

    local function sortLevel(a, b)
        return a.prestigeLevel > b.prestigeLevel
    end
    table.sort(tempArray, sortLevel)

    local level = 0
    for k, v in pairs(tempArray) do
        if v.prestigeLevel ~= level then
            v.showFlag = true
            level = v.prestigeLevel
        end
    end

    return tempArray
end]]

--[[function DataManager.getSystemPrestigeLevel()
    local level = _userBO.prestigeLevel + 1
    local data = StaticDataManager.getSystemPrestigeLevel()
    if level <= #data then
        return DeepCopy(data[level])
    else
        return DeepCopy(data[#data])
    end
end]]

function DataManager.getSystemHeroLevel(color,level)
	local heroExp = 0
	local data = StaticDataManager.getSystemHeroLevel()
	for k,v in pairs(data) do
		if v.color == color and v.level == level then
			heroExp = v.exp
		end
	end
	return heroExp
end

-- 获取副本
function DataManager.getSystemDuplicateList(mapId)
    local temp = { }
    local data = StaticDataManager.getSystemBigForces()
    for k, v in pairs(data) do
        if v.mapId == mapId then
            table.insert(temp, DeepCopy(v))
        end
    end
    return temp
end

--获取乱序大关卡列表
function DataManager.getSystemBigForcesList(bigForcesId)
    local temp = {}
    local forces = StaticDataManager.getSystemForces()
    --获取数据
    for k, v in pairs(forces) do
        if v.bigForcesId == bigForcesId then
            temp[v.preForcesId] = DeepCopy(v)
        end
    end
	
    return temp
end

-- 获取大关卡副本
function DataManager.getSystemDuplicateForcesList(bigForcesId,forcesType)
    local retData = {}
    local temp = DataManager.getSystemBigForcesList(bigForcesId)
    --排序 (preForceId=0为开头 )
    local nextData = temp[0]
    while(nextData) do
        table.insert(retData, nextData)
        nextData = temp[nextData.forcesId]
    end
	
    --更新状态
	local flag = false
    local userForceBo = DataManager.getUserBigForceBo(bigForcesId,forcesType)
    for k,v in pairs(retData) do
        v.times = 0
		v.isPass = 0
		v.isShow = 0
		v.status = GameField.forcesStatus_null
        if userForceBo[v.forcesId] then
            v.status = userForceBo[v.forcesId].status
            v.times = userForceBo[v.forcesId].times
            v.forcesType = userForceBo[v.forcesId].forcesType--这个只在完成做处理 或者 用不上
        end
		
		if k == 1 and v.status == GameField.forcesStatus_null then
			v.isPass = 1
			v.isShow = 1
		end
		
		if k == #retData and v.status == GameField.forcesStatus_pass then
			v.isPass = 1
			retData[1].isShow = 1
		end
		
		if flag == false and v.status == GameField.forcesStatus_notPass then
		    flag = true
			v.isPass = 1
			v.isShow = 1
		end
		
		if v.status == GameField.forcesStatus_pass then
			v.isPass = 1
		end
    end
    return retData
end

--更新副本
function DataManager.setNextForcesId(bigForcesId, nowForcesId, forcesType)
    local nowForceBo = DataManager.getUserBigForceBo(bigForcesId, forcesType)
    local forces = DataManager.getSystemBigForcesList(bigForcesId)
	
    for k, v in pairs(nowForceBo) do
        if v.forcesId == nowForcesId then
            v.times = v.times + 1
            v.status = GameField.forcesStatus_pass
            local force = forces[nowForcesId]--获取下一关信息
            if force then--如果存在下一关
                if not nowForceBo[force.forcesId] then--如果下一关卡尚未开放,否则不做操作
                    nowForceBo[force.forcesId] = {
                        userId = v.userId,
                        mapId = v.mapId,
                        bigForcesId = v.bigForcesId,
                        forcesId = force.forcesId,
                        status = GameField.forcesStatus_notPass,--初始状态未通过
                        forcesType = forcesType,--难度一致
                        times = 0,--初始通过次数为0
                    }
                end
            else--如果已经是最后一关了
                local nextForceBo = DataManager.getUserBigForceBo(bigForcesId, forcesType+1)--获取下一难度所有关卡
                force = forces[0]--获取第一关信息
                if not nextForceBo[force.forcesId] then--如果第一关难度尚未开放,否则不做操作
                    nextForceBo[force.forcesId] = {
                        userId = v.userId,
                        mapId = v.mapId,
                        bigForcesId = v.bigForcesId,
                        forcesId = force.forcesId,
                        status = GameField.forcesStatus_notPass,--初始状态未通过
                        forcesType = forcesType+1,--难度+1
                        times = 0,--初始通过次数为0
                    }
                end
            end
            break
        end
    end
end

function DataManager.setUserBigForceBo(userForcesList)

    _userBigForcesList[userForcesList[1].bigForcesId] = {}--每次进入关卡重设所涉关卡信息 userForcesList该信息不为空
    for i, v in pairs(userForcesList) do
        if not _userBigForcesList[v.bigForcesId][v.forcesType] then
            _userBigForcesList[v.bigForcesId][v.forcesType] = {}
        end
        _userBigForcesList[v.bigForcesId][v.forcesType][v.forcesId] = DeepCopy(v)--三层
    end
end

function DataManager.getUserBigForceBo(bigForcesId,forcesType)
    if not _userBigForcesList[bigForcesId] then
        _userBigForcesList[bigForcesId] = {}
    end
	
    if not _userBigForcesList[bigForcesId][forcesType] then
        _userBigForcesList[bigForcesId][forcesType] = {}
    end
    
	return _userBigForcesList[bigForcesId][forcesType]
end

-- BOSS的QTE
function DataManager.getSystemMonsterQte(monsterHero)
    local temp = { }
    local data = StaticDataManager.getSystemQte()
    for m, n in pairs(monsterHero) do
        for k, v in pairs(data) do
            if v.monsterId == tonumber(n) then
                table.insert(temp, DeepCopy(v))
            end
        end
    end
    return temp
end

-- BOSS的QTE效果
function DataManager.getSystemMonsterQteEffectId(qteEffectId)
    return StaticDataManager.getSystemQteEffectId(qteEffectId)
end

-- 探索系统默认数据
function DataManager.getSystemExploreMap(mapId)
	local data = StaticDataManager.getSystemExploreMap()
    return data[mapId]
end

--地图图片
function DataManager.getSystemExploreMapList(mapId)
	local mapRes = {} --图片资源 
	local ranRes = {} --随机资源
	local resId = 0
	
	local data = StaticDataManager.getSystemExploreMap()
	for k,v in pairs(data) do
		if v.camp == _userBO.camp or v.camp == GameField.Camp_all then 
			if v.mapId == mapId then
				resId = v.resId
			else
				table.insert(mapRes,v.resId)
			end
		end
	end
	
	local num = #mapRes
	num = num > 10 and 10 or num
	for k=1,num do
		local idx = math.random(#mapRes)
		table.insert(ranRes,mapRes[idx])
		table.remove(mapRes,idx)
	end
	table.insert(ranRes,num,resId)

	return ranRes
end

-- 探索地图奖励
function DataManager.getSystemExploreReward(mapId)
	local temp = {}
	local data = StaticDataManager.getSystemExploreReward()
	for k,v in pairs(data)do
		if v.mapId == mapId then
			table.insert(temp, DeepCopy(v))
		end
	end
    return temp
end

-- 探索英雄
function DataManager.getSystemExploreRewardHero()
	local mapList = {}
	local heroList = {}
	local reward = StaticDataManager.getSystemExploreReward()
	local mapDate = StaticDataManager.getSystemExploreMap()
	for k,v in pairs(mapDate) do
		if v.camp == _userBO.camp or v.camp == GameField.Camp_all then 
			table.insert(mapList,v.mapId)
		end
	end
	
	for k,v in pairs(reward)do
		for m,n in pairs(mapList)do
			if n == v.mapId then
				local retStr = Split(v.rewards, "|")
				for m,n in pairs(retStr) do
					local array = Split(n,",")	
					local toolType = tonumber(array[1])
					local toolId = tonumber(array[2])
					if toolType == GameField.hero and _userHeroMap[toolId] == nil then --类型,道具ID,数量,探索得到的英雄进行过滤
						local hero = DataManager.getStaticSystemHeroId(toolId) --获取英雄
						table.insert(heroList,hero)
					end
				end
			end
		end
	end
	
	local function sortColor(a,b)
		return a.heroColor < b.heroColor
	end
	table.sort(heroList,sortColor)
	
	return heroList
end


function DataManager.getSystemExploreExchangeHero()
    local tempArray = { }
    local data = StaticDataManager.getSystemExploreExchange()
    for k, v in pairs(data) do
        local systemHero = DataManager.getStaticSystemHeroId(v.systemHeroId)
        systemHero.needLevel = v.needLevel
        systemHero.needIntegral = v.needIntegral
        systemHero.needVipLevel = v.needVipLevel
        if  not _userHeroMap[v.systemHeroId] 
            and v.camp == _userBO.camp then
            table.insert(tempArray, systemHero)
        end
    end
    --排序 积分越高位置越高(越靠前)
    table.sort(tempArray, function (a, b)
        return a.needIntegral > b.needIntegral
    end)
    return tempArray
end

-- 当前邮箱列表
function DataManager.getEmailList()
    return _email_list
end

-- 获取当前邮箱最大邮件ID
function DataManager.getMaxMailId()
    local maxMailId = 0
    for _, v in pairs(_email_list) do
        if maxMailId < v.userMailId then
            maxMailId = v.userMailId
        end
    end
    return maxMailId
end

-- 插入(或者更新)一堆新邮件
function DataManager.insertMails(data)
    for _, v in pairs(data) do
        _email_list[v.userMailId] = DeepCopy(v)
    end
end

-- 删除一条邮件
function DataManager.deleteMails(data)
    for _, v in pairs(data) do
        _email_list[v.userMailId] = nil
    end
end

-- 聊天记录插入操作
function DataManager.insertChatMsg(type, data)
    table.insert(_cache_msg[type], 1, DeepCopy(data))
    if #_cache_msg[type] > 30 then
        table.remove(_cache_msg[type], #_cache_msg[type])
    end
end

-- 获取聊天记录
function DataManager.getChatMsg(type)
    return _cache_msg[type]
end

-- 获取聊天颜色
function DataManager.getChatMsgColor(type)
    return _chat_msg_colors[type]
end

-- 初始化当铺信息(插入价格,...)
function DataManager.fillPawnShopInfo(originData)
    for _, v in pairs(originData) do
        local localData = StaticDataManager.getSystemPawnShop(v.mallId)
        v.toolNum = localData.toolNum
        v.toolType = localData.toolType
        v.toolId = localData.toolId
        v.category = localData.category
        v.price = localData.price
    end
end

-- 跑马灯本地信息
function DataManager.getSystemMessageClient()
    return StaticDataManager.getSystemMessageClient()
end

-- 获取系统配置表装备情况
function DataManager.getSystemEquip(equipId)
    return StaticDataManager.getSystemEquip(equipId)
end

-- 获取系统配置表装备属性情况
function DataManager.getSystemEquipAttr(equipId)
    return StaticDataManager.getSystemEquipAttr(equipId)
end

--装备属性不会被修改或者增加 所以直接操作即可
-- 获取用户指定装备数量
function DataManager.getUserEquipNum(toolId)
	local num = 0 
    for k, v in pairs(_userEquipList) do
        if v.toolId == toolId then
            num = num + 1
        end
    end
    return num
end

-- 获取用户装备表
function DataManager.getUserEquipList()
    return _userEquipList
end

-- 获取指定装备
function DataManager.getUserEquip(userEquipId)
    return _userEquipList[userEquipId]
end

-- 添加指定装备的属性
function DataManager.updateUserEquipMagicAttr(userEquipId, attrs)
	_userEquipList[userEquipId].magicEquipAttr = attrs
end

--删除指定装备
function DataManager.removeUserEquip(userEquipId)
    _userEquipList[userEquipId] = nil
end

-- 获取背包中的装备(未穿戴)
function DataManager.getUserPackageEquipList()
    local retEquipList = { }
    for _, v in pairs(_userEquipList) do
        if not v.userHeroId or v.userHeroId == "" then
            table.insert(retEquipList, DeepCopy(v))
        end
    end
    return retEquipList
end

-- 获取指定英雄穿戴
function DataManager.getUserHeroEquipList(userHeroId)
    local retEquipList = { }
    for k, v in pairs(_userEquipList) do
        if userHeroId == v.userHeroId then
            table.insert(retEquipList, DeepCopy(v))
        end
    end
    return retEquipList
end

-- 更新用户装备(其实就是增加/替换)
function DataManager.updateUserEquip(equipList)
    if equipList then
        for k, v in pairs(equipList) do
            if _userEquipList[v.userEquipId] then
                _userEquipList[v.userEquipId] = DataTranslater.tranEquip(v)
            else
                _userEquipList[v.userEquipId] = DataTranslater.tranEquip(v)
            end
			
			table.insert(_last_get_equip, {userEquipId = v.userEquipId})
        end
    end
end

--英雄升级
function DataManager.heroLevelUpgrade(goodsList)
	for k,v in pairs(goodsList) do
		if v.goodsType == GameField.level and v.goodsNum > 0 then --用户等级
			DataManager.setRangeTaskList()
			TileMapUIPanel_heroLevelUpgrade()
		end
	end
end

-- 通用掉落
function DataManager.updateCommonGoods(msgObj)
    DataManager.updateHeroList(msgObj.body.drop.heroList)
    DataManager.updateGoodsList(msgObj.body.drop.goodsList)
    DataManager.updateUserEquip(msgObj.body.drop.equipList)
    DataManager.updateHeadSkillList(msgObj.body.drop.heroSkillList)
	DataManager.updateUesrGemstoneList(msgObj.body.drop.gemstoneList)
	
	UserInfoUIPanel_refresh()
	DataManager.heroLevelUpgrade(msgObj.body.drop.goodsList)
end

--日常任务刷新表
function DataManager.getSystemDailyTask(systemTaskId)
    return StaticDataManager.getSystemDailyTask(systemTaskId)
end


--设置用户生活技能信息
function DataManager.setLifeSkillsInfo(msgObj)
	_userLifeInfoBO = msgObj.body.userLifeInfoBOList
end

--获取用户生活技能信息
function DataManager.getLifeSkillsInfo()
	return  _userLifeInfoBO
end

--获取用户生活配置表(主要是花费配置)
function DataManager.getLifeConfig(category)
    return StaticDataManager.getSystemLifeConfig(category)
end

--获取用户生活奖励
function DataManager.getLifeReward()
    return StaticDataManager.getSystemReward()
end

--获取装备出售列表
function DataManager.getStaticEquipToolMall()
    return StaticDataManager.getSystemEquipToolMall()
end

--获取附魔道具出售表
function DataManager.getStaticMagicToolMall()
    return StaticDataManager.getSystemMagicToolMall()
end

--获取遣散英雄
function DataManager.getDismissHero(systemHeroId)
    return _userDismissHeroMap[systemHeroId]
end

--遣散英雄
function DataManager.dismissHero(systemHeroId)
    if _userHeroMap[systemHeroId] then
        _userDismissHeroMap[systemHeroId] = _userHeroMap[systemHeroId]
        _userDismissHeroMap[systemHeroId].status = 0--状态置为0
        _userHeroMap[systemHeroId] = nil
    end
end

--邀请遣散英雄
function DataManager.CallBackDismissHero(systemHeroId)
    if _userDismissHeroMap[systemHeroId] then
        _userHeroMap[systemHeroId] = _userDismissHeroMap[systemHeroId]
        _userHeroMap[systemHeroId].status = 1--状态置为1
        _userDismissHeroMap[systemHeroId] = nil
    end
end

--判断地图是否激活
function DataManager.isOpenMap(mapId)
    for k,v in pairs(_user_openMap_List) do
        if v == mapId then
            return true
        end
    end
    return false
end

--判断地图是否有城镇
function DataManager.isHasTown(mapId)
	local map = StaticDataManager.getSystemMap()
	for k,v in pairs(map) do
		if mapId == k then
			local hasTown = v.hasTownLogo
			if hasTown ~= 0 then
				return true
			else
				return false
			end
		end
	end
end

--判断是否在城镇中
function DataManager.isInTown(mapId, currentSceneId)
	local map = StaticDataManager.getSystemMap()
	for k,v in pairs(map) do
		if mapId == k then
			local hasTown = v.hasTownLogo
			if hasTown == currentSceneId then
				return true
			else
				return false
			end
		end
	end
end

--增加激活的地图
function DataManager.addOpenMapId(mapId)
    table.insert(_user_openMap_List, mapId)
end

--获取整个场景
function DataManager.getSystemScene()
    return StaticDataManager.getSystemScene()
end

--保存当前场景
function DataManager.setCurrentSceneId(nowSceneId)
    _cache_curSceneId = nowSceneId
end

--获取当前场景
function DataManager.getCurrentSceneId()
    return _cache_curSceneId
end

--获取战斗自动分配ID
function DataManager.getFightHeroId()
	_fightHeroId = _fightHeroId + 1
	return _fightHeroId
end

--重置战斗ID
function DataManager.setFightHeroId()
	_fightHeroId = 1
end

--获取荣誉物品
function DataManager.getSystemHonourExchange()
	return StaticDataManager.getSystemHonourExchange()
end

--玩家开放的地图ID
function DataManager.setUserTileMapInfo(x,y,s)
	_userTileMapInfo.x = x
	_userTileMapInfo.y = y
	_userTileMapInfo.sceneId = s
end

--获取地图信息
function DataManager.getUserTileMapInfo()
	return _userTileMapInfo
end

function DataManager.setShowWindowTips(tips)
	table.insert(_userWindowTips,tostring(tips))
end

function DataManager.getIsShowWindowTips(tips)
	for k,v in pairs(_userWindowTips)do
		if tonumber(v) == tips then
			return true
		end
	end
	return false
end
--锻造

function DataManager.getSystemAllToolForge()
	local dic = StaticDataManager.getSystemToolForge()
	return dic
end

function DataManager.getSystemToolForgeByToolIdAndType(toolID, type)
	local dic = StaticDataManager.getSystemToolForge()
	for i = 1, #dic do
		if toolID == dic[i].toolId and type == dic[i].type then
			return dic[i]
		end
	end
	return nil
end

--获取所有能进行矿石熔炼的所有矿石材料
function DataManager.getSystemToolAllOreMaterialByType(type)
	local dic = StaticDataManager.getSystemToolForge()
	local ret = {}
	for k, v in pairs(dic) do 
		if v.type == type then
			local materialList = Split(v.material, "|")
			for i, j in pairs(materialList) do
				local materialInfo = Split(j, ",")
				local materialId = tonumber(materialInfo[2])
				ret[materialId] = {toolId = v.toolId, num = v.num, material = v.material}
			end
		end
	end
	return ret
end

--获取所有能进行宝石熔炼的所有矿石材料
function DataManager.getSystemGemSynthesisAllOreMaterialByType(type)
	local dic = StaticDataManager.getSystemGemstoneForgeList()
	local ret = {}
	for k, v in pairs(dic) do 
		if v.type == type then
			local materialList = Split(v.material, "|")
			for i, j in pairs(materialList) do
				local materialInfo = Split(j, ",")
				local materialId = tonumber(materialInfo[2])
				ret[materialId] = {toolId = v.gemstoneId, num = v.num, material = v.material}
			end
		end
	end
	return ret
end

--升星
function DataManager.getSystemHeroPromoteStar(star,idx)
	local data = StaticDataManager.getSystemHeroPromoteStar()
	for k,v in pairs(data)do
		if v.star == star and v.type == idx then
			return DeepCopy(v)
		end
	end
end

--传承
function DataManager.getSystemHeroInherit(star)
	return StaticDataManager.getSystemHeroInherit(star)
end

--宝石
function DataManager.getSystemGemstone(gemstoneId)
	return StaticDataManager.getSystemGemstone(gemstoneId)
end

--宝石属性
function DataManager.getSystemGemstoneAttr(gemstoneId)
	local temp = {}
	local data = StaticDataManager.getSystemGemstoneAttr()
	for k,v in pairs(data)do
		if v.gemstoneId == gemstoneId then
			table.insert(temp,DeepCopy(v))
		end
	end
	return temp
end

--宝石合成
function DataManager.getSystemGemstoneForgeByIdAndTyep(gemstoneId,type)
	local data = StaticDataManager.getSystemGemstoneForgeList()
	for k, v in pairs(data) do
		if v.gemstoneId == gemstoneId and v.type == type  then
			return DeepCopy(v)
		end
	end
end

--宝石锻造
function DataManager.getSystemGemstoneForge(gemstoneId)
	return StaticDataManager.getSystemGemstoneForge(gemstoneId)
end

--宝石锻造列表
function DataManager.getSystemGemstoneForgeList()
	return StaticDataManager.getSystemGemstoneForgeList()
end

--宝石升级
function DataManager.getSystemGemstoneUpgrade(gemstoneId)
	return StaticDataManager.getSystemGemstoneUpgrade(gemstoneId)
end

--
function DataManager.getUserGemstoneList()
	local tempList = {}
	for k,v in pairs(_userGemstoneList)do
		table.insert(tempList,v)
	end
	return tempList
end

--宝石列表
function DataManager.getCanMosaicGemstoneList()
	local tempList = {}
	for k,v in pairs(_userGemstoneList)do
		if v.userEquipId == nil or v.userEquipId == "" then
			table.insert(tempList,v)
		end
	end
	return tempList
end

--宝石列表
function DataManager.getEquipGemstoneList(userEquipId)
	local tempList = {}
	for k,v in pairs(_userGemstoneList)do
		if v.userEquipId == userEquipId then
			tempList[v.pos] = v
		end
	end
	return tempList
end

--更新宝石
function DataManager.updateGemstone(userGemstoneBO)
	local id = userGemstoneBO.userGemstoneId
	_userGemstoneList[id].pos = userGemstoneBO.pos
	_userGemstoneList[id].attr = userGemstoneBO.attr
	_userGemstoneList[id].userEquipId = userGemstoneBO.userEquipId
end

--删除宝石
function DataManager.removeGemstoneId(userGemstoneId)
	_userGemstoneList[userGemstoneId] = nil
end

--添加宝石
function DataManager.addUserGemstone(userGemstoneBO)
	local newGemstone = DataTranslater.tranGemstone(userGemstoneBO)
	_userGemstoneList[newGemstone.userGemstoneId] = newGemstone
	
	table.insert(_last_get_stone, {userGemstoneId = newGemstone.userGemstoneId})
end

-- 更新团长技能列表
function DataManager.updateUesrGemstoneList(gemstoneList)
    if gemstoneList then
        for k, v in pairs(gemstoneList) do
            DataManager.addUserGemstone(v)
        end
    end
end


function DataManager.doSortList(sortList,compareFuns)
    if not sortList then return end
    table.sort(sortList,function(a,b) 
	   for i=1,#compareFuns do
            local fun = compareFuns[i]
            local result = fun(a,b)
            if result<0 then
                return true
            elseif result>0 then
                return false
            end
        end
    end)
end

--英雄排序
--1.出阵英雄（按照阵位12345）>工作中英雄>训练中英雄>空闲英雄
--2.英雄装等>英雄品质>英雄星级>英雄级别
function DataManager.getSortHeroList(sortList)
    local heroList1 = {}
	local heroList2 = {}
	for k,v in pairs(sortList)do
		if v.pos > 0 then
			table.insert(heroList1,v)
		else
			table.insert(heroList2,v)
		end
	end
	
	local function sortPos(a,b)
		return a.pos < b.pos
	end
	
	local function sortStatus(a,b)
		if a.status < b.status then
			return 1
		elseif a.status > b.status then
			return -1
		else
			return 0
		end
	end
	
	local function sortEffective(a,b)
		if a.effective < b.effective then
			return 1
		elseif a.effective > b.effective then
			return -1
		else
			return 0
		end
	end
	
	local function sortColor(a,b)
		if a.heroColor < b.heroColor then
			return 1
		elseif a.heroColor > b.heroColor then
			return -1
		else
			return 0
		end
	end
	
	local function sortStar(a,b)
		if a.star < b.star then
			return 1
		elseif a.star > b.star then
			return -1
		else
			return 0
		end
	end
	
	local function sortLevel(a,b)
		if a.level < b.level then
			return 1
		elseif a.level > b.level then
			return -1
		else
			return 0
		end
	end
	
	local compareFuns = {}
	table.insert(compareFuns,sortStatus)
	table.insert(compareFuns,sortEffective)
	table.insert(compareFuns,sortColor)
	table.insert(compareFuns,sortStar)
	table.insert(compareFuns,sortLevel)
	DataManager.doSortList(heroList2,compareFuns)
	
	table.sort(heroList1,sortPos)
	for k,v in pairs(heroList2)do
		table.insert(heroList1,v)
	end
	return heroList1
end

--宝石装备列表
function DataManager.getEquipGemList(userHeroId,userEquipId,isPopEquip)
	local tempHero = {}
	local tempHero1 = {}
	local tempHero2 = {}
	local equipList1 = {}
	local equipList2 = {}
	local equipHero = {}
	local targetList = {}
	
	for k,v in pairs(_userHeroMap)do
		if v.pos > 0 then
			table.insert(tempHero1,v)
		else
			table.insert(tempHero2,v)
		end
	end
	
	local function sortPos(a,b)
		return a.pos < b.pos
	end
	table.sort(tempHero1,sortPos)
	
	local function sortLevel(a,b)
		return a.level > b.level
	end
	table.sort(tempHero2,sortLevel)
	
	for k,v in pairs(tempHero1)do
		table.insert(tempHero,v)
	end
	
	for k,v in pairs(tempHero2)do
		table.insert(tempHero,v)
	end
	
	for k,v in pairs(_userEquipList) do
		if v.userHeroId ~= nil and v.userHeroId ~= "" then
			table.insert(equipList1,v)
		else
			table.insert(equipList2,v)
		end
	end
		
	for k,v in pairs(tempHero) do
		for m,n in pairs(equipList1)do
			if v.userHeroId == n.userHeroId then
				table.insert(equipHero,v)
				break
			end
		end
	end
	
	for k,v in pairs(equipHero) do
		local heroInfo = {showType=GameField.hero,isChild=false,isSelect=false,info=v}	
		table.insert(targetList,heroInfo)
		if isPopEquip and v.userHeroId == userHeroId then
			heroInfo.isSelect = true
			
			for m,n in pairs(equipList1)do
				if v.userHeroId == n.userHeroId then
					local quipInfo = {showType=GameField.equip,isChild=true,isSelect=false,info=n}
					table.insert(targetList,quipInfo)
					
					if userEquipId == n.userEquipId then
						quipInfo.isSelect = true
					end
				end
			end
		end
	end
	
	local heroInfo = {showType=GameField.tool,isChild=false,isSelect=false,info={userHeroId=-1}}	
	table.insert(targetList,heroInfo)

	if isPopEquip and userHeroId == -1 then
		heroInfo.isSelect = true
		for k,v in pairs(equipList2)do
			local quipInfo = {showType=GameField.equip,isChild=true,isSelect=false,info=v}
			table.insert(targetList,quipInfo)

			if userEquipId == v.userEquipId then
				quipInfo.isSelect = true
			end
		end
	end

	return targetList
end

--附魔
-- 根据附魔卷轴的id  或者这个卷轴需要的材料
function DataManager.getSystemMagicMaterialByMagicId(toolID)
	local dic = StaticDataManager.getSystemMagicMaterial()
	return dic[toolID]
end

function DataManager.getSystemEquipFixedAttr(equipId)
	return StaticDataManager.getSystemEquipFixedAttr(equipId)
end

function DataManager.setHeroStatus(userHeroId,status)
	if _userHeroMap[userHeroId] then
		_userHeroMap[userHeroId].status = status
	end
end

function DataManager.initFightData()
	_fightData = {}
end

function DataManager.addFightData(data)
	table.insert(_fightData,data)
end

function DataManager.getFightData()
	local temp1 = {} --伤害
	local temp2 = {} --输出
	local temp3 = {} --治疗
	
	local temp4 = {} --伤害
	local temp5 = {} --输出
	local temp6 = {} --治疗
	
	for k,v in pairs(_fightData) do
		--我方
		if v.actMode1 == GameField.actMode2 and 
		   v.actMode2 == GameField.actMode1 then
			table.insert(temp1,v)
		end
		
		if v.actMode1 == GameField.actMode1 and 
		   v.actMode2 == GameField.actMode2 then
			table.insert(temp2,v)
		end
		if v.actMode1 == GameField.actMode1 and 
		   v.actMode2 == GameField.actMode1 and
		   v.value > 0 then
			table.insert(temp3,v)
		end
		
		--敌方
		if v.actMode1 == GameField.actMode1 and 
		   v.actMode2 == GameField.actMode2 then
			table.insert(temp4,v)
		end
		if v.actMode1 == GameField.actMode2 and 
		   v.actMode2 == GameField.actMode1 then
			table.insert(temp5,v)
		end
		if v.actMode1 == GameField.actMode2 and 
		   v.actMode2 == GameField.actMode2 and
		   v.value > 0 then
			table.insert(temp6,v)
		end
	end
	return temp1,temp2,temp3,temp4,temp5,temp6
end

function DataManager.getSystemAchievement()
	return StaticDataManager.getSystemAchievement()
end

function DataManager.getSystemLoginReward30()
	return StaticDataManager.getSystemLoginReward30()
end

--获取玩家上次获得的武器，道具， 宝石
function DataManager.getLastGetGoods()
	local equip = DeepCopy(_last_get_equip)
	local tool = DeepCopy(_last_get_tool)
	local stone = DeepCopy(_last_get_stone)
	return equip, tool, stone
end

--清除玩家上次获得的武器，道具， 宝石
function DataManager.clearLastGetGoods()
	_last_get_equip = {}
	_last_get_tool = {}
	_last_get_stone = {}
end


--获取玩家仓库的武器
function DataManager.getRepertoryStoreEquip()
	return DeepCopy(_repertory_store_equip)
end

--获取玩家仓库的道具
function DataManager.getRepertoryStoreTool()
	return DeepCopy(_repertory_store_tool)
end

--获取玩家仓库的宝石
function DataManager.getRepertoryStoreStone()
	return DeepCopy(_repertory_store_stone)
end

--删除仓库指定装备
function DataManager.removeRepertoryEquip(userEquipId)
	_userEquipList[userEquipId] = DeepCopy(_repertory_store_equip[userEquipId])
    _repertory_store_equip[userEquipId] = nil
end

--减仓库道具
function DataManager.reduceRepertoryTool(toolId, reduceToolNum)
    for k, v in pairs(_repertory_store_tool) do
        if v.toolId == toolId then
            v.toolNum = v.toolNum - reduceToolNum
            if v.toolNum <= 0 then
                table.remove(_repertory_store_tool, k)
            end
            break
        end
    end	
	-- 更新用户道具
	DataManager.updateUserTool({goodsId = toolId, goodsNum = reduceToolNum})	
end

--删除仓库宝石
function DataManager.removeRepertoryGemstoneId(userGemstoneId)
	_userGemstoneList[userGemstoneId]= DeepCopy(_repertory_store_stone[userGemstoneId])
	_repertory_store_stone[userGemstoneId] = nil
end

-- 添加仓库装备
function DataManager.addRepertoryEquip(userEquipId)
	_repertory_store_equip[userEquipId] = DeepCopy(_userEquipList[userEquipId])
	_userEquipList[userEquipId] = nil
end

-- 添加仓库道具
function DataManager.addRepertoryTool(toolId, toolNum)
    local flag = true
    for k, v in pairs(_repertory_store_tool) do
        if v.toolId == toolId then
            v.toolNum = v.toolNum + toolNum
            if v.toolNum <= 0 then
                table.remove(_repertory_store_tool, k)
            end
            flag = false
            break
        end
    end
    if flag then
        table.insert(_repertory_store_tool, DataTranslater.tranTool({ toolId = toolId, toolNum = toolNum }))
    end
	
	DataManager.reduceUserTool(toolId, toolNum)
end

--添加仓库宝石
function DataManager.addRepertoryGemstone(userGemstoneId)
	_repertory_store_stone[userGemstoneId] = DeepCopy(_userGemstoneList[userGemstoneId])
	_userGemstoneList[userGemstoneId] = nil
end

--将背包 <======> 仓库 的转换
function DataManager.dumpRepertoryAndPackage(data)
	if GameField.StoreOperateTypeIn == data.type then	--存入仓库
		if GameField.equip == data.toolType then
			DataManager.addRepertoryEquip(data.userEquipId)
		elseif GameField.gemstone == data.toolType then
			DataManager.addRepertoryGemstone(data.userGemstoneId)
		else
			DataManager.addRepertoryTool(data.toolId, data.toolNum)
		end
	elseif GameField.StoreOperateTypeOut == data.type then 	--取出仓库(存入背包)
		if GameField.equip == data.toolType then
			DataManager.removeRepertoryEquip(data.userEquipId)
		elseif GameField.gemstone == data.toolType then
			DataManager.removeRepertoryGemstoneId(data.userGemstoneId)
		else
			DataManager.reduceRepertoryTool(data.toolId, data.toolNum)
		end
	end
end

function DataManager.updateStoreHouse(extendNum)
	_userBO.storehouseExtendTimes = _userBO.storehouseExtendTimes + extendNum
end

function DataManager.getSystemCareerClearConfig()
	return StaticDataManager.getSystemCareerClearConfig()
end

function DataManager.getSystemCareerClear()
	return StaticDataManager.getSystemCareerClear()
end

function DataManager.getSystemHeroPromote()
	return StaticDataManager.getSystemHeroPromote()
end

function DataManager.getSystemHeroCareerAdd()
	return StaticDataManager.getSystemHeroCareerAdd()
end

--获取每层显示的加成
function DataManager.getSystemHeroCareerAddById(careerId)
	local HeroCareerAdd = DataManager.getSystemHeroCareerAdd()

	local dic = {}
	for k,v in pairs(HeroCareerAdd) do
        local detailedCareerId = v.detailedCareerId
        local level = v.level
        local attribute = v.attribute
        if detailedCareerId == careerId then
            if level == 1 then
                dic[1] = attribute
            elseif level == 2 then
                dic[2] = attribute
            elseif level == 3 then
                dic[3] = attribute
            elseif level == 4 then
                dic[4] = attribute
            elseif level == 5 then
                dic[5] = attribute
            elseif level == 6 then
                dic[6] = attribute
            elseif level == 7 then
                dic[7] = attribute
            elseif level == 8 then
                dic[8] = attribute
            elseif level == 9 then
                dic[9] = attribute
            elseif level == 10 then
                dic[10] = attribute
            end
        end
    end
    return dic
end

--获得职业解锁的信息
function DataManager.getSystemCareerClearById(careerId)
	local careerClear = StaticDataManager.getSystemCareerClear()

	local dic = {}
	for i,v in pairs(careerClear) do
		local detailedCareerId = v.detailedCareerId
		if detailedCareerId == careerId then
			dic = v
		end
	end
	return dic
end

--获得徽章解锁信息
function DataManager.getSystemCareerClearInfoById(detailId)
	local heroDetailInfo = StaticDataManager.getSystemHeroDetailInfo()

	local dic = {}
	for k,v in pairs(heroDetailInfo) do
		local temp = {}
		local detailedCareerId = v.detailedCareerId
		if detailedCareerId == detailId then
			temp.skill01 = v.skill01
			temp.skill02 = v.skill02
			temp.skill03 = v.skill03
			temp.skill04 = v.skill04
			temp.heroDesc = v.heroDesc
			table.insert(dic, temp)
		end
	end
	return dic
end

--获得英雄进阶信息
function DataManager.getSystemHeroPromoteInfo(systemHeroId)
	local heroPromote = DataManager.getSystemHeroPromote()

	local dic = {}
	for k,v in pairs(heroPromote) do
		local temp = {}
		local sysHeroId = v.systemHeroId
		if systemHeroId == sysHeroId then
			temp.systemHeroId = v.systemHeroId
			temp.proSystemHeroId = v.proSystemHeroId
			temp.heroLevel = v.heroLevel
			temp.material = v.material
			table.insert(dic, temp)
		end
	end
	return dic
end

--获得相应的职业详细信息
function DataManager.getSystemHeroDescInfo(careerProMoteTab)
	local heroInfo = StaticDataManager.getSystemHeroDetailInfo()

	local dic = {}
	for k,v in pairs(careerProMoteTab) do
		local promoteId = v.proSystemHeroId
		for k,v in pairs(heroInfo) do
			local temp = {}
			if promoteId == v.systemHeroId then
				temp.skill01 = v.skill01
				temp.skill02 = v.skill02
				temp.skill03 = v.skill03
				temp.skill04 = v.skill04
				temp.heroDesc = v.heroDesc
				temp.resId = v.resId
				temp.heroName = v.heroName
				temp.careerId = v.careerId
				table.insert(dic, temp)
				break
			end
		end
	end
	return dic
end

--获得英雄是否可以进阶
function DataManager.isSystemHeroCanPromote(systemHeroId)
	local heroPromote = StaticDataManager.getSystemHeroPromote()

	local isCan = false
	for k,v in pairs(heroPromote) do
		local sysHeroId = v.systemHeroId
		if systemHeroId == sysHeroId then
			isCan = true
		end
	end
	return isCan
end

function DataManager.getSystemFightStandardRate()
	return StaticDataManager.getSystemFightStandardRate()
end

--战斗标准值
function DataManager.getSystemFightStandardValue(level)
	return StaticDataManager.getSystemFightStandardValue(level)
end

--是否为房主
function DataManager.setWorldBossRoomOwner(isRoomOwner)
	_worldBossRoomOwner = isRoomOwner
end

--获取房主
function DataManager.getWorldBossRoomOwner()
	return _worldBossRoomOwner == 1
end

--是否为房主
function DataManager.setChangeRoomOwner(userId)
	if _userBO.userId == userId then
		_worldBossRoomOwner = 1
	else	
		_worldBossRoomOwner = 0
	end
end

--世界boss
function DataManager.setWorldBossInfo(worldBossInfoBo)
	_worldBossStatus = 2
	_worldBossInfoBo = worldBossInfoBo
end

--获取世界
function DataManager.getWorldBossInfo()
	return _worldBossInfoBo
end

--世界Boss当前血量
function DataManager.setBossCurrentLife(currentLife)
	_worldBossInfoBo.currentLife = currentLife
end

--世界Boss的排行榜
function DataManager.setWorldBossHurtRank(bossHurtRank)
	_worldBossHurtRank = bossHurtRank
end

--世界Boss的状态
function DataManager.setWorldBossStatus(status)
	_worldBossStatus = status
	_worldBossStatus = 2
	_worldBossInfoBo = {}
end

function DataManager.getWorldBossStatus()
	return _worldBossStatus
end


function DataManager.getBossHero(mapId)
	local systemHero = nil
	local data = StaticDataManager.getSystemBossMap()
	for k,v in pairs(data)do
		if v.mapId == mapId then
			systemHero = DataManager.getStaticSystemHeroId(v.systemHeroId)
			break
		end
	end
	return systemHero
end

--系统活跃度任务
function DataManager.getSystemActivityTask()
	return StaticDataManager.getSystemActivityTask()
end

--系统活跃度任务
function DataManager.getSystemActivityTaskReward()
	return StaticDataManager.getSystemActivityTaskReward()
end

--系统活跃度任务引导
function DataManager.getSystemActivityTaskGuide()
	local data =  StaticDataManager.getSystemActivityTaskGuide()
	local ret = {}
	for k,v in pairs(data)do
		if v.minLevel <= _userBO.level and v.maxLevel >= _userBO.level and ( 3 == v.camp or v.camp == _userBO.camp) then
			ret[v.targetType] = v
		end
	end
	return DeepCopy(ret)
end

--根据道具的主ID和副ID获取所有道具
function DataManager.getSystemToolByToolTypeAndToolId(toolType, toolId)
	local systemTool
	local isTool = false
	if toolType == GameField.gold then	--金币
		isTool = true
		toolId = 1049
	elseif toolType == GameField.money then	--钱
		isTool = true
		toolId = 1050
	elseif toolType == GameField.heroExp then --英雄经验
		isTool = true
		toolId = 1051
	elseif toolType == GameField.exp then	--团队经验
		isTool = true
		toolId = 1052
	elseif toolType == GameField.jobExp then --魂能
		isTool = true
		toolId = 1053
	elseif toolType == GameField.honour then--荣誉
		isTool = true
		toolId = 1054
	elseif toolType == GameField.tool then	--道具
		isTool = true
		toolId = toolId
	end
	
	if isTool then --道具
		local systemTool = DataManager.getSystemTool(toolId)
		return systemTool
	end
	
	if toolType == GameField.hero then	--英雄
		local systemHero = DataManager.getStaticSystemHeroId(toolId)
		iconImg = IconPath.yingxiong.. systemHero.imgId .. ".png"
		qualityColor = systemHero.heroColor
	elseif toolType == GameField.heroSkill then --英雄技能
	
    elseif toolType == GameField.power then	--体力
	
	elseif toolType == GameField.activity then--活力
	
	elseif toolType == GameField.packExtendTimes then--背包扩展次数
	    
	elseif toolType == GameField.equip then  --装备
	    systemTool = DataManager.getSystemEquip(toolId)
		
	elseif toolType == GameField.level then  --用户等级 即团队等级
	    
	elseif toolType == GameField.prestigeLevel then  --声望等级
	    
	elseif toolType == GameField.chest then  --宝箱
		systemTool = DataManager.getSystemTool(toolId)
	elseif toolType == GameField.packExtendNum then  --背包大小
		systemTool = DataManager.getSystemTool(toolId)
	elseif toolType == GameField.gemstone then --宝石
		systemTool = DataManager.getSystemGemstone(toolId)
	end
	return systemTool
end
