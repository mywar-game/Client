-- 充值逻辑文件
require("LayerHelper")

WaitingUIPanel = {}

function WaitingUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--开始秒倒计时
function WaitingUIPanel:StartTimer()
	--timer更新界面回调
	local function WaitingUIPanel_Update()
		--更新倒计时数值
		local point = ""
		if math.mod(self.timer_count,4)==0 then
			point = ""
		elseif math.mod(self.timer_count,4)==1 then
			point = "..."
		elseif math.mod(self.timer_count,4)==2 then
			point = ".."
		elseif math.mod(self.timer_count,4)==3 then
			point = "."
		end
		self.timer_count = self.timer_count - 1
		self.panel:setLabelText("lab_txtMsg",self.msg..point)
		
		if self.timer_count <=0 then
			self:showNetworkErrorDialog()
			LayerManager.hideWaiting()
		end
	end
    self.tick_handler = Scheduler.ScheduleScriptFunc(self,WaitingUIPanel_Update, 1, false)
end

--结束秒倒计时
function WaitingUIPanel:StopTimer()
    Scheduler.UnscheduleScriptEntry(self.tick_handler)
end

--显示网络错误对话框
function WaitingUIPanel:showNetworkErrorDialog()
    LayerManager.showDialog(GameString.WaitingUIPanel_1)
end

--初始化入口
function WaitingUIPanel:Create(para)
	cclog("FTGAME+===>>>>>  test");
   	local p_name = "WaitingUI"
	self.panel = Panel:New()
	self.panel:InitPanel(p_name)
    self.timer_count = 22
	self.msg = para or GameString.WaitingUIPanel_1
    self.panel:setLabelText("lab_txtMsg",self.msg)
    
    --[[local waitSprite,waitAnim = ActionHelper.createFrameAnim("loading_waiting_01")
	waitSprite:setPosition(cc.p(320,495))
	waitSprite:runAction(waitAnim)
	self.panel.layer:addChild(waitSprite)]]

    return self.panel
end

--退出
function WaitingUIPanel:Release()
	if self.panel then
		self:StopTimer()
		self.panel.layer:removeFromParent(true)
		self.panel = nil	
	end
end

--隐藏
function WaitingUIPanel:Hide()
	self.panel:Hide()
end

--显示
function WaitingUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerTrue()
end