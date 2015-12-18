require("DataManager")
--提醒类操作管理类
NotificationManager = {}

--创建普通通知
function NotificationManager.createNotification(scale)
	scale = scale or 1
	local notiSprite = CreateCCSprite("common/have_new_task.png")
	notiSprite:setScale(scale)
	local scaleAction = ActionHelper.createScaleActionForever(scale)
	return notiSprite,scaleAction
end

--显示武将，活动，背包
function NotificationManager.showMenuNotification()
	MainMenuUIPanel_showMenuNotification()
end


--刷新刷新通知
function NotificationManager.refreshMenuNotification(targetPanelName)
	
end