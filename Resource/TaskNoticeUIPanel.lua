require("TaskLibrary")
TaskNoticeUIPanel = {
panel = nil,
}
function TaskNoticeUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function TaskNoticeUIPanel:Create(para)
    local p_name = "TaskNoticeUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	--业务逻辑编写处
	cclog('TaskNoticeUIPanel:Create(para)')
	local state = false
	local function noreceiveCallBack()
		state = not state
		self.panel:getChildByName("notice_left"):setVisible(state)
		self.panel:getChildByName("notice_right"):setVisible(not state)
		
		local moveX = state and 220 or -220
		self.panel.layer:runAction(cc.MoveBy:create(0.5,cc.p(moveX,0)))
	end
	noreceiveCallBack()
	
	local function btnCallBack(sender,tag)
		if tag == 0 then
			LayerManager.show("TaskUIPanel")
			noreceiveCallBack()
		elseif tag == 1 then
			noreceiveCallBack()
		end
	end
	self.panel:addNodeTouchEventListener("btn_task",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_noreceive",btnCallBack,1)
	
	local function OnItemShowCallback(scroll_view,item,data,idx)
		local taskCxt = TaskLibrary.parsing(data.taskLibrary,data.taskPara)
		self.panel:setItemLabelText(item,"lab_taskDesc",taskCxt)
		self.panel:setItemLabelText(item,"lab_taskName",data.taskName)
		self.panel:setItemLabelText(item,"lab_taskNum",data.finishTimes.."/"..data.needFinishTimes)
	end
	
	local function OnItemClickCallback(item,data,idx)	
		cclog("data.taskLibrary====="..data.taskLibrary)
		if data.taskLibrary ==  GameField.tasklibrary1 then
		
		elseif data.taskLibrary ==  GameField.tasklibrary2 then
		
		elseif data.taskLibrary ==  GameField.tasklibrary3 then
		
		elseif data.taskLibrary ==  GameField.tasklibrary4 then
			local taskNpc = ""
			if data.status == GameField.taskStatus1 then
				local taskPara = TaskLibrary.conversionPara(data.taskPara)
				taskNpc = taskPara.sceneId..","..taskPara.forcesId..",2"
			else
				taskNpc = data.receiveTaskNpc..",1"
			end
			DataManager.setReceiveTaskNpc(taskNpc) --2 主面板执行任务
			TileMapUIPanel_autoFindNpcTask()
			noreceiveCallBack()
		elseif data.taskLibrary ==  GameField.tasklibrary5 then
		
		elseif data.taskLibrary ==  GameField.tasklibrary6 then
		
		elseif data.taskLibrary ==  GameField.tasklibrary7 then
	
		elseif data.taskLibrary ==  GameField.tasklibrary8 then
		
		elseif data.taskLibrary ==  GameField.tasklibrary9 then
		
		end
	end
	
	local function refreshTaskInfo()
		local data = DataManager.getAcceptedTask()
		self.panel:InitListView(data,OnItemShowCallback,OnItemClickCallback)
	end
	refreshTaskInfo()
	
	function TaskNoticeUIPanel_refreshTaskInfo()
		refreshTaskInfo()
	end

	self:Show()
	
	return panel
end
--退出
function TaskNoticeUIPanel:Release()
	self.panel:Release()
end
--隐藏
function TaskNoticeUIPanel:Hide()
	self.panel:Hide()
end
--显示
function TaskNoticeUIPanel:Show()
	local sprite = self.panel:getChildByName("big_box")
	local function TaskNoticeUIPanel_Ontouch(e,x,y)
		x = self.panel.layer:convertToNodeSpace(cc.p(x,y)).x
		y = self.panel.layer:convertToNodeSpace(cc.p(x,y)).y
		if isClickSprite(sprite,x,y) then
			return true
		end
		return false
	end
	self.panel:Show()
	self.panel.layer:registerScriptTouchHandler(TaskNoticeUIPanel_Ontouch,false,0,true)
end
