HeroInfoDetailUIPanel = {
panel = nil,
}

function HeroInfoDetailUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

--����
function HeroInfoDetailUIPanel:Create(para)
    local p_name = "HeroInfoDetailUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)	
	
	local hero = para.data
	local img_bkg = self.panel:getChildByName("img_heroHead")
	local heroIcon = IconUtil.createHeroIcon(hero, true)
	heroIcon:setPosition(cc.p(img_bkg:getContentSize().width/2, img_bkg:getContentSize().height/2))
	img_bkg:addChild(heroIcon, 5)
	
	self.panel:setImageTexture("img_bg", IconPath.tansuo .. "i_tcbg_" .. hero.heroColor .. ".png")
	
	local heroAttribute = DataManager.getSystemHeroAttributeId(hero.systemHeroId,1)
    self.panel:setLabelText("lab_strengthNum", math.ceil(heroAttribute.strength))
    -- ����
    self.panel:setLabelText("lab_agileNum", math.ceil(heroAttribute.agile))
    -- ����
    self.panel:setLabelText("lab_staminaNum", math.ceil(heroAttribute.stamina))
    -- ����
    self.panel:setLabelText("lab_intelligenceNum", math.ceil(heroAttribute.intelligence))
    -- �ǻ�
	--�μ�����
	self.panel:setLabelText("lab_gj",math.ceil(heroAttribute.attackPower))
	self.panel:setLabelText("lab_fs",math.ceil(heroAttribute.magicPower))
	self.panel:setLabelText("lab_bj",heroAttribute.phyCrit)
	self.panel:setLabelText("lab_hj",heroAttribute.armor)
	self.panel:setLabelText("lab_ds",heroAttribute.dodge)
	self.panel:setLabelText("lab_gd",heroAttribute.parry)
	
	local hp = math.ceil(heroAttribute.hp)
	self.panel:setLabelText("lab_lifeNum",  hp .. "/" .. hp)
	self.panel:setImageTexture("img_heroCareer", "career/car_" .. hero.careerId .. ".png")
	self.panel:setLabelText("lab_name",  hero.heroName)
	self.panel:setLabelText("lab_level",  "lv." .. 1)
	
	return panel
end

--�˳�
function HeroInfoDetailUIPanel:Release()
	self.panel:Release()
end
--����
function HeroInfoDetailUIPanel:Hide()
	self.panel:Hide()	
end
--��ʾ
function HeroInfoDetailUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
