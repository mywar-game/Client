
--网络响应处理包装
Callback = {}
local function showErrorTip(code)
	local errorStr = ErrorCode[code]
	if errorStr then
		Tips(errorStr)
	else
		Tips(GameString.unknow)
	end
end

function NetResponseHelper_onRecvMessage(key)
	local msgObj = {}
	local head = {}
	local body = {}	
	local inStream = SocketMessage:getInstance():getSocketMessage(key)
	head.ground = inStream:ReadInt()   --错误码
	head.errorCode = inStream:ReadInt()   --错误码
	head.fromType = inStream:ReadShort() --来源类型
	head.fromID = inStream:ReadUTFString() --来源id
	head.toType = inStream:ReadShort() --目的类型
	head.toID = inStream:ReadUTFString() --目的id
	head.msgType =  inStream:ReadShort() --消息类型 1 请求消息 2响应消息 3广播消息
	head.msgSequense = inStream:ReadInt() --消息序列号
	head.cmdCode = inStream:ReadUTFString() --消息接口名称
	head.userSequense = inStream:ReadUTFString() --用户序列号
	head.msgLength = inStream:ReadInt() --用户序列号
	head.priority = inStream:ReadBYTE() --优先
	if head.msgType == 2 then
		LayerManager.hideWaiting()
	end
	
	if head.errorCode == 1000 then
		local exter = ""
		if head.msgType == 2 then
			exter = "Res"
		elseif head.msgType == 3 then
			exter = "Notify"
		end
		cclog("webApi/"..head.cmdCode..exter..".lua")
		if file_exists("webApi/"..head.cmdCode..exter..".lua") then
			local actCls = loadstring("return "..head.cmdCode..exter..":New()")()
			body = actCls:decode(inStream)
		end
		
		msgObj.head = head
		msgObj.body = body
		--cclog("head.cmdCode========================"..head.cmdCode)

		local callAct = loadstring("return Callback."..head.cmdCode)()
		callAct(msgObj)
	else
		if head.cmdCode == "UAction_login" then
			Callback.UAction_login(head.errorCode)
		else
			showErrorTip(head.cmdCode.."_"..head.errorCode)
		end
	end
	inStream:delete()
end

--小助手可领取奖励信息变跟推送
function Callback.Activity_updateActivityTask(msgObj)
	if LayerManager.isPanelActive("AssistantUIPanel") then
		AssistantUIPanel_Activity_updateActivityTask(msgObj)
	end	
end

function Callback.User_midNightPush(msgObj)
	DataManager.setUserMidNightPush(msgObj)
	if LayerManager.isPanelActive("SignSystemUIPanel") then
		sendUserLoginRewardBOReq()
	elseif LayerManager.isPanelActive("AssistantUIPanel") then
		AssistantUIPanel_ActivityAction_reStart()
	end	
end

function Callback.User_push(msgObj)
	DataManager.setUserPush(msgObj)
	Main_LoadingFinish()
end

function Callback.User_pushUserProperties(msgObj)
	DataManager.updateUserProperties(msgObj)
end

function Callback.Scene_enter(msgObj)
	if LayerManager.isPanelActive("TileMapUIPanel") then
		TileMapUIPanel_Scene_enter(msgObj)
	end
end

function Callback.Scene_exit(msgObj)
	if LayerManager.isPanelActive("TileMapUIPanel") then
		TileMapUIPanel_Scene_exit(msgObj)
	end
end

function Callback.Scene_move(msgObj)
	if LayerManager.isPanelActive("TileMapUIPanel") then
		TileMapUIPanel_Scene_move(msgObj)
	end
end

function Callback.Task_update(msgObj)
	DataManager.updateTask(msgObj.body.updateUserTaskList)
	MainMenuUIPanel_updateMainlineTask()
	
	if LayerManager.isPanelActive("TileMapUIPanel") then
		TileMapUIPanel_Task_update(msgObj)
	end
	
	if LayerManager.isFloatPanelActive("TaskUIPanel") then
		TaskUIPanel_Task_update(msgObj)
	end

    if LayerManager.isFloatPanelActive("DayTaskUIPanel") then
		DayTaskUIPanel_Task_update(msgObj)
    end
end

function Callback.user_logout(msgObj)
	NetEventHandler.isAutoConn = false
end	

function Callback.UAction_login(errorCode)
	if errorCode == 1001 then
		
	elseif errorCode == 2001 then
		LayerManager.hideLoadLayer()
		LayerManager.show("SelectCampUIPanel")
	elseif errorCode == 2002 then
	
	elseif errorCode == 3000 then
		Tips(GameString.loginFail)
	end
end

function Callback.UserAction_creat(msgObj)
	if LayerManager.isThridPanelActive("CreateTeamUIPanel") then
		CreateTeamUIPanel_UserAction_creat(msgObj)
	end
end

function Callback.UserAction_changeUserName(msgObj)
	DataManager.setUserBoName(msgObj.body.name)
	DataManager.replaceMoney(msgObj.body.money)
	if 0 ~= tonumber(msgObj.body.toolId) then
		DataManager.reduceUserTool(msgObj.body.toolId, 1)
	end
	if LayerManager.isPanelActive("TileMapUIPanel") then
		TileMapUIPanel_ChangeUserHeroName(msgObj.body.name)
	end
	if LayerManager.isFloatPanelActive("ChangeNameUIPanel") then
		ChangeNameUIPanel_UserAction_changeUserName(msgObj)
	end
end

function Callback.ForcesAction_attack(msgObj)
	if LayerManager.isFloatPanelActive("FightDeployUIPanel") then
		FightDeployUIPanel_ForcesAction_attack(msgObj)
        return
	end
	
	if LayerManager.isFloatPanelActive("FightResultUIPanel") then
		FightResultUIPanel_ForcesAction_attack(msgObj)
		return
	end

    if LayerManager.isPanelActive("TileMapUIPanel") then
        TileMapUIPanel_ForcesAction_attack(msgObj)
    end
end

function Callback.ForcesAction_endAttack(msgObj)
	if LayerManager.isPanelActive("FightUIPanel") then
		DataManager.updateCommonGoods(msgObj)
		FightUIPanel_ForcesAction_endAttack(msgObj)
	end
