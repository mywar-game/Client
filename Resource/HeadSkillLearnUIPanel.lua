HeadSkillLearnUIPanel = {
panel = nil,
}

function HeadSkillLearnUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

--技能学习面板
function HeadSkillLearnUIPanel:Create(para)
    local p_name = "HeadSkillLearnUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
    
	local isAnim = true
	local posData = {}--标识那几个坑是否填充的材料id
	local selectData  = {}--当前选中的数据
	local skillSprite = {}
	local itemInfoList = {}
	local selectSprite = nil
	local systemHeroSkillId = para.systemHeroSkillId
       
    local function setGoldAndExpNum()--计算并设置金币数
		local expNum = 0
		local goldNum = 0
		for k,v in pairs(posData) do
			if v then
				expNum = expNum + v.num
				goldNum = goldNum + 1
			end
		end
		self.panel:setLabelText("lab_choose_gold",selectData.skillLevel*goldNum*100)
		self.panel:setLabelText("lab_choose_exp","+"..expNum)
    end
	
	local function setItemToolNum(toolId,state)
		local item = nil
		local data = nil
		for k,v in pairs(itemInfoList)do
			if v.data.toolId == toolId then
				data = v.data
				item = v.item
			end
		end
		
		local num = state and 1 or -1
		if item then
			data.toolNum = data.toolNum + num
			if data.toolNum > 0 then
			self.panel:setItemLabelText(item,"lab_num",data.toolNum)
			else
				refreshSkillBookList()
			end
		else
			refreshSkillBookList()
		end
	end
    
	--清除坑位
    local function cleanAddSkillBook() 
        for k,v in pairs(skillSprite) do
            if v then
				v:removeFromParent(true)
			end
        end
		posData = {}
		skillSprite = {}
		self.panel:setLabelText("lab_choose_gold",0)
		self.panel:setLabelText("lab_choose_exp",0)
    end
	
	local function btnAnimationTips(isFull)
		if isFull and isAnim then
			isAnim = false
			for k=1,5 do
				local key = "btn_skill_"..k
				local button = self.panel:getChildByName(key)
				local arr={}
				arr[1] = cc.ScaleTo:create(0.2,1.2)
				arr[2] = cc.ScaleTo:create(0.2,1)
				arr[3] = cc.CallFunc:create(function()
					if k == 5 then
						isAnim = true
					end
				end)
				local sq = cc.Sequence:create(arr)
				button:stopAllActions()
				button:runAction(sq)
			end
		end
	end
    
    --技能显示详情区域
    local function showHeadSkillInfo(item,data)
		selectData = data
		cleanAddSkillBook()
        systemHeroSkillId = data.systemHeroSkillId
		
		if selectSprite then
			selectSprite:setVisible(false)
		end
		selectSprite = self.panel:getItemChildByName(item,"img_select")
		selectSprite:setVisible(true)
		
        local systemSkill = DataManager.getSystemSkillId(selectData.skillId)
        self.panel:setLabelText("lab_info_skillNameEx",systemSkill.name)
        self.panel:setLabelText("lab_info_skillLevel","Lv."..selectData.skillLevel)
        self.panel:setLabelText("lab_info_skillTimes",systemSkill.cdTime.."S")
        self.panel:setLabelText("lab_info_skillDescEx",systemSkill.remark)
		self.panel:setImageTexture("img_info_skillHead",IconPath.tuanji..systemSkill.imgId..".png")
		
		local careerStr = ""
		local needCareerList = Split(systemSkill.needCareer,",")
		for k,v in pairs(needCareerList)do
			if k == #needCareerList then
				careerStr = careerStr..GameString.careerId1ToStr[tonumber(v)]
			else
				careerStr = careerStr..GameString.careerId1ToStr[tonumber(v)]..GameString.huozhe
			end
		end
        self.panel:setLabelText("lab_info_skillCareer",careerStr)
		
        local systemSkillLevel = StaticDataManager.getSystemHeroSkillLevel(selectData.skillLevel+1,selectData.color)
        if systemSkillLevel then
			self.panel:setBtnEnabled("btn_upgrade",true)
            self.panel:setProgressBarPercent("ProgressBar_exp",selectData.skillExp/systemSkillLevel.exp*100)
        else
			self.panel:setBtnEnabled("btn_upgrade",false)
            self.panel:setProgressBarPercent("ProgressBar_exp",100)--配置有问题 直接显示100%
        end
    end
	
    --技能显示详情区域end
    local function OnItemShowCallback(scroll_view,item,data,idx)--显示技能列表中的技能
        local systemSkill = DataManager.getSystemSkillId(data.skillId)
        if data.systemHeroSkillId == systemHeroSkillId then
            showHeadSkillInfo(item,data)
        end
		self.panel:setItemLabelText(item,"lab_skillName",systemSkill.name)
		self.panel:setItemLabelText(item,"lab_skillLevel",data.skillLevel)
        self.panel:setItemLabelText(item,"lab_crystalNum",data.needCrystal)
        self.panel:setItemImageTexture(item,"img_skillHead",IconPath.tuanji..systemSkill.imgId..".png")
    end
	
	--团战技能列表相关start
    local function OnItemClickCallback(item,data,idx)--点击技能列表中的技能
		itemInfoList = {}
        showHeadSkillInfo(item,data)
    end
	
    local function refreshHeadSkillLearnInfo()--显示技能列表
		local idx = 0
        local data = DataManager.getUserHeroSkillList()
		for k,v in pairs(data)do
			if v.skillId == systemHeroSkillId then
				idx = k
			end
		end
        self.panel:InitListView(data,OnItemShowCallback,OnItemClickCallback,"ListView_skill","ListItem_skill",nil,idx)
    end
	
	----------------------------------------------------------
	--消耗道具列表区域start
    local function SkillBook_OnItemShowCallBack(scroll_view,item,data,idx)--显示道具列表
        self.panel:setItemImageTexture(item,"img_skillIcon",IconPath.daoju..data.imgId..".png")
        self.panel:setItemImageTexture(item,"img_skillmaterialkuang",IconPath.pinzhiKuang..data.color..".png")
        self.panel:setItemLabelText(item,"lab_num",data.toolNum)
		table.insert(itemInfoList,{item=item,data=data})
    end
    
    local function SkillBook_OnItemClickCallback(item,data,idx)--点击道具列表
		local isFull = true
		for k=1,5 do
			local key = "btn_skill_"..k
			if skillSprite[key] == nil then
				local sprite = CreateCCSprite(IconPath.daoju..data.imgId..".png")
				local button = self.panel:getChildByName(key)
				local size = button:getContentSize()
				sprite:setPosition(cc.p(size.width/2,size.height/2))
				button:addChild(sprite)
				
				isFull = false
				posData[key] = data
				skillSprite[key] = sprite
				setItemToolNum(data.toolId,false)
				setGoldAndExpNum()
				break
			end
		end
		btnAnimationTips(isFull)
    end
	
    function refreshSkillBookList()
		local toolList = DataManager.getUserToolListByType(102)--全局道具列表
		for k=#toolList,1,-1 do
			local toolNum = toolList[k].toolNum
			for m,n in pairs(posData) do
				if n and n.toolId == toolList[k].toolId then
					toolNum = toolNum - 1
				end
			end
			toolList[k].toolNum = toolNum
			if toolNum <= 0 then
				table.remove(toolList,k)
			end
		end
		itemInfoList = {}
        self.panel:InitListView(toolList,SkillBook_OnItemShowCallBack,SkillBook_OnItemClickCallback,"ListView_material","ListItem_material",3)
    end
	
	--网络请求区域start
    local function reqUpgrade()--请求升级
		local listTool = {}
		for k,v in pairs(posData)do
			if v then
				local skillTool = SkillToolBO:New()
				skillTool:setInt_toolId(v.toolId)
				skillTool:setInt_toolNum(1)
				table.insert(listTool,skillTool)
			end
		end
		
		if #listTool == 0 then
			btnAnimationTips(true)
			return
		end
		
		local upgradeLeaderSkillReq = HeroAction_upgradeLeaderSkillReq:New()
		upgradeLeaderSkillReq:setString_userHeroSkillId(selectData.userHeroSkillId)
		upgradeLeaderSkillReq:setList_skillToolBOList(listTool)
		NetReqLua(upgradeLeaderSkillReq,true)
    end
	
	local function autoSelectTool()
		local isFull = true
		local idx = 1
		for k=1,5 do
			local itemInfo = itemInfoList[1]
			if itemInfo then
				local data = itemInfo.data
				if data.toolNum == 1 then
					idx = idx + 1
				end
				local key = "btn_skill_"..k
				if skillSprite[key] == nil and data.toolNum >= 1 then
					local sprite = CreateCCSprite(IconPath.daoju..data.imgId..".png")
					local button = self.panel:getChildByName(key)
					local size = button:getContentSize()
					sprite:setPosition(cc.p(size.width/2,size.height/2))
					button:addChild(sprite)
					
					isFull = false
					posData[key] = data
					skillSprite[key] = sprite
					setItemToolNum(data.toolId,false)
					setGoldAndExpNum()
				end
			end
		end
	end
	
    local function onClickAddSkillBook(flag,tag)
		local x = flag and -122 or 130
		local skillCxt = self.panel:getChildByName("img_border")
		skillCxt:runAction(cc.MoveTo:create(0.2,cc.p(x,-20)))
		
		local material = self.panel:getChildByName("img_skillMaterial")
		if flag and material:isVisible() then
			local toolId = nil
			local key = "btn_skill_"..(tag-3)
			if posData[key] then
				toolId = posData[key].toolId
			end
			
			if skillSprite[key] then
				skillSprite[key]:removeFromParent(true)
			end
			
			skillSprite[key] = nil
			posData[key] = nil
			setGoldAndExpNum()
			
			if toolId then
				setItemToolNum(toolId,true)
			end
		end
		self.panel:setNodeVisible("img_skillList",not flag)
		self.panel:setNodeVisible("img_skillMaterial",flag)
    end
	
	function HeadSkillLearnUIPanel_HeroAction_upgradeLeaderSkill()
		refreshSkillBookList()
		refreshHeadSkillLearnInfo()
	end

	--按钮功能事件start
    local function btnCallBack(sender,tag)
        if tag == 0 then
            self:Release()
        elseif tag == 1 then
			reqUpgrade()
		elseif tag == 2 then
			autoSelectTool()
		elseif tag == 3 then
		   onClickAddSkillBook(false,tag)
        else
           onClickAddSkillBook(true,tag)
        end
    end
    self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_upgrade",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_auto",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_close",btnCallBack,3)
    self.panel:addNodeTouchEventListener("btn_skill_1",btnCallBack,4)
    self.panel:addNodeTouchEventListener("btn_skill_2",btnCallBack,5)
    self.panel:addNodeTouchEventListener("btn_skill_3",btnCallBack,6)
    self.panel:addNodeTouchEventListener("btn_skill_4",btnCallBack,7)
    self.panel:addNodeTouchEventListener("btn_skill_5",btnCallBack,8)

	refreshSkillBookList()
    refreshHeadSkillLearnInfo()
    
	return panel
end

--
function HeadSkillLearnUIPanel:Release()
	self.panel:Release()
end
--
function HeadSkillLearnUIPanel:Hide()
	self.panel:Hide()
end
--
function HeadSkillLearnUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end