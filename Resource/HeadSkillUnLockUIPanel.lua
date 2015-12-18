HeadSkillUnLockUIPanel = {
panel = nil,
}

function HeadSkillUnLockUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

--团长技能显示panel
function HeadSkillUnLockUIPanel:Create(para)
    local p_name = "HeadSkillUnLockUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
    
	local systemHeroSkillId = para.systemHeroSkillId
    local systemHeroSkill = DataManager.getSystemHeroSkillId(systemHeroSkillId,1)
    local systemSkill = DataManager.getSystemSkillId(systemHeroSkill.skillId)
    local systemHeroSkillConfig = DataManager.getHeadSkillConfigById(systemHeroSkillId)
    
	--设置元素内容
	local needCareerList = Split(systemSkill.needCareer,",")
	local careerStr = ""
	for k,v in pairs(needCareerList)do
		if 0 == tonumber(v) then
			careerStr = GameString.careerIdAllToStr
		else
			if k == #needCareerList then
				careerStr = careerStr..GameString.careerId1ToStr[tonumber(v)]
			else
				careerStr = careerStr..GameString.careerId1ToStr[tonumber(v)]..GameString.huozhe
			end
		end
	end
	
    local item = self.panel.studioUI
    self.panel:setItemLabelText(item,"lab_js_name",systemSkill.name)
    self.panel:setItemLabelText(item,"lab_js_career",careerStr)
    self.panel:setItemLabelText(item,"lab_js_cd_t",systemSkill.cdTime.."S")
    self.panel:setItemLabelText(item,"lab_js_desc",systemSkill.remark)
    self.panel:setItemLabelText(item,"lab_js_shuijing",systemSkill.expend)
    self.panel:setItemImageTexture(item,"img_js_skillhead","res/team_skill/"..systemSkill.imgId..".png")
    self.panel:setItemLabelText(item,"lab_js_yq","VIP"..systemHeroSkillConfig.vipLevel)
   
   if systemHeroSkillConfig.gold>0 then
        self.panel:setItemLabelText(item,"lab_js_need_gold",systemHeroSkillConfig.gold)
        self.panel:setNodeVisible("img_money",false)
    elseif systemHeroSkillConfig.money>0 then
        self.panel:setItemLabelText(item,"lab_js_need_gold_t","所需钻石:")
        self.panel:setNodeVisible("img_gold",false)
        self.panel:setItemLabelText(item,"lab_js_need_gold",systemHeroSkillConfig.money) 
    else
        self.panel:setNodeVisible("img_money",false)
        self.panel:setNodeVisible("img_gold",false)
        self.panel:setNodeVisible("lab_js_need_gold",false)
    end
    self.panel:setItemLabelText(item,"lab_js_needteamlevel","LV"..systemHeroSkillConfig.level)
    self.panel:setItemLabelText(item,"lab_js_lv","Lv.1")
		
	local function btnCallBack(sender,tag)
		if tag == 1 then
			para.callBack()
		end
		self:Release()
	end

    self.panel:addNodeTouchEventListener("btn_js_close",btnCallBack,0)
    self.panel:addNodeTouchEventListener("btn_qrjs",btnCallBack,1)
	return panel
end

function HeadSkillUnLockUIPanel:Release()
    self.panel:Release(true)
end

function HeadSkillUnLockUIPanel:Hide()
	self.panel:Hide()
end

function HeadSkillUnLockUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