end

function Callback.ForcesAction_cancelCollect(msgObj)
	
end

function Callback.SceneAction_loaded(msgObj)
	if LayerManager.isPanelActive("TileMapUIPanel") then
		TileMapUIPanel_SceneAction_loaded(msgObj)
	end
end

function Callback.SceneAction_enter(msgObj)
	if LayerManager.isPanelActive("TileMapUIPanel") then
		TileMapUIPanel_SceneAction_enter(msgObj)
	end
end

function Callback.HeroAction_changeHeroPos(msgObj)
	DataManager.replaceBattleHero(msgObj.body.updateHeroList)
	if LayerManager.isFloatPanelActive("HeroTeamUIPanel") then
		HeroTeamUIPanel_HeroAction_changeHeroPos(msgObj)
    elseif LayerManager.isFloatPanelActive("FightDeployUIPanel") then
		FightDeployUIPanel_HeroAction_changeHeroPos(msgObj)
	end 
end

function Callback.HeroAction_autoAmenb(msgObj)
	DataManager.replaceBattleHero(msgObj.body.updateHeroList)
	if LayerManager.isFloatPanelActive("HeroTeamUIPanel") then
		HeroTeamUIPanel_HeroAction_autoAmenb(msgObj)
    elseif LayerManager.isFloatPanelActive("FightDeployUIPanel") then
		FightDeployUIPanel_HeroAction_autoAmenb(msgObj)
	end
end

function Callback.HeroAction_changeSkillPos(msgObj)
	DataManager.updateUserHeroSkill(msgObj.body.updateHeroSkillPosList)
	if LayerManager.isFloatPanelActive("HeroTeamUIPanel") then
		HeroTeamUIPanel_HeroAction_changeSkillPos(msgObj)
    elseif LayerManager.isFloatPanelActive("FightDeployUIPanel") then
		FightDeployUIPanel_HeroAction_changeSkillPos(msgObj)
	end 
end

function Callback.TaskAction_addTask(msgObj)
	if LayerManager.isFloatPanelActive("TaskDetailsUIPanel") then
		TaskDetailsUIPanel_TaskAction_addTask(msgObj)
    elseif LayerManager.isFloatPanelActive("DayTaskUIPanel") then
		DayTaskUIPanel_TaskAction_addTask(msgObj)
	end 
end

function Callback.TaskAction_receiveTask(msgObj)
    DataManager.updateCommonGoods(msgObj)
	MainMenuUIPanel_updateMainlineTask()
	if LayerManager.isFloatPanelActive("TaskDetailsUIPanel") then
		TaskDetailsUIPanel_TaskAction_receiveTask(msgObj)
    elseif LayerManager.isFloatPanelActive("DayTaskUIPanel") then
		DayTaskUIPanel_TaskAction_receiveTask(msgObj)
	end 
end

function Callback.TaskAction_dropTask(msgObj)
	if LayerManager.isFloatPanelActive("TaskUIPanel") then
		
	end 
end

function Callback.PrestigeAction_inviteHero(msgObj)
	DataManager.replaceGold(msgObj.body.gold)
    DataManager.replaceMoney(msgObj.body.money)
	DataManager.updateCommonGoods(msgObj)	
	if LayerManager.isFloatPanelActive("PrestigeUIPanel") then
		PrestigeUIPanel_PrestigeAction_inviteHero(msgObj)
	end 
end
--团长技能学习
function Callback.HeroAction_studyLeaderSkill(msgObj)
    DataManager.addUserHeroSkill(msgObj.body.userHeroSkillBO)
    --更新金币及钻石
    DataManager.replaceGold(msgObj.body.gold)
    DataManager.replaceMoney(msgObj.body.money)
    UserInfoUIPanel_refresh()
    if LayerManager.isFloatPanelActive("HeadSkillUIPanel") then
	   HeadSkillUIPanel_HeroAction_studyLeaderSkill()
    end
end
--团长技能升级
function Callback.HeroAction_upgradeLeaderSkill(msgObj)
    --更新团长技能
    DataManager.updateUserHeroSkillLevelAndExp(msgObj.body.userHeroSkillId,msgObj.body.skillLevel,msgObj.body.skillExp)
	
	--更新金币
    DataManager.replaceGold(msgObj.body.gold)
    UserInfoUIPanel_refresh()
	
    --更新消耗的道具
	local skillToolBOList = msgObj.body.skillToolBOList
    for k=1,#skillToolBOList do
		DataManager.reduceUserTool(skillToolBOList[k].toolId,skillToolBOList[k].toolNum)
    end
	 
	if LayerManager.isFloatPanelActive("HeadSkillLearnUIPanel") then
	   HeadSkillLearnUIPanel_HeroAction_upgradeLeaderSkill(msgObj)
    end
end

function Callback.ForcesAction_getCopyForcesInfo(msgObj)	
	DataManager.setUserBigForceBo(msgObj.body.userForcesList)
	if LayerManager.isFloatPanelActive("FightDropUIPanel") then
	   FightDropUIPanel_ForcesAction_getCopyForcesInfo(msgObj)
    end
end

--探索(主界面)
function Callback.ExploreAction_getUserExploreInfo(msgObj)
    if LayerManager.isFloatPanelActive("ExploreUIPanel") then
        ExploreUIPanel_ExploreAction_getUserExploreInfo(msgObj)
    end
end

function Callback.ExploreAction_exchange(msgObj)
    if LayerManager.isFloatPanelActive("ExploreExchangeUIPanel") then
		DataManager.updateCommonGoods(msgObj)
        ExploreExchangeUIPanel_ExploreAction_exchange(msgObj)
    end
end

function Callback.ExploreAction_refreshMap(msgObj)
    if LayerManager.isFloatPanelActive("ExploreUIPanel") then
        DataManager.replaceMoney(msgObj.body.money)
		UserInfoUIPanel_refresh()
        ExploreUIPanel_ExploreAction_refreshMap(msgObj)
    end
end

