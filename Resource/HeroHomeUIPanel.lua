HeroHomeUIPanel = {
panel = nil,
}
function HeroHomeUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function HeroHomeUIPanel:Create(para)
    local p_name = "HeroHomeUI"
    local panel = Panel:New()
	self.panel = panel
	self.para = para
    panel:InitPanel(p_name)

	--类别选择 
	local function OnItemShowCallback(scroll_view,item,data,idx)
		self.panel:setItemLabelText(item,"lab_heroName",data.heroName)
		self.panel:setItemBitmapText(item,"lab_zbdz",data.effective)
		self.panel:setItemBitmapText(item,"lab_level","Lv."..data.level)
		self.panel:setItemImageTexture(item,"img_heroHead",IconPath.yingxiong..data.imgId..".png")
		self.panel:setItemImageTexture(item,"img_headColor",IconPath.pinzhiYaun..data.heroColor..".png")
		self.panel:setItemBitmapText(item,"lab_heroCareer", GameString.careerId1ToStr[data.careerId])
		self.panel:setItemLabelText(item,"lab_state",GameString["heroState"..data.status])
	end
	
	local function OnItemClickCallback(item,data,idx)
		self.panel:delayRelease(function() 
			LayerManager.show("HeroDescUIPanel",{hero=data,idx=GameField.heroDescPackage})
		end)
	end
	
	function refreshHeroInfo(selectType)
		local heroList = {}
		local heroListAll = DataManager.getUserHeroList()
		if selectType == 1 then
		    heroList = heroListAll
		else
		    for k,v in pairs(heroListAll) do
                local heroTemp = v
		        if selectType==2 then --肉盾 对应mt
					if heroTemp.standId == 1 then
						table.insert(heroList,heroTemp)
					end
				elseif selectType==3 then --输出对应 对应 近战和远程输出
					if heroTemp.standId == 2 or heroTemp.standId == 3 then
						table.insert(heroList,heroTemp)
					end
				elseif selectType==4 then --治疗对应奶
					if heroTemp.standId == 4 then
						table.insert(heroList,heroTemp)
					end
				end
		    end
		end
		
		if selectType == 1 then
			self.panel:setBtnEnabled("btn_qb",false)
			self.panel:setBtnEnabled("btn_rd",true)
			self.panel:setBtnEnabled("btn_sc",true)
			self.panel:setBtnEnabled("btn_zl",true)
		elseif selectType == 2 then
			self.panel:setBtnEnabled("btn_qb",true)
			self.panel:setBtnEnabled("btn_rd",false)
			self.panel:setBtnEnabled("btn_sc",true)
			self.panel:setBtnEnabled("btn_zl",true)
		elseif selectType == 3 then
			self.panel:setBtnEnabled("btn_qb",true)
			self.panel:setBtnEnabled("btn_rd",true)
			self.panel:setBtnEnabled("btn_sc",false)
			self.panel:setBtnEnabled("btn_zl",true)
		elseif selectType == 4 then
			self.panel:setBtnEnabled("btn_qb",true)
			self.panel:setBtnEnabled("btn_rd",true)
			self.panel:setBtnEnabled("btn_sc",true)
			self.panel:setBtnEnabled("btn_zl",false)
		end
		
		heroList = DataManager.getSortHeroList(heroList)
		self.panel:InitListView(heroList,OnItemShowCallback,OnItemClickCallback,nil,nil,2,nil,1)
	end
	refreshHeroInfo(1)
	
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		elseif tag == 1 then
			refreshHeroInfo(1)
		elseif tag == 2 then
			refreshHeroInfo(2)
		elseif tag == 3 then
			refreshHeroInfo(3)
		elseif tag == 4 then
			refreshHeroInfo(4)
		end
	end
	
	--返回按钮
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_qb",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_rd",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_sc",btnCallBack,3)
	self.panel:addNodeTouchEventListener("btn_zl",btnCallBack,4)
	
	return panel
end
--退出
function HeroHomeUIPanel:Release()
		self.panel:Release()
end
--隐藏
function HeroHomeUIPanel:Hide()
	self.panel:Hide()
end
--显示
function HeroHomeUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
