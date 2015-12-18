--物品/装备详情
ToolDetailUIPanel = {}
function ToolDetailUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function ToolDetailUIPanel:Create(para)
	local p_name = "ToolDetailUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
	local data = para.data--属性列表(用以生成界面文字)
    local function addNewItem(behindNode, imgPath, txt, txtColor, offsetX, offsetY)
        local x,y = behindNode:getPosition()
        local size = behindNode:getContentSize()
        local addLab
        local imgIcon
        y = y - size.height
        if offsetY then y=y-offsetY end
        if offsetX then x=x+offsetX end
        if imgPath then
           
        end
        if txt then
            addLab = CreateLabel(txt, nil, 18, txtColor or cc.c3b(255,255,255), 1, cc.size(280,0), 1)
            addLab:setPosition(x,y)
            self.panel:getChildByName("img_equipContent"):addChild(addLab)
        end
        if imgIcon then return imgIcon end
        return addLab
    end
	
    local preItem
    if para.type == GameField.heroSkill then	--技能
	
        self.panel:setLabelText("lab_equipName", data.name)
        self.panel:setImageTexture("img_box",IconPath.shuxingtishi.."xzb_kuang1.png")
        self.panel:setNodeVisible("lab_equipLevel", false)
        self.panel:setNodeVisible("lab_levelTip", false)
        preItem = self.panel:getChildByName("lab_equipName")
        preItem = addNewItem(preItem, nil, LabelChineseStr.ToolDetailUIPanel_6_cd..data.cdTime..LabelChineseStr.common_miao, nil, 5, 0)
        
		local heroAttr = DataManager.getSystemHeroAttributeId(data.systemHeroId,1)
		local stringTab = EquipDetailUtil.showSkillData(heroAttr,data)		
		local descLab = createRichColorLabel(stringTab,20,cc.size(300,80))
		descLab:setPosition(-170,-160)
		descLab:getAnchorPoint(cc.p(0,1))
		self.panel:getChildByName("img_equipContent"):addChild(descLab)
		
		--preItem = addNewItem(preItem, nil, string.format(data.remark,value), cc.c3b(251,216,96), 0, 20)
	elseif para.type == GameField.gemstone then --宝石
		self.panel:setLabelText("lab_equipName", data.name)
		self.panel:setLabelText("lab_equipLevel",data.level)
		preItem = self.panel:getChildByName("lab_equipName")
		
		local attrList = json.decode(data.attr)
		for k,v in pairs(attrList)do
			local str = LabelChineseStr["ToolDetailUIPanel_3_"..v.attr]
			preItem = addNewItem(preItem, nil,str.."+"..v.value, cc.c3b(251,216,96), 0, 20)
		end
    elseif  para.type == skillBook then
        
    elseif para.type ~= GameField.equip then--其他道具
        self.panel:setLabelText("lab_equipName", data.name)
        self.panel:getChildByName("lab_equipName"):setColor(GetQualityColor(data.color))
        self.panel:setImageTexture("img_box", IconPath.shuxingtishi.."xzb_kuang"..data.color..".png")
		self.panel:setLabelText("lab_equipLevel", data.level)
        --self.panel:setNodeVisible("lab_equipLevel", false)
        --self.panel:setNodeVisible("lab_levelTip", false)
        addNewItem(self.panel:getChildByName("lab_levelTip"), nil, data.description, nil, 5, 0)
    else--装备
		--[[
	    local systemEquip = DataManager.getSystemEquip(data.equipId)
        --获取所有属性
        self.panel:setLabelText("lab_name", systemEquip.name)
        self.panel:getChildByName("lab_name"):setColor(GetQualityColor(systemEquip.quality))
        self.panel:setImageTexture("big_box", IconPath.shuxingtishi.."zb_kuang"..systemEquip.quality..".png")
        self.panel:setLabelText("lab_level", systemEquip.level)
        preItem = self.panel:getChildByName("lab_levelTip")
        --唯一性
		
        if #systemEquip.pos <= 1 then
            preItem = addNewItem(preItem, nil, LabelChineseStr.ToolDetailUIPanel_1, nil, 0, 5)
        end
        --属于什么武器
        preItem = addNewItem(preItem, nil, LabelChineseStr["ToolDetailUIPanel_2_"..systemEquip.equipType], nil, 0, 5)
        --属性添加
        local function addEquipAttr(attrCell, color)
            local showStr = ""
            if attrCell.name == "damage" then
                showStr = attrCell.value.." "..LabelChineseStr["ToolDetailUIPanel_3_"..attrCell.name]
            else
                showStr = "+"..attrCell.value.." "..LabelChineseStr["ToolDetailUIPanel_3_"..attrCell.name]
            end
            preItem = addNewItem(preItem, nil, showStr, color, 0, 5)
        end
        
		
		local minDamage = nil
		local maxDamage = nil
		for k,v in pairs(data.uniqueAttr) do
			if v.name == "miniDamage" then
				minDamage = v.value
			elseif v.name == "maxDamage" then
				maxDamage = v.value
			end
		end
		
		--伤害
		if minDamage and maxDamage then
			addEquipAttr({name="damage",value=minDamage.." - "..maxDamage})
		end
		
		--独有属性展示
		for k,v in pairs(data.uniqueAttr) do
			if v.name ~= "miniDamage" and v.name ~= "maxDamage" then
				addEquipAttr(v)
			end
        end
		
        --主属性展示
        for k,v in pairs(data.equipMainAttr) do
            addEquipAttr(v)
        end
		
        --副属性展示
        for k,v in pairs(data.equipSecondaryAttr) do
            addEquipAttr(v, cc.c3b(0,255,0))
        end
		
		--附魔属性展示
		if nil ~= data.magicEquipAttr or "" ~= data.magicEquipAttr then
			local magicAttr = json.decode(data.magicEquipAttr)
			cclog("===============>" .. data.magicEquipAttr)
			cclogtable(magicAttr)
			if nil ~= magicAttr then
				for k, v in pairs(magicAttr) do
				preItem = addNewItem(preItem, nil, "+ " .. v.value .. " " .. v.attr, cc.c3b(0, 255, 0), 0, 5)
			end
			end

		end
        --职业
        local careerStr = LabelChineseStr.ToolDetailUIPanel_4
        for k,v in pairs(systemEquip.needCareer) do
            careerStr = careerStr..LabelChineseStr["ToolDetailUIPanel_4_"..v]
            if k ~= #systemEquip.needCareer then
                careerStr = careerStr..","
            end
        end
        preItem = addNewItem(preItem, nil, careerStr, nil, 0, 5)
        --需要等级
        preItem = addNewItem(preItem, nil, LabelChineseStr.ToolDetailUIPanel_5..systemEquip.needLevel, nil, 0, 5)
        --描述
        preItem = addNewItem(preItem, nil, systemEquip.description, cc.c3b(0xff,0xd7,0), 0, 5)]]
		
		self.panel:setImageTexture("img_box", IconPath.shuxingtishi.."zb_kuang"..data.quality..".png")
		EquipDetailUtil.showAttrInfo(self.panel,data,{},"lab_levelTip",cc.size(280,0),cc.p(0,-20))
    end

    return self.panel
end

--退出
function ToolDetailUIPanel:Release()
	self.panel:Release(true)
end

--隐藏
function ToolDetailUIPanel:Hide()
	self.panel:Hide()
end

--显示
function ToolDetailUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerTrue()
end