--页面控制器


--【概述】界面分为 Panel,DialogPanel,AlertDialog,三层。LayerManager在show时，会根据目标界面统一做如下【操作】清除本身及之上的UI元素，在本层中显示当前UI元素
--【层级关系】
--BG,L1,跑马灯，L2,L3,Waiting,SysDialog,Pointer
--【事件分发优化级】
--与层级关系一致"
--[[接口一览

LayerManager.setTouchEnable(enable)     --设置是否屏蔽触摸事件
LayerManager.addMaskLayer(layer)        --将元素添加到遮罩层，显示级别高于对话框和新手引导
LayerManager.show(panel_name,para)      --显示panel
LayerManager.showDialog(msg, btnNum, callBackFun,iconPathPositive,iconPathNegative,titleImgPath) --显示通用对话框
LayerManager.showSysDialog(msg)                 --显示系统级对话框
LayerManager.showWaiting(msg)
LayerManager.hideWaiting()      
LayerManager.refreshCurrentPanel()              --刷新当前页面
LayerManager.isPanelActive(panelName)           --页面是否活跃
LayerManager.isFloatPanelActive(panelName)		--浮层
LayerManager.refreshUserInfo(delayForUpdateUI)  --刷新用户区域
]]--

LayerManager = {}

require("PointerManager")
require("WaitingUIPanel")
require("DialogUIPanel")
require("JumpFilter")
require("NotificationManager")

require("UserGuideUIPanel")
require("DialogForGuideUIPanel")

local _GameScene
local _WaitingUIPanel

local _ActivePanelControl = nil--当前活动的ui控制器
local _ActivePanelName = nil--当前活动的ui控制器名称
local _ActivePara = nil--当前页面创建时传入的参数

local _FloatPanelControl = nil--当前浮层活动的ui控制器
local _FloatPanelName = nil--当前浮层活动的ui控制器名称
local _FloatPara = nil--当前页面创建时传入的参数

local _ThridPanelControl = nil--当前第三层活动的ui控制器
local _ThridPanelName = nil--当前第三层浮层活动的ui控制器名称
local _ThridPara = nil--当前第三层页面创建时传入的参数

local game_layer
local layer1_bg
local layer2_panel
local layer3_float_panel
local layer3_thrid_panel
local layer4_dialog
local layer5_waiting
local layer6_sys_dialog
local layer7_pointer

local layer_tmp_touch_mask--用于屏蔽触摸事件的层

--以浮层形式显示的panel
local first_panels = {
FightUIPanel=true,
TileMapUIPanel=true,
}

local float_panels = {
TaskUIPanel=true,
PackageUIPanel=true,
FightDropUIPanel=true,
FightDeployUIPanel=true,
TaskDetailsUIPanel=true,
FightResultUIPanel=true,
PrestigeUIPanel=true,
HeroHomeUIPanel=true,
HeroInfoUIPanel=true,
DuplicateUIPanel=true,
HeadSkillUIPanel=true,
UserInfoDetailUIPanel=true,
HeadSkillLearnUIPanel=true,
ExploreUIPanel=true,
ExploreExchangeUIPanel=true,
EmailUIPanel=true,
EmailSenderUIPanel=true,
EmailReceiverUIPanel=true,
FriendUIPanel=true,
ChatUIPanel=true,
PawnShopUIPanel=true,
HearthstoneUIPanel=true,
HeroTeamUIPanel=true,
NpcFunctionUIPanel=true,
DayTaskUIPanel = true,
LifeSkillsUIPanel = true,
LifeSkillsSetUIPanel = true,
SystemSetUIPanel = true,
WorldMapUIPanel = true,
GroceryUIPanel = true,
SystemSetUIPanel = true,
guidPanel = true,
HeroDescUIPanel=true,
NoticeUIPanel = true,
TextureShowUIPanel=true,
ArenaMainUIPanel=true,
EquipRecoveryUIPanel = true,
HeroStarUIPanel=true,
HeroInheritUIPanel=true,
EquipGemUIPanel=true,
EquipEnchantUIPanel = true,
GemSynthesisLookUIPanel = true,
GemSynthesisUIPanel=true,
EquipEnchantForgeUIPanel = true,
EquipForgeLookUIPanel = true,
EquipForgeUIPanel=true,
LoadingTipsUIPanel=true,
AchieveUIPanel=true,
AchieveUIPanel=true,
SignSystemUIPanel = true,
ChangeNameUIPanel = true,
ChartsUIPanel = true,
RepertoryStoreUIPanel = true,
ProfessionUIPanel = true,
ProfessionDetailUIPanel = true,
ProfessionAdvancedUIPanel = true,
FightPasueUIPanel=true,
FriendLineupUIPanel = true,
AssistantUIPanel = true,
MarqueeSenderUIPanel = true,
}

