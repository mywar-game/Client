--邮件主界面
EmailUIPanel = {}
function EmailUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function EmailUIPanel:Create(para)
	local p_name = "EmailUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)    
   
	local clickIdx = nil
	local idSortEmail = {}
    local waitToRead = nil
	local waitToDelete = {}
	local oneClickCheckAll = false  -- 一键全选
	local systemConfig = DataManager.getSystemConfig()
	local allItemCheckBox = {}

    --list监听
    local function OnItemShowCallback(scroll_view, item, data, idx)
		local checkBox = self.panel:getItemChildByName(item, "ckbox_delSelect")
		checkBox:setVisible(false)	--隐藏删除勾选
		table.insert(allItemCheckBox, {checkBox = checkBox, data = data})
		
        if #data.goodsBeanBOList > 0 and 0 == data.receiveStatus then --如果有附件 换掉icon
            self.panel:setItemImageTexture(item, "img_icon", IconPath.youjian.."i_fujianicon.png")
        end
		
        if data.status == 0 then--如果未读就添加提醒按钮
			local retIcon = self.panel:getItemChildByName(item,"img_iconFg")
			local animAction = ActionHelper.createScaleActionForever()
			retIcon:setVisible(true)
			retIcon:runAction(animAction)
        end
        
		if data.mailType == -1 then--私聊
            self.panel:setItemLabelText(item, "lab_title",data.title)
        else
             self.panel:setItemLabelText(item, "lab_title", data.title)
        end
		
        self.panel:setItemLabelText(item, "lab_time", 
            LabelChineseStr.EmailUIPanel_1..(data.expiredTime)..LabelChineseStr.EmailUIPanel_2)
        self.panel:setItemLabelText(item, "lab_review", data.content)
        
		local function selectedEvent(sender, eventType, tag)
            if eventType == ccui.CheckBoxEventType.selected then
                waitToDelete[data.userMailId] = data
            elseif eventType == ccui.CheckBoxEventType.unselected then
                waitToDelete[data.userMailId] = nil
            end 
        end
		
		self.panel:setItemNodeVisible(item,"ckbox_delSelect", data.isSelected or false)
        self.panel:setItemCheckBoxSelect(item,"ckbox_delSelect", data.isSelected or false)
        --self.panel:addItemCheckBoxNodeSelectEvent(item,"ckbox_delSelect", selectedEvent)
    end
	
    local function OnItemClickCallback(item, data, idx) 
        --读邮件
        local readReq = MailAction_readReq:New()
        readReq:setInt_userMailId(data.userMailId)
	    NetReqLua(readReq, true)
		
		clickIdx = idx
        waitToRead = data
    end

    local function refreshEmailList()
        local emailList = DataManager.getEmailList()
        --创建逆序list 注意一定要重建顺序emil
        idSortEmail = {}
        for _,v in pairs(emailList) do
			v.isSelected = false
            table.insert(idSortEmail, DeepCopy(v))
        end
        table.sort(idSortEmail, function (a,b)
            return a.userMailId > b.userMailId
        end)
		
		allItemCheckBox = {}
        self.panel:InitListView(idSortEmail, OnItemShowCallback, OnItemClickCallback,"ListView","ListItem",para.idx or 1,nil,1)
        self.panel:getChildByName("ListView"):jumpToTop()
        if #idSortEmail <= 0 then
            self.panel:setNodeVisible("lab_nothing", true)
			 self.panel:setBtnEnabled(false)
		else
            self.panel:setNodeVisible("lab_nothing", false)
			self.panel:setBtnEnabled(true)
        end
    end
    refreshEmailList()
	
	--正常状态 falg是ture   删除状态  flag 是false
	local function setButtonStatus(flag)
		self.panel:setNodeVisible("btn_delete", flag)
		self.panel:setNodeVisible("btn_all", flag)
		self.panel:setNodeVisible("btn_send", flag)
		self.panel:setNodeVisible("btn_delete_cancel", not flag)
		self.panel:setNodeVisible("btn_delete_all", not flag)
		self.panel:setNodeVisible("btn_delete_ture", not flag)
		oneClickCheckAll = false
		self.panel:setBitmapText("bitmap_del_all", LabelChineseStr.EmailUIPanel_6)
	end
	
	local function deleteMailStatus()
		for k, v in pairs(allItemCheckBox) do
			v.checkBox:setVisible(true)
		end
		setButtonStatus(false)
	end
	
	local function deleteMails(data)
		local deleteReq = MailAction_deleteReq:New()
		deleteReq:setString_userMailIds(data.mailIdsStr)
		NetReqLua(deleteReq, true)
	end
	
	local function doDeleteMails()
		--找出所有勾选的邮件
		local flagHasBeanBO = false
		local mailIdsStr = ""
		waitToDelete = {}
		if oneClickCheckAll then
			for k, v in pairs(idSortEmail) do
				if v.isSelected then
					waitToDelete[v.userMailId] = v
					--table.insert(waitToDelete, v)
				end
			end
			for k, v in pairs(allItemCheckBox) do
				if not v.checkBox:getSelectedState() then
					waitToDelete[v.data.userMailId] = nil
				end
			end
		else
			for k, v in pairs(allItemCheckBox) do
				if v.checkBox:getSelectedState() then
					table.insert(waitToDelete, v.data)
				end
			end
		end
		for _,v in pairs(waitToDelete) do
			if #v.goodsBeanBOList > 0 and 0 == v.receiveStatus then
				flagHasBeanBO = true
			end
			 mailIdsStr = string.format("%s%s,", mailIdsStr, v.userMailId)
		end
		if string.len(mailIdsStr) <= 0 then
			Tips(LabelChineseStr.EmailUIPanel_3)
		else
			--删邮件
			local arg = {mailIdsStr = mailIdsStr}
			if flagHasBeanBO then
				LayerManager.showDialog(LabelChineseStr.EmailUIPanel_5, deleteMails, arg)
			else
				deleteMails(arg)
			end
		end
	end
	
	local function btnCallBack(sender,tag)
        if tag == 0 then
		    self:Release() 
        elseif tag == 1 then
			doDeleteMails()
        elseif tag == 2 then--一键领取
            local oneClickRec = MailAction_oneClickReceiveReq:New()
	        NetReqLua(oneClickRec, true)
        elseif tag == 3 then
			LayerManager.show("EmailSenderUIPanel", {idx = 1, fromPanel="EmailUIPanel"})
		elseif tag == 4 then
			for k, v in pairs(allItemCheckBox) do
				v.checkBox:setSelectedState(false)
				v.checkBox:setVisible(false)
			end
			setButtonStatus(true)
		elseif tag == 5 then
			--找出所有邮件
			oneClickCheckAll = not oneClickCheckAll
			for k, v in pairs(idSortEmail) do
				v.isSelected = oneClickCheckAll
			end
			for k, v in pairs(allItemCheckBox) do
				v.checkBox:setSelectedState(oneClickCheckAll)
			end
			if oneClickCheckAll then
				self.panel:setBitmapText("bitmap_del_all", LabelChineseStr.EmailUIPanel_7)
			else
				self.panel:setBitmapText("bitmap_del_all", LabelChineseStr.EmailUIPanel_6)
			end
		elseif tag == 6 then
			deleteMailStatus()
        end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_delete_ture",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_all",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_send",btnCallBack,3)
	self.panel:addNodeTouchEventListener("btn_delete_cancel",btnCallBack,4)
	self.panel:addNodeTouchEventListener("btn_delete_all",btnCallBack,5)	
	self.panel:addNodeTouchEventListener("btn_delete",btnCallBack,6)
	
    --获取邮件
    local function requestMails(maxMailId, isShowWaiting)
        local mailListReq = MailAction_getMailListReq:New()
        mailListReq:setInt_mailId(maxMailId or DataManager.getMaxMailId())
	    NetReqLua(mailListReq, isShowWaiting)
    end
    requestMails(nil, true)
	
    function EmailUIPanel_MailAction_getMailList(msgObj)
        --插入新的邮件
        DataManager.insertMails(msgObj.body.userMailList)
        refreshEmailList()
    end

    function EmailUIPanel_MailAction_read(msgObj)
        LayerManager.show("EmailReceiverUIPanel", {data=waitToRead,idx = clickIdx, fromPanel="EmailUIPanel"})
    end
	
    function EmailUIPanel_MailAction_delete(msgObj)
        DataManager.deleteMails(waitToDelete)
        Tips(LabelChineseStr.EmailUIPanel_4)
        refreshEmailList()
		setButtonStatus(true)
    end

    function EmailUIPanel_MailAction_oneClickReceive(msgObj)
        LayerManager.show("DialogRewardsUIPanel",msgObj.body.drop)--展示获得东西
        requestMails(0)
    end

    function EmailUIPanel_Response_PushNotify(msgObj)
        requestMails(0)
    end

    return self.panel
end

--退出
function EmailUIPanel:Release()
	self.panel:Release()
end

--隐藏
function EmailUIPanel:Hide()
	self.panel:Hide()
end

--显示
function EmailUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end