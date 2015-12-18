require("SkeletonSkill")
BossQTE = {}

--随机点
function BossQTE.getRandomPoint()
	local r = {1,2,3,4,5}
	local n = {}
	for k=1,5 do
		while true do
			local rd = math.random(5)
			if r[rd] > 0 then
				n[k] = r[rd]
				r[rd] = 0
				break
			end
		end
	end
	return n
end

--随机颜色
function BossQTE.getRandomColor(b)
	local n = {}
	for k=1,b do
		n[k] = math.random(3)
	end
	return n
end

--随机坐标
function BossQTE.getRandomPosition(idx)
	local p = {}
	local n = 5
	local s = 60
	for k=1,n do
		p[k] = {x=960*(2*k-1)/(n*2),y=100}
	end
	
	local x = p[idx].x
	local y = p[idx].y
	
	x = x-s/2 + math.random(s)
	y = p[idx].y + math.random(s*4)
	return x,y
end

--多次点击单个坐标
function BossQTE.getMuitleTouchPosition(idx)
	local p = {{x=800,y=150},{x=160,y=150},{x=480,y=150}}
	return p[idx].x,p[idx].y
end

--颜色坐标
function BossQTE.getColorTouchPosition(idx)
	local p = {{x=330,y=200},{x=480,y=200},{x=630,y=200}}
	return p[idx].x,p[idx].y
end

function BossQTE.DelayTimeFunc(rootLayer,delay,callBack)
	local arr = {}
    arr[1] = cc.DelayTime:create(delay)
    arr[2] = cc.CallFunc:create(callBack)
	local sq = cc.Sequence:create(arr)
	rootLayer:runAction(sq)
end

--所有英雄的状态
function BossQTE.stopAllHero(heroList,monsterList,state)
	for k,v in pairs(heroList)do
		if state then
			v.hero:pause()
			v.heroBg:pause()
		else
			v.hero:resume()
			v.heroBg:resume()
		end
		v.isWaitQTE = state
	end
	
	for k,v in pairs(monsterList)do
		if state then
			v.hero:pause()
			v.heroBg:pause()
		else
			v.hero:resume()
			v.heroBg:resume()
		end
		v.isWaitQTE = state
	end
end