function Callback.ExploreAction_explore(msgObj)
	DataManager.updateCommonGoods(msgObj)
    if LayerManager.isFloatPanelActive("ExploreUIPanel") then
        ExploreUIPanel_ExploreAction_explore(msgObj)
    end
end

function Callback.ExploreAction_autoRefresh(msgObj)
    if LayerManager.isFloatPanelActive("ExploreUIPanel") then
        DataManager.replaceMoney(msgObj.body.mon)
        UserInfoUIPanel_refresh()
        ExploreUIPanel_ExploreAction_autoRefresh(msgObj)
    end
end

--email邮件
--获取邮件列表
function Callback.MailAction_getMailList(msgObj)
    if LayerManager.isFloatPanelActive("EmailUIPanel") then
        EmailUIPanel_MailAction_getMailList(msgObj)
    end
end

--读取邮件
function Callback.MailAction_read(msgObj)
    if LayerManager.isFloatPanelActive("EmailUIPanel") then
        EmailUIPanel_MailAction_read(msgObj)
    end
end

--领取邮件附件
function Callback.MailAction_receive(msgObj)
    if LayerManager.isFloatPanelActive("EmailReceiverUIPanel") then
		DataManager.updateCommonGoods(msgObj)
        EmailReceiverUIPanel_MailAction_receive(msgObj)
    end
end

--发送邮件
function Callback.MailAction_sendEmail(msgObj)
    if LayerManager.isFloatPanelActive("EmailSenderUIPanel") then
        EmailSenderUIPanel_MailAction_sendEmail(msgObj)
    end
end

--删除邮件
function Callback.MailAction_delete(msgObj)
    if LayerManager.isFloatPanelActive("EmailUIPanel") then
        EmailUIPanel_MailAction_delete(msgObj)
	elseif LayerManager.isFloatPanelActive("EmailReceiverUIPanel") then
		EmailReceiverUIPanel_MailAction_delete(msgObj)
    end
end

--一键领取邮件附件
function Callback.MailAction_oneClickReceive(msgObj)
    if LayerManager.isFloatPanelActive("EmailUIPanel") then
		DataManager.updateCommonGoods(msgObj)
        EmailUIPanel_MailAction_oneClickReceive(msgObj)
    end
end

--邮件审核好友
function Callback.FriendAction_auditApply(msgObj)
    if LayerManager.isFloatPanelActive("EmailReceiverUIPanel") then
        EmailReceiverUIPanel_FriendAction_auditApply(msgObj)
    end
end

--邮件来袭推送(仅负责相应notify)
function Callback.Mail_pushNewEmail(msgObj)
    if LayerManager.isFloatPanelActive("EmailUIPanel") then
        EmailUIPanel_Response_PushNotify(GameField.PushNotify_Email, msgObj)
    else
        MainMenuUIPanel_Response_PushNotify(GameField.PushNotify_Email, msgObj)
    end
end

--获取好友
function Callback.FriendAction_getUserFriendList(msgObj)
    if LayerManager.isFloatPanelActive("FriendUIPanel") then
        FriendUIPanel_FriendAction_getUserFriendListReq(msgObj)
    elseif LayerManager.isFloatPanelActive("EmailSenderUIPanel") then
        EmailSenderUIPanel_FriendAction_getUserFriendList(msgObj)
    elseif LayerManager.isFloatPanelActive("ChatUIPanel") then
        ChatUIPanel_FriendAction_getUserFriendList(msgObj)
	elseif LayerManager.isFloatPanelActive("LifeSkillsSetUIPanel") then
		LifeSkillsSetUIPanel_FriendAction_getUserFriendList(msgObj)
    end
end

--获取黑名单
function Callback.FriendAction_getUserBlackList(msgObj)
    if LayerManager.isFloatPanelActive("FriendUIPanel") then
        FriendUIPanel_FriendAction_getUserBlackList(msgObj)
    end
end

--显示好友阵容
function Callback.HeroAction_getUserBattleInfo(msgObj)
    if LayerManager.isFloatPanelActive("FriendLineupUIPanel") then
        FriendLineupUIPanel_HeroAction_getUserBattleInfo(msgObj)
    end
end

--申请添加好友
function Callback.FriendAction_applyFriend(msgObj)
    if LayerManager.isFloatPanelActive("FriendUIPanel") then
        FriendUIPanel_FriendAction_applyFriend(msgObj)
    elseif LayerManager.isFloatPanelActive("ChatUIPanel") then
        ChatUIPanel_FriendAction_applyFriend(msgObj)
    end
end

--添加进黑名单
function Callback.FriendAction_addBlack(msgObj)
    if LayerManager.isFloatPanelActive("FriendUIPanel") then
        FriendUIPanel_FriendAction_addBlack(msgObj)
    elseif LayerManager.isFloatPanelActive("ChatUIPanel") then
        ChatUIPanel_FriendAction_addBlack(msgObj)
    end
end

--移除黑名单
function Callback.FriendAction_deleteBlack(msgObj)
    if LayerManager.isFloatPanelActive("FriendUIPanel") then
        FriendUIPanel_FriendAction_deleteBlack(msgObj)
    end
end

--获取可邀请参战的玩家(大部分为好友)
function Callback.FriendAction_getJoinBattleUserList(msgObj)
    if LayerManager.isFloatPanelActive("FightDeployUIPanel") then
		local battleUserList = {}
		for k,v in pairs(msgObj.body.battleUserList)do
			local hero = DataTranslater.tranFriendHero(v)
			table.insert(battleUserList,hero)
		end
        FightDeployUIPanel_FriendAction_getJoinBattleUserList(battleUserList)
    end
end

--聊天
--发送世界聊天
function Callback.ChatAction_worldOfChat(msgObj)
    DataManager.insertChatMsg(msgObj.body.userChatRecordBO.type, msgObj.body.userChatRecordBO)
    --主界面MainMenuUIPanel
    MainMenuUIPanel_Chat_pushChatInfo(msgObj)
    if LayerManager.isFloatPanelActive("ChatUIPanel") then
        ChatUIPanel_Chat_pushChatInfo(msgObj)
    end
end

