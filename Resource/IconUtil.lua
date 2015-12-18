IconUtil = {}

--附加通用触屏事件
function IconUtil.addCommonTouchEvent(node, type, data, touchCallBack)
    --注册按钮事件 包括单击双击长按拖动事件
    local function isContain(touchPos, sprite)--判断touch事件是否被包含在该sprite
        local location = sprite:convertToNodeSpace(touchPos)
        local s = sprite:getContentSize()
        local rect = cc.rect(0,0,s.width,s.height)
        if cc.rectContainsPoint(rect,location) then
            return true
        end
        return false
    end
	
    node.extraTouchData = {}
    node.extraTouchData.clickTim = 0
    node.extraTouchData.endTim = 0
    local function touchStart(touch, event)
        if not isContain(touch:getLocation(), node) then
            node.extraTouchData.startTim = nil 
            return false
        end
		
        node.extraTouchData.startTim = os.clock()
        if node.extraTouchData.startTim - node.extraTouchData.endTim > 0.2 then--两次点击间隔超过0.2秒则恢复单击次数
            node.extraTouchData.clickTim = 0
        end
		
        --启动定时器 如果长时间未释放手指则打开详情界面 初步设置为0.32秒
        node:stopAllActions()
        node:runAction(cc.Sequence:create(cc.DelayTime:create(0.32), 
        cc.CallFunc:create(function()
			node.extraTouchData.toolDetailWin = LayerManager.show("ToolDetailUIPanel",{data=data,type=type})
			--设置弹出框在附近
			local pos = node:convertToWorldSpace(cc.p(0,node:getContentSize().height))
			local boxSize = node.extraTouchData.toolDetailWin.panel:getChildByName("img_box"):getContentSize()
			if pos.x+node:getContentSize().width < UIConfig.stageWidth/2 then
				pos.x = pos.x 
					+ node:getContentSize().width 
					+ boxSize.width
			end
			if pos.y-boxSize.height < 0 then--这里设置最低高度(暂时定为自身高度)
				pos.y = boxSize.height
			end
			node.extraTouchData.toolDetailWin.panel:getChildByName("img_equipContent"):setPosition(pos)
            if touchCallBack then
                touchCallBack(GameField.Event_LongPress, touch:getLocation())
            end
        end)))
		
        if touchCallBack then
            touchCallBack(GameField.Event_Click, touch:getLocation())
        end
		
        return true
    end
	
    local function touchMove(touch, event)
        if not node.extraTouchData.startTim then return end
        if not isContain(touch:getLocation(), node) then
            --如果拖动的位置超出了则停止显示
            node:stopAllActions()
            if node.extraTouchData.toolDetailWin then
                node.extraTouchData.toolDetailWin:Release()
                node.extraTouchData.toolDetailWin = nil
            end
            --请求回调
            if touchCallBack then
                touchCallBack(GameField.Event_Move, touch:getLocation())
            end
        end
    end
	
    local function touchFinish(touch, event)
        node:stopAllActions()
        if node.extraTouchData.toolDetailWin then
            node.extraTouchData.toolDetailWin:Release()
            node.extraTouchData.toolDetailWin = nil
        end
        if not node.extraTouchData.startTim then return end
        node.extraTouchData.endTim = os.clock()
        node.extraTouchData.clickTim = node.extraTouchData.clickTim + 1
		node.extraTouchData.startTim = nil
        if node.extraTouchData.clickTim >= 2 then--如果连续单击次数大于2则检查是否有操作函数
			node.extraTouchData.clickTim = 0
            if touchCallBack then
                touchCallBack(GameField.Event_DoubleClick, touch:getLocation())
            end
        elseif node.extraTouchData.clickTim == 1 then--单击回调 主要用于移动
            if touchCallBack then
                touchCallBack(GameField.Event_End, touch:getLocation())
            end
        end
        
    end
	
    local listenner = cc.EventListenerTouchOneByOne:create()
    listenner:setSwallowTouches(true)
    listenner:registerScriptHandler(touchStart,cc.Handler.EVENT_TOUCH_BEGAN)
    listenner:registerScriptHandler(touchMove,cc.Handler.EVENT_TOUCH_MOVED)
    listenner:registerScriptHandler(touchFinish,cc.Handler.EVENT_TOUCH_ENDED)
    listenner:registerScriptHandler(touchFinish,cc.Handler.EVENT_TOUCH_CANCELLED)
    local eventDispatcher = node:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listenner,node)     
end

