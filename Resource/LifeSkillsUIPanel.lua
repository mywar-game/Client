--�����������

LifeSkillsUIPanel = {
}

function LifeSkillsUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

--����
function LifeSkillsUIPanel:Create(para)
    local p_name = "LifeSkillsUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	local dataObj
    local leftData--�̶��ǵ�������еĻ�
    local rightData--����ʣ�µ�����еĻ�
	local imgLeftCD = self.panel:getChildByName("img_leftCD")
	local imgRightCD = self.panel:getChildByName("img_rightCD")
	local labLeftCD = self.panel:getChildByName("lab_leftTimes")
	local labRightCD = self.panel:getChildByName("lab_rightTimes")
		
	local function updataData()
		for k,v in pairs(dataObj) do
		    --��������� �������ұ�
			if v.category == 1 or v.category == 2 then
				if rightData == nil then
					rightData = v
				elseif v.status ~= 0 then
					rightData = v
				end
			elseif v.category == 3 then
				leftData = v
			end
		end
		
		if leftData.status == 1 or leftData.status == 2 then
			self.panel:setNodeVisible("img_leftAdd",false)
			self.panel:setImageTexture("img_leftTitle",IconPath.shenghuojineng.."t_diaoyu.png")
			self.panel:setBtnImage("btn_left",IconPath.shenghuojineng.."i_dyucg.png",IconPath.shenghuojineng.."i_dyucg.png")
		end
		
		if rightData.status == 1 or rightData.status == 2 then
			self.panel:setNodeVisible("btn_reset",true)
			if rightData.category == 1 then
				self.panel:setNodeVisible("img_rightAdd",false)
				self.panel:setImageTexture("img_rightTitle",IconPath.shenghuojineng.."t_wakuang.png")
				self.panel:setBtnImage("btn_right",IconPath.shenghuojineng.."i_wakcg.png",IconPath.shenghuojineng.."i_wakcg.png")
			else
				self.panel:setNodeVisible("img_rightAdd",false)
				self.panel:setImageTexture("img_rightTitle",IconPath.shenghuojineng.."t_huapu.png")
				self.panel:setBtnImage("btn_right",IconPath.shenghuojineng.."i_wakcg.png",IconPath.shenghuojineng.."i_wakcg.png")
			end
		end
		
		if leftData.status == 2 or rightData.status == 2 then
			local function frameScriptFunc()
				if leftData.status == 2 then
					imgLeftCD:setVisible(true)
					leftData.remainderTime = leftData.remainderTime - 1000
					if leftData.remainderTime > 0 then
						labLeftCD:setString(Utils.remainTimeToStringHHMMSS(leftData.remainderTime))
					else
						labLeftCD:setString(LabelChineseStr.LifeSkillsUIPanel_5)
					end
				end
				
				if rightData.status == 2 then
					imgRightCD:setVisible(true)
					rightData.remainderTime = rightData.remainderTime - 1000
					if rightData.remainderTime > 0 then
						labRightCD:setString(Utils.remainTimeToStringHHMMSS(rightData.remainderTime))
					else
						labRightCD:setString(LabelChineseStr.LifeSkillsUIPanel_5)
					end
				end
			end
			
			frameScriptFunc()
			self:StopSchedule()
			self.schedule = self.panel:scheduleScriptFunc(frameScriptFunc,1)
		end
	end 

	function LifeSkillsUIPanel_LifeAction_getUserLifeInfo(msgObj)
        dataObj = msgObj.body.userLifeInfoBOList
	    updataData()
	end
	
    function LifeSkillsUIPanel_LifeAction_createLifeBuilder(msgObj)
        dataObj = {msgObj.body.userLifeInfoBO}
	    updataData()
    end

    function LifeSkillsUIPanel_LifeAction_reCreateLifeBuilder(msgObj)
        dataObj = {msgObj.body.userLifeInfoBO}
	    updataData()
    end
	
	local function showBuildLife(tag)
		local payType = DataManager.getUserBO()
		local lifeConfig = DataManager.getLifeConfig(tag)
		local msg = LabelChineseStr.LifeSkillsUIPanel_4
		if lifeConfig.money > 0 then 
			msg = msg..LabelChineseStr.common_zuanshi..":"..lifeConfig.money.." " 
		end
		
		if lifeConfig.gold > 0 then 
			msg = msg..LabelChineseStr.common_jinbi..":"..lifeConfig.gold 
		end
		
		LayerManager.showDialog(msg, function()
			local createReq = LifeAction_createLifeBuilderReq:New()
			createReq:setInt_category(tag)
			NetReqLua(createReq,true)
		end)
	end
	
	--����
	local function resetBuildLife(tag)
		local leaveDataConfig = DataManager.getLifeConfig(tag)
		local msg = LabelChineseStr.LifeSkillsUIPanel_4
		if leaveDataConfig.money > 0 then 
			msg = msg..LabelChineseStr.common_zuanshi..":"..leaveDataConfig.money.." " 
		end
		
		if leaveDataConfig.gold > 0 then 
			msg = msg..LabelChineseStr.common_jinbi..":"..leaveDataConfig.gold 
		end
		
		LayerManager.showDialog(msg,function()
			local reBuilderReq = LifeAction_reCreateLifeBuilderReq:New()
			reBuilderReq:setInt_category(tag)
			NetReqLua(reBuilderReq, true)
		end)
	end
    
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		elseif tag == 1 then
			--��������˵��
			local node = self.panel:getChildByName("img_left")
			local visible = node:isVisible()
			local x = visible and 0 or 110
			local moveTo = cc.MoveTo:create(0.5,cc.p(x,-24))
			self.panel:setNodeVisible("img_left",not visible)
			self.panel:getChildByName("img_border"):runAction(moveTo)
		elseif tag == 2 then--�ؽ� �����ұߵ�
		    if rightData.status == 1 then--δ�һ������ؽ�
				LayerManager.show("LifeSkillsChangeUIPanel",{callBack=resetBuildLife})
            elseif rightData.status == 2 then--�һ�״̬�������ؽ�
                Tips(LabelChineseStr.LifeSkillsUIPanel_3)
            else
                Tips(LabelChineseStr.LifeSkillsUIPanel_2)
            end
		elseif tag == 3 then
			if leftData.status == 0 then
				showBuildLife(3)
			else
				LayerManager.show("LifeSkillsSetUIPanel",leftData)
            end
		elseif tag == 4 then
			if rightData.status == 0 then
				LayerManager.show("LifeSkillsChangeUIPanel",{callBack=showBuildLife})
			else
			    LayerManager.show("LifeSkillsSetUIPanel",rightData)
            end
		end
	end
	
    self.panel:setLabelText("lab_content",LabelChineseStr.LifeSkillsUIPanel_rule)
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_guize",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_reset",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_left",btnCallBack,3)
	self.panel:addNodeTouchEventListener("btn_right",btnCallBack,4)
	
	--���ͻ�ȡ�û��������Ϣ
    local function requestUserLifeInfo()
        local lifereq = LifeAction_getUserLifeInfoReq:New()
	    NetReqLua(lifereq,true)
    end
	requestUserLifeInfo()
	
	return panel
end

function LifeSkillsUIPanel:StopSchedule()
	if self.schedule then
		self.panel:unscheduleScriptEntry(self.schedule)
		self.schedule = nil
	end
end

--�˳�
function LifeSkillsUIPanel:Release()
	self:StopSchedule()
	self.panel:Release()
end
--����
function LifeSkillsUIPanel:Hide()
	self.panel:Hide()	
end
--��ʾ
function LifeSkillsUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
