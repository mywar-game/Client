require("SkeletonSkill")
require("SkeletonAction")
MainMenuUIPanel = {}

function MainMenuUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function MainMenuUIPanel:Create(para)
    local p_name = "MainMenuUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
    local systemConfig = DataManager.getSystemConfig()
    local userInfo = DataManager.getUserBO()
	local state = false
	local mainlineImg --图片
	local mainlinePara --参数
	local mainlineTask --主线任务
	local original = {}
	local moveTime = {0.1,0.15,0.2,0.25,0.25,0.3,0.3,0.3,0.3,0.3}--从左到右 或者从上到下
    local cacheTwoMsgs = {}--主界面缓存的两条聊天数据
    local menuNoticeTab = {}--主界面提醒列表[type]=icon
    --更新menu图标
    self.panel:getChildByName("btn_menu"):loadTextureNormal(
    userInfo.camp == GameField.Camp_Alliance and IconPath.caidan.."lianmengbiaozhi.png" or IconPath.caidan.."buluobiaozhi.png")
    --end
    local function insertToOriginal(head, num)
	    local mx,my = self.panel:getChildByName("btn_menu"):getPosition()
        for k=num,1,-1 do
		    local button = self.panel:getChildByName(head..k)
            button:setVisible(state)
            if not original[head..k] then 
                if head == "btn_menuI" then
                    button:setPositionX(-100)
                else
                    button:setPosition(cc.p(mx, my))
                end
            end
            if head == "btn_menuV" then
		        original[head..k] = {mx=mx, my=my, x=mx, y=my + 90*(num-k + 1),index=k,head=head}
            elseif head == "btn_menuH" then
		        original[head..k] = {mx=mx, my=my, x=mx - 94*(num-k + 1), y=my,index=k,head=head}
            elseif head == "btn_menuI" then
                local y = button:getPositionY()
		        original[head..k] = {mx=-100, my=y, x=70, y=y, index=k, head=head}
            end
	    end
    end
    --清空横列表元素显示(组合了下函数)
    insertToOriginal("btn_menuH", 8)
    original = {}
    --清空横列表元素显示(组合了下函数)
	insertToOriginal("btn_menuV", 4)
    --insertToOriginal("btn_menuH", 2)
    insertToOriginal("btn_menuI", 4)

	--清空指定类型提示
    local function clearPushNotify(type)
        if menuNoticeTab[type] then
            menuNoticeTab[type]:removeFromParent()
            menuNoticeTab[type] = nil
        end
    end

	--返回可见于不可见。 false 表示可见 。 true表示不可见。
    local function  leftMenuShow(menuName)
	      if  "btn_menuI4" == menuName then--探索
		       if userInfo.level >= tonumber(systemConfig.explore_open_level) then		
			      return false -- 表示可见
			   else		
			      return true --表示不可见。
			   end 
		  elseif "btn_menuI3" == menuName then--竞技场
		       if userInfo.level >= tonumber(systemConfig.pk_open_level) then--竞技场	
			      return false -- 表示可见
			   else
			      return true --表示不可见。
			   end
		  elseif "btn_menuI1" == menuName  then--升星
               if userInfo.level >= tonumber(systemConfig.hero_promote_star_open_level)  then--升星
			      return false -- 表示可见
			   else
			      return true --表示不可见。
			   end
		  end
	      return false
	end

    --刷新主界面消息
    local function reFreshMsg()
        local function OnMsgItemShowCallback(scroll_view, item, data, idx)
            local lab_name = self.panel:getItemChildByName(item, "lab_name")
            local lab_content = self.panel:getItemChildByName(item, "lab_content")
            local color = DataManager.getChatMsgColor(data.type)
            if data.type ~= 4 then--非私聊
                self.panel:setItemLabelText(item, "lab_name", string.format("[%s]%s:",LabelChineseStr["ChatUIPanel_" .. data.type], data.userName), color[1])
            else--私聊
                if data.userId ~= userInfo.userId then--别人对我说
                    self.panel:setItemLabelText(item, "lab_name", data.userName, color[1])
                else--我对别人说
                    self.panel:setItemLabelText(item, "lab_name", data.targetUserName, color[1])
                end
            end
            self.panel:setItemLabelText(item, "lab_content", data.content, color[2])
            lab_content:setPositionX(lab_name:getPositionX()+lab_name:getContentSize().width)
        end
        local function OnMsgItemClickCallback(item, data, idx)
            
        end
        self.panel:InitListView(cacheTwoMsgs, OnMsgItemShowCallback, OnMsgItemClickCallback)
    end
    function MainMenuUIPanel_GetState()
	    return  state 
	end
	function MainMenuUIPanel_menuMove(newState)
        if newState ~= nil then
            if newState == state then 
			   return 
			end
            state = newState
        else
		    state = not state
        end
		if state then
			for k,v in pairs(original)do
				local button = self.panel:getChildByName(v.head..v.index)
                button:stopAllActions()
				button:setPosition(cc.p(v.mx,v.my))
				button:setVisible(leftMenuShow(v.head..v.index))
				button:runAction(cc.Sequence:create(cc.ToggleVisibility:create(),cc.MoveTo:create(moveTime[v.index],cc.p(v.x,v.y))))
			end
				self.panel:setNodeVisible("img_chatBkg", true)
                TaskGuideUIPanel_Hide_Show(0)   --0隐藏/1显示
		else
			for k,v in pairs(original)do
				local button = self.panel:getChildByName(v.head..v.index)
				cclog(  v.head..v.index )
                button:stopAllActions()
				button:setPosition(cc.p(v.x,v.y))
                button:setVisible(true)
			    local temp = leftMenuShow(v.head..v.index)
				if temp then
					button:runAction(cc.Sequence:create(
					    cc.ToggleVisibility:create(),
						cc.MoveTo:create(moveTime[v.index],cc.p(v.mx,v.my))
						)
					)
				else
					button:runAction(cc.Sequence:create(
						cc.MoveTo:create(moveTime[v.index],cc.p(v.mx,v.my)),
						cc.ToggleVisibility:create()
						)
					)
				end
				
			end
            self.panel:setNodeVisible("img_chatBkg", false)
            TaskGuideUIPanel_Hide_Show(1)   --0隐藏/1显示
            reFreshMsg()
		end
	end
	--MainMenuUIPanel_menuMove(true)  --默认不要打开因为新手指引。需要处理一大坨内容。此处 待议
	local function resetHNum(num)
        insertToOriginal("btn_menuH", num)
        if state then--偏移挤出来
            for k,v in pairs(original)do
                if v.head == "btn_menuH" then
				    local button = self.panel:getChildByName(v.head..v.index)
				    button:runAction(cc.Sequence:create(
                        cc.MoveTo:create(moveTime[6],cc.p(v.x,v.y))
                        )
                    )
                end
			end
        end
		
    end
    --获取玩家等级 开放不同功能
	--团队升级会发送  newFresh true 
    function MainMenuUIPanel_updateOpenIcon(newFresh)
        --左边的那坨按钮触发
	    if userInfo.level >= tonumber(systemConfig.pk_open_level) then -- 竞技场开放等级
		    -- self.panel:setNodeVisible("btn_menuI3",false)
		    if userInfo.level == tonumber(systemConfig.pk_open_level) and newFresh then 
				MainMenuUIPanel_menuMove(false)
				UserGuideUIPanel.showGuideLevel(self.panel,false,"MainMenuUIPanel", UserGuideUIPanel.Dialog_JJC)				
			end 		   
		end
	    if userInfo.level >= tonumber(systemConfig.explore_open_level) then -- 探索开放等级
		   --self.panel:setNodeVisible("btn_menuI4",false) 
		   if userInfo.level == tonumber(systemConfig.explore_open_level) and newFresh then  --and newFresh 
				MainMenuUIPanel_menuMove(false)
				UserGuideUIPanel.showGuideLevel(self.panel,false,"MainMenuUIPanel", UserGuideUIPanel.Dialog_TS)				
		   end 
		end
        if userInfo.level >= tonumber(systemConfig.hero_promote_star_open_level) then --升星
		  -- self.panel:setNodeVisible("btn_menuI1",false) 
		    if userInfo.level == tonumber(systemConfig.hero_promote_star_open_level) and newFresh then  
				MainMenuUIPanel_menuMove(false)
				UserGuideUIPanel.showGuideLevel(self.panel,false,"MainMenuUIPanel", UserGuideUIPanel.Dialog_SX)				
		   end 
	    end

        if userInfo.level >= tonumber(systemConfig.life_open_level) then--生活18 
				resetHNum(6)
            if userInfo.level == tonumber(systemConfig.life_open_level) and newFresh then 
				Tips(LabelChineseStr.MainMenuUIPanel_4)
				UserGuideUIPanel.showGuideLevel(self.panel,false,"MainMenuUIPanel", UserGuideUIPanel.Dialog_SH)	
			end
        elseif userInfo.level >= tonumber(systemConfig.team_skill_open_level) then--团长 8
				resetHNum(5)
            if userInfo.level == tonumber(systemConfig.team_skill_open_level) and newFresh then
				Tips(LabelChineseStr.MainMenuUIPanel_2)
				UserGuideUIPanel.showGuideLevel(self.panel,false,"MainMenuUIPanel",UserGuideUIPanel.Dialog_TZ)
			end
		elseif userInfo.level >= tonumber(systemConfig.friend_open_level) then--好友 5
				resetHNum(4)
            if userInfo.level == tonumber(systemConfig.friend_open_level) and newFresh then 
				Tips(LabelChineseStr.MainMenuUIPanel_3) 
				end	
        elseif userInfo.level >= tonumber(systemConfig.pack_open_level) then--背包 3
				resetHNum(3)-- 开放背包
            if userInfo.level == tonumber(systemConfig.pack_open_level) and newFresh then
				Tips(LabelChineseStr.MainMenuUIPanel_1)	
				UserGuideUIPanel.showGuideLevel(self.panel,false,"MainMenuUIPanel", UserGuideUIPanel.Dialog_Pack)
			end	
        else
			resetHNum(2)
        end
    end
    MainMenuUIPanel_updateOpenIcon()
    
	--打开宝石合成
	function MainMenuUIPanel_openGemSynthesis()
       LayerManager.show("GemSynthesisLookUIPanel")
    end
	
	--打开锻造
    function MainMenuUIPanel_openForge()
       LayerManager.show("EquipForgeLookUIPanel") --第一列
    end
	
	--打开分解
    function MainMenuUIPanel_openResolve()
        LayerManager.show("EquipRecoveryUIPanel", {data = nil})
    end
	
	--打开声望兑换
    function MainMenuUIPanel_openPrestige()
        LayerManager.show("PrestigeUIPanel")
    end

    --打开成就
    function MainMenuUIPanel_openAchieve()
        LayerManager.show("AchieveUIPanel")
    end
	
	--宝石加工
	function MainMenuUIPanel_openEquipGem()
		LayerManager.show("EquipGemUIPanel")
	end
	
    --打开探索
    function MainMenuUIPanel_openExplore()
        if userInfo.level >= tonumber(systemConfig.explore_open_level) then
			LayerManager.show("ExploreUIPanel")
        else
            Tips(systemConfig.explore_open_level..LabelChineseStr.ExploreUIPanel_1)
        end
    end
	
	--打开邮箱
    function MainMenuUIPanel_openEmail()
        LayerManager.show("EmailUIPanel",{idx=1}) --第一列
        clearPushNotify(GameField.PushNotify_Email)
    end

	--打开职业
    function MainMenuUIPanel_openProfession()
        LayerManager.show("ProfessionUIPanel")
	end
	
	--打开升星
    function MainMenuUIPanel_openStar()
        LayerManager.show("HeroStarUIPanel")
    end
	
	--打开仓库
    function MainMenuUIPanel_openRepertoryStore()
		LayerManager.show("RepertoryStoreUIPanel")
    end
	
	--打开竞技
    function MainMenuUIPanel_openArena()
		if userInfo.level >= tonumber(systemConfig.pk_open_level) then
		    LayerManager.show("ArenaMainUIPanel")
		else
			Tips(systemConfig.pk_open_level..LabelChineseStr.PKUIPanel_1)
		end
    end
	
    --打开好友
    function MainMenuUIPanel_openFriend()
        if userInfo.level >= tonumber(systemConfig.friend_open_level) then
		   LayerManager.show("FriendUIPanel")
		else
			Tips(systemConfig.friend_open_level..LabelChineseStr.FriendUIPanel_1)
		end
    end
    --打开聊天
    function MainMenuUIPanel_openChat()
        LayerManager.show("ChatUIPanel")
    end
    --打开当铺
    function MainMenuUIPanel_openPawnShop()
        LayerManager.show("PawnShopUIPanel")
    end
    --打开任务
    function MainMenuUIPanel_openTask()
        LayerManager.show("TaskUIPanel")
    end
    --打开日常任务
    function MainMenuUIPanel_openDailyTask()
        LayerManager.show("DayTaskUIPanel")
    end
    --打开团队技能
    function MainMenuUIPanel_openTeamSkill()
        LayerManager.show("HeadSkillUIPanel")
    end
    --打开背包
    function MainMenuUIPanel_openPackage()
		local data = DataManager.getSceneHero()
		LayerManager.show("HeroDescUIPanel",{hero=data,idx = GameField.heroDescPackage})
    end
    --打开英雄界面
    function MainMenuUIPanel_openHeroHome()
        LayerManager.show("HeroHomeUIPanel")
    end
    --打开阵容界面
    function MainMenuUIPanel_openTeam()
        LayerManager.show("HeroTeamUIPanel")
    end
    --打开好友
    function MainMenuUIPanel_openFriend()
        LayerManager.show("FriendUIPanel")
    end
	
	--打开世界地图
    function MainMenuUIPanel_openWorldMap()
        LayerManager.show("WorldMapUIPanel")
    end

	--打开设置
    function MainMenuUIPanel_systemSet()
        LayerManager.show("SystemSetUIPanel")
		--LayerManager.show("EquipEnchantForgeUIPanel")
    end
	
    --打开杂货铺
    function MainMenuUIPanel_openGrocery()
        LayerManager.show("GroceryUIPanel")		  
    end
	
	--打开附魔
    function MainMenuUIPanel_openEnchant()
        LayerManager.show("EquipEnchantUIPanel")
    end
	
	--打开附魔的药草精粹
    function MainMenuUIPanel_openEnchantForge()
        LayerManager.show("EquipEnchantForgeUIPanel")
    end

	local function btnCallBack(sender,tag)
		if tag == "btn_menu" then
			MainMenuUIPanel_menuMove()
		elseif tag == "btn_menuV4" then--设置
			MainMenuUIPanel_systemSet()   
		elseif tag == "btn_menuV3" then--地图
            MainMenuUIPanel_openWorldMap()
		elseif tag == "btn_menuV2" then--成就
            local userBo = DataManager.getUserBO()
            if userBo.level >= 5 then
                MainMenuUIPanel_openAchieve()
            else
                Tips(LabelChineseStr.MainMenuUIPanel_7)
            end
           --MainMenuUIPanel_openPrestige()
        elseif tag == "btn_menuV1" then--任务
            MainMenuUIPanel_openTask()
		elseif tag == "btn_menuH8" then--公会
            
		elseif tag == "btn_menuH7" then--商城
			
		elseif tag == "btn_menuH6" then--生活
	    	UserGuideUIPanel.stepClick( "image_menu_guide2" )
			MainMenuUIPanel_LifeSkillsPanel()
		elseif tag == "btn_menuH5" then--团长技能
            MainMenuUIPanel_openTeamSkill()
		elseif tag == "btn_menuH4" then--好友
			MainMenuUIPanel_openFriend()
        elseif tag == "btn_menuH3" then--背包
			UserGuideUIPanel.stepClick( "image_menu_guide2" )
            MainMenuUIPanel_openPackage()
        elseif tag == "btn_menuH2" then--阵容
		    UserGuideUIPanel.stepClick( "image_menu_guide2" )
		    UserGuideUIPanel.stepClick( "image_menu_guide3" )
            MainMenuUIPanel_openTeam()
        elseif tag == "btn_menuH1" then--英雄
            MainMenuUIPanel_openHeroHome()
        elseif tag == "btn_menuI5" then
            MainMenuUIPanel_openChat()
		elseif tag == "btn_menuI6" then--职业
			MainMenuUIPanel_openProfession()
		elseif tag == "btn_menuI4" then--探索
			UserGuideUIPanel.stepClick( "image_menu_guide14" )
            MainMenuUIPanel_openExplore()
		elseif tag == "btn_menuI3" then--竞技场
			UserGuideUIPanel.stepClick( "image_menu_guide13" )
            MainMenuUIPanel_openArena()
		elseif tag == "btn_menuI2" then--邮件
            MainMenuUIPanel_openEmail()
		elseif tag == "btn_menuI1" then--升星
			UserGuideUIPanel.stepClick( "image_menu_guide11" )
            --MainMenuUIPanel_openStar()
			--MainMenuUIPanel_openRepertoryStore()
			MainMenuUIPanel_openProfession()
		elseif tag == "btn_menu_guide" then --引导
			if mainlineTask and mainlinePara then
				DataManager.setReceiveTaskNpc(mainlinePara)
				TileMapUIPanel_cleanJumpScene()
				TileMapUIPanel_autoFindNpcTask()
			end
            MainMenuUIPanel_HightLightBtn(false)
			UserGuideUIPanel.stepClick("btn_menu_guide") -- 新手引导被触发的 
		end
	end
    function MainMenuUIPanel_HightLightBtn(isHightLight)
		--[[
        local x,y = self.panel:getChildByName("btn_menu_guide"):getPosition()
        local contentRight = self.panel:getChildByName("content_right")
        if isHightLight then
            if not contentRight.hightLightIcon then
                local skeletonSkill = SkeletonSkill:New()
	            local skeleton1 = skeletonSkill:Create("t10",0)
				skeleton1:setScale(2)
                skeleton1:setAnchorPoint(cc.p(0.5, 0.5))
	            skeleton1:setPosition(cc.p(x,y-136))
	            skeletonSkill:setCommonPlay(true)
                contentRight.hightLightIcon = skeletonSkill
                contentRight:addChild(skeleton1, 0)
            end
        else
            if contentRight.hightLightIcon then
                contentRight.hightLightIcon:Release()
                contentRight.hightLightIcon = nil
            end
        end
		]]
    end
	self.panel:addNodeTouchEventListener("btn_menu",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_menu_guide",btnCallBack)
	
    local function batchAddListener(head, len)
        for i=1,len do
	        self.panel:addNodeTouchEventListener(head..i,btnCallBack)
        end
    end
	batchAddListener("btn_menuV", 4)
    batchAddListener("btn_menuH", 8)
    batchAddListener("btn_menuI", 5)
    
	--聊天信息推送
    function MainMenuUIPanel_Chat_pushChatInfo(msgObj)
        local data = msgObj.body.userChatRecordBO
        if data.type == 5 or data.type == 1 or data.type == 4 or data.type == 3 or data.type == 2 then
            table.insert(cacheTwoMsgs, 1, DeepCopy(data))
            if #cacheTwoMsgs > 2 then
                table.remove(cacheTwoMsgs, 3)
            end
            reFreshMsg()
        end
		local userBo = DataManager.getUserBO()
		if data.userId == userBo.userId then
			TileMapUIPanel_OwnChat_pushChatInfo(data)
		end
    end
	
    --各种推送消息过来相应
    function MainMenuUIPanel_Response_PushNotify(type,msgObj)
        local icon
        if type == GameField.PushNotify_Email then
            icon = IconUtil.CreateNoticeIcon(self.panel:getChildByName("btn_menuI2"))
        end
        menuNoticeTab[type] = icon
    end
	
	if 1 == DataManager.systemUserPushConfig().mailStatus then
		MainMenuUIPanel_Response_PushNotify(GameField.PushNotify_Email, nil)
		--DataManager.systemUserPushConfig().mailStatus = 0
	end
	
	function MainMenuUIPanel_updateMainlineTask()
		mainlineTask = DataManager.getMainlineTask()
		if mainlineTask then
			mainlinePara,mainlineImg = TaskLibrary.getAutoFindWayPara(mainlineTask)
			if mainlineImg then
				self.panel:setImageTexture("img_heroHead",mainlineImg)
                MainMenuUIPanel_HightLightBtn(true)
			end
		end
	end
	MainMenuUIPanel_updateMainlineTask()
	
	function  MainMenuUIPanel_LifeSkillsPanel()
        if userInfo.level >= tonumber(systemConfig.life_open_level) then
		    LayerManager.show("LifeSkillsUIPanel")
        else
            Tips(systemConfig.life_open_level..LabelChineseStr.LifeSkillsUIPanel_1)
        end
	end
	
    return panel
end

--底部导航菜单切换回调
function MainMenuUIPanel:ChangeCenter(targetPanelName)          
    LayerManager.show(targetPanelName)
end

--退出
function MainMenuUIPanel:Release()
	self.panel:Release()
end

--隐藏
function MainMenuUIPanel:Hide()
	self.panel:Hide()
end

--显示
function MainMenuUIPanel:Show()
	self.panel:Show()
end