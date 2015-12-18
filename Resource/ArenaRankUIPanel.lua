ArenaRankUIPanel = {
panel = nil,
}
function ArenaRankUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end
--创建
function ArenaRankUIPanel:Create(para)
    local p_name = "ArenaRankUI"
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
		local path = nil
		if data.rank == 1 then
			path = "i_st01.png"
		elseif data.rank == 2 then
			path = "i_st02.png"
		elseif data.rank == 3 then
			path = "i_st03.png"
		end
		
		if path then
			local sprite = CreateCCSprite("NewUi/xinqietu/haoyou/"..path)
			sprite:setPosition(cc.p(50,60))
			item:addChild(sprite)
		end
		
		self.panel:setItemBitmapText(item,"lab_rank",data.rank)
		self.panel:setItemLabelText(item,"lab_userName",data.userName)
		self.panel:setItemLabelText(item,"lab_teamName",data.legionName)
		self.panel:setItemBitmapText(item,"lab_level","Lv."..data.level)
		self.panel:setItemBitmapText(item,"lab_effective",data.defencePower)
		
		local systemHero = DataManager.getStaticSystemHeroId(data.systemHeroId)
		self.panel:setItemImageTexture(item,"img_head",IconPath.yingxiong..systemHero.imgId..".png")
		self.panel:setItemImageTexture(item,"img_color",IconPath.yingxiong.."i_head_color_"..systemHero.heroColor..".png")
				
		for k,v in pairs(data.defenceHeroList)do
			local defenceHero = DataManager.getStaticSystemHeroId(v)
			local bgSprite = CreateCCSprite("NewUi/xinqietu/tongyong/i_black.png")
			bgSprite:setPosition(cc.p(400+40*k,30))
			bgSprite:setScale(0.5)
			item:addChild(bgSprite)
			
			local headSprite = CreateCCSprite(IconPath.yingxiong..defenceHero.imgId..".png")
			headSprite:setScale(0.5)
			headSprite:setPosition(cc.p(400+40*k,30))
			item:addChild(headSprite)
			
			local colorSprite = CreateCCSprite(IconPath.pinzhiYaun..systemHero.heroColor..".png")
			colorSprite:setPosition(cc.p(400+40*k,30))
			colorSprite:setScale(0.5)
			item:addChild(colorSprite)
		end
	end
	
	local function OnItemClickCallback(item,data,idx)
	
	end
	
	function ArenaRankUIPanel_PkAction_getPkRank(msgObj)
		self.panel:InitListView(msgObj.body.rankList,OnItemShowCallback,OnItemClickCallback)
	end
	
	local getPkRankReq = PkAction_getPkRankReq:New()
	NetReqLua(getPkRankReq,true)
	
	return panel
end
--退出
function ArenaRankUIPanel:Release()
	self.panel:Release()
end
--隐藏
function ArenaRankUIPanel:Hide()
	self.panel:Hide()	
end
--显示
function ArenaRankUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end