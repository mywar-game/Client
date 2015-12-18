NotescontactUIPanel = {
panel = nil,
}

function NotescontactUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

--创建
function NotescontactUIPanel:Create(para)
    local p_name = "NotescontactUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	--init ui
	self.panel:setNodeVisible("ListView", false)
	self.panel:setNodeVisible("ListItem", false)
	
	--要发送的标题和内容
	local edit_detail 		-- 意见内容输入框
	local sendTitle = nil
	local sendContent = nil
	local sysConfig = DataManager.getSystemConfig()
	local listViewBgSprite = self.panel:getChildByName("img_listBg")
	listViewBgSprite:setVisible(false)
	local initPosition = cc.p(127, 280)
	local okPosition = {cc.p(127, 250), cc.p(127, 220), cc.p(127, 190), cc.p(127, 160), cc.p(127, 130)}
	
	local listData = {}
	--local selectItem = {}
	for k = 1, 5 do 
		table.insert(listData, {title = LabelChineseStr["NotescontactUIPanelTitles_" .. k]})
	end
	local lab_items = {}
	local lab_template = self.panel:getChildByName("btn_tmp")
	lab_template:setVisible(false)
	
	local function OnItemClickCallback(item, data, idx)
		self.panel:setLabelText("lab_title", data.title)
		listViewBgSprite:setVisible(false)
		edit_detail:setVisible(true)	-- 设置内容输入框是否显示
		sendTitle = data.title
    end
	
	for k, v in pairs(listData) do 
		local item = lab_template:clone()
		lab_template:getParent():addChild(item)
		cclog(v.title)
		item:getChildByName("lab_content"):setString(v.title)
		item:addTouchEventListener(function(sender,eventType)
			if eventType == ccui.TouchEventType.ended then
				--SoundEffect.playSoundEffect("button")
				OnItemClickCallback(item, v ,k)
			end
	   end)
		table.insert(lab_items, item)
	end
	
	local function editBoxTextEventHandle(strEventName, pSender, name)
        if strEventName == "ended" then
            if name == "edbox_content" then
                sendContent = self.panel:getChildByName("lab_contenthint"):getString()
                if string.len(sendContent) <= 0 then
                    self.panel:setNodeVisible("lab_content", true)
                else
                    self.panel:setNodeVisible("lab_content", false)
                end
            end
        end
    end
	
    local function createEditBox()  
        txtAttr = {
        input={callBack=editBoxTextEventHandle,
                    bindLabel=self.panel:getChildByName("lab_contenthint"),
                    max_length = tonumber( sysConfig.advice_content_limit),
                    lineLen = 20,
                    place_holder="",
                    pic='NewUi/xinqietu/yijianfankui/i_srnrong.png',},
        offset={y=0,x=0,},
        name='edbox_content',}
        edit_detail = self.panel:createEditBox(txtAttr)
        edit_detail:setAnchorPoint(cc.p(0,0))
        self.panel:getChildByName("img_content"):addChild(edit_detail, -1)
    end
    createEditBox()
	
	local function showTitle(flag)
		if not flag then
			listViewBgSprite:setVisible(true)
			for k, v in pairs(lab_items) do
				v:setPosition(initPosition)
				v:setVisible(false)
				v:runAction(cc.Sequence:create(cc.DelayTime:create((5 - k) * 0.2), cc.Show:create(), cc.MoveTo:create(0.2, okPosition[k])))
			end
		else
			for k, v in pairs(lab_items) do
				v:setPosition(okPosition[k])
				v:setVisible(true)
				v:runAction(cc.Sequence:create(cc.DelayTime:create((k - 1)*0.2), cc.MoveTo:create(0.2, initPosition), cc.Hide:create(),
				cc.CallFunc:create(function() if k == 5 then listViewBgSprite:setVisible(false) end end)))
			end
		end
	end
	
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		elseif tag == 1 then
			if  sendTitle ~= nil and sendContent ~= nil then
				if string.len(tostring(sendTitle)) == 0 or string.len(tostring(sendContent)) == 0 then
					LayerManager.showDialog(LabelChineseStr.NotescontactUIPanel_1)
					return false
				end
				--发送数据
				local req = SettingAction_commitAdviceReq:New()
				req:init()
				req:setString_title( sendTitle )
				req:setString_content( sendContent )		
				NetReqLua( req , true) 							
			else	
				LayerManager.showDialog(LabelChineseStr.NotescontactUIPanel_1)	
			end 
		elseif tag == 2 then
			local listVisble = listViewBgSprite:isVisible()
			edit_detail:setVisible(listVisble)	-- 设置内容输入框是否显示
			for k, v in pairs(lab_items) do
				v:stopAllActions()
			end
			showTitle(listVisble)
		end
		
    end
	
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_commit",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_xiala",btnCallBack,2)

	return panel
end

function NotescontactUIPanel_SettingAction_commitAdvice(msgObj)
	LayerManager.showDialog(LabelChineseStr.NotescontactUIPanel_2)	
end	


--退出
function NotescontactUIPanel:Release()
	self.panel:Release(true)
end
--隐藏
function NotescontactUIPanel:Hide()
	self.panel:Hide()	
end
--显示
function NotescontactUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
