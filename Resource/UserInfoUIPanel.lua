UserInfoUIPanel = {}

function UserInfoUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function UserInfoUIPanel:Create(para)
    local p_name = "UserInfoUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)

    local function formatNum(num)
        if num > 9999999 then
            num = math.floor(num/1000000)..'M'
        elseif num > 99999 then 
            num = math.floor(num/1000)..'K'
        end
        return num
    end
   
	function UserInfoUIPanel_refresh()
		local userBo = DataManager.getUserBO()
		local teamEpx1,teamEpx2 = DataManager.getSystemTeamExp()
		local baseExp = teamEpx2.exp-teamEpx1.exp
		local curExp = userBo.exp-teamEpx1.exp
		local expBar = curExp / baseExp
		
		self.panel:setBitmapText("lab_money",formatNum(userBo.money))
		self.panel:setBitmapText("lab_gold",formatNum(userBo.gold))
        self.panel:setBitmapText("lab_jobExp", formatNum(userBo.jobExp))
		self.panel:setBitmapText("lab_level",userBo.level)
        self.panel:setLabelText("lab_name", userBo.roleName)
        self.panel:setBitmapText("lab_vip", userBo.vipLevel)
        self.panel:setLabelText("lab_heroExp",curExp.."/"..baseExp)
		self.panel:setProgressBarPercent("pro_exp",expBar*100)
		self.panel:setBitmapText("lab_effective", userBo.effective)

		local systemHero = DataManager.getSceneHero()
		self.panel:setImageTexture("img_heroHead",IconPath.yingxiong..systemHero.imgId..".png")
		self.panel:setImageTexture("img_heroColor",IconPath.pinzhiYaun..systemHero.heroColor..".png")
	end
	UserInfoUIPanel_refresh()
	
	--战斗力
	local oldEffective = 10000
	function UserInfoUIPanel_effective(effective)
		local py = 0
		local ty = 0
		local ef = effective-oldEffective
		local fnt = nil
		local color = nil
		if ef < 0 then
			py = -140
			ty = 70
			ef = GameString.zhandouli..ef
			fnt = "zhanlihs30.fnt"
		else
			py = 140
			ty = -70
			ef = GameString.zhandouli.."+"..ef
			fnt = "zhanlils30.fnt"
		end
		
		local winSize = Director.getRealWinSize()
		local tmplayer = LayerManager.getGameLayer()
		local txtLbl = cc.LabelBMFont:create(ef,"NewUi/shuzibiaoqian/"..fnt)
		txtLbl:setPosition(cc.p(winSize.width/2,winSize.height/2+ty))
		tmplayer:addChild(txtLbl,1024)
	
		local arr1 = {}
		arr1[1] = cc.MoveBy:create(0.5,cc.p(0,py))
		arr1[2] = cc.FadeOut:create(0.5)
		arr1[3] = cc.CallFunc:create(function() 
			txtLbl:removeFromParent(true)
		end)
		local sq1 = cc.Sequence:create(arr1)
		txtLbl:runAction(sq1)
		
		local effectiveLab = self.panel:getChildByName("lab_effective")
		local function callback()
			effectiveLab:runAction(cc.ScaleTo:create(0.2,1))
		end
		
		local action = ActionHelper.createDataStepAction(effectiveLab,oldEffective,effective,callback)
		effectiveLab:runAction(action)
		effectiveLab:runAction(cc.ScaleTo:create(0.2,1.3))
		oldEffective = effective
	end
	
	function UserInfoUIPanel_OpenLoginReward30Info()
		local activity = DataManager.getSystemActivityList()
		if nil ~= activity and #activity >= 1 then
			local req = ActivityAction_getLoginReward30InfoReq:New()
			NetReqLua(req, true)
		end
	end
	
	function UserInfoUIPanel_getActivityTaskInfo()
		local assistReq = ActivityAction_getActivityTaskInfoReq:New()
		NetReqLua(assistReq, true)
	end
	
	local function btnCallBack(sender,tag)
		if tag == 0 then
			--UserInfoUIPanel_effective(math.random(10000))
			LayerManager.show("UserInfoDetailUIPanel")
		elseif tag == 1 then
			UserInfoUIPanel_OpenLoginReward30Info()
		elseif tag == 2 then
			LayerManager.show("ChartsUIPanel")
		elseif 3 == tag then	--请求小助手
			UserInfoUIPanel_getActivityTaskInfo()
		end
	end
	
	self.panel:addNodeTouchEventListener("btn_info",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_sign", btnCallBack, 1)
	self.panel:addNodeTouchEventListener("btn_charts", btnCallBack, 2)
	self.panel:addNodeTouchEventListener("btn_assist", btnCallBack, 3)
	
	--网络响应
	--响应签到活动数据请求 进入签到
	function UserInfoUIPanel_ActivityAction_getLoginReward30Info(msgObj)
		LayerManager.show("SignSystemUIPanel", {msgObj = msgObj})
	end
	--收到网络消息   进入小助手
	function UserInfoUIPanel_ActivityAction_getActivityTaskInfo(msgObj)
		LayerManager.show("AssistantUIPanel", {msgObj = msgObj.body})
	end
   
    return panel
end

--退出
function UserInfoUIPanel:Release()
	self.panel:Release()
end

--隐藏
function UserInfoUIPanel:Hide()
	self.panel:Hide()
end

--显示
function UserInfoUIPanel:Show()
	self.panel:Show()
end