local thrid_panels = {
ArenaHeroUIPanel=true,
ArenaTipsUIPanel=true,
ArenaRankUIPanel=true,
ArenaLogUIPanel=true,
ArenaShopUIPanel=true,
DialogRewardsUIPanel=true,
DialogRewardsNewUIPanel = true,
CollectionUIPanel=true,
ExploreRefreshTipUIPanel=true,
ExploreSelectUIPanel=true,
HeroInfoDetailUIPanel=true,
FriendDetailUIPanel=true,
FriendAddUIPanel=true,
HeadSkillUnLockUIPanel=true,
LifeSkillsChangeUIPanel=true,
LoginServerListUIPanel=true,
PawnNumSelectUIPanel=true,
CreateTeamUIPanel=true,
SwitchSetUIPanel=true,
NotescontactUIPanel=true,
ServerListUIPanel=true,
HeroStoneUIPanel=true,
InputCountUIPanel = true,
FightStatisticsUIPanel=true,
SystemRulerUIPanel = true,
}

local four_panels = {
ToolDetailUIPanel=true,
}

local hide_head_panels = {
FightUIPanel = true,
}

local hide_foot_panels = {
FightUIPanel = true,
}

local hide_task_panels = {
FightUIPanel = true,
}

local marquee_panels = {
    
}

--初始化
function LayerManager.init(game_scene,layer)
    _GameScene = game_scene
    game_layer = layer
    --初始化新手引导

    layer1_bg = cc.Layer:create()
    layer2_noraml_panel = cc.Layer:create()
    layer3_float_panel = cc.Layer:create()
    layer3_thrid_panel = cc.Layer:create()
    layer4_dialog = cc.Layer:create()
    layer4_guide_layer = cc.Layer:create()
    
    layer5_waiting = cc.Layer:create()
    layer6_sys_dialog = cc.Layer:create()
    layer7_pointer = cc.Layer:create()
    layer8_debug = cc.Layer:create()
    
    game_layer:addChild(layer1_bg,1)
    game_layer:addChild(layer2_noraml_panel,20)
    game_layer:addChild(layer3_float_panel,30)
    game_layer:addChild(layer3_thrid_panel,35)
    game_layer:addChild(layer4_dialog,40)
    game_layer:addChild(layer4_guide_layer,45)
    
    --mask_layer 用于浮在所有界面元素上方的内容，添加到49层
    game_layer:addChild(layer5_waiting,50)
    game_layer:addChild(layer6_sys_dialog,60)
    game_layer:addChild(layer7_pointer,70)
    game_layer:addChild(layer8_debug,80)
    
    --添加触摸指示器
    PointerManager.init(layer7_pointer)
end

--获取游戏的根层，此方法用途：
--1.给战斗切白，做场景放大用

function LayerManager.showGameLayer()
    return _GameScene:showGameLayer()
end

function LayerManager.getRootLayer()
    return _GameScene:getRootLayer()
end

function LayerManager.getRootPanel()
    return _GameScene:getFootPanel()
end

--显示新手引导 
function LayerManager.showGUID(idx,pos,isConstraint)
	--UserGuideUIPanel.show(idx,pos,isConstraint)