function BossQTE.CreateButton(x,y,idx,qteLayer,btnCallback)
	local path = "NewUi/qietu/qte/"
	local bgSprite = CreateCCSprite(path.."anniudi.png")
	bgSprite:setPosition(cc.p(x,y))
	qteLayer:addChild(bgSprite,999)
	local size = bgSprite:getContentSize()
		
	local function touchEvent(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			btnCallback(bgSprite)
			SoundEffect.playSkillSound("button")
		end
    end

	idx = idx > 4 and 1 or idx
	local imgPath = path.."quantoudianjiquyu.png"
	local button = ccui.Button:create()
    button:setTouchEnabled(true)
    button:loadTextures(imgPath,imgPath,"")
    button:setPosition(cc.p(size.width/2+3,size.height/2+18))        
    button:addTouchEventListener(touchEvent)
    bgSprite:addChild(button)

	local skeleteImg = {"reddanci","greendanci","bluedianci","duocidianji"}
	local skeleteSkill = SkeletonSkill:New()
	local skelete = skeleteSkill:Create(skeleteImg[idx],1)
	skelete:setPosition(cc.p(size.width/2+3,size.height/2-10))
	bgSprite:addChild(skelete,100)
	return bgSprite
end

--简单点击QTE
function BossQTE.CreateSimpleTouchQTE(x,y,k,b,qteLayer,callback)
	local touchNum = 0
	local function btnCallBack(bgSprite)
		touchNum =  touchNum + 1
	    if callback and touchNum >= b then
			bgSprite:removeFromParent(true)
			callback(k)
	    end
	end
	BossQTE.CreateButton(x,y,1,qteLayer,btnCallBack)
end

--多点击QTE
function BossQTE.CreateMutilTouchQTE(x,y,k,b,qteLayer,callback)
	local function btnCallBack(bgSprite)
		callback(k)
	end
	BossQTE.CreateButton(x,y,4,qteLayer,btnCallBack)
end

--颜色QTE
function BossQTE.CreateColorTouchQTE(x,y,k,b,qteLayer,callback)
	local function btnCallBack(bgSprite)
		callback(k)
	end
	BossQTE.CreateButton(x,y,k,qteLayer,btnCallBack)
end

function BossQTE.CreateColorSprite(qteLayer,colorList)
	local spriteList = {}
	local path = "NewUi/qietu/qte/"
	local pathImg = {"hongsetishi.png","lvsetishi.png","lansetishi.png"}
	for k,v in pairs(colorList)do
		local colorSprite = CreateCCSprite(path..pathImg[v])
		colorSprite:setPosition(cc.p(480+(k*2-1-#colorList)*35,390))
		qteLayer:addChild(colorSprite)
		spriteList[k] = colorSprite
	end
	return spriteList
end

function BossQTE.CreateCombatSprite(qteLayer)
	local imgId = "NewUi/qietu/zhandou/lianji.png"
	local combatSprite = CreateCCSprite(imgId)
	combatSprite:setPosition(cc.p(460,390))
	qteLayer:addChild(combatSprite)
	
	local size = combatSprite:getContentSize()
	local fnt = "NewUi/qietu/ziti/num_30_yellow.fnt"	
	local txtLbl = cc.LabelBMFont:create("0",fnt)
	txtLbl:setPosition(cc.p(size.width,size.height/2))
	txtLbl:setAnchorPoint(cc.p(0,0.5))
	combatSprite:addChild(txtLbl)
	return combatSprite,txtLbl
end

--滑动
function BossQTE.CreateSlideTouchQTE(x,y,k,b,qteLayer,callback)
	local function btnCallBack(bgSprite)
		callback(k)
	end
	return BossQTE.CreateButton(x,y,1,qteLayer,btnCallBack)
end

function BossQTE.CreateQTELayer(rootLayer,c)
	local qteLayer = LayerHelper.createTranslucentLayer()
	qteLayer:setTouchEnabled(true)
	qteLayer:registerScriptTouchHandler(function(e,x,y) return true end,false,0,true)
	rootLayer:addChild(qteLayer,999)
	
	local path = "NewUi/qietu/qte/"
	local bgSprite = CreateCCSprite(path.."baisebantoudi.png")
	local size = bgSprite:getContentSize()
	bgSprite:setPosition(cc.p(480,430))
	qteLayer:addChild(bgSprite)
	
	local tipSprite = CreateCCSprite("NewUi/qietu/zhandou/boss_tip.png")
	tipSprite:setPosition(cc.p(size.width/2,size.height+50))
	bgSprite:addChild(tipSprite)
	
	local proSprite = CreateCCSprite(path.."daojishikuang.png")
	proSprite:setScale(1.5)
	proSprite:setPosition(cc.p(size.width/2,size.height/2+15))
	bgSprite:addChild(proSprite)
	
	local haoSprite = CreateCCSprite(path.."gantanhao.png")
	haoSprite:setPosition(cc.p(size.width/2,size.height-22))
	bgSprite:addChild(haoSprite)
	
	local arr1 = {}
	arr1[1] = cc.ProgressTo:create(c,0)
	arr1[2] = cc.CallFunc:create(function() 
		qteLayer:removeFromParent(true)
	end)
	
	local sq1 = cc.Sequence:create(arr1)
	local sz = proSprite:getContentSize()
	local progTimer = cc.ProgressTimer:create(CreateCCSprite(path.."daojishi.png"))
	progTimer:setPercentage(100)
	progTimer:setBarChangeRate({ x = 1, y = 0 })
	progTimer:setMidpoint({x = 1, y = 0 })
	progTimer:setPosition(cc.p(sz.width/2,sz.height/2))
	progTimer:setType(cc.PROGRESS_TIMER_TYPE_BAR)
	progTimer:runAction(sq1)
	proSprite:addChild(progTimer)
	
	return qteLayer
end

--单次点击
function BossQTE.playSinglePoint(a,b,c,qteLayer,qteCallBack)
	local stateList = {}
	local touchNum = 0
	local colorList = {1,1,1}
	local spriteList = BossQTE.CreateColorSprite(qteLayer,colorList)
	local function ckeckQTE(state)
		local flag = true
		for m=1,#stateList do
			if stateList[m] == 0 then
				flag = false
			end
		end
		if flag or state then
			qteCallBack(flag)
		end
	end
	
	local rd = BossQTE.getRandomPoint()
	for k=1,a do
		stateList[k] = 0
		local x,y = BossQTE.getRandomPosition(rd[k])
		BossQTE.DelayTimeFunc(qteLayer,0.05*k,function() 
			BossQTE.CreateSimpleTouchQTE(x,y,k,b,qteLayer,function(m) 
				touchNum = touchNum + 1
				spriteList[touchNum]:setVisible(false)
				
				stateList[m] = 1
				ckeckQTE(false)
			end)
		end)
	end
	
	BossQTE.DelayTimeFunc(qteLayer,c,function() 
		ckeckQTE(true)
	end)
end

--多点
function BossQTE.playMultiPoint(a,b,c,qteLayer,qteCallBack)
	local touchNum = 0
	local combatSprite,txtLabel = BossQTE.CreateCombatSprite(qteLayer)
	for k=1,a do
		local x,y = BossQTE.getMuitleTouchPosition(k)
		BossQTE.DelayTimeFunc(qteLayer,0.05*k,function() 
			BossQTE.CreateMutilTouchQTE(x,y,k,b,qteLayer,function(m)
				touchNum =  touchNum + 1
				txtLabel:setString(touchNum)
				
				local arr = {}
				local mx,my = 460,390
				combatSprite:setPosition(cc.p(mx,my))
				arr[1] = cc.MoveTo:create(0.1,cc.p(mx-10,my))
				arr[2] = cc.MoveTo:create(0.1,cc.p(mx,my))
				local sq = cc.Sequence:create(arr)
				combatSprite:runAction(sq)
			end)
		end)
	end
	
	BossQTE.DelayTimeFunc(qteLayer,c,function() 
		if touchNum >= b then
			qteCallBack(true)
		else
			qteCallBack(false)
		end
	end)
end

function BossQTE.playColorPoint(a,b,c,qteLayer,qteCallBack)
	local touchNum = 0		
	local stateList = {}
	local colorList = BossQTE.getRandomColor(b)
	local spriteList = BossQTE.CreateColorSprite(qteLayer,colorList)
	
	local function ckeckQTE()
		local flag = true
		for k=1,b do
			if stateList[k] == nil then
				flag = false
			end
		end
		qteCallBack(flag)
	end
	
	for k=1,a do
		local x,y = BossQTE.getColorTouchPosition(k)
		BossQTE.DelayTimeFunc(qteLayer,0.05*k,function() 
			BossQTE.CreateColorTouchQTE(x,y,k,b,qteLayer,function(m)
				touchNum =  touchNum + 1
				if colorList[touchNum] ==  m then
					stateList[touchNum] = 1
					spriteList[touchNum]:setVisible(false)
				else
					touchNum = 0
					stateList = {}
					for i=1,#spriteList do
						spriteList[i]:setVisible(true)
					end
				end
				
				if touchNum == b then
					ckeckQTE()
				end
			end)
		end)
	end
	
	BossQTE.DelayTimeFunc(qteLayer,c,function()
		ckeckQTE()
	end)
end

function BossQTE.playSlidePoint(a,b,c,qteLayer,qteCallBack)
	local touchNum = 0	
	local stateList = {}	
	local buttonList = {}
	local recordList = {}
	local touchLayer = cc.Layer:create()
	touchLayer:setTouchEnabled(true)
	qteLayer:addChild(touchLayer,999)
	
	local colorList = {1,1,1}
	local spriteList = BossQTE.CreateColorSprite(qteLayer,colorList)
	
	local function ckeckQTE(state)
		local flag = true
		for k,v in pairs(stateList) do
			if stateList[k] == 0 then
				flag = false
			end
		end
		if flag or state then
			qteCallBack(flag)
		end
	end

	local rd = BossQTE.getRandomPoint()
	for k=1,a do
		stateList[k] = 0
		local x,y = BossQTE.getRandomPosition(rd[k])
		recordList[k] = {x=x,y=y}
		BossQTE.DelayTimeFunc(qteLayer,0.05*k,function() 
			buttonList[k] = BossQTE.CreateSlideTouchQTE(x,y,k,b,qteLayer,function(m)
			end)
		end)
	end
	
	BossQTE.DelayTimeFunc(qteLayer,c,function()
		ckeckQTE(true)
	end)
	
	touchLayer:registerScriptTouchHandler(function (e,x,y)
		x = touchLayer:convertToNodeSpace(cc.p(x,y)).x
		y = touchLayer:convertToNodeSpace(cc.p(x,y)).y
		if e=="began" then	
			
		elseif e=="moved" then
			for k,v in pairs(recordList)do
				if buttonList[k]:isVisible() then
					if math.abs(v.x-x) < 100 and math.abs(v.y-y) < 100 then
						touchNum = touchNum + 1
						stateList[k] = 1
						buttonList[k]:setVisible(false)
						spriteList[touchNum]:setVisible(false)
						break
					end
				end
			end
		else
			ckeckQTE(false)
		end
		return true
	end,false,0,true)
end

function BossQTE.playQTE(rootLayer,systemQte,effectQte,heroList,monsterList,qteFinishCallBack,qteClickCallBack)
	local msgObj = transformEffectParams(systemQte.funParams)	--转换效果
	local a =  msgObj.a or 1 --数量
	local b =  msgObj.b or 1 --次数
	local c =  msgObj.c or 1 --时间
	
	local qteLayer = BossQTE.CreateQTELayer(rootLayer,c)
	local qteEffectId = effectQte.qteEffectId
	qteEffectId = StaticField.qteEffectId6
	
	local function qteCallBack(flag)
		qteLayer:stopAllActions()
		rootLayer:stopAllActions()
		qteLayer:removeFromParent(true)
		qteFinishCallBack(flag,systemQte.skillId,qteEffectId)
		BossQTE.stopAllHero(heroList,monsterList,false)
	end
	
	local function clickCallBack()
		qteClickCallBack()
	end
	
	if qteEffectId == StaticField.qteEffectId1 then
		BossQTE.playSinglePoint(a,b,c,qteLayer,qteCallBack)
	elseif qteEffectId == StaticField.qteEffectId2 then
		BossQTE.playMultiPoint(a,b,c,qteLayer,qteCallBack)
	elseif qteEffectId == StaticField.qteEffectId3 then
		BossQTE.playColorPoint(a,b,c,qteLayer,qteCallBack)
	elseif qteEffectId == StaticField.qteEffectId4 then
		BossQTE.playSlidePoint(a,b,c,qteLayer,qteCallBack)
	elseif qteEffectId == StaticField.qteEffectId5 then

	end
end

function BossQTE.autoQTE(rootLayer,systemQTE,qteTriggerType,heroList,monsterList,qteFinishCallBack)
	if #systemQTE == 0 then
		return
	end
	
	for k,v in pairs(systemQTE)do
		local effectQte = DataManager.getSystemMonsterQteEffectId(v.qteEffectId)
		if qteTriggerType ==  effectQte.triggerType then
			if effectQte.triggerType ==  StaticField.qteTriggerType0 then
			
			elseif effectQte.triggerType ==  StaticField.qteTriggerType1 then
			
			elseif effectQte.triggerType ==  StaticField.qteTriggerType2 then
				v.triggerParas = 3
				BossQTE.DelayTimeFunc(rootLayer,v.triggerParas,function() 
					BossQTE.stopAllHero(heroList,monsterList,true)
					BossQTE.playQTE(rootLayer,v,effectQte,heroList,monsterList,qteFinishCallBack)
				end)
			end
		end
	end
end