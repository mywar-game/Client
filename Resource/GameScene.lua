require("MainMenuUIPanel")
require("TaskGuideUIPanel")
require("UserInfoUIPanel")
require("TaskNoticeUIPanel")
require("Marquee")
require("LoginUIPanel")

GameScene = {}

local stageWidth = UIConfig.stageWidth --舞台
local stageHeight = UIConfig.stageHeight

local winSize = Director.getViewSizeScale()

local midstageWidth = stageWidth/2
local midstageHeight = stageHeight/2

local midWidth = winSize.width/2
local midHeight = winSize.height/2

g_change_battle_array_waterflowcode = 0

function GameScene:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function GameScene:getadapterLayer()
    return self.adapterLayer
end

function GameScene:getRootLayer()
    return self.rootLayer
end

--隐藏和显示
function GameScene:setFootLayerHide(flag)
	 if self.foot_panel then
		self.foot_panel.layer:setVisible(flag)
		self.foot_panel.layer:setTouchEnabled(flag)
	end
end

function GameScene:getFootPanel()
	return self.foot_panel
end

--隐藏和显示
function GameScene:setTopLayerHide(flag)
	if self.head_panel then
		self.head_panel.layer:setVisible(flag)
		self.head_panel.layer:setTouchEnabled(flag)
	end
end

--隐藏和显示
function GameScene:setTaskLayerHide(flag)
	if self.task_panel then
		self.task_panel.layer:setVisible(flag)
		self.task_panel.layer:setTouchEnabled(flag)
	end
end

--隐藏和显示
function GameScene:setMarqueeLayerHide(flag)
	if self.marquee then
		self.marquee:setVisible(flag)
		self.marquee:setTouchEnabled(flag)
	end
end

function GameScene:createAndRun()
    local scene = cc.Scene:create()
    Director.runScene(scene)
	
	local adapterLayer = CreateLayer()
	scene:addChild(adapterLayer)--适配的layer
	self.adapterLayer = adapterLayer
	
	local rootLayer = CreateLayer()--游戏可视的layer
	rootLayer:setContentSize(cc.size(winSize.width,winSize.height))
	rootLayer:setPosition(cc.p(0,0))
	adapterLayer:addChild(rootLayer,2)
    self.rootLayer = rootLayer
   
    --[[
    --测试一下
    local userUI = UserLoginQueueUI:New()
    local userPanel = userUI:Create()
    self.rootLayer:addChild( userPanel.layer, 1000)
    userPanel:Show()
    --]]
    --LayerManager.show("UserLoginQueueUI")
   -- LayerManager.showQueueDialog()

	--背景
    local bg = CreateCCSprite("common/interface_common_bg.png")
    bg:setPosition(midWidth,midHeight)
    rootLayer:addChild(bg)

	local gameLayer = CreateLayer()
	gameLayer:setPosition(cc.p(0,0))
	rootLayer:addChild(gameLayer,2)
	self.gameLayer = gameLayer
	
    --初始化层管理类
	LayerManager.init(self,gameLayer)
    
    local function onLoadingFinishCallback()	
		self:showGameLayer()
    end

    local isEnter = false
    local function enterGame()
        if isEnter == false then
            isEnter = true
            self:showLoadingLayer(onLoadingFinishCallback)
        end
    end

    if Config.isOpenApiAndCheckVersion == true then
        LayerManager.show("LoginUIPanel",enterGame)
    else
        enterGame()
    end

	--键盘事件
    self:registerKeypadHandler(adapterLayer)
end

