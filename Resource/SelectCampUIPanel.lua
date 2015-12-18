SelectCampUIPanel = 
{
    panel = nil,
}

function SelectCampUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

--创建
function SelectCampUIPanel:Create(para)
    local p_name = "SelectCampUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	--业务逻辑编写处
	
	local curTime = 0

	local path = "NewUi/xinqietu/chuanjue/chuangjue"
	local armature = CreateSkeleton(path,"chuangjue")
	armature:setPosition(cc.p(-50,-200))
    armature:getAnimation():play("tx")

	local content = self.panel:getChildByName("content")
	content:addChild(armature)

    local titleSprite = CreateCCSprite("NewUi/xinqietu/chuanjue/banner.png")
    titleSprite:setPosition(cc.p(0, 200))
    titleSprite:setAnchorPoint(cc.p(0.5, 0.5))
	content:addChild(titleSprite)
	
	self.panel:setNodeVisible("img_left", false)
	self.panel:setNodeVisible("img_right", false)

	local selectType = 1	
	local function btnCallBtn(sender,tag)
		if tag == 0 then
			selectType = 1
			self.panel:setNodeVisible("img_left", false)
			self.panel:setNodeVisible("img_right", true)
			startTimer()
			--SoundEffect.pauseBackgroundMusic()
			SoundEffect.setBackgrouondMusicVolume(0.3)
			SoundEffect.playSoundEffect("LM")
		elseif tag == 1 then
			selectType = 2
			self.panel:setNodeVisible("img_left", true)
			self.panel:setNodeVisible("img_right", false)
			startTimer()
			--SoundEffect.pauseBackgroundMusic()
			SoundEffect.setBackgrouondMusicVolume(0.3)
			SoundEffect.playSoundEffect("BL")
		elseif tag == 2 then
			LayerManager.show("CreateTeamUIPanel",{selectType=selectType})
		end
	end
	
	--联盟
	self.panel:addNodeTouchEventListener("btn_left",btnCallBtn,0)
	--部落
    self.panel:addNodeTouchEventListener("btn_right",btnCallBtn,1)
	--下一步
	self.panel:addNodeTouchEventListener("btn_qd",btnCallBtn,2)	
	
	SoundEffect.stopBgMusic()
	SoundEffect.playBgMusic("camp")

	--倒计时回调
	function timerCallBack()
		if curTime == 4 then
			--SoundEffect.resumeBackgroundMusic()
			SoundEffect.setBackgrouondMusicVolume(1.0)
			Scheduler.UnscheduleScriptEntry(self.tick_handler)
		end
		curTime = curTime + 1
	end

	--开始秒倒计时
    function startTimer()
    	curTime = 0
    	if self.tick_handler then
    		Scheduler.UnscheduleScriptEntry(self.tick_handler)
    	end
		self.tick_handler = Scheduler.ScheduleScriptFunc(self, timerCallBack, 1, false)
	end
	
	return panel
end
--退出
function SelectCampUIPanel:Release()
	self.panel:Release()
end
--隐藏
function SelectCampUIPanel:Hide()
	self.panel:Hide()
end
--显示
function SelectCampUIPanel:Show()
	self.panel:Show()
end
