-------------------------------------------------------------------------
--
-- 文 件 名 : TaskGuideUIPanel.lua
-- 创 建 者 ：chenximin
-- 创建时间 ：2015-04-23
-- 功能描述 ：任务引导
--
-------------------------------------------------------------------------

TaskGuideUIPanel = {}

function TaskGuideUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function TaskGuideUIPanel:Create(para)
	local p_name = "TaskGuideUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)

	local curStatus = GameField.taskStatus1
	local curType = GameField.taskType1
	local selectTask = nil
	local viewIdx = 1
	local btnIdx = 1
	local branchTask = DataManager.getBranchTaskList() --支线
	local temp1,temp2,temp3,temp4 = DataManager.getUserTaskList() --主线
	local mainlinePara --参数
	local mainlineTask --主线任务
	local firstListView = 0

	local mainBtn = 0
	local branchBtn = 0
	local dailyBtn = 0
	local taskBtn = 0

	function MainMenuUIPanel_updateMainlineTask()
		mainlineTask = DataManager.getMainlineTask()
		if mainlineTask then
			mainlinePara,mainlineImg = TaskLibrary.getAutoFindWayPara(mainlineTask)
		end
	end
	MainMenuUIPanel_updateMainlineTask()

	local function addTaskList(taskList,tempList,taskType)
		for k,v in pairs(tempList) do
            if  taskType ~= GameField.taskType3 or (curStatus ~= GameField.taskStatus0 and taskType == GameField.taskType3) then
			    v.taskType = 0 
                if taskType == GameField.taskType3 then--日常任务的奖励另外获取
                    v.rewards = DataManager.getSystemDailyTask(v.systemTaskId)[v.star].rewards
                end
                table.insert(taskList,v)
            end
		end
	end

	local function addTaskListFirst(taskList,tempList,taskType)
		for k,v in pairs(tempList) do
            if  taskType ~= GameField.taskType3 or (curStatus ~= GameField.taskStatus0 and taskType == GameField.taskType3) then
			    v.taskType = 0 
                if taskType == GameField.taskType3 then--日常任务的奖励另外获取
                    v.rewards = DataManager.getSystemDailyTask(v.systemTaskId)[v.star].rewards
                end
                table.insert(taskList,v)
            end
		end
	end

	local function getTaskSortDataFirst()
		if viewIdx == 1 then
			local taskList = {}
			table.insert(taskList,{taskType=GameField.taskType1,systemTaskId=0,taskName=""})
			addTaskListFirst(taskList,temp2,GameField.taskType1)
			table.insert(taskList,{taskType=GameField.taskType2,systemTaskId=0,taskName=""})
			addTaskListFirst(taskList,temp3,GameField.taskType2)
	        if curStatus ~= GameField.taskStatus0 then
			    table.insert(taskList,{taskType=GameField.taskType3,systemTaskId=0,taskName=""})
	        end
	        addTaskListFirst(taskList,temp4,GameField.taskType3)

	        return taskList
	    elseif viewIdx == 2 then
		    local taskList = {}
			table.insert(taskList,{taskType=GameField.taskType1,systemTaskId=0,taskName=""})
			addTaskListFirst(taskList,temp1,GameField.taskType1)
			table.insert(taskList,{taskType=GameField.taskType2,systemTaskId=0,taskName=""})
			addTaskListFirst(taskList,branchTask,GameField.taskType2)

	        return taskList
		end
	end
	
	--获取任务
	local function getTaskSortData(status,taskType)
		local taskList = {}
		if status == GameField.taskStatus0 then--可领取
			if taskType == GameField.taskType1 then --主线
				addTaskList(taskList,temp1,taskType)
			elseif taskType == GameField.taskType2 then --支线
				addTaskList(taskList,branchTask,taskType)
			end
		else
			if taskType == GameField.taskType1 then --主线
				addTaskList(taskList,temp2,taskType)
			elseif taskType == GameField.taskType2 then --支线
				addTaskList(taskList,temp3,taskType)
			elseif taskType == GameField.taskType3 then --日线
				addTaskList(taskList,temp4,taskType)
			end
		end
		return taskList
	end

	local function OnItemShowCallback(scroll_view,item,data,idx)
		self.panel:setItemLabelText(item, "lab_level", "("..data.limitMinLevel..")")
		self.panel:setItemLabelText(item, "lab_task_name", data.taskName)
		self.panel:setItemLabelText(item, "lab_task", data.taskDesc)
		if data.finishTimes == data.needFinishTimes then
			self.panel:setItemLabelText(item, "lab_progress", "(完成)")
		else
			self.panel:setItemLabelText(item, "lab_progress", "("..data.finishTimes.."/"..data.needFinishTimes..")")
		end
	end
	
	local function OnItemClickCallback(item,data,idx)
		if selectTask and selectTask.systemTaskId == data.systemTaskId then
			return
		end
		selectTask = data
		cclog("129;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
		cclogtable(selectTask)
		if selectTask.status == GameField.taskStatus0 then
			DataManager.setReceiveTaskNpc(selectTask.receiveTaskNpc..",0,0,"..selectTask.systemTaskId) --1 NPC接受任务
        elseif selectTask.status == GameField.taskStatus1 then
            local mainlinePara = TaskLibrary.getAutoFindWayPara(selectTask)
            DataManager.setReceiveTaskNpc(mainlinePara)
        elseif selectTask.status == GameField.taskStatus2 then
		    DataManager.setReceiveTaskNpc(selectTask.handinTaskNpc..",0,0,"..selectTask.systemTaskId) --1 NPC完成任务
        end
        cclog("139;>>>>>>>>>>>>>>>>>>>>>>>>>>")
		TileMapUIPanel_cleanJumpScene()
		TileMapUIPanel_autoFindNpcTask()
	end
	
	--刷新任务
	local function refreshTaskInfo(status,taskType)
		local data = getTaskSortData(status,taskType)
		self.panel:InitListView(data, OnItemShowCallback, OnItemClickCallback, "ListView", "ListItem")
	end
	self.panel:setBtnEnabled("btn_left",false)
	self.panel:setBtnEnabled("btn_right",true)

	local function OnItemShowCallbackFirst(scroll_view,item,data,idx)
		if data.taskType > 0 then
			local pathName = ""
			if data.taskType == GameField.taskType1 then
				pathName = "t_zhuxianrw.png"
			elseif data.taskType == GameField.taskType2 then
				pathName = "t_zhixianrw.png"
			elseif data.taskType == GameField.taskType3 then
				pathName = "t_ricrenwu.png"
			end
			
			--任务横幅
			local typeSprite = CreateCCSprite(IconPath.renwu..pathName)
			typeSprite:setAnchorPoint(cc.p(0,0))
			typeSprite:setPosition(cc.p(15,3))
			item:addChild(typeSprite)

			self.panel:setItemNodeVisible(item, "lab_level_first", false)
			self.panel:setItemNodeVisible(item, "lab_task_name_first", false)

			if data.taskType == 1 then
				mainBtn = idx
			elseif data.taskType == 2 then
				branchBtn = idx
			elseif data.taskType == 3 then
				dailyBtn = idx
			end

		else
			self.panel:setItemLabelText(item, "lab_level_first", "("..data.limitMinLevel..")")
			self.panel:setItemLabelText(item, "lab_task_name_first", data.taskName)
		end
	end

	local function OnItemClickCallbackFirst(item,data,idx)
		if data.taskType == 1 or idx > mainBtn and idx < branchBtn then
			ListShowHide(true, 1)
			curType = GameField.taskType1

			refreshTaskInfo(curStatus,curType)
		elseif data.taskType == 2 or idx > branchBtn and idx < dailyBtn then
			ListShowHide(true, 2)
			curType = GameField.taskType2

			refreshTaskInfo(curStatus,curType)
		elseif data.taskType == 3 or idx > dailyBtn then
			ListShowHide(true, 3)
			curType = GameField.taskType3

			refreshTaskInfo(curStatus,curType)
		end
	end

	--第一次刷新任务，为了超大号傻逼任务引导
	local function refreshTaskInfoFirst()
		local data = getTaskSortDataFirst()
		self.panel:InitListView(data, OnItemShowCallbackFirst, OnItemClickCallbackFirst, "ListView_first", "ListItem_first", nil, nil, 1)
	end
	refreshTaskInfoFirst()

	--推送刷新任务列表
	function TaskUIPanel_Task_update()
		branchTask = DataManager.getBranchTaskList() --支线
		temp1,temp2,temp3,temp4 = DataManager.getUserTaskList() --主线
	end

	--显示/隐藏公共接口
	function TaskGuideUIPanel_Hide_Show(tag)
		if tag == 0 then--隐藏
			local btnHide = self.panel:getChildByName("btn_hide")
			local bg = self.panel:getChildByName("img_bg")
			if btnHide:isVisible() and delayTime ~= 2 then
				local function hideCallback()
					self.panel:setNodeVisible("btn_hide", false)
				end

				local bg = self.panel:getChildByName("img_bg")
				local bgX, bgY = bg:getPosition()
				local size = bg:getContentSize()

				local moveBy = cc.MoveBy:create(0.3, cc.p(size.width, 0))
				local callback = cc.CallFunc:create(hideCallback)
				local seq = cc.Sequence:create(moveBy, callback)
				bg:runAction(seq)
			end
			self.panel:setNodeVisible("btn_show", false)
		elseif tag == 1 then--显示
			self.panel:setNodeVisible("btn_show", true)
		end
	end

	--进来时，设置3秒钟后自动隐藏
	local function PanelThreeSecondHide()
		delayTime = 2
		local function bgHide()
			local function hideCallback()
				self.panel:setNodeVisible("btn_hide", false)
				self.panel:setNodeVisible("btn_show", true)
				delayTime = 0
			end

			local bg = self.panel:getChildByName("img_bg")
			local bgX, bgY = bg:getPosition()
			local size = bg:getContentSize()

			local moveBy = cc.MoveBy:create(0.3, cc.p(size.width, 0))
			local callback = cc.CallFunc:create(hideCallback)
			local seq = cc.Sequence:create(moveBy, callback)
			bg:runAction(seq)
		end

		local delay = cc.DelayTime:create(delayTime)
		local callback = cc.CallFunc:create(bgHide)
		local seq = cc.Sequence:create(delay, callback)
		self.panel.layer:runAction(seq)
	end
	PanelThreeSecondHide()

	--隐藏/显示列表
	function ListShowHide(bShow, tag)
		if bShow then
			self.panel:setNodeVisible("ListView_first", false)
			self.panel:setNodeVisible("ListItem_first", false)

			self.panel:setNodeVisible("img_top_title", true)
			self.panel:setNodeVisible("btn_goback", true)
			self.panel:setNodeVisible("ListView", true)
			self.panel:setNodeVisible("ListItem", true)

			if tag == 1 then
				self.panel:setImageTexture("img_top_title","NewUi/xinqietu/renwu/t_zhuxianrw.png")
			elseif tag == 2 then
				self.panel:setImageTexture("img_top_title","NewUi/xinqietu/renwu/t_zhixianrw.png")
			elseif tag == 3 then
				self.panel:setImageTexture("img_top_title","NewUi/xinqietu/renwu/t_ricrenwu.png")
			end
		end
	end

	local function btnCallBack(sender,tag)
		if tag == 0 then--隐藏
			local function hideCallback()
				self.panel:setNodeVisible("btn_hide", false)
				self.panel:setNodeVisible("btn_show", true)
			end

			local bg = self.panel:getChildByName("img_bg")
			local bgX, bgY = bg:getPosition()
			local size = bg:getContentSize()

			local moveBy = cc.MoveBy:create(0.3, cc.p(size.width, 0))
			local callback = cc.CallFunc:create(hideCallback)
			local seq = cc.Sequence:create(moveBy, callback)
			bg:runAction(seq)
		elseif tag == 1 then--显示
			local function showCallback()
				self.panel:setNodeVisible("btn_hide", true)
				self.panel:setNodeVisible("btn_show", false)
			end

			local bg = self.panel:getChildByName("img_bg")
			local bgX, bgY = bg:getPosition()
			local size = bg:getContentSize()

			local moveBy = cc.MoveBy:create(0.3, cc.p(-size.width, 0))
			local callback = cc.CallFunc:create(showCallback)
			local seq = cc.Sequence:create(moveBy, callback)
			bg:runAction(seq)
		elseif tag == 2 then--已接受
			viewIdx = 1
			curStatus = GameField.taskStatus1

			self.panel:setNodeVisible("ListView_first", true)
			self.panel:setNodeVisible("ListItem_first", true)

			refreshTaskInfoFirst()

			self.panel:setNodeVisible("img_top_title", false)
			self.panel:setNodeVisible("btn_goback", false)
			self.panel:setNodeVisible("ListView", false)
			self.panel:setNodeVisible("ListItem", false)

			self.panel:setBtnEnabled("btn_left",false)
			self.panel:setBtnEnabled("btn_right",true)
		elseif tag == 3 then--未接受
			viewIdx = 2
			curStatus = GameField.taskStatus0

			self.panel:setNodeVisible("ListView_first", true)
			self.panel:setNodeVisible("ListItem_first", true)

			refreshTaskInfoFirst()

			self.panel:setNodeVisible("img_top_title", false)
			self.panel:setNodeVisible("btn_goback", false)
			self.panel:setNodeVisible("ListView", false)
			self.panel:setNodeVisible("ListItem", false)

			self.panel:setBtnEnabled("btn_left",true)
			self.panel:setBtnEnabled("btn_right",false)
		elseif tag == 4 then--返回
			self.panel:setNodeVisible("ListView_first", true)
			self.panel:setNodeVisible("ListItem_first", true)

			refreshTaskInfoFirst()

			self.panel:setNodeVisible("img_top_title", false)
			self.panel:setNodeVisible("btn_goback", false)
			self.panel:setNodeVisible("ListView", false)
			self.panel:setNodeVisible("ListItem", false)
		end
	end
	self.panel:addNodeTouchEventListener("btn_hide",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_show",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_left",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_right",btnCallBack,3)
	self.panel:addNodeTouchEventListener("btn_goback",btnCallBack,4)

    return self.panel
end

--退出
function TaskGuideUIPanel:Release()
	self.panel:Release()
end

--隐藏
function TaskGuideUIPanel:Hide()
	self.panel:Hide()
end

--显示
function TaskGuideUIPanel:Show()
	self.panel:Show()
end