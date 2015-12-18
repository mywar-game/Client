--日常任务

AssistantUIPanel = {}

function AssistantUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function AssistantUIPanel:Create(para)
	local p_name = "AssistantUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
    
    local systemConfig = DataManager.getSystemConfig()
    local userInfo = DataManager.getUserBO()
	
	local systemActivityTask = DataManager.getSystemActivityTask()
	local systemActivityTaskGuide = DataManager.getSystemActivityTaskGuide()
	local systemActivityTaskReward = DataManager.getSystemActivityTaskReward()
	
	local data = para.msgObj
    local completeTaskList	= {}			--缓存的已完成任务列表
    local unCompleteTaskList = {}			--缓存未完成任务
	
	local function initRewardUI(data)
		self.panel:setBitmapText("bitlab_have", data.point)
		self.panel:setProgressBarPercent("probar", data.point / systemActivityTaskReward[3].point * 100)
		
		for k = 1, 3 do
			local dic = data.point - systemActivityTaskReward[4 - k].point
			if dic < 0 then
				self.panel:setBitmapText("lab_owe", LabelChineseStr.AssistantUIPanelTitle_1 .. -dic .. LabelChineseStr.AssistantUIPanelTitle_2)
			end
		end
		
		for k=1, 3 do
			self.panel:setBitmapText("lab_num"..k, systemActivityTaskReward[k].point)
			local btn = self.panel:getChildByName("btn_reward_" .. k)
			if data.rewardLogList and data.rewardLogList[k] and 1 == data.rewardLogList[k].status then			--未领取
				btn:setEnable(false)
			elseif data.rewardLogList and data.rewardLogList[k] and 2 == data.rewardLogList[k].status then
				btn:setEnable(false)
			end
		
			if systemActivityTaskReward[k].point <= data.point and (#data.rewardLogList < 1 or  data.rewardLogList and data.rewardLogList[k] and 1 == data.rewardLogList[k].status) then
				self.panel:setNodeVisible("lab_owe", false)
				self.panel:setNodeVisible("btn_recieve", true)
				btn:setScale(1.5)
			end
		end
	end
	
	initRewardUI(data)
	
	
	local function OnRewardItemShowCallback(scroll_view, item, data, idx)
		local tool = DataManager.getSystemToolByToolTypeAndToolId(tonumber(data[1]), tonumber(data[2]))
		self.panel:setItemLabelText(item, "lab_temp",tool.name .. " X" .. data[3])
	end
	
	local function OnRewardItemClickCallback(item, data, idx)
	end
	
	local function showRewards(idx)
		self.panel:setNodeVisible("img_details", true)
		self.panel:setLabelText("lab_tips", LabelChineseStr.AssistantUIPanelTitle_0 .. 	systemActivityTaskReward[idx].point)
		local rewardInfo = systemActivityTaskReward[idx]
		local rewardList = Split(rewardInfo.rewards, "|")
		local showData = {}
		for k, v in pairs(rewardList) do
			local reward = Split(v, ",")
			table.insert(showData, reward)
		end
		self.panel:InitListView(showData, OnRewardItemShowCallback, OnRewardItemClickCallback, "ListView_rewards", "ListItem_rewards")
	end
	for k=1, 3 do 
		local btn = self.panel:getChildByName("btn_reward_" .. k)
		btn:addTouchEventListener(
			function(sender,eventType)
				if eventType == ccui.TouchEventType.began then
					local arr = {}
					arr[1] = cc.DelayTime:create(0.5)
					arr[2]= cc.CallFunc:create(function() showRewards(k) end)
					local action = cc.Sequence:create(arr)
					btn:runAction(action)
				else
					self.panel:setNodeVisible("img_details", false)
					btn:stopAllActions()
				end
			end
		)
	end
	
	for k, v in pairs(data.userActivityTaskList) do
		if 1 == v.status then
			table.insert(completeTaskList, v)
		else 
			table.insert(unCompleteTaskList, v)
		end
	end
	
	local functionStr = {[10] = "MainMenuUIPanel_openArena", [11] = "UserInfoUIPanel_OpenLoginReward30Info"
	,[12] = "MainMenuUIPanel_openTeamSkill", [13] = "MainMenuUIPanel_openExplore"
	,[18] = "MainMenuUIPanel_openProfession"}
	
	--解析字符串
	local function conversionPara(taskPara)
		local para = {}
		local array = Split(taskPara,";")
		for k,v in pairs(array) do
			local temp = Split(v,":")
			if temp[1] == "sceneId" then
				para.sceneId = temp[2]
			elseif temp[1] == "mapId" then
				para.mapId = temp[2]
			elseif temp[1] == "forcesId" then
				para.forcesId = temp[2]
			elseif temp[1] == "monsterId" then
				para.monsterId = temp[2]
			elseif temp[1] == "npcId" then
				para.npcId = temp[2]
			elseif temp[1] == "bigForcesId" then
				para.bigForcesId = temp[2]
			end
		end
		return para
	end
	
	--前往按钮回调
	local function btnGoCallback(data)
		local typeId = systemActivityTask[data.activityTaskId].targetType
		local npcDataInfo = systemActivityTaskGuide[typeId].params
		local guidType = tostring(npcDataInfo)
		if "0" == guidType then
			if nil ~= functionStr[typeId]  then
				self:Release()
				loadstring(functionStr[typeId].."()")()
			end
		else
			local taskPara = conversionPara(npcDataInfo)
			local taskNpc = taskPara.sceneId..","
			if nil ~= taskPara.npcId then
				taskNpc = taskNpc..taskPara.npcId..",0"
			elseif nil ~= taskPara.forcesId then
				taskNpc = taskNpc..taskPara.forcesId..",2"
			elseif nil ~= taskNpc.bigForcesId then
				taskNpc = taskNpc..taskPara.bigForcesId..",1"
			end
			if "" ~= taskNpc then
				self:Release()
				DataManager.setReceiveTaskNpc(taskNpc)
				TileMapUIPanel_cleanJumpScene()
				TileMapUIPanel_autoFindNpcTask()
			else
				Tips("ERROR")
			end

		end		
	end
    --list监听	
    local function OnItemShowCallback(scroll_view, item, data, idx)
		local systemData = systemActivityTask[data.activityTaskId]
		if 0 == data.status then
			self.panel:setItemNodeVisible(item, "img_complete", false)
			self.panel:setItemNodeVisible(item, "btn_go", true)
			local node = item:getChildByName("btn_go")
			node:addTouchEventListener(function(sender,eventType)
			if eventType == ccui.TouchEventType.ended then
				SoundEffect.playSoundEffect("button")
				btnGoCallback(data)
			end
	   end)
		else
			self.panel:setItemNodeVisible(item, "img_complete", true)
			self.panel:setItemNodeVisible(item, "btn_go", false)
		end
		
		self.panel:setItemLabelText(item, "lab_title" ,systemData.targetDesc)
		self.panel:setItemLabelText(item, "lab_status" ,LabelChineseStr["AssistantUIPanelStatus_"..data.status] .. "(" .. data.finishTimes .. "/" .. systemData.needFinishTimes .. ")" .. "  +" .. systemData.point)
	
    end

    local function OnItemClickCallback(item, data, idx)

    end
	
	
	local function refreshListView(idx)
		local showData = {}
		if 1 == idx then
			showData = completeTaskList
		elseif 2 == idx then
			showData = unCompleteTaskList
		end
		self.panel:setBtnEnabled("btn_1", idx ~= 1)
		self.panel:setBtnEnabled("btn_2", idx ~= 2)
		if #showData < 1 then
			self.panel:setNodeVisible("lab_nothing", true)
		else
			self.panel:setNodeVisible("lab_nothing", false)
		end
		self.panel:InitListView(showData, OnItemShowCallback, OnItemClickCallback, nil, nil, nil, nil, 1)
    end
	
	refreshListView(2)

	local function btnCallBack(sender,tag)
		if tag == 0 then
		    self:Release() 
        elseif tag <= 2 then
			refreshListView(tag)
		elseif 3 == tag then
			local assistReq = ActivityAction_receiveActivityTaskRewardReq:New()
			NetReqLua(assistReq, true)
		end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_1",btnCallBack,1)
    self.panel:addNodeTouchEventListener("btn_2",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_recieve",btnCallBack, 3)
	
	
	--重新打开活跃度界面
	function AssistantUIPanel_ActivityAction_reStart()
		self:Release()
		UserInfoUIPanel_getActivityTaskInfo()
	end
	
	--领取活跃度奖励
	function AssistantUIPanel_ActivityAction_receiveActivityTaskReward(msgObj)
		LayerManager.show("DialogRewardsUIPanel", msgObj.body.drop, true)--展示获得东西
		AssistantUIPanel_ActivityAction_reStart()
	end
	
	--推送活跃度信息更新
	function AssistantUIPanel_Activity_updateActivityTask(msgObj)
		local data
		data.point = msgObj.body.point
		data.rewardLogList = msgObj.body.updateUserActivityTaskList
		initRewardUI(data)
	end
    return self.panel
end

--退出
function AssistantUIPanel:Release()
	self.panel:Release()
end

--隐藏
function AssistantUIPanel:Hide()
	self.panel:Hide()
end

--显示
function AssistantUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end