require("TaskLibrary")

TaskUIPanel = 
{
	panel = nil,
}

function TaskUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

--创建
function TaskUIPanel:Create(para)
    local p_name = "TaskUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	local userBo = DataManager.getUserBO()
	local money = userBo.money

	--业务逻辑编写处
	local curType 
	local curStatus
	local selectTask
	local selectSprite
	local itemBgSprite
	local isShowDesc = false
	local branchTask = DataManager.getBranchTaskList() --支线
	local temp1,temp2,temp3,temp4 = DataManager.getUserTaskList() --主线
	local function addTaskList(taskList,tempList,taskType)
		table.insert(taskList,{taskType=GameField.taskType1,systemTaskId=0,taskName=""})
		table.insert(taskList,{taskType=GameField.taskType2,systemTaskId=0,taskName=""})
        if curStatus ~= GameField.taskStatus0 then
		    table.insert(taskList,{taskType=GameField.taskType3,systemTaskId=0,taskName=""})
        end
		for k,v in pairs(tempList) do
            if  taskType ~= GameField.taskType3 or 
                (curStatus ~= GameField.taskStatus0 and taskType == GameField.taskType3) then
			    v.taskType = 0 
                if taskType == GameField.taskType3 then--日常任务的奖励另外获取
                    v.rewards = DataManager.getSystemDailyTask(v.systemTaskId)[v.star].rewards
                end
			    table.insert(taskList,taskType+1,v)
            end
		end
	end
	
	--获取任务
	local function getTaskSortData(status,taskType)
		local taskList = {}
		if status == GameField.taskStatus0 then 
			if taskType == GameField.taskType1 then
				addTaskList(taskList,temp1,taskType)
			elseif taskType == GameField.taskType2 then
				addTaskList(taskList,branchTask,taskType)
			--elseif taskType == GameField.taskType3 then
				--addTaskList(taskList,dailyTask,taskType)
			end
		else
			if taskType == GameField.taskType1 then
				addTaskList(taskList,temp2,taskType)
			elseif taskType == GameField.taskType2 then
				addTaskList(taskList,temp3,taskType)
			elseif taskType == GameField.taskType3 then
				addTaskList(taskList,temp4,taskType)
			end
		end
		return taskList
	end
	
	--任务的信息
	local function createTaskDecsInfo()
		local height = 330
		local posY = height
		local nodeArray = TaskLibrary.createTaskDetailArray(selectTask,isShowDesc)
		local scrollView = self.panel:getChildByName("scrollView")
		scrollView:removeAllChildren()
		
		for k,v in pairs(nodeArray) do
			local node = nodeArray[k]
			local size = node:getContentSize()
			posY = posY - size.height - 5
			if k == 1 or k == 4 then
				node:setPosition(cc.p(0,posY))
			else
				node:setPosition(cc.p(10,posY))
			end
			node:setAnchorPoint(cc.p(0,0))
			scrollView:addChild(node)
		end
		
		if posY < 0 then
			for k,v in pairs(nodeArray) do
				local node = nodeArray[k]
				local x,y = node:getPosition()
				node:setPosition(cc.p(x,y-posY))
			end
		end
		self.panel:setNodeVisible("lab_taskName",true)
		self.panel:setNodeVisible("btn_taskDesc",true)
		scrollView:setInnerContainerSize(cc.size(400,height-posY))
		self.panel:setLabelText("lab_taskName",selectTask.taskName)
	end
	
	--任务详细内容
	local function createTaskCxt(item,data)
		if selectTask and selectTask.systemTaskId == data.systemTaskId then
			return
		end
		selectTask = data
		createTaskDecsInfo() --任务的信息
		
		if itemBgSprite then
			itemBgSprite:setVisible(true)
		end
		itemBgSprite = self.panel:getItemChildByName(item,"img_itemBg")
		itemBgSprite:setVisible(false)

		if selectSprite then
			selectSprite:removeFromParent(true)
		end
		selectSprite = CreateCCSprite(IconPath.renwu.."i_renwuxz.png")
		selectSprite:setAnchorPoint(cc.p(0,0))
		selectSprite:setPosition(cc.p(2,3))
		item:addChild(selectSprite)

        local btnGoto = self.panel:getChildByName("btn_goto")
        local btnGiveUp = self.panel:getChildByName("btn_giveup")
		if selectTask.status == GameField.taskStatus0 or 
		   selectTask.status == GameField.taskStatus2 then --可领取
			btnGoto:setVisible(true)
            btnGiveUp:setVisible(false)
            btnGoto:setPosition(cc.p(230, 70))
		elseif selectTask.status == GameField.taskStatus1 then --已领取
			btnGoto:setVisible(true)
            btnGoto:setPosition(cc.p(140, 70))
            btnGiveUp:setVisible(true)
            btnGiveUp:setPosition(cc.p(330, 70))
		end
	end

	local function OnItemShowCallback(scroll_view,item,data,idx)
		if data.taskType > 0 then
			local selImage = ""
			if data.taskType == curType then
				selImage = IconPath.renwu.."b_renwuxz.png"
			else
				selImage = IconPath.renwu.."b_renwuxz02.png"
			end
			local selSprite = CreateCCSprite(selImage)
			selSprite:setAnchorPoint(cc.p(0,0))
			selSprite:setPosition(cc.p(0,0))
			item:addChild(selSprite)
			local pathName = ""
			if data.taskType == GameField.taskType1 then
				pathName = "t_zhuxianrw.png"
			elseif data.taskType == GameField.taskType2 then
				pathName = "t_zhixianrw.png"
			elseif data.taskType == GameField.taskType3 then
				pathName = "t_ricrenwu.png"
			end
			local typeSprite = CreateCCSprite(IconPath.renwu..pathName)
			typeSprite:setAnchorPoint(cc.p(0,0))
			typeSprite:setPosition(cc.p(32,15))
			item:addChild(typeSprite)
			self.panel:setItemNodeVisible(item,"img_itemBg",false)
		else		
			local nameLabel = CreateLabel(data.taskName)
			nameLabel:setAnchorPoint(cc.p(0,0))
			nameLabel:setPosition(cc.p(40,15))
			item:addChild(nameLabel,2)			
			if selectTask == nil then
				createTaskCxt(item,data)
			end
		end
	end
	
	local function OnItemClickCallback(item,data,idx)
		if data.taskType == 0 then
			createTaskCxt(item,data)
		else
			self.refreshTaskInfo(curStatus,data.taskType)
		end
	end
	
	--刷新任务
	local function refreshTaskInfo(status,taskType)
		curType = taskType
		curStatus = status
		selectTask = nil
		selectSprite = nil
		itemBgSprite = nil
		
		self.panel:setNodeVisible("lab_taskName",false)
		self.panel:setNodeVisible("btn_taskDesc",false)
		local scrollView = self.panel:getChildByName("scrollView")
		scrollView:removeAllChildren()

		local data = getTaskSortData(status,taskType)		
		if #data <= 3 then --无任务
			self.panel:setNodeVisible("btn_goto",false)
			self.panel:setNodeVisible("btn_giveup",false)
		end
		
		if status == GameField.taskStatus1 then
			self.panel:setBtnEnabled("btn_receive",false)
			self.panel:setBtnEnabled("btn_noreceive",true)
		else
			self.panel:setBtnEnabled("btn_receive",true)
			self.panel:setBtnEnabled("btn_noreceive",false)
		end
		self.panel:InitListView(data,OnItemShowCallback,OnItemClickCallback)
	end
	refreshTaskInfo(GameField.taskStatus1,GameField.taskType1)
	self.refreshTaskInfo = refreshTaskInfo
	
	local function btnCallBack(sender,tag)
		if tag == 0 then--关闭
			self:Release()
		elseif tag == 1 then--已接受
			refreshTaskInfo(GameField.taskStatus1,GameField.taskType1)
		elseif tag == 2 then--未接收
			refreshTaskInfo(GameField.taskStatus0,GameField.taskType1)
		elseif tag == 3 then--放弃和前往，领奖
			if selectTask.status == GameField.taskStatus0 then
				DataManager.setReceiveTaskNpc(selectTask.receiveTaskNpc..",0,0,"..selectTask.systemTaskId) --1 NPC接受任务
            elseif selectTask.status == GameField.taskStatus1 then
                local mainlinePara = TaskLibrary.getAutoFindWayPara(selectTask)
                DataManager.setReceiveTaskNpc(mainlinePara)
            elseif selectTask.status == GameField.taskStatus2 then
			    DataManager.setReceiveTaskNpc(selectTask.handinTaskNpc..",0,0,"..selectTask.systemTaskId) --1 NPC完成任务
            end
			TileMapUIPanel_cleanJumpScene()
			TileMapUIPanel_autoFindNpcTask()
			self:Release()
		elseif tag == 4 then
			local dropTaskReq = TaskAction_dropTaskReq:New()
			dropTaskReq:setInt_systemTaskId(selectTask.systemTaskId)
			NetReqLua(dropTaskReq)
		elseif tag ==  5 then
			isShowDesc = not isShowDesc
			createTaskDecsInfo()
		end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_receive",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_noreceive",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_goto",btnCallBack,3)
	self.panel:addNodeTouchEventListener("btn_giveup",btnCallBack,4)
	self.panel:addNodeTouchEventListener("btn_taskDesc",btnCallBack,5)
	
	--推送刷新任务列表
	function TaskUIPanel_Task_update()
		branchTask = DataManager.getBranchTaskList() --支线
		temp1,temp2,temp3,temp4 = DataManager.getUserTaskList() --主线
		self.refreshTaskInfo(curStatus,curType)
	end

    --删除任务
    function TaskUIPanel_TaskAction_dropTask(msgObj)
		
    end
		
	return panel
end
--退出
function TaskUIPanel:Release()
	self.panel:Release()
end

--隐藏
function TaskUIPanel:Hide()
	self.panel:Hide()
end
--显示
function TaskUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