--发送附近聊天
function Callback.ChatAction_nearbyOfChat(msgObj)
    DataManager.insertChatMsg(msgObj.body.userChatRecordBO.type, msgObj.body.userChatRecordBO)
    --主界面MainMenuUIPanel
    MainMenuUIPanel_Chat_pushChatInfo(msgObj)
    if LayerManager.isFloatPanelActive("ChatUIPanel") then
        ChatUIPanel_Chat_pushChatInfo(msgObj)
    end
end

--发送私聊
function Callback.ChatAction_privateOfChat(msgObj)
    DataManager.insertChatMsg(msgObj.body.userChatRecordBO.type, msgObj.body.userChatRecordBO)
    --主界面MainMenuUIPanel
    MainMenuUIPanel_Chat_pushChatInfo(msgObj)
    if LayerManager.isFloatPanelActive("ChatUIPanel") then
        ChatUIPanel_Chat_pushChatInfo(msgObj)
    end
end

--发送阵营聊天
function Callback.ChatAction_campOfChat(msgObj)
    DataManager.insertChatMsg(msgObj.body.userChatRecordBO.type, msgObj.body.userChatRecordBO)
	MainMenuUIPanel_Chat_pushChatInfo(msgObj)
    if LayerManager.isFloatPanelActive("ChatUIPanel") then
        ChatUIPanel_Chat_pushChatInfo(msgObj)
    end
end

--获取聊天记录(主界面)
function Callback.ChatAction_getChatRecord(msgObj)
    --暂时弃用
end

--推送聊天记录
function Callback.Chat_pushChatInfo(msgObj)
    DataManager.insertChatMsg(msgObj.body.userChatRecordBO.type, msgObj.body.userChatRecordBO)
    --主界面MainMenuUIPanel
	MainMenuUIPanel_Chat_pushChatInfo(msgObj)
	if LayerManager.isPanelActive("TileMapUIPanel") then
		TileMapUIPanel_Chat_pushChatInfo(msgObj)
	end
    
    if LayerManager.isFloatPanelActive("ChatUIPanel") then
        ChatUIPanel_Chat_pushChatInfo(msgObj)
    end
end

--当铺
--获取当铺信息
function Callback.PawnshopAction_getPawnshopInfo(msgObj)
    if LayerManager.isFloatPanelActive("PawnShopUIPanel") then
        PawnShopUIPanel_PawnshopAction_getPawnshopInfo(msgObj)
    end
end

--当铺买入
function Callback.PawnshopAction_buyIn(msgObj)
    if LayerManager.isFloatPanelActive("PawnShopUIPanel") then
        DataManager.updateCommonGoods(msgObj)
        PawnShopUIPanel_PawnshopAction_buyIn(msgObj)
    end
end

--当铺卖出
function Callback.PawnshopAction_sell(msgObj)
    if LayerManager.isFloatPanelActive("PawnShopUIPanel") then
		DataManager.updateCommonGoods(msgObj)
        PawnShopUIPanel_PawnshopAction_sell(msgObj)
    end
end

--穿戴装备
function Callback.EquipAction_wearEquip(msgObj)
	DataManager.updateUserEquip(msgObj.body.userEquipBOList)
    if LayerManager.isFloatPanelActive("HeroDescUIPanel") then
        HeroDescUIPanel_EquipAction_wearEquip(msgObj)
    end
end

--卸下装备
function Callback.EquipAction_unWearEquip(msgObj)
	DataManager.updateUserEquip({msgObj.body.userEquipBO})
    if LayerManager.isFloatPanelActive("HeroDescUIPanel") then       
        HeroDescUIPanel_EquipAction_unWearEquip(msgObj)
    end
end

--遣散英雄
function Callback.HeroAction_disband(msgObj)
    if LayerManager.isFloatPanelActive("HeroDescUIPanel") then
		HeroDescUIPanel_HeroAction_disband(msgObj)
	end
end

--跑马灯推送
function Callback.Message_pushMessage(msgObj)
    Marquee.pushData(msgObj.body.messageList)
end

--删除背包里面的物品
function Callback.PackAction_abandonTool(msgObj)
	local function checkTrue()
		local uiPanel = {"HeroDescUIPanel", "GroceryUIPanel", "EquipEnchantForgeUIPanel","GemSynthesisLookUIPanel", "EquipRecoveryUIPanel", "EquipForgeLookUIPanel"}
		for k, v in pairs(uiPanel) do
			if LayerManager.isFloatPanelActive(v) then
				return true
			end
		end
		return false
	end
    if checkTrue() then
        PackageUIPanel_PackAction_abandonTool(msgObj)
    end
end

--道具使用 宝箱
function Callback.ToolAction_openBox(msgObj)
	DataManager.updateCommonGoods(msgObj)
	for k, v in pairs(msgObj.body.toolList)	do	
		DataManager.reduceUserTool(v.goodsId, v.goodsNum)
	end
    if LayerManager.isFloatPanelActive("HeroDescUIPanel") or
	   LayerManager.isFloatPanelActive("GroceryUIPanel") then
        PackageUIPanel_ToolAction_openBox(msgObj)
    end
	
	--特殊处理可能嗑药所以也要更新英雄界面
	if LayerManager.isFloatPanelActive("HeroDescUIPanel") then
		HeroInfoUIPanel_ToolAction_openBox(msgObj)
	end
end

--仓库存入或者取出
function Callback.PackAction_storehouseInOrOut(msgObj)
	DataManager.dumpRepertoryAndPackage(msgObj.body)
    if LayerManager.isFloatPanelActive("RepertoryStoreUIPanel") then
        RepertoryStoreUIPanel_PackAction_storehouseInOrOut(msgObj)
    end
end

--仓库扩展背包
function Callback.PackAction_extendStorehouse(msgObj)
	DataManager.updateStoreHouse(msgObj.body.extendNum)
	DataManager.replaceMoney(msgObj.body.money)
    if LayerManager.isFloatPanelActive("RepertoryStoreUIPanel") then
        RepertoryStoreUIPanel_PackAction_extendStorehouse(msgObj)
    end
end

