--仅仅处理副本
require("FightDropUIPanel")

DuplicateUIPanel = {
panel = nil,
}

function DuplicateUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

--创建
function DuplicateUIPanel:Create(para)
    local p_name = "DuplicateUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	local forcesDifficulty = GameField.forcesDifficulty1
	local function OnItemShowCallback(scroll_view,item,data,idx)
		local forcesMonster = DataManager.getSystemForcesMonster(data.forcesId,forcesDifficulty)
		local monsterIdList = Split(forcesMonster.monsterId,"|")
		local bossMonsterId = tonumber(monsterIdList[#monsterIdList])
		local systemMonster = DataManager.getSystemMonsterId(bossMonsterId)
		local systemHero = DataManager.getStaticSystemHeroId(systemMonster.systemHeroId)
		local num = forcesMonster.attackLimitTimes-data.times
		num = num < 0 and 0 or num		
		self.panel:setItemLabelText(item,"lab_forceName",systemHero.heroName)
		self.panel:setItemLabelText(item,"lab_skillNum",num)
		self.panel:setItemImageTexture(item,"img_heroHead","res/hero_icon/"..systemHero.imgId..".png")
		self.panel:setItemImageTexture(item,"img_heroColor","common/head_color_"..systemHero.heroColor..".png")
		
		if idx == 1 then
			self.panel:setItemNodeVisible(item,"img_lock",false)
		elseif data.status == -1 then
			self.panel:setItemNodeVisible(item,"img_lock",true)
			self.panel:setItemNodeColor(item,"img_sk1")
			self.panel:setItemNodeColor(item,"img_sk2")
			self.panel:setItemNodeColor(item,"img_listBg")
			self.panel:setItemNodeColor(item,"img_skill")
			self.panel:setItemNodeColor(item,"img_heroHead")
			self.panel:setItemNodeColor(item,"img_heroColor")
		end
	end
	
	local function OnItemClickCallback(item,data,idx)
		local forcesMonster = DataManager.getSystemForcesMonster(data.forcesId,forcesDifficulty)
		local num = forcesMonster.attackLimitTimes-data.times
		if data.status == -1 and idx > 1 then
			Tips(GameString.duplicateTips)
		else
			if num > 0 then
				local fightDropUIPanel = FightDropUIPanel:New()
				local fightdrop = fightDropUIPanel:Create({num=num,forces=data,forcesDifficulty=forcesDifficulty})
				self.panel.layer:addChild(fightdrop.layer)
			else
				Tips(GameString.duplicateRunOver)
			end
		end
	end
	
	local function refreshDuplicateInfo(tag)
		if tag == 1 then
			forcesDifficulty = GameField.forcesDifficulty1
			self.panel:setBtnEnabled("btn_diff_1",false)
			self.panel:setBtnEnabled("btn_diff_2",true)
			self.panel:setBtnEnabled("btn_diff_3",true)
		elseif tag == 2 then
			forcesDifficulty = GameField.forcesDifficulty2
			self.panel:setBtnEnabled("btn_diff_1",true)
			self.panel:setBtnEnabled("btn_diff_2",false)
			self.panel:setBtnEnabled("btn_diff_3",true)
		elseif tag == 3 then
			forcesDifficulty = GameField.forcesDifficulty3
			self.panel:setBtnEnabled("btn_diff_1",true)
			self.panel:setBtnEnabled("btn_diff_2",true)
			self.panel:setBtnEnabled("btn_diff_3",false)
		end
		local systemForces = DataManager.getSystemDuplicateForcesList(para.forces.bigForcesId,forcesDifficulty)
		self.panel:InitListView(systemForces,OnItemShowCallback,OnItemClickCallback,nil,nil,2)
	end
	
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		elseif tag == 1 then
			refreshDuplicateInfo(1)
		elseif tag == 2 then
			refreshDuplicateInfo(2)
		elseif tag == 3 then
			refreshDuplicateInfo(3)
		end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_diff_1",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_diff_2",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_diff_3",btnCallBack,3)
	self.panel:setLabelText("lab_titleName",para.forces.bigForcesName.."(Lv."..para.forces.limitLevel..")")
	
	function DuplicateUIPanel_ForcesAction_getCopyForcesInfo(msgObj)
		refreshDuplicateInfo(1)
	end
	
    if #DataManager.getUserBigForceBo(para.forces.bigForcesId,forcesDifficulty) > 0 then
		refreshDuplicateInfo(1)
	else
		local getCopyForcesReq = ForcesAction_getCopyForcesInfoReq:New()
		getCopyForcesReq:setInt_mapId(para.forces.mapId)
		getCopyForcesReq:setInt_bigForcesId(para.forces.bigForcesId)
		NetReqLua(getCopyForcesReq, true)
	end
	
	return panel
end

--退出
function DuplicateUIPanel:Release()
	self.panel:Release()
end
--隐藏
function DuplicateUIPanel:Hide()
	self.panel:Hide()
end
--显示
function DuplicateUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