end

--隐藏和显示
function LayerManager.setFootLayerHide(flag)
    return _GameScene:setFootLayerHide(flag)
end

--隐藏和显示
function LayerManager.setTopLayerHide(flag)
    return _GameScene:setTopLayerHide(flag)
end

--隐藏和显示
function LayerManager.setTaskLayerHide(flag)
    return _GameScene:setTaskLayerHide(flag)
end

--获取游戏层，此方法用途：
--Tips
function LayerManager.getGameLayer()
    return game_layer
end

--设置是否屏蔽触摸事件
function LayerManager.setTouchEnable(enable)
    if not enable then
        if not layer_tmp_touch_mask then
            layer_tmp_touch_mask = cc.Layer:create()
        	layer_tmp_touch_mask:registerScriptTouchHandler(function(e,x,y) return true end,false,-128,true)
        	layer_tmp_touch_mask:setTouchEnabled(true)
            _GameScene:getRootLayer():addChild(layer_tmp_touch_mask)
        end
    else
        if layer_tmp_touch_mask then
            layer_tmp_touch_mask:setTouchEnabled(false)
            layer_tmp_touch_mask:removeFromParent()
            layer_tmp_touch_mask = nil
        end
    end
end

--将元素添加到遮罩层，显示级别高于对话框和新手引导
function LayerManager.addMaskLayer(layer)
    game_layer:addChild(layer,49)
end

--添加到debug层
function LayerManager.addToDebugLayer(layer)
    layer8_debug:addChild(layer,100)
end

--创建新的Panel
local function createNewPanel(layer,targetPanelName,para)
	require(targetPanelName)
	local activePanelControl = loadstring("return "..targetPanelName..":New()")()
	if not activePanelControl then cclog(targetPanelName.." New() Failed") return end
	local activePanel = activePanelControl:Create(para)
	if not activePanel.layer then cclog(targetPanelName.." Create() return a nil layer") return end
	
	activePanelControl:Show()
	layer:addChild(activePanel.layer)
	return activePanelControl
end

--显示第三层panel
local function showThridPanel(targetPanelName,para)
	if _ThridPanelControl then
		_ThridPanelControl:Hide()
		_ThridPanelControl:Release()
	end
	_ThridPara = para
	_ThridPanelName = targetPanelName
	_ThridPanelControl = createNewPanel(layer3_thrid_panel,targetPanelName,para)
	UserGuideUIPanel.showGuide(_ThridPanelControl.panel,nil,targetPanelName)
	return _ThridPanelControl
end

--显示浮层panel
local function showFloatPanel(targetPanelName,para,isAddFloatWin)
	if _FloatPanelControl then
		_FloatPanelControl:Hide()
		_FloatPanelControl:Release()
	end
	
	_FloatPara = para
	_FloatPanelName = targetPanelName
	_FloatPanelControl = createNewPanel(layer3_float_panel,targetPanelName,para)
	UserGuideUIPanel.showGuide(_FloatPanelControl.panel,nil,targetPanelName)
	return _FloatPanelControl
end

--正常
local function showNoramlPanel(targetPanelName,para)        
	if _ActivePanelControl then
		_ActivePanelControl:Hide()
    	_ActivePanelControl:Release()
	end
	
	_ActivePara = para
	_ActivePanelName = targetPanelName
	_ActivePanelControl = createNewPanel(game_layer,targetPanelName,para)
    UserGuideUIPanel.showGuide(_GameScene.foot_panel,nil,targetPanelName)
	return _ActivePanelControl
end