--道具扩展格子
function Callback.PackAction_extendPack(msgObj)
	DataManager.updateCommonGoods(msgObj)
    if LayerManager.isFloatPanelActive("HeroDescUIPanel") or 
	   LayerManager.isFloatPanelActive("GroceryUIPanel") then
        PackageUIPanel_PackAction_extendPack(msgObj)
    end
end

--提交任务
function Callback.TaskAction_commitTask(msgObj)
	DataManager.updateSingleTask(msgObj.body.systemTaskId,msgObj.body.status)
	if LayerManager.isPanelActive("TileMapUIPanel") then
        TileMapUIPanel_TaskAction_commitTask(msgObj)
    end
end

--日常任务
function Callback.TaskAction_getUserDailyTaskInfo(msgObj)
    if LayerManager.isFloatPanelActive("DayTaskUIPanel") then
        DayTaskUIPanel_TaskAction_getUserDailyTaskInfo(msgObj)
    end
end

--日常任务一键刷新
function Callback.TaskAction_oneClickRefresh(msgObj)
    if LayerManager.isFloatPanelActive("DayTaskUIPanel") then
        DayTaskUIPanel_TaskAction_oneClickRefresh(msgObj)
    end
end

--日常任务一键五星
function Callback.TaskAction_refreshFiveStar(msgObj)
    if LayerManager.isFloatPanelActive("DayTaskUIPanel") then
        DayTaskUIPanel_TaskAction_refreshFiveStar(msgObj)
    end
end

--获取用户生活技能信息
function Callback.LifeAction_getUserLifeInfo(msgObj)
	DataManager.setLifeSkillsInfo(msgObj)
    if LayerManager.isFloatPanelActive("LifeSkillsUIPanel") then
        LifeSkillsUIPanel_LifeAction_getUserLifeInfo(msgObj)
    end
end

--建造用户生活建筑
function Callback.LifeAction_createLifeBuilder(msgObj)
	local lifeConfig = DataManager.getLifeConfig(msgObj.body.userLifeInfoBO.category)
	DataManager.addMoney(-lifeConfig.money)
	DataManager.addGold(-lifeConfig.gold)
	UserInfoUIPanel_refresh()
	
	if LayerManager.isFloatPanelActive("LifeSkillsUIPanel") then
        LifeSkillsUIPanel_LifeAction_createLifeBuilder(msgObj)
    end
end

--重新建造用户生活建筑
function Callback.LifeAction_reCreateLifeBuilder(msgObj)
	local lifeConfig = DataManager.getLifeConfig(msgObj.body.userLifeInfoBO.category)
	DataManager.addMoney(-lifeConfig.money)
	DataManager.addGold(-lifeConfig.gold)
	UserInfoUIPanel_refresh()
	
	if LayerManager.isFloatPanelActive("LifeSkillsUIPanel") then
        LifeSkillsUIPanel_LifeAction_reCreateLifeBuilder(msgObj)
    end
end

--开始挂机
function Callback.LifeAction_hangup(msgObj)
	local heroState = GameField.heroStatus1
	if msgObj.body.userLifeInfoBO.category == 1 then
		heroState = GameField.heroStatus3
	elseif msgObj.body.userLifeInfoBO.category == 2 then
		heroState = GameField.heroStatus4
	elseif msgObj.body.userLifeInfoBO.category == 3 then
		heroState = GameField.heroStatus5
	end
	DataManager.setHeroStatus(msgObj.body.userLifeInfoBO.userHeroId1,heroState)
	DataManager.setHeroStatus(msgObj.body.userLifeInfoBO.userHeroId2,heroState)
	DataManager.setHeroStatus(msgObj.body.userLifeInfoBO.userHeroId3,heroState)
	
	if LayerManager.isFloatPanelActive("LifeSkillsSetUIPanel") then
        LifeSkillsSetUIPanel_LifeAction_hangup(msgObj)
    end
end

--取消挂机
function Callback.LifeAction_cancelHangup(msgObj)
	DataManager.setHeroStatus(msgObj.body.userLifeInfoBO.userHeroId1,GameField.heroStatus1)
	DataManager.setHeroStatus(msgObj.body.userLifeInfoBO.userHeroId2,GameField.heroStatus1)
	DataManager.setHeroStatus(msgObj.body.userLifeInfoBO.userHeroId3,GameField.heroStatus1)
	if LayerManager.isFloatPanelActive("LifeSkillsSetUIPanel") then
        LifeSkillsUIPanel_LifeAction_cancelHangup(msgObj)
    end
end

--领取挂机奖励
function Callback.LifeAction_receiveReward(msgObj)
	DataManager.updateCommonGoods(msgObj)
	DataManager.setHeroStatus(msgObj.body.userLifeInfoBO.userHeroId1,GameField.heroStatus1)
	DataManager.setHeroStatus(msgObj.body.userLifeInfoBO.userHeroId2,GameField.heroStatus1)
	DataManager.setHeroStatus(msgObj.body.userLifeInfoBO.userHeroId3,GameField.heroStatus1)
	if LayerManager.isFloatPanelActive("LifeSkillsSetUIPanel") then
        LifeSkillsSetUIPanel_LifeAction_receiveReward(msgObj)
    end
end

--预览挂机奖励
function Callback.LifeAction_getHangupRewardList(msgObj)
    if LayerManager.isFloatPanelActive("LifeSkillsSetUIPanel") then
        LifeSkillsSetUIPanel_LifeAction_getHangupRewardList(msgObj)
    end
end

--更换上阵英雄
function Callback.HeroAction_changeTeamLeader(msgObj)
    if LayerManager.isFloatPanelActive("HeroTeamUIPanel") then
        HeroTeamUIPanel_HeroAction_changeTeamLeader(msgObj)
    end
end

--意见提交
function Callback.SettingAction_commitAdvice(msgObj)
	if LayerManager.isThridPanelActive("SystemSetUIPanel") then		
		NotescontactUIPanel_SettingAction_commitAdvice(msgObj)
	end
end

--商店买入
function Callback.MallAction_buyIn(msgObj)
    if LayerManager.isFloatPanelActive("GroceryUIPanel") then		
		DataManager.updateCommonGoods(msgObj)
		GroceryUIPanel_MallAction_buyIn(msgObj)
	end
end

