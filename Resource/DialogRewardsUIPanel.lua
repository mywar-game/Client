--消息提示框逻辑
DialogRewardsUIPanel = {}
function DialogRewardsUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function DialogRewardsUIPanel:Create(para)
	local p_name = "DialogRewardsUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
	
	local dropData = EquipDetailUtil.showDropData(para)
    local function OnItemShowCallback(scroll_view, item, data, idx)
        local img_bkg = self.panel:getItemChildByName(item,"img_bkg")
        local icon = IconUtil.GetIconByIdType(data.goodsType,data.goodsId,data.goodsNum,{})
        icon:setPosition(cc.p(img_bkg:getContentSize().width/2, img_bkg:getContentSize().height/2))
        img_bkg:addChild(icon)
    end
    
	local function OnItemClickCallback(item, data, idx)
    
	end
	
    if #dropData <= 0 then 
        self.panel:setNodeVisible("lab_nothing", true)
    end
    self.panel:InitListView(dropData, OnItemShowCallback, OnItemClickCallback, nil, nil, 5)

	local function btnCallBack(sender,tag)
	    self:Release(true)
	end
	
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_sure",btnCallBack,1)
	
    return self.panel
end

--退出
function DialogRewardsUIPanel:Release()
	self.panel:Release(true)
end

--隐藏
function DialogRewardsUIPanel:Hide()
	self.panel:Hide()
end

--显示
function DialogRewardsUIPanel:Show()
	self.panel:Show()
    self.panel:registerScriptTouchHandlerClose()
end