--显示panel(注意isAddFloatWin 使用该项需自行释放窗口)
function LayerManager.show(panel_name,para)
	if four_panels[panel_name] then
		return createNewPanel(layer3_thrid_panel,panel_name,para)
	elseif thrid_panels[panel_name] then--显示第三层panel	
		return showThridPanel(panel_name,para)
    elseif float_panels[panel_name] then --单独处理 带返回
        return showFloatPanel(panel_name,para)	
    else
		if hide_head_panels[panel_name] then
			LayerManager.setTopLayerHide(false)
		else
			LayerManager.setTopLayerHide(true)
		end
		
		if hide_foot_panels[panel_name] then
			LayerManager.setFootLayerHide(false)
		else
			LayerManager.setFootLayerHide(true)
		end
		
		if hide_task_panels[panel_name] then
			LayerManager.setTaskLayerHide(false)
		else
			LayerManager.setTaskLayerHide(true)
		end
		return showNoramlPanel(panel_name,para)
    end
	  NotificationManager.refreshMenuNotification(panel_name)
end

--显示通用对话框
--btnNum:按钮数量(支持1个或2个按钮) callBackFun按钮回调函数
--callBackFun回调参数 1个 para:点击的按钮值
--按钮值（确定：1，关闭：2）
--如果 btnNum, callBackFun 为nil 这默认只有确定按钮 并且无回调
--iconPathPositive 确定按钮文字
--iconPathNegative 取消按钮文字
--titleImgPath标题文字
function LayerManager.showDialog(msg,callBackFun, args)
	local tmpDialogPanel = DialogUIPanel:New()
	tmpDialogPanel:Create(msg,callBackFun,args)	
    tmpDialogPanel:Show()
	layer4_dialog:addChild(tmpDialogPanel.panel.layer,9999)
end

--新手引导的弹出框
function LayerManager.showDialogForGuide(msg,callBackFun)
	local tmpDialogPanel = DialogForGuideUIPanel:New()
	tmpDialogPanel:Create(msg,callBackFun)	
    tmpDialogPanel:Show()
	layer4_dialog:addChild(tmpDialogPanel.panel.layer,9999)
end

--显示系统级对话框
function LayerManager.showSysDialog(msg)
	local dialog = layer6_sys_dialog:getChildByTag(1024)
	if dialog then
		dialog:removeFromParent(true)
	end
	require("ErrorDialogUIPanel")
	local tmpErrorDialogPanel = ErrorDialogUIPanel:New()
	tmpErrorDialogPanel:Create(msg)	
	tmpErrorDialogPanel:Show()
	layer6_sys_dialog:addChild(tmpErrorDialogPanel.panel.layer,1024,1024)
end

--显示退出游戏确认对话框
function LayerManager.showExitDialog(confirm_callBack)
	local dialog = layer6_sys_dialog:getChildByTag(1024)
	if dialog then
		dialog:removeFromParent(true)
	end
    require("EndGameDialogUIPanel")
	local tmpEndGameDialogUIPanel = EndGameDialogUIPanel:New()
	tmpEndGameDialogUIPanel:Create(confirm_callBack)	
    tmpEndGameDialogUIPanel:Show()
	layer6_sys_dialog:addChild(tmpEndGameDialogUIPanel.panel.layer,1024,1024)
end

--显示登陆排队对话框
function LayerManager.showQueueDialog(queue_callBack)
	local dialog = layer6_sys_dialog:getChildByTag(1024)
	if dialog then
		dialog:removeFromParent(true)
	end
    require("UserLoginQueueUIPanel")
    local queueDialog = UserLoginQueueUIPanel:New()
    local queueDialogPanel = queueDialog:Create()
    queueDialog:Show()
    layer6_sys_dialog:addChild(queueDialogPanel.layer,1024,1024) 
end

function LayerManager.showWaiting(msg)
    if _WaitingUIPanel then
        LayerManager.hideWaiting()
    end

    _WaitingUIPanel = WaitingUIPanel:New()
    _WaitingUIPanel:Create(msg)
    _WaitingUIPanel:Show()
    _WaitingUIPanel:StartTimer()--取消30秒倒计时
    layer5_waiting:addChild(_WaitingUIPanel.panel.layer,1023)   
end

