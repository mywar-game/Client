require("TaskLibrary")
TaskDetailsUIPanel = {
panel = nil,
}
function TaskDetailsUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function TaskDetailsUIPanel:Create(para)
    local p_name = "TaskDetailsUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	local isShowDesc = false
	
	--业务逻辑编写处
    local selectTask = para.selectTask
	if selectTask.status == GameField.taskStatus0 then
		if selectTask.limitMinLevel <= DataManager.getUserBO().level then
			self.panel:setNodeVisible("btn_receive",true)
		else
			self.panel:setNodeVisible("lab_tips",true)
			self.panel:setLabelText("lab_tips",selectTask.limitMinLevel..GameString.acceptTask)
		end
	elseif selectTask.status == GameField.taskStatus1 then
		self.panel:setNodeVisible("btn_moveTo",true)
	elseif selectTask.status == GameField.taskStatus2 then
		self.panel:setNodeVisible("btn_complete",true)
		self.panel:setNodeVisible("btn_moveTo", false)
		self.panel:setNodeVisible("btn_receive", false)
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
		scrollView:setInnerContainerSize(cc.size(400,height-posY))
		self.panel:setLabelText("lab_taskName",selectTask.taskName)
	end
	createTaskDecsInfo()

	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		elseif tag == 1 then --接受
			local addTaskReq = TaskAction_addTaskReq:New()
			addTaskReq:setInt_systemTaskId(selectTask.systemTaskId)
            addTaskReq:setInt_star(0)--日常专用 其他传0
			NetReqLua(addTaskReq)
			UserGuideUIPanel.stepClick( "btn_receive" ) -- 新手引导监听触发
		elseif tag == 2 then
			local receiveTaskReq = TaskAction_receiveTaskReq:New()
			receiveTaskReq:setInt_systemTaskId(selectTask.systemTaskId)
			NetReqLua(receiveTaskReq)
			UserGuideUIPanel.stepClick( "btn_complete" ) -- 新手引导监听触发
        elseif tag == 3 then -- 新手引导监听触发
			local mainlinePara = TaskLibrary.getAutoFindWayPara(selectTask)
            DataManager.setReceiveTaskNpc(mainlinePara)
			TileMapUIPanel_cleanJumpScene()
			TileMapUIPanel_autoFindNpcTask()
			self:Release()
			UserGuideUIPanel.stepClick( "btn_moveTo" ) -- 新手引导监听触发
		elseif tag == 4 then
			isShowDesc = not isShowDesc
			createTaskDecsInfo()
		end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_receive",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_complete",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_moveTo",btnCallBack,3)
	self.panel:addNodeTouchEventListener("btn_taskDesc",btnCallBack,4)
	
	--接受任务
	function TaskDetailsUIPanel_TaskAction_addTask()
		selectTask.status = GameField.taskStatus1
		self.panel:setNodeVisible("btn_moveTo",true)
		self.panel:setNodeVisible("btn_receive",false) 
	end
	
	--完成任务
	function TaskDetailsUIPanel_TaskAction_receiveTask()
		para.callback()
		self:Release()
		if  1 == selectTask.taskType then
		    UserGuideUIPanel.TaskFinish( selectTask.systemTaskId , selectTask.status ) 
		end
		
	end
	return panel
end
--退出
function TaskDetailsUIPanel:Release()
	self.panel:Release()
end
--隐藏
function TaskDetailsUIPanel:Hide()
	self.panel:Hide()
end
--显示
function TaskDetailsUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
