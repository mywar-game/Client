-------------------------------------------------------------------------
--
-- 文 件 名 : ProfessionDetailUIPanel.lua
-- 创 建 者 ：chenximin
-- 创建时间 ：2015-04-23
-- 功能描述 ：职业详细信息
--
-------------------------------------------------------------------------

ProfessionDetailUIPanel = {}

function ProfessionDetailUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function ProfessionDetailUIPanel:Create(para)
	local p_name = "ProfessionDetailUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)

    local systemConfig = DataManager.getSystemConfig()
    local jobExpMax = systemConfig.user_job_exp_max   --魂能最大值
    local userBo = DataManager.getUserBO()
    local jobExp = userBo.jobExp   --魂能

    local curCareerClearInfoList = {detailedCareerId = para.careerId, level = para.careerLevel}   --职业信息

    local careerAdd = DataManager.getSystemHeroCareerAddById(curCareerClearInfoList.detailedCareerId)
    local careerClear = DataManager.getSystemCareerClearById(curCareerClearInfoList.detailedCareerId)
    local careerInfo = DataManager.getSystemCareerClearInfoById(curCareerClearInfoList.detailedCareerId)

    local function appendCareerAddString(idx, title, value)
        local firstStr = ""
        if idx == 1 then
            firstStr = "一层："
        elseif idx == 2 then
            firstStr = "二层："
        elseif idx == 3 then
            firstStr = "三层："
        elseif idx == 4 then
            firstStr = "四层："
        elseif idx == 5 then
            firstStr = "五层："
        elseif idx == 6 then
            firstStr = "六层："
        elseif idx == 7 then
            firstStr = "七层："
        elseif idx == 8 then
            firstStr = "八层："
        elseif idx == 9 then
            firstStr = "九层："
        elseif idx == 10 then
            firstStr = "十层："
        end

        local secondStr = ""
        if title == "strength" then
            secondStr = "力量+"
        end

        local all = firstStr .. secondStr .. value
        return all
    end

	--职业描述和技能
    local function refreshCareerInfoAndSkill()
        --显示职业描述
        self.panel:setLabelText("lab_title", careerInfo[1].heroDesc)

        --显示技能
        if careerInfo.skill01 ~= 0 then
            --self.panel:setImageTexture(name,path)
        end

        if careerInfo.skill02 ~= 0 then
            --self.panel:setImageTexture(name,path)
        end

        if careerInfo.skill03 ~= 0 then
            --self.panel:setImageTexture(name,path)
        end

        if careerInfo.skill04 ~= 0 then
            --self.panel:setImageTexture(name,path)
        end
    end
    refreshCareerInfoAndSkill()
	
    --显示职业加成
    local function refreshCareerAddLabel()
		for k,v in ipairs(careerAdd) do
			local careerAddTab = Split(v,":")
			local addTitle = careerAddTab[1]
			local addValue = careerAddTab[2]

			self.panel:setLabelText("lab_left_"..k, appendCareerAddString(k, addTitle, addValue))
		end

        if curCareerClearInfoList.level == 0 then
            for i=1,10 do
                local label = self.panel:getChildByName("lab_left_"..i)
                label:setColor(cc.c3b(255, 255, 255))
            end
        end

		for i=1,curCareerClearInfoList.level do
			local label = self.panel:getChildByName("lab_left_"..i)
			label:setColor(cc.c3b(0, 255, 0))
		end
    end
    refreshCareerAddLabel()

    --灌注按钮、进度条和魂能值
    local function refreshBtnInfo()
        --设置灌注按钮
        if curCareerClearInfoList.level ~= 10 then   --不等于10还没解锁
            self.panel:setBtnEnabled("btn_affuse", true)
        else   --10已经解锁
            self.panel:setBtnEnabled("btn_affuse", false)
            Tips("此职业已经解锁")
        end

        if curCareerClearInfoList.level == 0 or curCareerClearInfoList.level == 10 then
            self.panel:setBtnEnabled("btn_goback", false)
        else
            self.panel:setBtnEnabled("btn_goback", true)
        end

        --设置进度条
        self.panel:setProgressBarPercent("pro_jobexp", jobExp*100/jobExpMax)
		
		--设置自己拥有的魂能和需要灌注的魂能
		self.panel:setLabelText("lab_jobexp", jobExp .. "/" .. careerClear.jobExp)
    end
    refreshBtnInfo()

    --请求解锁职业
    local function careerClearReq()
        local reqCareerClear = HeroAction_careerClearReq:New()
        reqCareerClear:setInt_detailedCareerId(curCareerClearInfoList.detailedCareerId)
        NetReqLua(reqCareerClear, true)
    end

    --请求解锁职业回调
    function ProfessionDetailUIPanel_HeroAction_careerClear(msgObj)
        jobExp = msgObj.body.jobExp
        curCareerClearInfoList = msgObj.body.userCareerInfo
		DataManager.getUserBO().jobExp = jobExp

        refreshCareerAddLabel()
        refreshBtnInfo()
    end

    --请求魂能回退
    local function jopExpGobackReq()
        local reqJopExpGoback = HeroAction_returnJobExpReq:New()
        reqJopExpGoback:setInt_detailedCareerId(curCareerClearInfoList.detailedCareerId)
        NetReqLua(reqJopExpGoback, true)
    end

    --请求魂能回退回调
    function ProfessionDetailUIPanel_HeroAction_returnJobExp(msgObj)
        jobExp = msgObj.body.jobExp
        curCareerClearInfoList = msgObj.body.userCareerInfo
        DataManager.getUserBO().jobExp = jobExp
        
        refreshCareerAddLabel()
        refreshBtnInfo()

        cclog("167:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
        cclogtable(msgObj)
        Tips("魂能回退成功")
    end
 
    local function btnCallBack(sender,tag)
        if tag == 0 then   --关闭
            self:Release() 
            LayerManager.show("ProfessionUIPanel")
        elseif tag == 1 then   --魂能灌注
            --魂能达不到需要的1/10
            if jobExp < careerClear.jobExp*0.1 then
                Tips("魂能不足")
            else
                -- local pro = (jobExp-careerClear.jobExp*0.1)/jobExp*100
                -- self.panel:setProgressBarPercent("pro_jobexp", pro)
                careerClearReq()
            end
        elseif tag == 2 then   --魂能回退
            jopExpGobackReq()
        elseif tag == 3 then
            
        elseif tag == 4 then
            
        elseif tag == 5 then

        elseif tag == 6 then
            
            
        end
    end
    self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
    self.panel:addNodeTouchEventListener("btn_affuse",btnCallBack,1)
    self.panel:addNodeTouchEventListener("btn_goback",btnCallBack,2)
    self.panel:addNodeTouchEventListener("btn_skill_1",btnCallBack,3)
    self.panel:addNodeTouchEventListener("btn_skill_2",btnCallBack,4)
    self.panel:addNodeTouchEventListener("btn_skill_3",btnCallBack,5)
    self.panel:addNodeTouchEventListener("btn_skill_4",btnCallBack,6)

    return self.panel
end

--退出
function ProfessionDetailUIPanel:Release()
	self.panel:Release()
end

--隐藏
function ProfessionDetailUIPanel:Hide()
	self.panel:Hide()
end

--显示
function ProfessionDetailUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end