function GameScene:showLoadingLayer(onLoadingFinishCallback)
    local layer = CreateLayer()

    --背景
    local bg = CreateCCSprite("loading/splash_bg.png")
    bg:setPosition(midWidth,midHeight)
    layer:addChild(bg)
   
    local loading_txt = CreateCCSprite("loading/loading.png")
    loading_txt:setPosition(midWidth,77)
    layer:addChild(loading_txt,4)
    
    --进度条背景
    local loadingbg  = CreateCCSprite("loading/loading_progress_bg.png")
	loadingbg:setPosition(midWidth,77)
    layer:addChild(loadingbg,2)
    
    --进度条
    local loading = cc.ProgressTimer:create(CreateCCSprite("loading/loading_progress_fg.png"))
	loading:setType(1)
	loading:setMidpoint(cc.p(0, 1))
	loading:setBarChangeRate(cc.p(1, 0))
	loading:setPosition(loadingbg:getPosition())
	loading:setPercentage(0)
    layer:addChild(loading,2)
			
    --齿轮
    local gear = CreateCCSprite("loading/chilun.png")
    gear:setPosition(midWidth/2-60,77)
    layer:addChild(gear,3)
	
	local action1 = cc.RepeatForever:create(cc.RotateBy:create(3,1080))
	gear:runAction(action1)
    
    local act = cc.ProgressTo:create(1,50+math.random(30))
	Scheduler.ActionCallback(loading, act,{time = 1,onComplete=function() end})
	Scheduler.PerformWithDelay(scene,0.1,NetInit)
    
    local function loading_over()
        layer:removeFromParent(true)
        onLoadingFinishCallback()
        layer = nil
    end

    function Main_LoadingFinish()
		cclog("LoadingFinish")
        if layer then
			local act = cc.ProgressTo:create(1,100)
			Scheduler.ActionCallback(loading, act ,{time = 1,onComplete=function() loading_over() end })
		end
    end
	self.load_layer = layer
    self.rootLayer:addChild(layer,10)
	
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
    local tipLabel = CreateLabel(num, nil, 20, cc.c3b(255,255,255), 1)
    tipLabel:setString("小提示: ".. strTip)
    tipLabel:setPosition(midWidth-220, 110)
    layer:addChild(tipLabel)

	--显示调试信息
	if Config.debug then
		local function btnFunc()
			Main_cleanLog()
			LayerManager.refreshManualPanel()
		end
		self.rootLayer:addChild(createMenuItem("ui_editor/btn_2.png", "ui_editor/btn_1.png",480,620,btnFunc),1024)
		
		local save = CreateLabel("更新",nil,20,cc.c3b(255,0,0))
		save:setPosition(480,620)
		self.rootLayer:addChild(save,1024)
		
		local function btnFunc1()
			LayerManager.show("TextureShowUIPanel")
		end
		self.rootLayer:addChild(createMenuItem("ui_editor/btn_2.png", "ui_editor/btn_1.png",540,620,btnFunc1),1024)
		
		local save = CreateLabel("内存",nil,20,cc.c3b(255,0,0))
		save:setPosition(540,620)
		self.rootLayer:addChild(save,1024)
	end
	
    --生成文件标识cocos2d已启动，java代码定时轮循该文件。发现文件存在时，则隐藏加载界面
    WriteFile("loadingTagFile","ok")
end

--显示游戏舞台
function GameScene:showGameLayer()
	--顶部用户信息
    local userInfoUIPanelControl = UserInfoUIPanel:New()
    local head_panel = userInfoUIPanelControl:Create({mainScene=scene})
    userInfoUIPanelControl:Show()
	head_panel.layer:setPosition(0,0)
    self.gameLayer:addChild(head_panel.layer,2)
    self.head_panel = head_panel

	--底部导航按钮
	local mainMenuUIPanel = MainMenuUIPanel:New()
    local foot_panel = mainMenuUIPanel:Create()
	foot_panel.layer:setPosition(0,0)
    self.gameLayer:addChild(foot_panel.layer,2)
	self.foot_panel = foot_panel

    --右边任务引导栏
    local taskGuideUIPanel = TaskGuideUIPanel:New()
    local task_panel = taskGuideUIPanel:Create()
    task_panel.layer:setPosition(0,0)
    self.gameLayer:addChild(task_panel.layer,2)
    self.task_panel = task_panel

   --self.rootLayer:addChild(userUI.layer,1000)
   --userUI:Show()

	--[[
	--任务提示
	local taskNoticeUIPanel = TaskNoticeUIPanel:New()
	local task_panel = taskNoticeUIPanel:Create()
	task_panel.layer:setPosition(0,0)
    self.gameLayer:addChild(task_panel.layer,2)
	self.task_panel = task_panel
	]]
	
    --跑马灯
    self.marquee = Marquee.Init()
    self.gameLayer:addChild(self.marquee,2)

    --debug信息
    Debug.show()
	if Config.isShowTile then
		LayerManager.show("geziUIPanel")
	else
		LayerManager.show("TileMapUIPanel")
	end

 -- LayerManager.showQueueDialog()

	
end

--刷新用户信息
function GameScene:refreshUserInfo(delayForUpdateUI)
	if self.head_panel then
        if delayForUpdateUI then
            Scheduler.PerformWithDelay(self.head_panel.layer,delayForUpdateUI,function() self.head_panel.refresh() end)
        else
            self.head_panel.refresh()
        end
    end
	
    if UserInfoDetailPanel_freshUserInfo then
		UserInfoDetailPanel_freshUserInfo()
	end
end

function GameScene:registerKeypadHandler(layer)
    self.isShowingExitConfirmDialog = false

    --退出确认
    function Keypad_confirm_callBack(buttonOrder)    
        if buttonOrder == 1 then --确定
            self.isShowingExitConfirmDialog = false
        else --取消
            Director.exitGame()
            self.isShowingExitConfirmDialog = false
        end
    end

    local function onKeypad(event)
        if event == "backClicked" then
    		if catchBackPressed and catchBackPressed() then
    		else
    			if not self.isShowingExitConfirmDialog then
    				self.isShowingExitConfirmDialog = true
    				LayerManager.showExitDialog(Keypad_confirm_callBack)
    			end
    		end
         end
    end

	layer:setKeyboardEnabled(true)
	layer:registerScriptKeypadHandler(onKeypad)
end



