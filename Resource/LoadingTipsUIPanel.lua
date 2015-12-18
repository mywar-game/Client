--Loading Tips

LoadingTipsUIPanel = {}

local stageWidth = UIConfig.stageWidth --舞台
local stageHeight = UIConfig.stageHeight

local winSize = Director.getViewSizeScale()

local midstageWidth = stageWidth/2
local midstageHeight = stageHeight/2

local midWidth = winSize.width/2
local midHeight = winSize.height/2

function LoadingTipsUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function LoadingTipsUIPanel:Create(para)
	local p_name = "LoadingTipsUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
    
	local minValue = 10
	local maxValue = 100
	
    

    self.panel:setProgressBarPercent("pro_progress", minValue/maxValue*100)

    --随机数
    local randNum = math.random(1, 7)
    local strTip = ""

    if randNum == 1 then
        strTip = LabelChineseStr.LoadingTipsUIPanel_1
    elseif randNum == 2 then
        strTip = LabelChineseStr.LoadingTipsUIPanel_2
    elseif randNum == 3 then
        strTip = LabelChineseStr.LoadingTipsUIPanel_3
    elseif randNum == 4 then
        strTip = LabelChineseStr.LoadingTipsUIPanel_4
    elseif randNum == 5 then
        strTip = LabelChineseStr.LoadingTipsUIPanel_5
    elseif randNum == 6 then
        strTip = LabelChineseStr.LoadingTipsUIPanel_6
    elseif randNum == 7 then
        strTip = LabelChineseStr.LoadingTipsUIPanel_7
    end

    --设置Tip内容
    self.panel:setLabelText("lab_tip", "Tip: ".. strTip)

    return self.panel
end

--退出
function LoadingTipsUIPanel:Release()
	self.panel:Release()
end

--隐藏
function LoadingTipsUIPanel:Hide()
	self.panel:Hide()
end

--显示
function LoadingTipsUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end