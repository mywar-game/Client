--聊天
ChatUIPanel = {}
function ChatUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function ChatUIPanel:Create(para)
	local p_name = "ChatUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
    local userInfo = DataManager.getUserBO()
	local systemConfig = DataManager.getSystemConfig()
    local sendContent = ""
    local cachePosX = nil--这两个缓存值用于缓存当前界面位置
    local cachePosY = nil
    local cacheFriendList = {}--缓存好友列表
    local cacheSelectIndex =  para and para.index or 1
	
    local cacheFloatMsg = nil--暂存的浮动窗选定聊天信息
    local headStr = nil--头字符
	local function editBoxTextEventHandle(strEventName, pSender, name)
        if strEventName == "ended" then
            sendContent = self.panel:getChildByName("lab_sendContent"):getString()
            if string.len(sendContent) <= 0 then
                self.panel:setNodeVisible("lab_sendContentHint", true)
            else
                self.panel:setNodeVisible("lab_sendContentHint", false)
            end
        end
    end
    local function createEditBox()
        local txtAttr = {
        input={callBack=editBoxTextEventHandle,
                    bindLabel=self.panel:getChildByName("lab_sendContent"),
                    max_length=systemConfig.chat_char_num_max,
                    lineLen = systemConfig.chat_char_num_max,
                    place_holder="",
                    pic=IconPath.liaotian..'i_shurukuang.png',},
        offset={y=0,x=0,},
        name='edbox_name',}
	    local edit_name = self.panel:createEditBox(txtAttr)
        edit_name:setAnchorPoint(cc.p(0,0))
        self.panel:getChildByName("img_content"):addChild(edit_name, 0)
    end
    createEditBox()
    --好友栏
    local function OnFriendItemShowCallback(scroll_view, item, data, idx)
        self.panel:setItemLabelText(item,"lab_name", data.name)
        self.panel:setItemLabelText(item,"lab_level", "Lv."..data.level)
        self.panel:setItemImageTexture(item, "img_team", IconUtil.getTeamImgPath(data.camp))
    end
    local function OnFriendItemClickCallback(item, data, idx)
        self.panel:setLabelText("lab_tips", data.name)
        cachePrivateUID = data.userId
        cachePrivateName = data.name
    end
	
    local function switchFriendWin(isOpen)		
		local x = isOpen and 130 or 0
        local borderSprite = self.panel:getChildByName("big_box")
		borderSprite:runAction(cc.MoveTo:create(0.5,cc.p(x,-13)))
        self.panel:setNodeVisible("img_friends",isOpen)
		
		if isOpen and #cacheFriendList > 0 then
			self.panel:setNodeVisible("lab_nothing", false)
			self.panel:InitListView(cacheFriendList, OnFriendItemShowCallback, OnFriendItemClickCallback, "ListView_friend", "ListItem_friend", nil, nil, 1)
		end
    end

    local function OnMsgItemShowCallback(scroll_view, item, data, idx)
        local lab_name = self.panel:getItemChildByName(item, "lab_name")
		local lab_content = self.panel:getItemChildByName(item, "lab_content")		
        local color = DataManager.getChatMsgColor(cacheSelectIndex)
        if data.type ~= 4 then--非私聊
            self.panel:setItemLabelText(item, "lab_name", string.format("[%s]%s:",headStr,data.userName), color[1])
        else--私聊
           if data.userId ~= userInfo.userId then--别人对我说
                self.panel:setItemLabelText(item, "lab_name", data.userName, color[1])
            else--我对别人说
                self.panel:setItemLabelText(item, "lab_name", data.targetUserName, color[1])
            end
        end
        self.panel:setItemLabelText(item, "lab_content", data.content, color[2])
        lab_content:setPositionX(lab_name:getPositionX()+lab_name:getContentSize().width)

    end
    local function OnMsgItemClickCallback(item, data, idx)
        --只有发送者不是自己的才弹出
        if userInfo.userId ~= data.userId then
            self.panel:setNodeVisible("node_floatwin", true)
            cacheFloatMsg = data
        end
    end
    local function reFreshMessage()
        local cacheMessages = DataManager.getChatMsg(cacheSelectIndex)
        self.panel:InitListView(cacheMessages, OnMsgItemShowCallback, OnMsgItemClickCallback, "ListView_content", "ListItem_content")
    end
    local function reFreshUI()
        self.panel:setNodeVisible("node_floatwin", false)
        self.panel:setLabelText("lab_sendContent", "")
        self.panel:setNodeVisible("lab_sendContentHint", true)
        cachePrivateUID = ""
        cachePrivateName = ""
        reFreshMessage()
    end
    
    local function switchTab(selectIndex)
        cacheSelectIndex = selectIndex
        --还原
        self.panel:setBtnEnabled("btn_1", true)
        self.panel:setBtnEnabled("btn_2", true)
        self.panel:setBtnEnabled("btn_3", true)
        self.panel:setBtnEnabled("btn_4", true)
		self.panel:setBtnEnabled("btn_5", true)
        --选定
        self.panel:setBtnEnabled("btn_"..selectIndex, false)
        switchFriendWin(false)
        if selectIndex == 1 then--世界
            headStr = LabelChineseStr.ChatUIPanel_1
            self.panel:setLabelText("lab_tips", LabelChineseStr.ChatUIPanel_1)
        elseif selectIndex == 2 then--阵营
            if userInfo.camp == GameField.Camp_Alliance then--联盟
                 headStr = LabelChineseStr.ChatUIPanel_11
                 self.panel:setLabelText("lab_tips", LabelChineseStr.ChatUIPanel_11)
            else
                 headStr = LabelChineseStr.ChatUIPanel_2
                 self.panel:setLabelText("lab_tips", LabelChineseStr.ChatUIPanel_2)				 
            end
        elseif selectIndex == 3 then--公会
            headStr = LabelChineseStr.ChatUIPanel_3
            self.panel:setLabelText("lab_tips", LabelChineseStr.ChatUIPanel_3)
        elseif selectIndex == 4 then--私聊频道
            headStr = LabelChineseStr.ChatUIPanel_4
            self.panel:setLabelText("lab_tips", LabelChineseStr.ChatUIPanel_4)
            if #cacheFriendList > 0 then
                switchFriendWin(true)
            else
                local userFriendsReq = FriendAction_getUserFriendListReq:New()
                NetReqLua(userFriendsReq, true)
            end
		elseif selectIndex == 5 then--附近频道
            headStr = LabelChineseStr.ChatUIPanel_0
            self.panel:setLabelText("lab_tips", LabelChineseStr.ChatUIPanel_0)
        end
        reFreshUI()
    end
    switchTab(cacheSelectIndex)
	cachePrivateUID =  para and para.friendId or ""--私聊ID
    cachePrivateName =  para and para.friendName or ""--私聊名字
	if nil ~= cachePrivateName and "" ~= cachePrivateName  and nil ~= cachePrivateUID and "" ~= cachePrivateUID then
		self.panel:setLabelText("lab_tips", cachePrivateName)
	end
    local function sendMessage()
        local sendContent = self.panel:getChildByName("lab_sendContent"):getString()
        if not sendContent or sendContent == "" then
            Tips(LabelChineseStr.ChatUIPanel_5)
            return
        elseif cacheSelectIndex == 4 and 
                 "" == cachePrivateUID and 
                 "" == cachePrivateName then
            Tips(LabelChineseStr.ChatUIPanel_6)
            return
        end
        if cacheSelectIndex == 1 then
            local worldChatReq = ChatAction_worldOfChatReq:New()
            worldChatReq:setString_content(sendContent)
            NetReqLua(worldChatReq, true)
        elseif cacheSelectIndex == 2 then
            local campOfChatReq = ChatAction_campOfChatReq:New()
            campOfChatReq:setString_content(sendContent)
            NetReqLua(campOfChatReq, true)
        elseif cacheSelectIndex == 3 then
            Tips(LabelChineseStr.ChatUIPanel_7)
        elseif cacheSelectIndex == 4 then
            local privateOfChatReq = ChatAction_privateOfChatReq:New()
            privateOfChatReq:setString_content(sendContent)
            privateOfChatReq:setString_toUserId(cachePrivateUID)
            privateOfChatReq:setString_userName(cachePrivateName)
            NetReqLua(privateOfChatReq, true)
		elseif cacheSelectIndex == 5 then
            local nearbyChatReq = ChatAction_nearbyOfChatReq:New()
            nearbyChatReq:setString_content(sendContent)
            NetReqLua(nearbyChatReq, true)
        end
    end
	local function btnCallBack(sender,tag)
	    
        if tag == "btn_close" then
	    	self:Release() 
        elseif tag == "btn_1" then
            switchTab(1)
        elseif tag == "btn_2" then
            switchTab(2)
        elseif tag == "btn_3" then
            switchTab(3)
        elseif tag == "btn_4" then
            switchTab(4)
		elseif tag == "btn_5" then
            switchTab(5)
        elseif tag == "btn_send" then
            sendMessage()
        elseif tag == "node_floatwin" then--以下按钮均操作cacheFloatMsg
           self.panel:setNodeVisible("node_floatwin", false)
        elseif tag == "btn_addFriend" then--添加好友
           local applyFriendReq = FriendAction_applyFriendReq:New()
           applyFriendReq:setString_targetUserId(cacheFloatMsg.userId)
           applyFriendReq:setString_name(cacheFloatMsg.userName)
		   NetReqLua(applyFriendReq, true)
           self.panel:setNodeVisible("node_floatwin", false)
        elseif tag == "btn_privateChat" then--转私聊
            if cacheSelectIndex ~= 4 then
                switchTab(4)
            end
            cachePrivateUID = cacheFloatMsg.userId
            cachePrivateName = cacheFloatMsg.userName
            self.panel:setLabelText("lab_tips", cachePrivateName)
            self.panel:setNodeVisible("node_floatwin", false)
        elseif tag == "btn_team" then--查看阵营
            self.panel:setNodeVisible("node_floatwin", false)

        elseif tag == "btn_addBlack" then--拉黑
            local addBlackReq = FriendAction_addBlackReq:New()
            addBlackReq:setString_targetUserId(cacheFloatMsg.userId)
			NetReqLua(addBlackReq, true)
            self.panel:setNodeVisible("node_floatwin", false)
        elseif tag == "btn_leaveMessage" then--发送email
            LayerManager.show("EmailSenderUIPanel", {name=cacheFloatMsg.userName, fromPanel="ChatUIPanel"})
            self.panel:setNodeVisible("node_floatwin", false)
        end
	end
	self.panel:addNodeTouchEventListener("btn_close",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_1",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_2",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_3",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_4",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_5",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_send",btnCallBack)
	self.panel:addNodeTouchEventListener("node_floatwin",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_addFriend",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_privateChat",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_team",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_addBlack",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_leaveMessage",btnCallBack)
    --获取好友列表
    function ChatUIPanel_FriendAction_getUserFriendList(msgObj)
        cacheFriendList = msgObj.body.userFriendInfoBOList
        switchFriendWin(true)
    end
    --世界消息返回
   --[[ function ChatUIPanel_ChatAction_worldOfChat(msgObj)
        reFreshMessage()
    end
    --阵营消息
     function ChatUIPanel_ChatAction_campOfChat(msgObj)
        reFreshMessage()
     end
    --私聊
     function ChatUIPanel_ChatAction_privateOfChat(msgObj)
        reFreshMessage()
     end--]]
    --聊天推送消息
    function ChatUIPanel_Chat_pushChatInfo(msgObj)
        reFreshMessage()
    end
    --申请好友
    function ChatUIPanel_FriendAction_applyFriend(msgObj)
        Tips(LabelChineseStr.FriendUIPanel_4)
    end
    --加入黑名单
    function ChatUIPanel_FriendAction_addBlack(msgObj)
        Tips(LabelChineseStr.FriendUIPanel_5)
    end
    return self.panel
end

--退出
function ChatUIPanel:Release()
	self.panel:Release()
end

--隐藏
function ChatUIPanel:Hide()
	self.panel:Hide()
end

--显示
function ChatUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end