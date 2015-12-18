require("TaskLibrary")
NpcFunctionUIPanel = {
panel = nil,
}
function NpcFunctionUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--����
function NpcFunctionUIPanel:Create(para)
    local p_name = "NpcFunctionUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	--ҵ���߼���д��
    local systemConfig = DataManager.getSystemConfig()
    local userInfo = DataManager.getUserBO()
	local npcInfo = para.npcInfo
	local npcFunction = Split(npcInfo.npcFunction,",")
	
	local itemParent
	if 0 == tonumber(npcFunction[1]) then
		itemParent = self.panel:getChildByName("img_bg0")
	else
		local npcFunctionNum = #npcFunction
		itemParent = self.panel:getChildByName("img_bg" .. npcFunctionNum)
	end
	
	itemParent:setVisible(true)
	for k,v in pairs(npcFunction) do
		if tonumber(npcFunction[k]) > 0 then
			self.panel:setItemBitmapText(itemParent, "img_func"..k, LabelChineseStr["NpcFunctionUIPanel_"..v])
		end
    end
	self.panel:setLabelText("lab_talkInfo", npcInfo.npcName..":"..npcInfo.npcTalking)
	self.panel:setImageTexture("img_npc", IconPath.npc..npcInfo.imgId..".png")

	local function showNpcFunction(npcFunction)
		if npcFunction == GameField.npcFunction1 then--�ӻ���
			MainMenuUIPanel_openGrocery()
		elseif npcFunction == GameField.npcFunction2 then --�����̵�
		    
		elseif npcFunction == GameField.npcFunction3 then --����վ
            MainMenuUIPanel_openPawnShop()
		elseif npcFunction == GameField.npcFunction4 then --�һ�����
		    
		elseif npcFunction == GameField.npcFunction5 then --����
			if tonumber(systemConfig.equip_forge_open_level) > userInfo.level then
                Tips(systemConfig.equip_forge_open_level..LabelChineseStr.NpcFunctionTip_2)
            else
				MainMenuUIPanel_openForge()
			end
		elseif npcFunction == GameField.npcFunction6 then --����
		    
		elseif npcFunction == GameField.npcFunction7 then --�ƹ�
			MainMenuUIPanel_openPrestige()
		elseif npcFunction == GameField.npcFunction8 then --̽��
		    MainMenuUIPanel_openExplore()
		elseif npcFunction == GameField.npcFunction9 then --�ճ�����
            if tonumber(systemConfig.daily_task_open_level) > userInfo.level then
                Tips(systemConfig.daily_task_open_level..LabelChineseStr.NpcFunctionTip_1)
            else
			    MainMenuUIPanel_openDailyTask()
            end
		elseif npcFunction == GameField.npcFunction10 then --�ֽ�
			if tonumber(systemConfig.equip_forge_open_level) > userInfo.level then
                Tips(systemConfig.equip_forge_open_level..LabelChineseStr.NpcFunctionTip_3)
            else
				MainMenuUIPanel_openResolve()
			end
		elseif npcFunction == GameField.npcFunction11 then --��ħ
		    if tonumber(systemConfig.equip_magic_open_level) > userInfo.level then
                Tips(systemConfig.equip_magic_open_level..LabelChineseStr.NpcFunctionTip_5)
            else
				MainMenuUIPanel_openEnchant()
			end
		elseif npcFunction == GameField.npcFunction12 then --��ʯ����
			if tonumber(systemConfig.gemstone_open_level) > userInfo.level then
                Tips(systemConfig.gemstone_open_level..LabelChineseStr.NpcFunctionTip_4)
            else
				MainMenuUIPanel_openGemSynthesis()
			end
		elseif npcFunction == GameField.npcFunction13 then --��ʯ�ӹ�
			if tonumber(systemConfig.gemstone_open_level) > userInfo.level then
                Tips(systemConfig.gemstone_open_level..LabelChineseStr.NpcFunctionTip_4)
            else
				MainMenuUIPanel_openEquipGem()
			end
		elseif npcFunction == GameField.npcFunction14 then --��ħ�ں�
			if tonumber(systemConfig.equip_magic_open_level) > userInfo.level then
                Tips(systemConfig.equip_magic_open_level..LabelChineseStr.NpcFunctionTip_5)
            else
				MainMenuUIPanel_openEnchantForge()
			end
		elseif npcFunction == GameField.npcFunction15 then --��ħ�ں�
			MainMenuUIPanel_openRepertoryStore()
		end
	end

    local function OnItemShowCallback(scroll_view, item, data, idx)
        self.panel:setItemNodeVisible(item, "img_main", false)
        self.panel:setItemNodeVisible(item, "img_branch", false)
        if data.taskType == 1 then
            self.panel:setItemNodeVisible(item, "img_main", true)
            self.panel:setLabelText("lab_talkInfo", npcInfo.npcName..":"..npcInfo.npcTalking)
        else
            self.panel:setItemNodeVisible(item, "img_branch", true)
        end
        self.panel:setItemLabelText(item, "lab_detail", data.taskName)
        self.panel:addItemNodeTouchEventListener(item, "btn_click",function (sender,tag)
			  UserGuideUIPanel.stepClick( "btn_click_guide" ) 
              LayerManager.show("TaskDetailsUIPanel",{selectTask=data,callback=para.callback}) 
        end)
    end
	
    local function OnItemClickCallback(item, data, idx)
	
    end
	
	--��ʼ�������б�
	local taskList = DataManager.getNpcTaskList(para.curSceneId,npcInfo.systemNpcId)
	if #taskList < 1 then
		self.panel:setNodeVisible("img_bg3")
	end
    self.panel:InitListView(taskList,OnItemShowCallback,OnItemClickCallback)

	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		elseif tag == 1 then  --����������ʱ�򴥷���Ҫ�ص���
			UserGuideUIPanel.stepClick( "btn_func1" ) 
			showNpcFunction(tonumber(npcFunction[1]))	
		elseif tag == 2 then
			showNpcFunction(tonumber(npcFunction[2]))
		elseif tag == 3 then
			showNpcFunction(tonumber(npcFunction[3]))
		end
	end
	local item1 = self.panel:getChildByName("img_bg1")
	local item2 = self.panel:getChildByName("img_bg2")
	local item3 = self.panel:getChildByName("img_bg3")
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addItemNodeTouchEventListener(item1,"btn_func1",btnCallBack,1)
	
	self.panel:addItemNodeTouchEventListener(item2,"btn_func1",btnCallBack,1)
	self.panel:addItemNodeTouchEventListener(item2,"btn_func2",btnCallBack,2)
	
	self.panel:addItemNodeTouchEventListener(item3,"btn_func1",btnCallBack,1)
	self.panel:addItemNodeTouchEventListener(item3,"btn_func2",btnCallBack,2)
	self.panel:addItemNodeTouchEventListener(item3,"btn_func3",btnCallBack,3)
	
	return panel
end
--�˳�
function NpcFunctionUIPanel:Release()
	self.panel:Release()
end
--����
function NpcFunctionUIPanel:Hide()
	self.panel:Hide()
end
--��ʾ
function NpcFunctionUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
