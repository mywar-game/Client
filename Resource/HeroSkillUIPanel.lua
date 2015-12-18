HeroSkillUIPanel = {
panel = nil,
}
function HeroSkillUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function HeroSkillUIPanel:Create(para)
    local p_name = "HeroSkillUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	--业务逻辑编写处 
	local hero = para.hero
	self.panel:setLabelText("lab_heroName",hero.heroName)
	self.panel:setLabelText("lab_heroLevel","Lv."..hero.level)
	self.panel:setImageTexture("img_heroHead","res/hero_icon/"..hero.imgId..".png")		
	self.panel:setImageTexture("img_heroCareer","common/car_"..hero.careerId..".png")
	self.panel:setImageTexture("img_heroColor","common/head_color_"..hero.heroColor..".png")
	self.panel:setImageTexture("img_nameColor","common/name_color_"..hero.heroColor..".png")
	
	local passiveList = {}
	local initiativeList = {}
	for k=1,4 do
		local skill = hero["skill0"..k]
		local objectSkill = hero["objectSkill0"..k]
		if skill > 0 then
			local heroSkill = DataManager.getSystemHeroSkillId(skill,1)
			local systemSkill = DataManager.getSystemSkillId(heroSkill.skillId)
			table.insert(initiativeList,systemSkill)
		end
		if objectSkill > 0 then
			local heroSkill = DataManager.getSystemHeroSkillId(skill,1)
			local systemSkill = DataManager.getSystemSkillId(heroSkill.skillId)
			table.insert(passiveList,systemSkill)
		end 
	end
	
	local clickSprite = nil
	local function clickItemInfo(item,data,idx)
		if clickSprite then
			clickSprite:removeFromParent(true)
		end
		
		local size = item:getSize()
		clickSprite = CreateCCSprite("NewUi/qietu/renwujineng/jinengxuanzhongxuan.png") 
		clickSprite:setPosition(cc.p(size.width/2-5,size.height/2))
		item:addChild(clickSprite)
		
		self.panel:setLabelText("lab_heroSkillname",data.name)
		self.panel:setLabelText("lab_skillAdvanced",GameString["heroSkillDesc"..idx])
		self.panel:setLabelText("lab_skillTime",data.cdTime.."S")
		self.panel:setLabelText("lab_skillConsume",data.name)
		self.panel:setLabelText("lab_skillDesc",data.remark)
		if data.singTime == 0 then
			self.panel:setLabelText("lab_singTime",GameString.heroSkillSingTime)
		else
			self.panel:setLabelText("lab_singTime",GameString.heroSkillSingTime2..data.singTime.."S")
		end
	end

	--被动技能
	local function OnItemShowCallback(scroll_view,item,data,idx)
		if clickSprite == nil then
			clickItemInfo(item,data,idx)
		end
		if hero.level <= GameField.openLevel[idx] then
			self.panel:setItemNodeVisible(item,"img_lock",true)
			self.panel:setItemLabelText(item,"lab_levelDesc",GameString["heroSkillLock"..idx])
		else
			self.panel:setItemNodeVisible(item,"img_skillHead",true)
			self.panel:setItemLabelText(item,"lab_levelDesc",GameString["heroSkillDesc"..idx])
			self.panel:setItemImageTexture(item,"img_skillHead","res/hero_skill/"..data.imgId..".png")
		end
		self.panel:setItemLabelText(item,"lab_skillName",data.name)
	end
	
	local function OnItemClickCallback(item,data,idx)
		clickItemInfo(item,data,idx)
	end
	self.panel:InitListView(passiveList,OnItemShowCallback,OnItemClickCallback,"ListView_passive","ListItem")
	self.panel:InitListView(initiativeList,OnItemShowCallback,OnItemClickCallback,"ListView_initiative","ListItem")
	
	local function btnCallBack(sender,tag)
		if tag == 0 then
			if para.callback then
				para.callback(para.hero)
			end
		end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
    
	return panel
end
--退出
function HeroSkillUIPanel:Release()
	self.panel:Release()
end
--隐藏
function HeroSkillUIPanel:Hide()
	self.panel:Hide()
end
--显示
function HeroSkillUIPanel:Show()
	self.panel:Show()
end