function LayerManager.hideWaiting()
     if _WaitingUIPanel then
        _WaitingUIPanel:StopTimer()--取消30秒倒计时
        _WaitingUIPanel:Hide()
        _WaitingUIPanel:Release()
        _WaitingUIPanel = nil
     end
end

--刷新当前页面
function LayerManager.refreshCurrentPanel()
    --更新音乐状态,主要是为了处理ios锁屏导致网络中断，然后重连成功，音乐被恢复的问题
    if isNotPlaySound() then
        SoundEffect.stopBgMusic()
    end
    --例外情况
    --1.当前页面是战斗页不刷新，新手引导不刷新
    if LayerManager.isPanelActive("FightUIPanel") then
        return
    end
	
	if _ThridPanelName then
		LayerManager.show(_ThridPanelName,_ThridPara)
	elseif _FloatPanelName then
		LayerManager.show(_FloatPanelName,_FloatPara)
	elseif _ActivePanelName then
		LayerManager.show(_ActivePanelName,_ActivePara)
	end
end

function LayerManager.refreshManualPanel()
	require("refreshLogicFile")
	local function refresh(n)
		local ui = string.sub(n,1,-6)
		package.loaded[ui] = nil
		package.loaded[n] = nil
		LayerManager.refreshCurrentPanel()
	end
	
	local state = 0
	for n in pairs(_G)do
		local panel = string.sub(n,-7)
		if panel == "UIPanel" then
			local ui = string.sub(n,1,-6)
			package.loaded[ui] = nil
			package.loaded[n] = nil
--			require(ui)
			require(n)
		end
		
		if refreshLogicFile[n] then
			package.loaded[n] = nil
			require(n)
		end
	end
	
	for n in pairs(_G)do
		if _ThridPanelName then
			if n == _ThridPanelName then
				refresh(n)
				break
			end
		elseif _FloatPanelName then
			if n == _FloatPanelName then
				refresh(n)
				break
			end
		else
			if n == _ActivePanelName then
				refresh(n)
				break
			end
		end
	end
end

--返回页面是否活跃
--参数：panelName 当前游戏状态
--返回：false-不活跃 true-活跃
function LayerManager.isPanelActive(panelName)
	return _ActivePanelName == panelName
end

--判断当前浮层
function LayerManager.isFloatPanelActive(panelName)
	return _FloatPanelName == panelName
end

--判断当前浮层
function LayerManager.isThridPanelActive(panelName)
	return _ThridPanelName == panelName
end

--刷新用户区域
function LayerManager.refreshUserInfo(delayForUpdateUI)
    _GameScene:refreshUserInfo(delayForUpdateUI)
end

--转换坐标
function LayerManager.convertToNodeSpace(layer,x,y)
	local covertPos=layer:convertToNodeSpace(cc.p(x,y))
	local covertX=covertPos.x
	local covertY=covertPos.y
	return covertX,covertY
end

--隐藏进度层
function LayerManager.hideLoadLayer()
	_GameScene.load_layer:setVisible(false)
end

function LayerManager.showLoadLayer()
	_GameScene.load_layer:setVisible(true)
end

--删除
function LayerManager.nilPanel(panelName)
	if thrid_panels[panelName] then
		_ThridPara = nil
		_ThridPanelName = nil
		_ThridPanelControl = nil
	elseif float_panels[panelName] then
		_FloatPara = nil
		_FloatPanelName = nil
		_FloatPanelControl = nil
	elseif first_panels[panelName] then
		_ActivePara = nil
		_ActivePanelName = nil
		_ActivePanelControl = nil
	end
end

--手动删除
function LayerManager.manuallyDelete()
	if _ActivePanelControl then
		_ActivePanelControl:Hide()
    	_ActivePanelControl:Release()
    	_ActivePanelControl = nil
	end
end

--关闭浮层
function  LayerManager.closeFloatPanel()
	if _FloatPanelControl then
		_FloatPanelControl:Hide()
		_FloatPanelControl:Release()
		_FloatPanelControl = nil
		_FloatPanelName = nil
	end
end