--商店出售
function Callback.MallAction_sell(msgObj)
    if LayerManager.isFloatPanelActive("GroceryUIPanel") then		
		DataManager.updateCommonGoods(msgObj)
		GroceryUIPanel_MallAction_sell(msgObj)
	end
end

--获取回购列表
function Callback.MallAction_getBuyBackList(msgObj)
    if LayerManager.isFloatPanelActive("GroceryUIPanel") then		
		GroceryUIPanel_MallAction_getBuyBackList(msgObj)
	end
end

--回购
function Callback.MallAction_buyBack(msgObj)
    if LayerManager.isFloatPanelActive("GroceryUIPanel") then		
		DataManager.updateCommonGoods(msgObj)
		GroceryUIPanel_MallAction_buyBack(msgObj)
	end
end

--获取采集以及打怪的奖励
function Callback.ForcesAction_getCollectFightReward(msgObj)
    if LayerManager.isPanelActive("FightUIPanel") then
		DataManager.updateCommonGoods(msgObj)--不一定有
		FightUIPanel_ForcesAction_getCollectFightReward(msgObj)
	end
end

--开始采集
function Callback.ForcesAction_startCollect(msgObj)
    if LayerManager.isPanelActive("TileMapUIPanel") then
        TileMapUIPanel_ForcesAction_startCollect(msgObj)
    end
end

--结束采集
function Callback.ForcesAction_endCollect(msgObj)
    if LayerManager.isPanelActive("TileMapUIPanel") then
        if msgObj.body.isFightAgain == 0 then
		    DataManager.updateCommonGoods(msgObj)
        end
        TileMapUIPanel_ForcesAction_endCollect(msgObj)
    end
end

--获取地图矿场信息
function Callback.ForcesAction_getMapCollectionInfo(msgObj)
    if LayerManager.isPanelActive("TileMapUIPanel") then
        TileMapUIPanel_ForcesAction_getMapCollectionInfo(msgObj)
    end

end

--获取新手引导回调
function Callback.UserAction_recordGuideStep(msgObj)

end

--激活传送阵
function Callback.UserAction_recordOpenMap(msgObj)
    if LayerManager.isPanelActive("TileMapUIPanel") then
        TileMapUIPanel_UserAction_recordOpenMap(msgObj)
    end
end

--复活
function Callback.ForcesAction_relive(msgObj)
	if LayerManager.isPanelActive("FightUIPanel") then
		DataManager.replaceGold(msgObj.body.gold)
		DataManager.replaceMoney(msgObj.body.money)
        FightUIPanel_ForcesAction_relive()
    end
end

--首次进入竞技场
function Callback.PkAction_enterPk(msgObj)
	if LayerManager.isFloatPanelActive("ArenaMainUIPanel") then
		ArenaMainUIPanel_PkAction_enterPk(msgObj)
    end
end

--查看排行榜
function Callback.PkAction_getPkRank(msgObj)
	if LayerManager.isThridPanelActive("ArenaRankUIPanel") then
		ArenaRankUIPanel_PkAction_getPkRank(msgObj)
    end
end

--获取用户兑换奖励信息
function Callback.PkAction_getUserPkMallInfo(msgObj)
	if LayerManager.isThridPanelActive("ArenaShopUIPanel") then
		ArenaShopUIPanel_PkAction_getUserPkMallInfo(msgObj)
    end
end

--战斗日志
function Callback.PkAction_getPkFightLog(msgObj)
	if LayerManager.isThridPanelActive("ArenaLogUIPanel") then
		ArenaLogUIPanel_PkAction_getPkFightLog(msgObj)
    end
end

--兑换商品
function Callback.PkAction_exchange(msgObj)
	DataManager.updateCommonGoods(msgObj)
	if LayerManager.isThridPanelActive("ArenaShopUIPanel") then
		ArenaShopUIPanel_PkAction_exchange(msgObj)
    end
end

--上阵、下阵防守阵营
function Callback.PkAction_changePos(msgObj)
	if LayerManager.isThridPanelActive("ArenaHeroUIPanel") then
		ArenaHeroUIPanel_PkAction_changePos(msgObj)
    end
end

--重置等待时间
function Callback.PkAction_resetWaitingTime(msgObj)
	if LayerManager.isFloatPanelActive("ArenaMainUIPanel") then
		ArenaMainUIPanel_PkAction_resetWaitingTime(msgObj)
    end
end

--换一批
function Callback.PkAction_refreshChallenger(msgObj)
	if LayerManager.isFloatPanelActive("ArenaMainUIPanel") then
		ArenaMainUIPanel_PkAction_refreshChallenger(msgObj)
    end
end

--购买挑战次数
function Callback.PkAction_buyChallengeTimes(msgObj)
	if LayerManager.isFloatPanelActive("ArenaMainUIPanel") then
		ArenaMainUIPanel_PkAction_buyChallengeTimes(msgObj)
    end
end

--开始竞技场战斗
function Callback.PkAction_startPkFight(msgObj)
	if LayerManager.isFloatPanelActive("ArenaMainUIPanel") then
		ArenaMainUIPanel_PkAction_startPkFight(msgObj)
    end
end

--结束竞技场战斗
function Callback.PkAction_endPkFight(msgObj)
	if LayerManager.isPanelActive("FightUIPanel") then
		DataManager.updateCommonGoods(msgObj)
		FightUIPanel_PkAction_endPkFight(msgObj)
	end
end

--设置用户每日提示
function Callback.SettingAction_setDailyTips()

end


-- 装备锻造， 矿石熔炼， 药草淬炼
function Callback.EquipAction_equipForge(msgObj)
	DataManager.replaceGold(msgObj.body.gold)
	DataManager.replaceMoney(msgObj.body.money)
	DataManager.updateCommonGoods(msgObj)
	if LayerManager.isFloatPanelActive("EquipForgeUIPanel") then
		EquipForgeUIPanel_EquipAction_equipForge(msgObj)
	elseif LayerManager.isFloatPanelActive("EquipForgeLookUIPanel") then 
		EquipForgeLookUIPanel_EquipAction_equipForge(msgObj)
	elseif LayerManager.isFloatPanelActive("EquipEnchantForgeUIPanel")  then
		EquipEnchantForgeUIPanel_EquipAction_equipForge(msgObj)
	end	
