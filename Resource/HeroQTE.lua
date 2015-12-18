require("SkeletonSkill")
HeroQTE = {}
local QTETAG = 634
function HeroQTE.autoQTE(rootLayer,fightHero,qteFinishCallBack,qteClickCallBack)
	local qteLayer = cc.Layer:create()
	qteLayer:setTouchEnabled(true)
	qteLayer:registerScriptTouchHandler(function(e,x,y) return true end,false,0,true)
	rootLayer:addChild(qteLayer,999,QTETAG) --随意设定634
	
	local path = "NewUi/qietu/qte/"
	local proSprite = CreateCCSprite(path.."daojishikuang.png")
	proSprite:setScale(1.5)
	proSprite:setPosition(cc.p(480,430))
	qteLayer:addChild(proSprite)
	
	local haoSprite = CreateCCSprite(path.."gantanhao.png")
	haoSprite:setPosition(cc.p(480,470))
	qteLayer:addChild(haoSprite)
	
	local delay = 0.2 --延迟时间
	local beforeTime = 0.05 --提前时间
	local clickIndex = 0
	local qteTime = fightHero.heroInfo.systemHero.qteTime
	local qteAddspeed = fightHero.heroInfo.systemHero.qteAddspeed
	local qteCount = qteTime / delay
	local arr1 = {}
	arr1[1] = cc.ProgressTo:create(qteTime+beforeTime,0)
	arr1[2] = cc.CallFunc:create(function() 
		qteFinishCallBack(fightHero)
		qteLayer:stopAllActions()
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
	
	local bgSprite = CreateCCSprite(path.."anniudi.png")
	bgSprite:setPosition(cc.p(830,200))
	qteLayer:addChild(bgSprite,999)
	
	local isTouch = true
	local function delayTouch(cd)
		local arr = {}
		arr[1] = cc.DelayTime:create(cd)
		arr[2] = cc.CallFunc:create(function() 
			isTouch = true
		end)
		local sq = cc.Sequence:create(arr)
		qteLayer:runAction(sq)
		isTouch = false
	end
	
	local function addSpeedBattle()
		local playerTime = 0
		local activeSkillList = fightHero.heroInfo.activeSkillList
		for k,v in pairs(activeSkillList) do
			if v.skillPos == 1 then
				playerTime = v.cdTime
			end
		end
		
		local cdTime = playerTime/(1+qteAddspeed)
		local arr = {}
		arr[1] = cc.DelayTime:create(cdTime)
		arr[2] = cc.CallFunc:create(function()
			qteClickCallBack(fightHero,cdTime-beforeTime,false)
		end)
		local sq = cc.Sequence:create(arr)
		qteLayer:runAction(cc.RepeatForever:create(sq))
		qteClickCallBack(fightHero,delay-beforeTime,false) --马上启动
	end
	addSpeedBattle()
	
	local function touchEvent(sender,eventType)
		if isTouch and eventType == ccui.TouchEventType.ended then
			
			delayTouch(delay)
			clickIndex = clickIndex + 1
			if clickIndex <= qteCount then --避免用工具刷
				qteClickCallBack(fightHero,delay-beforeTime,true)
			end
		end
    end
	
	local size = bgSprite:getContentSize()
	local imgPath = path.."quantoudianjiquyu.png"
	local button = ccui.Button:create()
    button:setTouchEnabled(true)
    button:loadTextures(imgPath,imgPath,"")
    button:setPosition(cc.p(size.width/2+3,size.height/2+18))        
    button:addTouchEventListener(touchEvent)
    bgSprite:addChild(button)

	local skeleteSkill = SkeletonSkill:New()
	local skelete = skeleteSkill:Create("reddanci",1)
	skelete:setPosition(cc.p(size.width/2+3,size.height/2-10))
	bgSprite:addChild(skelete,100)
end

function HeroQTE.removeQteLayer(rootLayer,fightHero)
	if fightHero.isWaitQTE and rootLayer:getChildByTag(QTETAG) then
		rootLayer:removeChildByTag(QTETAG)
	end
end