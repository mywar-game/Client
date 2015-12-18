--日常任务

DayTaskUIPanel = {}

function DayTaskUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function DayTaskUIPanel:Create(para)
	local p_name = "DayTaskUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
    
    local systemConfig = DataManager.getSystemConfig()
    local userInfo = DataManager.getUserBO()
    local cacheTaskList--缓存的任务列表
    local cacheReciverTask--缓存领钱的任务
    local cacheTopStatus--最上层任务状态
    local starImgPathTab = 
    {
        IconPath.renwu.."lvxing.png",
        IconPath.renwu.."langxing.png",
        IconPath.renwu.."zixing.png"
    }

    --list监听
	self.panel:setLabelText("lab_dialogNum",userInfo.money)
	--self.panel:setLabelText("lab_goldNum",systemConfig.refresh_daily_five_star_cost)
	
    local function OnItemShowCallback(scroll_view, item, data, idx)
        local userTask = DataManager.getUserTaskId(data.systemTaskId) 
        local systemTask = DataManager.getSystemTaskId(data.systemTaskId)
        local systemDailyTask = DataManager.getSystemDailyTask(data.systemTaskId)
        self.panel:setItemLabelText(item, "lab_name", systemTask.taskName)
        self.panel:setItemLabelText(item, "lab_detail", systemTask.taskDesc)
		if userTask then
            self.panel:setItemLabelText(item, "lab_itemCount", userTask.finishTimes.."/"..systemTask.needFinishTimes)
        else
            self.panel:setItemLabelText(item, "lab_itemCount", "0/"..systemTask.needFinishTimes)
        end
        
        --添加奖励
        local rewardIcon = self.panel:getItemChildByName(item, "img_reward")
        local rewards = Split(systemDailyTask[data.star].rewards,"|")
        local cacheOffsetX = 70
        local function insertCommonValue(picPath, num)
            local picSprite = CreateCCSprite(picPath)
            cacheOffsetX = cacheOffsetX + 5
            picSprite:setAnchorPoint(cc.p(0,0.5))
            picSprite:setPosition(cc.p(cacheOffsetX,16))
            rewardIcon:addChild(picSprite)
            cacheOffsetX = cacheOffsetX +  picSprite:getContentSize().width + 2
            local numLabel = CreateLabel(num, nil, 20, cc.c3b(255,255,255), 1)
            numLabel:setPosition(cc.p(cacheOffsetX, 10))
            rewardIcon:addChild(numLabel)
            cacheOffsetX = cacheOffsetX + 74
        end
		
        for k,v in pairs(rewards) do
            local tools = Split(v,",")
            local toolType = tonumber(tools[1])
            local toolNum = tonumber(tools[3])
            if toolType == GameField.gold then--金币
                insertCommonValue(IconPath.tongyong.."i_jingb.png", toolNum)
            elseif toolType == GameField.jobExp then--声望
                insertCommonValue(IconPath.tongyong.."i_shengwang.png", toolNum)
            elseif toolType == GameField.exp then--团队经验
                insertCommonValue(IconPath.tongyong.."t_tdexp.png", toolNum)
            elseif toolType == GameField.heroExp then--英雄经验
                insertCommonValue(IconPath.tongyong.."t_rwexp.png", toolNum)
            end
        end
        --添加星星
        local nameLabel = self.panel:getItemChildByName(item, "lab_name")
        local nlSize = nameLabel:getContentSize()
        local starImgPath = IconPath.yingxiongshenxing.."i_xingx.png"  --starImgPathTab[math.ceil(data.star/2)]
        for k=1,data.star do
            local starIcon = CreateCCSprite(starImgPath)
            starIcon:setPosition(cc.p(148+k*32, 10))
            nameLabel:addChild(starIcon)
        end

        if data.status == 0 then--未领取
            if cacheTopStatus ~= 0 then
                self.panel:setItemBtnEnabled(item, "btn_get", false)
            end
            self.panel:setItemBitmapText(item, "lab_get", GameString.taskNotAccept)
        elseif data.status == 1 then--已领取
            self.panel:setItemBtnEnabled(item, "btn_get", false)
            self.panel:setItemBitmapText(item, "lab_get", GameString.taskAccept)
        elseif data.status == 2 then--完成准备拿钱
            self.panel:setItemBitmapText(item, "lab_get", GameString.taskCompleted)
        end
        self.panel:addItemNodeTouchEventListener(item, "btn_get", function (sender, tag)
            if data.status == 0 then--领取任务
                local addTaskReq = TaskAction_addTaskReq:New()
			    addTaskReq:setInt_systemTaskId(data.systemTaskId)
                addTaskReq:setInt_star(data.star)
			    NetReqLua(addTaskReq, true)
            elseif data.status == 2 then--领钱
                local receiveTaskReq = TaskAction_receiveTaskReq:New()
			    receiveTaskReq:setInt_systemTaskId(data.systemTaskId)
			    NetReqLua(receiveTaskReq, true)
                cacheReciverTask = data
            end
        end)
    end

    local function OnItemClickCallback(item, data, idx)
		
    end

	local function btnCallBack(sender,tag)
		
		if tag == 0 then
		    self:Release() 
        elseif tag == 1 then
			local tipStr = LabelChineseStr.DayTaskUIPanel_1..systemConfig.one_click_refresh_cost..LabelChineseStr.common_zuanshi
            LayerManager.showDialog(tipStr,function()
                local reFreshReq = TaskAction_oneClickRefreshReq:New()
                NetReqLua(reFreshReq, true)
            end)
        elseif tag == 2 then
			local tipStr = LabelChineseStr.DayTaskUIPanel_1..systemConfig.refresh_daily_five_star_cost..LabelChineseStr.common_zuanshi
            LayerManager.showDialog(tipStr,function()
                local reFreshFiveStarReq = TaskAction_refreshFiveStarReq:New()
                NetReqLua(reFreshFiveStarReq, true)
            end)
		end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_refresh",btnCallBack,1)
    self.panel:addNodeTouchEventListener("btn_toFiveStar",btnCallBack,2)

    local function requestFreshDayTask()
        local getUserDailyTaskReq = TaskAction_getUserDailyTaskInfoReq:New()
        NetReqLua(getUserDailyTaskReq, true)
    end
    requestFreshDayTask()

    local function refreshListView()
        cacheTopStatus = 0
        table.sort(cacheTaskList, function(a,b)--状态越大越前
            --获取当前最大状态
            if a.status > cacheTopStatus then cacheTopStatus = a.status end
            if b.status > cacheTopStatus then cacheTopStatus = b.status end
            return a.status > b.status
        end)
        self.panel:InitListView(cacheTaskList, OnItemShowCallback, OnItemClickCallback)
        self.panel:getChildByName("ListView"):jumpToTop()
    end

    function DayTaskUIPanel_TaskAction_getUserDailyTaskInfo(msgObj)
        cacheTaskList = msgObj.body.userDailyTaskInfoList
        self.panel:setLabelText("lab_count", systemConfig.daily_task_receive_times - msgObj.body.remainderTimes)
        refreshListView()
    end

    function DayTaskUIPanel_TaskAction_oneClickRefresh(msgObj)
        cacheTaskList = msgObj.body.userDailyTaskInfoList
        DataManager.addMoney(-systemConfig.one_click_refresh_cost)
        UserInfoUIPanel_refresh()
        refreshListView()
    end

    function DayTaskUIPanel_TaskAction_refreshFiveStar(msgObj)
        --更新其中一个任务为5星
        for k,v in pairs(cacheTaskList) do
            if v.systemTaskId == msgObj.body.userDailyTaskInfo.systemTaskId then
                v.star = msgObj.body.userDailyTaskInfo.star
                v.status = msgObj.body.userDailyTaskInfo.status
            end
        end
        --
        DataManager.addMoney(-systemConfig.refresh_daily_five_star_cost)
	    UserInfoUIPanel_refresh()
        refreshListView()
    end

    function DayTaskUIPanel_TaskAction_addTask(msgObj)
    
	end

    function DayTaskUIPanel_TaskAction_receiveTask(msgObj)
    
	end

    function DayTaskUIPanel_Task_update(msgObj)
        requestFreshDayTask()
    end

    return self.panel
end

--退出
function DayTaskUIPanel:Release()
	self.panel:Release()
end

--隐藏
function DayTaskUIPanel:Hide()
	self.panel:Hide()
end

--显示
function DayTaskUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end