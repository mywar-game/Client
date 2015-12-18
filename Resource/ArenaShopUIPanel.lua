ArenaShopUIPanel = {
panel = nil,
}
function ArenaShopUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function ArenaShopUIPanel:Create(para)
    local p_name = "ArenaShopUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
    
	local buyMall = nil
	local pkMallList = nil
	
    --按钮事件
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:setLabelText("lab_honor",DataManager.getUserBO().honour)
	
	local function cacheBuyMoney(extraData)
        spendGold = extraData.price
    end
	
	local function getPkMallList(mallId)
		for k,v in pairs(pkMallList)do
			if v.maillId == mallId then
				return v
			end
		end
		return nil
	end
	
	local function OnItemShowCallback(scroll_view,item,data,idx)
		local buyMall = getPkMallList(data.mallId)
		local systemTool = DataManager.getSystemTool(data.toolId)
		self.panel:setItemLabelText(item,"lab_num",data.needHonour)
		self.panel:setItemLabelText(item,"lab_name",systemTool.name)
	
		self.panel:setItemImageTexture(item,"img_head","res/tool/"..systemTool.imgId..".png")
		self.panel:setItemImageTexture(item,"img_color","common/good_color__"..systemTool.color..".png")
		
		if buyMall then
			if data.dayBuyNum == -1 then
				self.panel:setItemLabelText(item,"lab_buyNum",data.totalBuyNum - buyMall.totalBuyNum)
			else
				self.panel:setItemLabelText(item,"lab_buyNum",data.dayBuyNum - buyMall.dayBuyNum)
			end
		else
			if data.dayBuyNum == -1 then
				self.panel:setItemLabelText(item,"lab_buyNum",data.totalBuyNum)
			else
				self.panel:setItemLabelText(item,"lab_buyNum",data.dayBuyNum)
			end
		end
	end
	
	function ArenaShopUIPanel_PkAction_exchange()
		self.panel:setLabelText("lab_honor",DataManager.getUserBO().honour)
	end
	
	local function OnItemClickCallback(item,data,idx)
		if DataManager.getUserBO().honour >= data.needHonour then
			local exchangeReq = PkAction_exchangeReq:New()
			exchangeReq:setInt_mallId(data.mallId)
			NetReqLua(exchangeReq,true)
		else
			Tips(GameString.honourTips)
		end
	end
	
	function ArenaShopUIPanel_PkAction_getUserPkMallInfo(msgObj)
		pkMallList = msgObj.body.pkMallList
		local systemHonour = DataManager.getSystemHonourExchange()
		self.panel:InitListView(systemHonour,OnItemShowCallback,OnItemClickCallback)
	end
	
	local getUserPkMallInfoReq = PkAction_getUserPkMallInfoReq:New()
	NetReqLua(getUserPkMallInfoReq,true)
	
	return panel
end
--退出
function ArenaShopUIPanel:Release()
	self.panel:Release()
end
--隐藏
function ArenaShopUIPanel:Hide()
	self.panel:Hide()	
end
--显示
function ArenaShopUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end