end

function Callback.EquipAction_equipRecycle(msgObj)
	if nil ~= msgObj.body.gold then
		DataManager.replaceGold(msgObj.body.gold)
	end
	if nil ~= msgObj.body.money then
		DataManager.replaceMoney(msgObj.body.money)
	end
	DataManager.updateCommonGoods(msgObj)
	if LayerManager.isFloatPanelActive("EquipRecoveryUIPanel") then
		EquipRecoveryUIPanel_EquipAction_equipRecycle(msgObj)
    end
end

function Callback.HeroAction_promoteHeroStar(msgObj)
	for k,v in pairs(msgObj.body.goodsList)do
		DataManager.reduceUserTool(v.goodsId,v.goodsNum)
	end
	DataManager.replaceGold(msgObj.body.gold)
	DataManager.replaceMoney(msgObj.body.money)
	DataManager.replaceStar(msgObj.body.userHeroBO)
	UserInfoUIPanel_refresh()
	if LayerManager.isFloatPanelActive("HeroStarUIPanel") then
		HeroStarUIPanel_HeroAction_promoteHeroStar(msgObj)
    end
end

function Callback.HeroAction_heroInherit(msgObj)
	for k,v in pairs(msgObj.body.userHeroList)do
		DataManager.replaceStar(v)
	end
	for k,v in pairs(msgObj.body.goodsList)do
		DataManager.reduceUserTool(v.goodsId,v.goodsNum)
	end
	DataManager.replaceGold(msgObj.body.gold)
	DataManager.replaceMoney(msgObj.body.money)
	UserInfoUIPanel_refresh()
	if LayerManager.isFloatPanelActive("HeroInheritUIPanel") then
		HeroInheritUIPanel_HeroAction_heroInherit()
	end
end

function Callback.EquipAction_equipFillInGemstone(msgObj)

	for k,v in pairs(msgObj.body.userGemstoneBOList)do
		DataManager.updateGemstone(v)
	end
	
	if LayerManager.isFloatPanelActive("EquipGemUIPanel") then
		EquipGemUIPanel_EquipAction_equipFillInGemstone(msgObj)
	end
end

function Callback.EquipAction_equipMagic(msgObj)
	if nil ~= msgObj.body.gold then
		DataManager.replaceGold(msgObj.body.gold)
	end
	UserInfoUIPanel_refresh()
	if LayerManager.isFloatPanelActive("EquipEnchantUIPanel") then
		EquipEnchantUIPanel_EquipAction_equipMagic(msgObj)
    end
end

function Callback.GemstoneAction_gemstoneUpgrade(msgObj)
	if msgObj.body.status == 3 then
		for k,v in pairs(msgObj.body.userGemstoneIdList)do
			DataManager.removeGemstoneId(v)
		end
		
		for k,v in pairs(msgObj.body.goodsList)do
			DataManager.reduceUserTool(v.goodsId,v.goodsNum)
		end
		DataManager.addUserGemstone(msgObj.body.userGemstoneBO)
		DataManager.replaceGold(msgObj.body.gold)
		DataManager.replaceMoney(msgObj.body.money)
		UserInfoUIPanel_refresh()
	end
	
	if LayerManager.isFloatPanelActive("EquipGemUIPanel") then
		EquipGemUIPanel_GemstoneAction_gemstoneUpgrade(msgObj)
    end
end

function Callback.GemstoneAction_gemstoneResolve(msgObj)
	if msgObj.body.status == 3 then
		for k,v in pairs(msgObj.body.userGemstoneIdList)do
			DataManager.removeGemstoneId(v)
		end
		DataManager.updateCommonGoods(msgObj)
		DataManager.replaceGold(msgObj.body.gold)
		DataManager.replaceMoney(msgObj.body.money)
		UserInfoUIPanel_refresh()
	end
	
	if LayerManager.isFloatPanelActive("EquipGemUIPanel") then
		EquipGemUIPanel_GemstoneAction_gemstoneResolve(msgObj)
    end
end

function Callback.GemstoneAction_gemstoneForge(msgObj)
	if msgObj.body.status == 3 then
		DataManager.updateCommonGoods(msgObj)
		DataManager.replaceGold(msgObj.body.gold)
		DataManager.replaceMoney(msgObj.body.money)
		UserInfoUIPanel_refresh()
	end
	
	if LayerManager.isFloatPanelActive("GemSynthesisUIPanel") then
		GemSynthesisUIPanel_GemstoneAction_gemstoneForge(msgObj)
	elseif LayerManager.isFloatPanelActive("GemSynthesisLookUIPanel") then
		GemSynthesisLookUIPanel_GemstoneAction_gemstoneForge(msgObj)
    end
end

function Callback.ForcesAction_openBattleBox(msgObj)
	DataManager.updateCommonGoods(msgObj)
	if LayerManager.isFloatPanelActive("FightResultUIPanel") then
		FightResultUIPanel_ForcesAction_openBattleBox(msgObj)
	end
end

--成就系统
function Callback.AchievementAction_getUserAchievementInfo(msgObj)
    if LayerManager.isFloatPanelActive("AchieveUIPanel") then
        AchieveUIPanel_AchievementAction_getUserAchievementInfo(msgObj)
    end
end

--成就系统领取
function Callback.AchievementAction_receiveAchievementReward(msgObj)
    if LayerManager.isFloatPanelActive("AchieveUIPanel") then
        AchieveUIPanel_AchievementAction_receiveAchievementReward(msgObj)
    end
end

--成就系统信息变更推送
function Callback.Achievement_update(msgObj)
	if LayerManager.isFloatPanelActive("AchieveUIPanel") then
        AchieveUIPanel_Achievement_update(msgObj)
    end
end

--小助手
function Callback.ActivityAction_getActivityTaskInfo(msgObj)
    UserInfoUIPanel_ActivityAction_getActivityTaskInfo(msgObj)
end

