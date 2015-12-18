SignSystemUIPanel = {
panel = nil,
}
function SignSystemUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--����
function SignSystemUIPanel:Create(para)
    local p_name = "SignSystemUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
    
	--{day, status}
	local activetyInfo = {}
	local activetyDay
	local activetyStatus
	local userBo = DataManager.getUserBO()
	local currentListItem
	
	local function OnItemShowCallback(scroll_view,item,data,idx)
		--��ӽ�����ʾ
		local iconSprite = IconUtil.GetIconByIdType(data.toolType , data.toolId, data.toolNum, {touchCallBack=nil})
		local bgSprite = self.panel:getItemChildByName(item, "img_di")
		local size = bgSprite:getContentSize()
		iconSprite:setPosition(cc.p(size.width/2,size.height/2))
		bgSprite:addChild(iconSprite)
		
		self.panel:setItemVisable(item, "lab_date", true)
		self.panel:setItemBitmapText(item, "lab_date", LabelChineseStr.SignSystemUIPanelLab_1 .. tostring(idx) .. LabelChineseStr.SignSystemUIPanelLab_2)
		if idx < activetyDay then
			self.panel:setItemVisable(item, "img_mc", true)
			self.panel:setItemVisable(item, "img_sign", true)	
		elseif idx == activetyDay then
			currentListItem = item
			if 1 == activetyStatus then
				self.panel:setItemVisable(item, "img_sign", true)
				self.panel:setItemVisable(item, "img_mc", true)
				self.panel:setItemVisable(item, "img_select", false)
			else
				self.panel:setItemVisable(item, "img_sign", false)
				self.panel:setItemVisable(item, "img_mc", false)
				self.panel:setItemVisable(item, "img_select", true)	
			end
		else
			self.panel:setItemVisable(item, "img_sign", false)	
		end
		
		if data.vipLevel > 0 then
			self.panel:setItemVisable(item, "img_vip", true)
			self.panel:setItemBitmapText(item, "lab_vip", "v" .. data.vipLevel)
		end
	end
	
	local function OnItemClickCallback(item,data,idx)
	end
	
	--����ǩ����ȡ����
	local function receiveLoginReward30Req()
        local req = ActivityAction_receiveLoginReward30Req:New()
		req:setInt_day(activetyDay)
        NetReqLua(req, true)
	end
	
	--��Ӧǩ����ȡ����
	function SignSystemUIPanel_ActivityAction_receiveLoginReward30(msgObj)
		self.panel:setBtnEnabled("btn_recieve", false)
		if nil ~= currentListItem then
			self.panel:setItemVisable(currentListItem, "img_sign", true)
			self.panel:setItemVisable(currentListItem, "img_mc", true)
			self.panel:setItemVisable(currentListItem, "img_select", false)
		end
		LayerManager.show("DialogRewardsUIPanel", msgObj.body.drop, true)--չʾ��ö���
	end
	
	local function initUI(msgObj)
		local count = 1
		for k, v in pairs(msgObj.body.userLoginRewardList) do
			if v.day == #msgObj.body.userLoginRewardList then
				count = k
			end
			table.insert(activetyInfo, v)
		end
		activetyDay = activetyInfo[count].day
		activetyStatus = activetyInfo[count].status
		if nil == activetyDay or nil == activetyStatus then
			cclog("activetyInfo ����û��û������ѽ")
			return 
		end
		--ǩ�������Ѿ���ȡ
		if 1 == activetyStatus then
			self.panel:setBtnEnabled("btn_recieve", false)
		end
		
		--��ʾ����
		local sysRewards = DataManager.getSystemLoginReward30()
		
		--������ʱ���л�ȡ�� �� �·�
		local function systemMilliSecondToMonth()
			local seconds = DataManager.getServerSystemTimeAtStart()
			local timeStr = os.date("%Y:%m", seconds/1000)
			local timeTable = Split(timeStr, ":")
			return tonumber(timeTable[1]), tonumber(timeTable[2])
		end
		
		local year, month = systemMilliSecondToMonth()
		local days = {31,28,31,30,31,30,31,31,30,31,30,31}
		if (year%4 == 0 and year%100 ~= 0) or (year%400 ==0 ) then	-- ���� 2��������1
			days[2] = days[2] + 1
		end
		local showData = {}
		for i = 1, days[month] do
			table.insert(showData, sysRewards[i])
		end
		self.panel:InitListView(showData,OnItemShowCallback,OnItemClickCallback, nil, nil, 7)
	end
	initUI(para.msgObj)
	
	--��ť�¼�
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		elseif 1 == tag then
			receiveLoginReward30Req()
		end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_recieve",btnCallBack,1)
	
	return panel
end
--�˳�
function SignSystemUIPanel:Release()
	self.panel:Release()
end
--����
function SignSystemUIPanel:Hide()
	self.panel:Hide()	
end
--��ʾ
function SignSystemUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end