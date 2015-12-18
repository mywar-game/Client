ArenaHeroUIPanel = {
panel = nil,
}

function ArenaHeroUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

--创建
function ArenaHeroUIPanel:Create(para)
    local p_name = "ArenaHeroUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
    
	local selectSprite = nil
	local finalList = para.list
	local heroList = DeepCopy(para.list)
	cclogtable(heroList)
	function ArenaHeroUIPanel_PkAction_changePos()
		finalList = heroList
	end
	
    --按钮事件
	local function btnCallBack(sender,tag)
		if tag == 0 then
			para.callback(finalList)
			self:Release()
		elseif tag == 1 then
			local changePosReq = PkAction_changePosReq:New()
			changePosReq:setList_userHeroIdList(heroList)
			NetReqLua(changePosReq,true)	
			UserGuideUIPanel.stepClick("btn_save")
		end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_save",btnCallBack,1)
	
	self.panel:addNodeTouchEventListener("btn_hero_1",btnCallBack,5)
	self.panel:addNodeTouchEventListener("btn_hero_2",btnCallBack,6)
	self.panel:addNodeTouchEventListener("btn_hero_3",btnCallBack,7)
	self.panel:addNodeTouchEventListener("btn_hero_4",btnCallBack,8)
	self.panel:addNodeTouchEventListener("btn_hero_5",btnCallBack,9)
	
	local function clickHeroList(systemHeroId)
		local idx = -1
		for k=#heroList,1,-1 do
			if heroList[k] == systemHeroId then
				idx = k
			end
		end
		
		if idx == -1 then
			if #heroList < 5 then
				table.insert(heroList,systemHeroId)
			end
		else
			if #heroList > 1 then
				table.remove(heroList,idx)
			else
				Tips(GameString.arenaHeroTips)
			end
		end
	end
	--刷新
	local function refreshHeroList()
		local tempList = {}
		for k,v in pairs(heroList)do
			local systemHero = DataManager.getUserHeroId(v)
			table.insert(tempList,systemHero)
		end
		
		local effective = 0
		for k=1,5 do
			self.panel:setNodeVisible("img_bg_"..k,false)
		end
		
		for k,v in pairs(tempList) do
			effective = effective + tempList[k].effective
			self.panel:setImageTexture("img_head_"..k,IconPath.yingxiong..tempList[k].imgId..".png")
			self.panel:setImageTexture("img_color_"..k,IconPath.pinzhiYaun..tempList[k].heroColor..".png")
			self.panel:setNodeVisible("img_bg_"..k,true)
		end
		self.panel:setBitmapText("lab_effective",effective)
	end
	refreshHeroList()
	
	local function OnItemShowCallback(scroll_view,item,data,idx)
		self.panel:setItemImageTexture(item,"img_head",IconPath.yingxiong..data.imgId..".png")
		self.panel:setItemImageTexture(item,"img_color",IconPath.pinzhiYaun..data.heroColor..".png")
	end
	
	local function OnItemClickCallback(item,data,idx)
		clickHeroList(data.userHeroId)
		refreshHeroList()
		
		if selectSprite then
			selectSprite:setVisible(false)
		end
		selectSprite = self.panel:getItemChildByName(item,"img_select")
		selectSprite:setVisible(true)
		UserGuideUIPanel.stepClick("Image_item_guide")
	end
	
	local userHeroList = DataManager.getUserHeroList()
	userHeroList = DataManager.getSortHeroList(userHeroList)
	self.panel:InitListView(userHeroList,OnItemShowCallback,OnItemClickCallback,nil,nil,6)
		
	return panel
end
--退出
function ArenaHeroUIPanel:Release()
	self.panel:Release(true)
end
--隐藏
function ArenaHeroUIPanel:Hide()
	self.panel:Hide()	
end
--显示
function ArenaHeroUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end