FightStatisticsUIPanel = {
panel = nil,
}

function FightStatisticsUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

--创建
function FightStatisticsUIPanel:Create(para)
    local p_name = "FightStatisticsUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	if para.fightType == GameField.fightType3 then
		self.panel:setNodeVisible("img_vs",true)
	end
	
	--统计数量
	local function statisticsNum(temp)
		local num = 0
		for k,v in pairs(temp)do
			num = num + math.abs(v.value)
		end
		return num
	end

	local spriteList = {}
	local heroSprite1 = self.panel:getChildByName("img_hero1")
	local heroSprite2 = self.panel:getChildByName("img_hero2")
	local temp1,temp2,temp3,temp4,temp5,temp6 = DataManager.getFightData(para.fightType)
	local heroNum1 = statisticsNum(temp1)
	local heroNum2 = statisticsNum(temp2)
	local heroNum3 = statisticsNum(temp3)
	local heroNum4 = statisticsNum(temp4)
	local heroNum5 = statisticsNum(temp5)
	local heroNum6 = statisticsNum(temp6)
	self.panel:setLabelText("lab_cs",heroNum1)
	self.panel:setLabelText("lab_sc",heroNum2)
	self.panel:setLabelText("lab_zl",heroNum3)
	
	--显示
	local function showHeroProgressBar(temp,maxValue,posX,isSelf,idx)
		local hero = {}
		for k,v in pairs(temp)do
			local flag = true
			for m,n in pairs(hero)do
				if idx == 1 then
					if v.fightHeroId2 == n.fightHeroId2 then
						flag = false
						n.value = math.abs(n.value) + math.abs(v.value)
					end
				else
					if v.fightHeroId1 == n.fightHeroId1 then
						flag = false
						n.value = math.abs(n.value) + math.abs(v.value)
					end
				end
			end
			
			if flag then
				table.insert(hero,DeepCopy(v))
			end
		end
		
		table.sort(hero,function(a,b)
			return a.value > b.value
		end)
		
		for k,v in pairs(hero)do
			local imgStr = ""
			local systemHeroId
			local newHeroSprite
			if isSelf then
				newHeroSprite = heroSprite1:clone()
			else
				newHeroSprite = heroSprite2:clone()
			end
			
			if idx == 1 then
				imgStr = "i_hongtiaozhu.png"
				systemHeroId = v.systemHeroId2
			elseif idx == 2 then
				imgStr = "i_lantiaozhu.png"
				systemHeroId = v.systemHeroId1
			elseif idx == 3 then
				imgStr = "i_lvsetiaozhu.png"
				systemHeroId = v.systemHeroId1
			end
			
			newHeroSprite:setPosition(cc.p(posX,460-k*75))
			newHeroSprite:setVisible(true)
			self.panel.layer:addChild(newHeroSprite)
			self.panel:setItemLabelText(newHeroSprite,"lab_lv",math.abs(v.value))
			self.panel:setItemImageTexture(newHeroSprite,"pro_lv",IconPath.jiesuanshuju..imgStr)
			--self.panel:setItemProgressBarPercent(newHeroSprite,"pro_lv",(math.abs(v.value)/maxValue*100))
			
			local proBar = self.panel:getItemChildByName(newHeroSprite,"pro_lv")
			local action = ActionHelper.createUpgradeProStepAction(proBar,0,(math.abs(v.value)/maxValue*100))
			proBar:runAction(action)
			
			local systemHero = StaticDataManager.getSystemHeroId(systemHeroId)
			self.panel:setItemImageTexture(newHeroSprite,"img_heroHead",IconPath.yingxiong..systemHero.imgId..".png")
			self.panel:setItemImageTexture(newHeroSprite,"img_headColor",IconPath.pinzhiYaun..systemHero.heroColor..".png")
			table.insert(spriteList,newHeroSprite)
		end
	end
	
	local function showAllHeroBar(tempList1,tempList2,heroNumCount1,heroNumCount2,index)
		for k,v in pairs(spriteList)do
			v:removeFromParent(true)
		end
		spriteList = {}
		showHeroProgressBar(tempList1,heroNumCount1,300,true,index)
		if para.fightType == GameField.fightType3 then
			showHeroProgressBar(tempList2,heroNumCount2,660,false,index)
		end
	end
	showAllHeroBar(temp1,temp4,heroNum1,heroNum4,1)
	
    --按钮事件
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		elseif tag == 1 then
			showAllHeroBar(temp1,temp4,heroNum1,heroNum4,1)
		elseif tag == 2 then	
			showAllHeroBar(temp2,temp5,heroNum2,heroNum5,2)
		elseif tag == 3 then
			showAllHeroBar(temp3,temp6,heroNum3,heroNum6,3)
		end	
	end
	
	self.panel:addNodeTouchEventListener("btn_close",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_cs",btnCallBack,1)	
	self.panel:addNodeTouchEventListener("btn_sc",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_zl",btnCallBack,3)

	return panel
end
--退出
function FightStatisticsUIPanel:Release()
	self.panel:Release(true)
end
--隐藏
function FightStatisticsUIPanel:Hide()
	self.panel:Hide()	
end
--显示
function FightStatisticsUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end