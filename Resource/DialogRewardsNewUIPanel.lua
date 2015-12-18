--消息提示框逻辑
DialogRewardsNewUIPanel = {}
function DialogRewardsNewUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function DialogRewardsNewUIPanel:Create(para)
	local p_name = "DialogRewardsNewUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
    
	local dropData = EquipDetailUtil.showDropData(para.data)
    local function OnItemShowCallback(scroll_view, item, data, idx)
        local img_bkg = self.panel:getItemChildByName(item,"img_bkg")
        local icon = IconUtil.GetIconByIdType(data.goodsType,data.goodsId,data.goodsNum,{})
        icon:setPosition(cc.p(img_bkg:getContentSize().width/2, img_bkg:getContentSize().height/2))
        img_bkg:addChild(icon)
    end
    
	local function OnItemClickCallback(item, data, idx)
    
	end
	
    if #dropData <= 0 then 
        self.panel:setLabelText("label_title", LabelChineseStr.DialogRewardsNewUIPanel_1)
    end
    self.panel:InitListView(dropData, OnItemShowCallback, OnItemClickCallback, nil, nil, 5)
	
	--探索奖励界面所用
	if nil ~= para.titleString then
		self.panel:setLabelText("label_title", para.titleString)
	end
	-------------------------------------------------------------
	
	local function btnCallBack(sender,tag)
	    self:Release(true)
	end
	
	self.panel:addNodeTouchEventListener("btn_sure",btnCallBack,1)
	
    return self.panel
end

--退出
function DialogRewardsNewUIPanel:Release()
	self.panel:Release(true)
end

--隐藏
function DialogRewardsNewUIPanel:Hide()
	self.panel:Hide()
end

--显示
function DialogRewardsNewUIPanel:Show()
	self.panel:Show()
    self.panel:registerScriptTouchHandlerClose()
end