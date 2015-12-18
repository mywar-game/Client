ArenaLogUIPanel = {
panel = nil,
}
function ArenaLogUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function ArenaLogUIPanel:Create(para)
    local p_name = "ArenaLogUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
    
    --按钮事件
	local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()
		end
	end
	
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	
	local function OnItemShowCallback(scroll_view,item,data,idx)
		local fightTime = DataManager.getServerSystemTimeNow() - data.fightTime
		local d = math.floor(fightTime/3600/24)
		local h = math.floor(fightTime/3600)
		local m = math.ceil(fightTime/60)
		local ft = ""
		if d >= 1 then
			d = d >= 7 and 7 or d
			ft = d..GameString.dayAgo
		else
			if h >= 1 then
				ft = h..GameString.hourAgo
			else
				ft = math.ceil(m)..GameString.minuteAgo
			end
		end
		
		self.panel:setItemLabelText(item,"lab_time",ft)
		self.panel:setItemLabelText(item,"lab_name",data.targetUserName)
		self.panel:setItemBitmapText(item,"lab_level","Lv."..data.level)
		self.panel:setItemLabelText(item,"lab_place",data.changeRank)
		
		local stPath = data.flag <= 0 and "i_xiajjt.png" or "i_shangsjt.png"
		local flPath = data.flag <= 0 and "t_fuzi.png" or "t_sheng.png"
		local bgPath = data.flag <= 0 and "i_fuzibg.png" or "i_shengzibg.png"
		
		self.panel:setItemImageTexture(item,"img_state","NewUi/xinqietu/jingjichang/"..stPath)
		self.panel:setItemImageTexture(item,"img_flag","NewUi/xinqietu/jingjichang/"..flPath)
		self.panel:setItemImageTexture(item,"img_flagBg","NewUi/xinqietu/jingjichang/"..bgPath)
		
		local systemHero = DataManager.getStaticSystemHeroId(data.systemHeroId)
		self.panel:setItemImageTexture(item,"img_head",IconPath.yingxiong..systemHero.imgId..".png")
		self.panel:setItemImageTexture(item,"img_color",IconPath.pinzhiYaun..systemHero.heroColor..".png")
	end
	
	local function OnItemClickCallback(item,data,idx)
		
	end
	
	function ArenaLogUIPanel_PkAction_getPkFightLog(msgObj)
		self.panel:InitListView(msgObj.body.logList,OnItemShowCallback,OnItemClickCallback)
	end
	
	local getPkFightLogReq = PkAction_getPkFightLogReq:New()
	NetReqLua(getPkFightLogReq,true)
	
	return panel
end
--退出
function ArenaLogUIPanel:Release()
	self.panel:Release(true)
end

--隐藏
function ArenaLogUIPanel:Hide()
	self.panel:Hide()	
end
--显示
function ArenaLogUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end