HeadSkillUIPanel = {
panel = nil,
}

function HeadSkillUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

--团长技能显示panel
function HeadSkillUIPanel:Create(para)
    local p_name = "HeadSkillUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	local function OnItemShowCallback(scroll_view,item,data,idx)		
		local systemSkill = DataManager.getSystemSkillId(data.skillId)
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
		self.panel:setItemLabelText(item,"lab_skillCareer",careerStr)
		self.panel:setItemLabelText(item,"lab_skillName",systemSkill.name)
		self.panel:setItemLabelText(item,"lab_skillTimes",systemSkill.cdTime.."S")
		self.panel:setItemLabelText(item,"lab_skillDesc",systemSkill.remark)
        self.panel:setItemLabelText(item,"lab_crystalNum",data.needCrystal)
		
        self.panel:setItemImageTexture(item,"img_skillHead",IconPath.tuanji..systemSkill.imgId..".png")
		
		local userHeroSkill = DataManager.getHeadSkillById(data.systemHeroSkillId)
        local systemHeroSkillConfig = DataManager.getHeadSkillConfigById(data.systemHeroSkillId)
		if userHeroSkill == nil then
            if systemHeroSkillConfig.gold > 0 then
                self.panel:setItemLabelText(item,"lab_unlock_need_jbnum",systemHeroSkillConfig.gold)
                self.panel:setItemImageTexture(item,"img_money",IconPath.tongyong.."i_jingb.png")
            elseif systemHeroSkillConfig.money > 0 then
                self.panel:setItemLabelText(item,"lab_unlock_need_jbnum",systemHeroSkillConfig.money)
                self.panel:setItemImageTexture(item,"img_money",IconPath.tongyong.."i_zuansi.png")
            end
			self.panel:setItemNodeColor(item,"img_crystal")
			self.panel:setItemNodeColor(item,"img_skillHead")
			self.panel:setItemLabelText(item,"lab_skillLevel","Lv.1")
            self.panel:setItemNodeVisible(item,"img_vipBg",systemHeroSkillConfig.vipLevel ~= 0)
			self.panel:setItemImageTexture(item,"img_itemBg",IconPath.tuanchangjineng.."i_jndidahs.png")
			self.panel:setItemImageTexture(item,"img_shuijiao",IconPath.tuanchangjineng.."t_xiaohaosj02.png")
		else
		    self.panel:setItemLabelText(item,"lab_skillLevel","Lv."..userHeroSkill.skillLevel)
		    self.panel:setItemNodeVisible(item,"img_lock",false)
            self.panel:setItemNodeVisible(item,"img_vipBg",false)
            self.panel:setItemNodeVisible(item,"img_jb_bg",false)
		end
	end
	
	local function OnItemClickCallback(item,data)
		self.panel:delayRelease(function() 
			local userHeroSkill = DataManager.getHeadSkillById(data.systemHeroSkillId)
			if userHeroSkill ~= nil then
			    --如果存在 则弹出升级框
			   	LayerManager.show("HeadSkillLearnUIPanel",{systemHeroSkillId=data.systemHeroSkillId})
			else
				local function openLockCallBack()
					local reqLean = HeroAction_studyLeaderSkillReq:New()
					reqLean:setInt_systemHeroSkillId(data.systemHeroSkillId)
					NetReqLua(reqLean,true)
				end
				LayerManager.show("HeadSkillUnLockUIPanel",{systemHeroSkillId=data.systemHeroSkillId,callBack=openLockCallBack})
			end
		end)
	end
	
	local function showUpdatePanel(systemHeroSkillId)

	end
	
	local function refreshHeadSkillInfo()
		local data = DataManager.getHeadHeroSkillList()
		self.panel:InitListView(data,OnItemShowCallback,OnItemClickCallback,nil,nil,2)
		LayerManager.hideWaiting()
	end
	LayerManager.showWaiting() --主要太卡，做一些效果处理
	self.panel:delayRelease(refreshHeadSkillInfo)--做延迟
	
	function HeadSkillUIPanel_HeroAction_studyLeaderSkill()
		refreshHeadSkillInfo()
	end
	
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		elseif 1 == tag then
			LayerManager.show("SystemRulerUIPanel", {id = 2})
		end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_help",btnCallBack,1)
	
	return panel
end

function HeadSkillUIPanel:Release()
	self.panel:Release()
end
function HeadSkillUIPanel:Hide()
	self.panel:Hide()
end
function HeadSkillUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end