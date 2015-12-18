TaskLibrary = {}

function TaskLibrary.conversionPara(taskPara)
	local para = {}
	local array = Split(taskPara,",")
	for k,v in pairs(array) do
		local temp = Split(v,":")
		if temp[1] == "sceneId" then
			para.sceneId = tonumber(temp[2])
		elseif temp[1] == "mapId" then
			para.mapId = tonumber(temp[2])
		elseif temp[1] == "forcesId" then
			para.forcesId = tonumber(temp[2])
		elseif temp[1] == "monsterId" then
			para.monsterId = tonumber(temp[2])
		elseif temp[1] == "npcId" then
			para.npcId = tonumber(temp[2])
		elseif temp[1] == "bigForcesId" then
			para.bigForcesId = tonumber(temp[2])
		end
	end
	return para
end
	
function TaskLibrary.parsing(taskLibrary,taskPara)
	local taskCxt = ""
	local newPara = TaskLibrary.conversionPara(taskPara)
	if taskLibrary ==  GameField.tasklibrary1 then
		
	elseif taskLibrary ==  GameField.tasklibrary2 then
	
	elseif taskLibrary ==  GameField.tasklibrary3 then
	
	elseif taskLibrary ==  GameField.tasklibrary4 then
		local systemForces = DataManager.getSystemMapForcesId(newPara.forcesId)		
		taskCxt = systemForces.forcesName
	elseif taskLibrary ==  GameField.tasklibrary5 then
	
	elseif taskLibrary ==  GameField.tasklibrary6 then
	
	elseif taskLibrary ==  GameField.tasklibrary7 then

	elseif taskLibrary ==  GameField.tasklibrary8 then
	
	elseif taskLibrary ==  GameField.tasklibrary9 then
	
	end
	return taskCxt
end

function TaskLibrary.getAutoFindWayPara(mainlineTask)
	--自动寻路
	local function findNpc(npcInfo)
		local npc = Split(npcInfo,",")
		local imgStr = nil
		local systemNpc = DataManager.getSystemMapNpc(tonumber(npc[1]))
		for k,v in pairs(systemNpc)do
			if tonumber(npc[2]) == v.systemNpcId then
				imgStr = IconPath.yingxiong..v.imgId..".png"
				break
			end
		end
		return imgStr
	end
	
	local imgStr = nil
	local taskNpc = nil
	if mainlineTask.status == GameField.taskStatus0 then
		taskNpc = mainlineTask.receiveTaskNpc..",0,0,"..mainlineTask.systemTaskId
		imgStr = findNpc(mainlineTask.receiveTaskNpc)
	elseif mainlineTask.status == GameField.taskStatus2 then
		taskNpc = mainlineTask.handinTaskNpc..",0,0,"..mainlineTask.systemTaskId
		imgStr = findNpc(mainlineTask.handinTaskNpc)
	elseif mainlineTask.status == GameField.taskStatus1 then
		local taskPara = TaskLibrary.conversionPara(mainlineTask.taskPara)
		taskNpc = taskPara.sceneId..","
		if mainlineTask.taskLibrary ==  GameField.tasklibrary1 then
			taskNpc = taskNpc..taskPara.forcesId..",2"
		elseif mainlineTask.taskLibrary ==  GameField.tasklibrary2 then
			taskNpc = taskNpc..taskPara.npcId..",0"
			imgStr = findNpc(taskPara.mapId..","..taskPara.npcId)
		elseif mainlineTask.taskLibrary ==  GameField.tasklibrary3 then
		
		elseif mainlineTask.taskLibrary ==  GameField.tasklibrary4 then
			taskNpc = taskNpc..taskPara.bigForcesId..",1"
		elseif mainlineTask.taskLibrary ==  GameField.tasklibrary5 then
		
		elseif mainlineTask.taskLibrary ==  GameField.tasklibrary6 then
			taskNpc = taskNpc..taskPara.npcId..",0"
			imgStr = findNpc(taskPara.mapId..","..taskPara.npcId)
		elseif mainlineTask.taskLibrary ==  GameField.tasklibrary7 then
	
		elseif mainlineTask.taskLibrary ==  GameField.tasklibrary8 then
		
		elseif mainlineTask.taskLibrary ==  GameField.tasklibrary9 then
		
		elseif mainlineTask.taskLibrary ==  GameField.tasklibrary10 then
		
		elseif mainlineTask.taskLibrary ==  GameField.tasklibrary11 then
		
		elseif mainlineTask.taskLibrary ==  GameField.tasklibrary12 then
			taskNpc = taskNpc..taskPara.bigForcesId..",1"
		end
		taskNpc = taskNpc..","..mainlineTask.taskLibrary..","..mainlineTask.systemTaskId
	end
	return taskNpc,imgStr
end

