--消息提示框逻辑
EmailReceiverUIPanel = {}
function EmailReceiverUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function EmailReceiverUIPanel:Create(para)
	local p_name = "EmailReceiverUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
    local cacheApplyType = 0--好友申请缓存状态
    --list监听
    local function OnItemShowCallback(scroll_view, item, data, idx)
		local size = item:getContentSize()
        local icon = IconUtil.GetIconByIdType(data.goodsType,data.goodsId, data.goodsNum,{data=data})
        icon:setPosition(cc.p(size.width/2, size.height/2))
        item:addChild(icon)
    end
    local function OnItemClickCallback(item, data, idx) 
        
    end
    --刷新界面
    local function updateUI(data)
        if data.mailType == -1 then--私聊
            self.panel:setLabelText("lab_title", data.title)
			self.panel:setNodeVisible("btn_response", true)
			self.panel:setNodeVisible("btn_delete", true)
        else
             self.panel:setLabelText("lab_title", data.title)
        end
        self.panel:setLabelText("lab_detail",  data.content)
        self.panel:InitListView(data.goodsBeanBOList, OnItemShowCallback, OnItemClickCallback)
        if #data.goodsBeanBOList <= 0 then--如果没有附件物品就隐藏list和附件提示img
            self.panel:setNodeVisible("img_addon", false)
            self.panel:setNodeVisible("ListView", false)
            self.panel:setNodeVisible("btn_getin", false)
        end
        if data.receiveStatus == 1 then--已经领取
            self.panel:setNodeVisible("btn_getin", false)
        end
        --判断是否是添加好友的确认邮件
        if data.mailType ~= 1001 then
            self.panel:setNodeVisible("btn_sure", false)
            self.panel:setNodeVisible("btn_refuse", false)
        end
    end
    updateUI(para.data)

	local function btnCallBack(sender,tag)
		
        if tag == "btn_back" then
		    self:Release() 
            LayerManager.show(para.fromPanel,{idx = para.idx})
        elseif tag == "btn_getin" then
            local receiveReq = MailAction_receiveReq:New()
            receiveReq:setInt_userMailId(para.data.userMailId)
	        NetReqLua(receiveReq, true)
        elseif tag == "btn_sure" then
            local applyFriendReq = FriendAction_auditApplyReq:New()
            cacheApplyType = 1
            applyFriendReq:setInt_type(1)
            applyFriendReq:setInt_userMailId(para.data.userMailId)
	        NetReqLua(applyFriendReq, true)
        elseif tag == "btn_refuse" then
            local applyFriendReq = FriendAction_auditApplyReq:New()
            cacheApplyType = 0
            applyFriendReq:setInt_type(0)
            applyFriendReq:setInt_userMailId(para.data.userMailId)
        	NetReqLua(applyFriendReq, true)
		elseif tag == "btn_response" then
			self:Release() 
			LayerManager.show("EmailSenderUIPanel", {name=para.data.title, friendId = para.data.fromUserId, fromPanel="EmailUIPanel", idx = para.idx})
		elseif tag == "btn_delete" then
			local deleteReq = MailAction_deleteReq:New()
            deleteReq:setString_userMailIds(para.data.userMailId)
	        NetReqLua(deleteReq, true)
        end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_getin",btnCallBack)
    self.panel:addNodeTouchEventListener("btn_sure",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_refuse",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_response",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_delete",btnCallBack)
	
	function EmailReceiverUIPanel_MailAction_delete(msgObj)
		local data = {{userMailId = para.data.userMailId}}
        DataManager.deleteMails(data)
        Tips(LabelChineseStr.EmailUIPanel_4)
		self:Release()
        LayerManager.show(para.fromPanel,{idx = para.idx})
    end

    function EmailReceiverUIPanel_MailAction_receive(msgObj)
        LayerManager.show("DialogRewardsUIPanel",msgObj.body.drop)--展示获得东西
        para.data.receiveStatus = 1
        DataManager.insertMails({para.data})
        self.panel:setNodeVisible("btn_getin", false)
    end

    function EmailReceiverUIPanel_FriendAction_auditApply(msgObj)
        para.data.mailType = 1
        DataManager.insertMails({para.data})
        self.panel:setNodeVisible("btn_sure", false)
        self.panel:setNodeVisible("btn_refuse", false)
        Tips(LabelChineseStr["EmailReceiverUIPanel_"..cacheApplyType])
    end

    return self.panel
end

--退出
function EmailReceiverUIPanel:Release()
	self.panel:Release()
end

--隐藏
function EmailReceiverUIPanel:Hide()
	self.panel:Hide()
end

--显示
function EmailReceiverUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerTrue()
end