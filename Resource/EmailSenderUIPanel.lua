--发邮件模块
EmailSenderUIPanel = {}
function EmailSenderUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function EmailSenderUIPanel:Create(para)
	local p_name = "EmailSenderUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
	
    local sendName = para.name or ""
    local sendUserId = para.friendId or ""
    local sendContent = ""
    local cacheFriendList = nil--缓存好友列表
	local systemConfig = DataManager.getSystemConfig()
	
    local function editBoxTextEventHandle(strEventName, pSender, name)
        if strEventName == "ended" then
            if name == "edbox_name" then
                sendUserId = ""
                sendName = self.panel:getChildByName("lab_sendname"):getString()
                if string.len(sendName) <= 0 then
                    self.panel:setNodeVisible("lab_nameHint", true)
                else
                    self.panel:setNodeVisible("lab_nameHint", false)
                end
            elseif name == "edbox_detail" then
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
                    (systemConfig.email_char_max-#splitUTF8StrToSingleTab(calStr))..LabelChineseStr.EmailSenderUIPanel_4)
            end
        end
    end
	
    local function createEditBoxs()
        local txtAttr = {
        input={callBack=editBoxTextEventHandle,
                    bindLabel=self.panel:getChildByName("lab_sendname"),
                    max_length=10,
                    lineLen = 10,
                    place_holder="",
                    pic=IconPath.youjian..'i_shangshuru.png',},
        offset={y=0,x=0,},
        name='edbox_name',}
		
	    local edit_name = self.panel:createEditBox(txtAttr)
        edit_name:setAnchorPoint(cc.p(0,0))
        self.panel:getChildByName("img_name"):addChild(edit_name, 0)
        if para.name then--如果有玩家名字就先写上
             sendName = para.name 
             self.panel:setLabelText("lab_sendname", para.name)
             self.panel:setNodeVisible("lab_nameHint", false)
        end
	   
        txtAttr = {
        input={callBack=editBoxTextEventHandle,
                    bindLabel=self.panel:getChildByName("lab_detail"),
                    max_length=systemConfig.email_char_max,
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
            LabelChineseStr.EmailSenderUIPanel_3..systemConfig.email_char_max..LabelChineseStr.EmailSenderUIPanel_4)
    end
    createEditBoxs()
	
    local function OnItemShowCallback(scroll_view, item, data, idx)
        self.panel:setItemLabelText(item,"lab_name", data.name)
        self.panel:setItemLabelText(item,"lab_level", "Lv."..data.level)
        self.panel:setItemImageTexture(item, "img_team", IconUtil.getTeamImgPath(data.camp))
    end
	
    local function OnItemClickCallback(item, data, idx) 
        self.panel:setLabelText("lab_sendname", data.name)
        self.panel:setNodeVisible("lab_nameHint", false)
        sendName = data.name
        sendUserId = data.userId
    end

    local function switchFriendWin(isOpen)
		local x = isOpen and 150 or 0
        local borderSprite = self.panel:getChildByName("img_border")
		borderSprite:runAction(cc.MoveTo:create(0.5,cc.p(x,-15)))
        self.panel:setNodeVisible("img_friends",isOpen)
		
		if isOpen and #cacheFriendList > 0 then
			self.panel:setNodeVisible("lab_nothing", false)
			self.panel:InitListView(cacheFriendList,OnItemShowCallback, OnItemClickCallback)
		end
    end
    switchFriendWin(false)

	function EmailSenderUIPanel_MailAction_sendEmail(msgObj)
		Tips(LabelChineseStr.EmailSenderUIPanel_5)
    end
	
    function EmailSenderUIPanel_FriendAction_getUserFriendList(msgObj)
		cacheFriendList = msgObj.body.userFriendInfoBOList
		switchFriendWin(true)
    end
	
	local function btnCallBack(sender,tag)
		
        if tag == 0 then
            LayerManager.show(para.fromPanel,{idx = para.idx})
        elseif tag == 1 then
            local sendEmailReq = MailAction_sendEmailReq:New()
            sendEmailReq:setString_name(sendName)
            sendEmailReq:setString_toUserId(sendUserId)
            sendEmailReq:setString_content(sendContent)
	        NetReqLua(sendEmailReq, true)
        elseif tag == 2 then
            if not cacheFriendList then
                local userFriendsReq = FriendAction_getUserFriendListReq:New()
                NetReqLua(userFriendsReq, true)
            end
        end
	end
 
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_send",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_chooseFriend",btnCallBack,2)
	
    return self.panel
end

--退出
function EmailSenderUIPanel:Release()
	self.panel:Release()
end

--隐藏
function EmailSenderUIPanel:Hide()
	self.panel:Hide()
end

--显示
function EmailSenderUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerTrue()
end