function TaskLibrary.createTaskDetailArray(selectTask,isShowDesc)
	local nodeArray = {}
		
	local bgTSprite = CreateCCSprite(IconPath.renwu.."i_jbbg.png")
	local tagertSprite = CreateCCSprite(IconPath.renwu.."t_rwmb.png")
	tagertSprite:setAnchorPoint(cc.p(0,0.5))
	tagertSprite:setPosition(cc.p(10,20))
	bgTSprite:addChild(tagertSprite)
	table.insert(nodeArray,bgTSprite)
		
	local taskCxt = TaskLibrary.parsing(selectTask.taskLibrary,selectTask.taskPara)
	local targetLabel = CreateLabel(selectTask.taskDesc..taskCxt.."("..selectTask.finishTimes.."/"..selectTask.needFinishTimes..")",nil,22,nil,nil,cc.size(380,0))
	targetLabel:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	table.insert(nodeArray,targetLabel)

	local talkDesc = ""
	if selectTask.status == GameField.taskStatus2 then
		talkDesc = selectTask.handinTaskContent
	else
		talkDesc = selectTask.receiveTaskContent
	end
	
	if not isShowDesc then
		talkDesc = ""
	end
		
	local targetLabel = CreateLabel(talkDesc,nil,20,nil,nil,cc.size(380,0))
	targetLabel:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	table.insert(nodeArray,targetLabel)
	
	local bgWSprite = CreateCCSprite(IconPath.renwu.."i_jbbg.png")
	local rewardSprite = CreateCCSprite(IconPath.renwu.."t_jliwz.png")
	rewardSprite:setPosition(cc.p(10,20))
	rewardSprite:setAnchorPoint(cc.p(0,0.5))
	bgWSprite:addChild(rewardSprite)
	table.insert(nodeArray,bgWSprite)
	
	local rewards = Split(selectTask.rewards,"|")
    local rewardCommon = {}
    local rewardTools = {}
    --拆分不同种类奖励
    for k,v in pairs(rewards) do
        local tools = Split(v,",")
        local toolType = tonumber(tools[1])
        local toolNum = tonumber(tools[3])
        if toolType == GameField.gold
           or toolType == GameField.jobExp 
           or toolType == GameField.exp
           or toolType == GameField.heroExp then
            table.insert(rewardCommon, tools)
        else
            table.insert(rewardTools, tools)
        end
    end
    --排序通用奖励(保证一个图标一个文字即可)
    table.sort(rewardCommon, function (a,b)
        local toolTypeA = tonumber(a[1])
        local toolTypeB = tonumber(b[1])
        --金币
        if toolTypeA == GameField.gold then
            return true
        elseif toolTypeB == GameField.gold then
            return false
        end
        --英雄经验
        if toolTypeA == GameField.heroExp then
            return true
        elseif toolTypeB == GameField.heroExp then
            return false
        end
        --声望
        if toolTypeA == GameField.jobExp then
            return true
        elseif toolTypeB == GameField.jobExp then
            return false
        end
        --团队经验
        if toolTypeA == GameField.exp then
            return true
        elseif toolTypeB == GameField.exp then
            return false
        end
    end)
    
	local ceilWidth = 40
	local ceilHeight = 36
	local count = math.ceil(#rewardCommon/2)
    local rewardCommonLayer = cc.LayerColor:create(cc.c4b(0,0,0,0))
	rewardCommonLayer:setContentSize(cc.size(350,ceilHeight*count))
	table.insert(nodeArray,rewardCommonLayer)
    
	--提取出金币/团队经验/英雄经验/声望奖励
	local cacheCount = 0
    local cacheOffsetX = ceilWidth
    local cacheOffsetY = ceilHeight*(count-0.5)
    local function insertCommonValue(picPath,num)
        if cacheCount >= 2 then
			cacheCount = 0
            cacheOffsetX = ceilWidth
            cacheOffsetY = ceilHeight/2
        end
		
        local picSprite = CreateCCSprite(picPath)
        picSprite:setAnchorPoint(cc.p(0.5,0.5))
        picSprite:setPosition(cc.p(cacheOffsetX,cacheOffsetY))
        rewardCommonLayer:addChild(picSprite)
        
		local numLabel = CreateLabel(num,nil,20,cc.c3b(255,255,255),1)
        numLabel:setPosition(cc.p(cacheOffsetX+32,cacheOffsetY))
        rewardCommonLayer:addChild(numLabel)
		
		cacheCount = cacheCount + 1
        cacheOffsetX = cacheOffsetX + 158
    end
	
    for k,v in ipairs(rewardCommon) do
        local toolType = tonumber(v[1])
        local toolNum = tonumber(v[3])
        if toolType == GameField.gold then--金币
            insertCommonValue(IconPath.tongyong.."i_jingb.png",toolNum)
        elseif toolType == GameField.jobExp then--声望
            insertCommonValue(IconPath.tongyong.."i_shengwang.png",toolNum)
        elseif toolType == GameField.exp then--团队经验
            insertCommonValue(IconPath.tongyong.."t_tdexp.png",toolNum)
        elseif toolType == GameField.heroExp then--英雄经验
            insertCommonValue(IconPath.tongyong.."t_rwexp.png",toolNum)
        end
    end
	
    --结束
	local rewardsLen = math.ceil(#rewardTools/4)
	for k=1,rewardsLen do
		local rewardLayer = cc.LayerColor:create(cc.c4b(0,0,0,0))
		rewardLayer:setContentSize(cc.size(350,70))
		for m=1,4 do
			local tools = rewardTools[(k-1)*4+m]
			if tools then
				local iconSprite = IconUtil.GetIconByIdType(tools[1],tools[2],tools[3],{})
				iconSprite:setPosition(cc.p(80*m-30,30))
				rewardLayer:addChild(iconSprite)
			end
		end
		table.insert(nodeArray,rewardLayer)
	end
    return nodeArray
end
