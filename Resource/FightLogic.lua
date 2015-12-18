require("FightPlayer")
require("FightReport")
require("FightHero")
require("SkillAI")
require("Formula")
require("FightConfig")
require("SkeletonAction")

FightLogic = {}

function FightLogic:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function FightLogic:intiConfigFight(rootLayer,fightResult)
	--添加背景层
    local bgLayer = cc.Layer:create()
	rootLayer:addChild(bgLayer,-1)
	self.rootLayer = rootLayer
	
	SkillEffect.initBuffInfo() --初始化数据。
	self.fightReport = FightReport.parseFightReport(fightResult)
	
    self.fightPlayer = FightPlayer:New()
	self.fightPlayer:init(self,self.fightReport)
end

function FightLogic:setOnInitFightCallBack(onInitFightCallBack)
	self.onInitFightCallBack = onInitFightCallBack
end

function FightLogic:setOnFrontFightCallBack(onFrontFightCallBack)
	self.onFrontFightCallBack = onFrontFightCallBack
end

function FightLogic:setOnReplyCrystalCallBack(onReplyCrystalCallBack)
	self.onReplyCrystalCallBack = onReplyCrystalCallBack
end

function FightLogic:setOnViolentCallBack(onViolentCallBack)
	self.onViolentCallBack = onViolentCallBack
end

function FightLogic:setOnCanPlaySkillCallBack(onCanPlaycallBack)
	self.onCanPlaycallBack = onCanPlaycallBack
end

function FightLogic:setOnShowSkillCallBack(onShowSkillCallBack)
	--onShowSkillCallBack(self.fightReport.headSkill)
end

function FightLogic:setOnUpdateHateCallback(onUpdateHateCallback)
	self.onUpdateHateCallback = onUpdateHateCallback
end

function FightLogic:setOnUpdateBossBloodCallback(onUpdateBossBloodCallback)
	self.onUpdateBossBloodCallback = onUpdateBossBloodCallback
end

function FightLogic:setOnUpdateHeroBloodCallback(onUpdateHeroBloodCallback)
	self.onUpdateHeroBloodCallback = onUpdateHeroBloodCallback
end

function FightLogic:setOnConsumeCrystalCallback(onConsumeCrystalCallback)
	self.onConsumeCrystalCallback = onConsumeCrystalCallback
end

function FightLogic:setOnFightOverCallback(onFightOverCallback)
	self.onFightOverCallback = onFightOverCallback
end

function FightLogic:setOnPauseCallBack(onPauseCallBack)
	self.onPauseCallBack = onPauseCallBack
end


---------------------用户主动操作----------------------
function FightLogic:doUserClickStartFight()
	self.fightPlayer:doActionAttack() --开始攻击
end

function FightLogic:doPlayHeadSkill(pos)
	self.fightPlayer:doPlayHeadSkill(pos)
end