function Callback.ActivityAction_receiveActivityTaskReward(msgObj)
	DataManager.updateCommonGoods(msgObj)
    if LayerManager.isFloatPanelActive("AssistantUIPanel") then
        AssistantUIPanel_ActivityAction_receiveActivityTaskReward(msgObj)
    end
end

--签到系统
function Callback.ActivityAction_getLoginReward30Info(msgObj)
    UserInfoUIPanel_ActivityAction_getLoginReward30Info(msgObj)
end

function Callback.ActivityAction_receiveLoginReward30(msgObj)
	DataManager.updateCommonGoods(msgObj)
    if LayerManager.isFloatPanelActive("SignSystemUIPanel") then
        SignSystemUIPanel_ActivityAction_receiveLoginReward30(msgObj)
    end
end

function Callback.PrestigeAction_getInviteHeroInfo(msgObj)
	if LayerManager.isFloatPanelActive("PrestigeUIPanel") then
		PrestigeUIPanel_PrestigeAction_getInviteHeroInfo(msgObj)
	end
end

--排行榜系统
function Callback.RankAction_getUserRankInfo(msgObj)
    if LayerManager.isFloatPanelActive("ChartsUIPanel") then
        ChartsUIPanel_RankAction_getUserRankInfo(msgObj)
    end
end

--职业系统
function Callback.HeroAction_getUserCareerClearInfo(msgObj)
    if LayerManager.isFloatPanelActive("ProfessionUIPanel") then
        ProfessionUIPanel_HeroAction_getUserCareerClearInfo(msgObj)
    end

    if LayerManager.isFloatPanelActive("ProfessionDetailUIPanel") then
        ProfessionDetailUIPanel_HeroAction_getUserCareerClearInfo(msgObj)
    end
end

--职业解锁
function Callback.HeroAction_careerClear(msgObj)
    if LayerManager.isFloatPanelActive("ProfessionDetailUIPanel") then
        ProfessionDetailUIPanel_HeroAction_careerClear(msgObj)
    end
end

--推送世界Boss结束信息
function Callback.Boss_pushBossRoomOwner(msgObj)
	DataManager.setChangeRoomOwner(msgObj.body.userId)
end

--推送世界Boss信息
function Callback.Boss_pushWorldBossInfo(msgObj)
	DataManager.setWorldBossInfo(msgObj.body.worldBossInfoBO)
	
	if LayerManager.isPanelActive("TileMapUIPanel") then
		TileMapUIPanel_Boss_pushWorldBossInfo(msgObj)
    end
end

--推送世界Boss当前血量
function Callback.Boss_pushWorldBossCurrentLife(msgObj)
	DataManager.setBossCurrentLife(msgObj.body.currentLife)

	if LayerManager.isPanelActive("TileMapUIPanel") and TileMapUIPanel_Boss_pushWorldBossCurrentLife then
		TileMapUIPanel_Boss_pushWorldBossCurrentLife(msgObj)
    end
end

--推送世界Boss的排行榜
function Callback.Boss_pushWorldBossRank(msgObj)
	DataManager.setWorldBossHurtRank(msgObj.body)
	
	if LayerManager.isPanelActive("TileMapUIPanel") then
		--TileMapUIPanel_Boss_pushWorldBossRank(msgObj)
    end
end

--推送世界Boss结束信息
function Callback.Boss_pushWorldBossDie(msgObj)
	DataManager.setWorldBossStatus(msgObj.body.status)
	
	if LayerManager.isPanelActive("TileMapUIPanel") and TileMapUIPanel_Boss_pushWorldBossDie then
		TileMapUIPanel_Boss_pushWorldBossDie(msgObj)
    end
end

--推送用户攻击信息
function Callback.Boss_pushUserAttackInfo(msgObj)
	if LayerManager.isPanelActive("FightUIPanel") and FightUIPanel_Boss_pushUserAttackInfo then
		FightUIPanel_Boss_pushUserAttackInfo(msgObj)
    end
end

--推送用户退出boss战
function Callback.Boss_pushUserLeave(msgObj)
	if LayerManager.isPanelActive("FightUIPanel") then
		FightUIPanel_Boss_pushUserLeave(msgObj)
    end
end

--用户进入Boss战广播
function Callback.Boss_enter(msgObj)
	if LayerManager.isPanelActive("FightUIPanel") then
		FightUIPanel_Boss_enter(msgObj)
    end
end

--发送攻打世界boss的数据
function Callback.BossAction_attackBossInfo(msgObj)
	if LayerManager.isPanelActive("FightUIPanel") then
		FightUIPanel_BossAction_attackBossInfo(msgObj)
    end
end

--复活
function Callback.BossAction_relive(msgObj)
	if LayerManager.isPanelActive("TileMapUIPanel") then
		TileMapUIPanel_BossAction_relive(msgObj)
    end
end

--开始攻打世界boss
function Callback.BossAction_startAttackBoss(msgObj)	
	DataManager.setWorldBossRoomOwner(msgObj.body.isRoomOwner)
	
	if LayerManager.isPanelActive("TileMapUIPanel") then
		TileMapUIPanel_BossAction_startAttackBoss(msgObj)
    end
end

--魂能回退
function Callback.HeroAction_returnJobExp(msgObj)
    if LayerManager.isFloatPanelActive("ProfessionDetailUIPanel") then
        ProfessionDetailUIPanel_HeroAction_returnJobExp(msgObj)
    end
end

--职业进阶
function Callback.HeroAction_heroPromote(msgObj)
    if LayerManager.isFloatPanelActive("ProfessionAdvancedUIPanel") then
        ProfessionAdvancedUIPanel_HeroAction_heroPromote(msgObj)
    end
end

function Callback.BossAction_bornBoss(msgObj)

end

function Callback.BossAction_attackBossInfo(msgObj)

end

function Callback.Activity_updateActivityTask(msgObj)

end

function Callback.MessageAction_sendMsg(msgObj)
	local data = msgObj.body.goodsBeanBO
	DataManager.reduceUserTool(data.goodsId, data.goodsNum)
	if LayerManager.isFloatPanelActive("MarqueeSenderUIPanel")then
        MarqueeSenderUIPanel_MessageAction_sendMsg(msgObj)
    end
end