--获取道具(在package界面粗线过)
function IconUtil.GetIconByIdType(toolType,toolId,toolNum,extraPara)
    local qualityColor = 1
	toolId = tonumber(toolId)
	toolType = tonumber(toolType)
	if toolNum then
        toolNum = tonumber(toolNum)
    end
	 
	local isTool = false
	local iconImg = ""
	if toolType == GameField.gold then	--金币
		isTool = true
		toolId = 1049
	elseif toolType == GameField.money then	--钱
		isTool = true
		toolId = 1050
	elseif toolType == GameField.heroExp then --英雄经验
		isTool = true
		toolId = 1051
	elseif toolType == GameField.exp then	--团队经验
		isTool = true
		toolId = 1052
	elseif toolType == GameField.jobExp then --魂能
		isTool = true
		toolId = 1053
	elseif toolType == GameField.honour then--荣誉
		isTool = true
		toolId = 1054
	elseif toolType == GameField.tool or   math.floor(toolType/100) == GameField.tool then	--道具
		isTool = true
		toolId = toolId
	end
	if isTool then --道具
		local systemTools = DataManager.getSystemTool(toolId)
        if extraPara and not extraPara.data then
            extraPara.data = systemTools
        end
		qualityColor = systemTools.color
		cclog(IconPath.daoju..systemTools.imgId..".png")
		iconImg = IconPath.daoju..systemTools.imgId..".png"
	end
	
	if toolType == GameField.hero then	--英雄
		local systemHero = DataManager.getStaticSystemHeroId(toolId)
		iconImg = IconPath.yingxiong.. systemHero.imgId .. ".png"
		qualityColor = systemHero.heroColor
	elseif toolType == GameField.heroSkill then --英雄技能
	
    elseif toolType == GameField.power then	--体力
	
	elseif toolType == GameField.activity then--活力
	
	elseif toolType == GameField.packExtendTimes then--背包扩展次数
	    
	elseif toolType == GameField.equip then  --装备
	    local systemEquip = DataManager.getSystemEquip(toolId)
        if extraPara and not extraPara.data then
            extraPara.data = DataTranslater.tranEquip({equipId=toolId})
        end
        qualityColor = systemEquip.quality
        iconImg = IconPath.zhuangbei..systemEquip.imgId..".png"
	elseif toolType == GameField.level then  --用户等级 即团队等级
	    
	elseif toolType == GameField.prestigeLevel then  --声望等级
	    
	elseif toolType == GameField.chest then  --宝箱
		local systemTools = DataManager.getSystemTool(toolId)
		if extraPara and not extraPara.data then
            extraPara.data = systemTools
        end
		qualityColor = systemTools.color
		iconImg = IconPath.daoju..systemTools.imgId..".png"
	elseif toolType == GameField.packExtendNum then  --背包大小
		local systemTools = DataManager.getSystemTool(toolId)
		iconImg = IconPath.daoju..systemTools.imgId..".png"
	elseif toolType == GameField.gemstone then --宝石
		local systemgemstone = DataManager.getSystemGemstone(toolId)
		qualityColor = systemgemstone.quality
		iconImg = IconPath.baoshi..systemgemstone.imgId..".png"
	end
	local iconSprite = CreateCCSprite(iconImg)
    local size = iconSprite:getContentSize()

    --颜色品质(暂定方格)
    if qualityColor then
        local colorSprite = CreateCCSprite(IconPath.pinzhiKuang..qualityColor..".png")
        colorSprite:setPosition(cc.p(size.width/2, size.height/2))
        iconSprite:addChild(colorSprite)
    end

	if toolNum then 
	    local numLabel = CreateLabel("x"..toolNum)
	    numLabel:setAnchorPoint(cc.p(1,0))
	    numLabel:setPosition(cc.p(size.width,0))
	    iconSprite:addChild(numLabel)
	end

    --注册按钮事件 包括单击双击长按拖动事件
    if extraPara and not extraPara.closeTouchEvent and toolType ~= GameField.hero then--限定部分有弹出描述
        IconUtil.addCommonTouchEvent(iconSprite, toolType, extraPara.data, extraPara.touchCallBack)
    end
	return iconSprite
end

--创建完整英雄头像,...未完
function IconUtil.createHeroIcon(data, hideName)
    local iconNode = cc.Node:create()
    local iconBkg = CreateCCSprite(IconPath.tongyong.."i_black.png") --黑色圆圈背景
    iconNode:addChild(iconBkg)
    local iconHead = CreateCCSprite(IconPath.yingxiong.. data.imgId .. ".png")--头像
    iconNode:addChild(iconHead)
    local iconCircle = CreateCCSprite(IconPath.pinzhiYaun.. data.heroColor .. ".png")--品质项圈
    iconNode:addChild(iconCircle)
   --[[ local iconCareer = CreateCCSprite("career/car_" .. data.careerId .. ".png")--职业
    iconCareer:setAnchorPoint(cc.p(0.5, 0))
    iconNode:addChild(iconCareer)]]
    if not hideName then
        local labName = CreateLabel(data.heroName, nil, nil, cc.c3b(255,255,255), 3)--名字
        labName:setPosition(0, -52)
        iconNode:addChild(labName) 
    end
    return iconNode
end

--英雄头像框
function IconUtil.getHeroHeadKuangByColor(heroColor)
    
end

--英雄头像
function IconUtil.getHeroHead(data)
	return IconPath.yingxiong.. data.imgId .. ".png"
end

--团长技能框
function IconUtil.getLeaderSkillKuang(skillColor)
    
end
--团长技能图片资源
function IconUtil.getLeaderSkillImg(resId)
    
end
--获取阵营icon
function IconUtil.getTeamImgPath(camp)
    local retImgPath = nil
    if camp == GameField.Camp_Alliance then--联盟
        retImgPath = IconPath.liaotian .."lianmenglogoxiao.png"
    elseif camp == GameField.Camp_Clan then--部落
        retImgPath = IconPath.liaotian .."buluologoxiao.png"
    end
    return retImgPath
end

--创建提醒图标
function IconUtil.CreateNoticeIcon(sprite, pos)
    local animAction = ActionHelper.createScaleActionForever()
    local retIcon = CreateCCSprite(IconPath.youjian.."i_hongdian.png")
    retIcon:runAction(animAction)
    if sprite then
        local size = sprite:getContentSize()
        if not pos then pos = cc.p(size.width*4/5, size.height*4/5) end
        retIcon:setPosition(pos)
        sprite:addChild(retIcon)
    end
    return retIcon
end
