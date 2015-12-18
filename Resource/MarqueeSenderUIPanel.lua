--发邮件模块
MarqueeSenderUIPanel = {}
function MarqueeSenderUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function MarqueeSenderUIPanel:Create(para)
	local p_name = "MarqueeSenderUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
	
    local sendContent = ""
	local systemConfig = DataManager.getSystemConfig()
	
    local function editBoxTextEventHandle(strEventName, pSender, name)
        if strEventName == "ended" then
            if name == "edbox_detail" then
                sendContent = self.panel:getChildByName("lab_detail"):getString()
                if string.len(sendContent) <= 0 then
                    self.panel:setNodeVisible("lab_detailHint", true)
                else
                    self.panel:setNodeVisible("lab_detailHint", false)
                end
                --刷新一下倒数数字
                local calStr = string.gsub(sendContent, "\n", "")
                self.panel:setLabelText("lab_limitTip", 
                    LabelChineseStr.EmailSenderUIPanel_3..
                    (systemConfig.message_content_max-#splitUTF8StrToSingleTab(calStr))..LabelChineseStr.EmailSenderUIPanel_4)
            end
        end
    end
	
    local function createEditBoxs()
        txtAttr = {
        input={callBack=editBoxTextEventHandle,
                    bindLabel=self.panel:getChildByName("lab_detail"),
                    max_length=systemConfig.message_content_max,
                    lineLen = 13,
                    place_holder="",
                    pic=IconPath.youjian..'i_xiasrk.png',},
        offset={y=0,x=0,},
        name='edbox_detail',}
        local edit_detail = self.panel:createEditBox(txtAttr)
        edit_detail:setAnchorPoint(cc.p(0,0))
        self.panel:getChildByName("img_detail"):addChild(edit_detail, 0)
		 --刷新一下到数数字
        self.panel:setLabelText("lab_limitTip", 
            LabelChineseStr.EmailSenderUIPanel_3..systemConfig.message_content_max..LabelChineseStr.EmailSenderUIPanel_4)
		
    end
    createEditBoxs()

	
	function MarqueeSenderUI_MailAction_sendEmail(msgObj)
		Tips(LabelChineseStr.MarqueeSenderUI_5)
    end
	
	local function btnCallBack(sender,tag)
        if tag == 0 then
            self:Release()
        elseif tag == 1 then
			if string.len(sendContent) > 0 then
				local sendEmailReq = MessageAction_sendMsgReq:New()
				sendEmailReq:setString_content(sendContent)
				NetReqLua(sendEmailReq, true)
			else
				Tips("LabelChineseStr.MarqueeSenderUIPanelTips_1")
			end
        end
	end
	
	function MarqueeSenderUIPanel_MessageAction_sendMsg(msgObj)
		self:Release()
	end
 
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_send",btnCallBack,1)
	
    return self.panel
end

--退出
function MarqueeSenderUIPanel:Release()
	self.panel:Release()
end

--隐藏
function MarqueeSenderUIPanel:Hide()
	self.panel:Hide()
end

--显示
function MarqueeSenderUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end