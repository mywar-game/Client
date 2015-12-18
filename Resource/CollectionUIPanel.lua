--挖矿弹出进度
CollectionUIPanel = {}
function CollectionUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function CollectionUIPanel:Create(para)
	local p_name = "CollectionUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
    local imgRes = ""
	local nowTim = 0
    local nowIndex = 1
	local nowChangeTipsTim = 0
    local secTim = para.secTim or 1

	if para.forcesCategory == GameField.forcesCategory3 then
		imgRes = "caiji0"
	else
		imgRes = "diaoyu0"
	end
	self.panel:setImageTexture("img_tips",IconPath.caiji..imgRes.."1.png")
	Scheduler.PerformWithDelay(self.panel.layer, 1/60, function ()
        nowTim = nowTim + 1/60
        nowChangeTipsTim = nowChangeTipsTim + 1/60
        self.panel:setProgressBarPercent("ProgressBar_time", nowTim/secTim*100)        
        if nowTim >= secTim then
            para.callBack(true)
            self:Release()
        end
        if nowChangeTipsTim >= 0.5 then
            nowChangeTipsTim = 0
            nowIndex = nowIndex + 1
            self.panel:setImageTexture("img_tips",IconPath.caiji..imgRes..(nowIndex%6)..".png")
        end
    end, true)
	
	local function panel_Ontouch(e,x,y)
		para.callBack(false)
		self:Release()
	end
    self.panel.layer:setTouchEnabled(true)
	self.panel.layer:registerScriptTouchHandler(panel_Ontouch,false,0,true)
	
    return self.panel
end

--退出
function CollectionUIPanel:Release()
	self.panel:Release(true)
end

--隐藏
function CollectionUIPanel:Hide()
	self.panel:Hide()
end

--显示
function CollectionUIPanel:Show()
	self.panel:Show()
end