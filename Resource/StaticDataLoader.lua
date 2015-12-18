-- 静态数据加载器
require("ResourcesManager")

StaticDataLoader = { }

-- 从本地取数据
local DIR = "static_data/"
local DIR_FORCES = "static_data_forces/"
local DIR_CLIENT = "static_data_client/"

-- 读取json数据，为table
function ReadJsonFileContentTable(filePath)
    local filename = string.sub(filePath, 1, -6)
    local luafile = filename .. ".lua"
    if file_exists(luafile) then
        return require(filename)
    else
        return ReadEncryptFileContentTable(filePath)
    end
end

function StaticDataLoader.loadSystemAi()
    local file = "SystemAi.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.systemAiId do
        local temp = { }
        temp.systemAiId = data.systemAiId[i]
        temp.aiName = data.aiName[i]
        temp.alertScope = data.alertScope[i]
        temp.attackType = data.attackType[i]
        temp.alertType = data.alertType[i]
        dic[temp.systemAiId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemBasicAttribute()
    local file = "SystemBasicAttribute.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.careerId do
        local temp = { }
        temp.careerId = data.careerId[i]
        temp.basicAttributeId = data.basicAttributeId[i]
        temp.hp = data.hp[i]
        temp.attackPower = data.attackPower[i]
        temp.magicPower = data.magicPower[i]
        temp.armor = data.armor[i]
        temp.magicResist = data.magicResist[i]
        temp.attackSpeed = data.attackSpeed[i]
        temp.speedUp = data.speedUp[i]
        temp.penetration = data.penetration[i]
        temp.breakArmor = data.breakArmor[i]
        temp.hit = data.hit[i]
        temp.dodge = data.dodge[i]
        temp.phyCrit = data.phyCrit[i]
        temp.magCrit = data.magCrit[i]
        temp.tenacity = data.tenacity[i]
        temp.parry = data.parry[i]
        temp.accurate = data.accurate[i]
        temp.master = data.master[i]
        temp.hitParry = data.hitParry[i]
        temp.energy = data.energy[i]
        temp.energyRecover = data.energyRecover[i]
        temp.moveSpeed = data.moveSpeed[i]
        dic[temp.careerId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemForces()
    local file = "SystemForces.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.forcesId do
        local temp = { }
        temp.forcesId = data.forcesId[i]
        temp.preForcesId = data.preForcesId[i]
        temp.bigForcesId = data.bigForcesId[i]
        --temp.difficulty = data.difficulty[i]  去除
        temp.forcesCategory = data.forcesCategory[i]
        temp.imgId = data.imgId[i]
        temp.forcesName = data.forcesName[i]
        temp.forcesDesc = data.forcesDesc[i]
        temp.needResourceNum = data.needResourceNum[i]
        temp.attackPeriod = data.attackPeriod[i]
        --temp.attackLimitTimes = data.attackLimitTimes[i]  移至forceMonster
        temp.resId = data.resId[i]
        temp.collectionTime = data.collectionTime[i]
        temp.mapId = data.mapId[i]
		temp.modelScale = data.modelScale[i]
		temp.forcesTitle = data.forcesTitle[i]
        temp.x = data.x[i]
        temp.y = data.y[i]
        dic[temp.forcesId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemBigForces()
    local file = "SystemBigForces.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.bigForcesId do
        local temp = { }
        temp.bigForcesId = data.bigForcesId[i]
        temp.bigForcesName = data.bigForcesName[i]
        temp.limitLevel = data.limitLevel[i]
        temp.imgId = data.imgId[i]
        temp.mapId = data.mapId[i]
        temp.x = data.x[i]
        temp.y = data.y[i]
        dic[temp.bigForcesId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemForcesDropTool()
    local file = "SystemForcesDropTool.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.forcesDropId do
        local temp = { }
        temp.forcesDropId = data.forcesDropId[i]
        temp.forcesId = data.forcesId[i]
        temp.toolType = data.toolType[i]
        temp.toolId = data.toolId[i]
        temp.toolName = data.toolName[i]
        temp.lowerNum = data.lowerNum[i]
        temp.upperNum = data.upperNum[i]
        temp.minNum = data.minNum[i]
        temp.maxNum = data.maxNum[i]
        dic[temp.forcesDropId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemForcesMonster()
    local file = "SystemForcesMonster.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.forcesId do
        local temp = { }
        temp.forcesId = data.forcesId[i]
        temp.monsterId = data.monsterId[i]
        temp.forcesType = data.forcesType[i]
        temp.attackLimitTimes = data.attackLimitTimes[i]
        dic[i] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemFormulaPara()
    local file = "SystemFormulaPara.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.formulaId do
        local temp = { }
        temp.formulaId = data.formulaId[i]
        temp.remark = data.remark[i]
        temp.fightParaA = data.fightParaA[i]
        temp.fightParaB = data.fightParaB[i]
        temp.fightParaC = data.fightParaC[i]
        temp.fightParaD = data.fightParaD[i]
        temp.fightParaE = data.fightParaE[i]
        dic[temp.formulaId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemHeroLevel()
    local file = "SystemHeroLevel.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.level do
        local temp = { }
		temp.color = data.color[i]
        temp.level = data.level[i]
        temp.exp = data.exp[i]
        dic[i] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemHateValue()
    local file = "SystemHateValue.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.careerId do
        local temp = { }
        temp.careerId = data.careerId[i]
        temp.dodgeHateValue1 = data.dodgeHateValue1[i]
        temp.dodgeHateValue2 = data.dodgeHateValue2[i]
        temp.dodgeHateValue3 = data.dodgeHateValue3[i]
        temp.parryHateValue1 = data.parryHateValue1[i]
        temp.parryHateValue2 = data.parryHateValue2[i]
        temp.parryHateValue3 = data.parryHateValue3[i]
        temp.hitParryHateValue1 = data.hitParryHateValue1[i]
        temp.hitParryHateValue2 = data.hitParryHateValue2[i]
        temp.hitParryHateValue3 = data.hitParryHateValue3[i]
        dic[temp.careerId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemHero()
    local file = "SystemHero.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.systemHeroId do
        local temp = { }
        temp.systemHeroId = data.systemHeroId[i]
        temp.heroId = data.heroId[i]
        temp.heroName = data.heroName[i]
        temp.heroDesc = data.heroDesc[i]
        temp.heroColor = data.heroColor[i]
        temp.careerId = data.careerId[i]
        temp.detailedCareerId = data.detailedCareerId[i]
        temp.nationId = data.nationId[i]
        temp.raceId = data.raceId[i]
        temp.sexId = data.sexId[i]
        temp.resId = data.resId[i]
		temp.mainPropertyId = data.mainPropertyId[i]
        temp.imgId = data.imgId[i]
        temp.maxLevel = data.maxLevel[i]
        temp.frame = data.frame[i]
        temp.standId = data.standId[i]
        temp.skill01 = data.skill01[i]
        temp.skill02 = data.skill02[i]
        temp.skill03 = data.skill03[i]
        temp.skill04 = data.skill04[i]
        temp.skill05 = data.skill05[i]
        temp.objectSkill01 = data.objectSkill01[i]
        temp.objectSkill02 = data.objectSkill02[i]
        temp.objectSkill03 = data.objectSkill03[i]
        temp.objectSkill04 = data.objectSkill04[i]
        temp.modelScale = data.modelScale[i]
        temp.qteTime = data.qteTime[i]
        temp.qteAddspeed = data.qteAddspeed[i]
        temp.petId = data.petId[i]
        temp.petPercentage = data.petPercentage[i]
        temp.heroTitle = data.heroTitle[i]
        dic[temp.systemHeroId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemHeroAttribute()
    local file = "SystemHeroAttribute.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.systemHeroId do
        local temp = { }
        temp.systemHeroId = data.systemHeroId[i]
        temp.miniDamage = data.miniDamage[i]
        temp.maxDamage = data.maxDamage[i]
        temp.strength = data.strength[i]
        temp.strengthUp = data.strengthUp[i]
        temp.agile = data.agile[i]
        temp.agileUp = data.agileUp[i]
        temp.stamina = data.stamina[i]
        temp.staminaUp = data.staminaUp[i]
        temp.intelligence = data.intelligence[i]
        temp.intelligenceUp = data.intelligenceUp[i]
        temp.hp = data.hp[i]
        temp.attackPower = data.attackPower[i]
        temp.magicPower = data.magicPower[i]
        temp.armor = data.armor[i]
        temp.armorOdds = data.armorOdds[i]
		temp.resistance = data.resistance[i]
		temp.resistanceOdds = data.resistanceOdds[i]
        temp.speedUp = data.speedUp[i]
        temp.dodge = data.dodge[i]
        temp.dodgeOdds = data.dodgeOdds[i]
        temp.phyCrit = data.phyCrit[i]
        temp.parry = data.parry[i]
        temp.parryOdds = data.parryOdds[i]
        temp.energy = data.energy[i]
        temp.energyRecover = data.energyRecover[i]
        temp.moveSpeed = data.moveSpeed[i]
        temp.attackType = data.attackType[i]
        temp.attackRange = data.attackRange[i]
        temp.damageIncrease = data.damageIncrease[i]
        temp.toughIncrease = data.toughIncrease[i]
        temp.treatmentIncrease = data.treatmentIncrease[i]
        temp.speedOdds = data.speedOdds[i]
        temp.dodgeOdds = data.dodgeOdds[i]
        temp.critOdds = data.critOdds[i]
        temp.physicsTough = data.physicsTough[i]
        temp.magicTough = data.magicTough[i]
		temp.miniDamage = data.miniDamage[i]
		temp.maxDamage = data.maxDamage[i]
        -- temp.spirit=data.spirit[i]
        -- temp.spiritUp=data.spiritUp[i]
        -- temp.magicResist=data.magicResist[i]
        -- temp.attackSpeed=data.attackSpeed[i]
        -- temp.penetration=data.penetration[i]
        -- temp.breakArmor=data.breakArmor[i]
        -- temp.hit=data.hit[i]
        -- temp.magCrit=data.magCrit[i]
        -- temp.tenacity=data.tenacity[i]
        -- temp.accurate=data.accurate[i]
        -- temp.master=data.master[i]
        -- temp.hitParry=data.hitParry[i]
        dic[temp.systemHeroId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemHeroSkill()
    local file = "SystemHeroSkill.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.systemHeroSkillId do
        local temp = { }
        temp.systemHeroSkillId = data.systemHeroSkillId[i]
        temp.skillLevel = data.skillLevel[i]
        temp.skillId = data.skillId[i]
        temp.needCrystal = data.needCrystal[i]
        temp.color = data.color[i]
        temp.exp = data.exp[i]
        dic[i] = temp
    end
    return dic
end
function StaticDataLoader.loadSystemHeroSkillConfig()
    local file = "SystemHeroSkillConfig.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.systemHeroSkillId do
        local temp = { }
        temp.systemHeroSkillId = data.systemHeroSkillId[i]
        temp.level = data.level[i]
        temp.vipLevel = data.vipLevel[i]
        temp.money = data.money[i]
        temp.gold = data.gold[i]
        dic[temp.systemHeroSkillId] = temp
    end
    return dic
end
function StaticDataLoader.loadSystemHeroSkillLevelMax()
    local file = "SystemSkillLevelMax.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.color do
        local temp = { }
        temp.color = data.color[i]
        temp.max = data.max[i]
        dic[temp.color] = temp
    end
    return dic
end
function StaticDataLoader.loadSystemHeroSkillAction()
    local file = "SystemHeroSkillAction.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.heroId do
        local temp = { }
        temp.heroId = data.heroId[i]
        temp.skillId = data.skillId[i]
        temp.actionId = data.actionId[i]
        dic[temp.heroId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemMap()
    local file = "SystemMap.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.mapId do
        local temp = { }
        temp.mapId = data.mapId[i]
        temp.mapName = data.mapName[i]
        temp.mapDesc = data.mapDesc[i]
        temp.imgId = data.imgId[i]
        temp.breakPoint = data.breakPoint[i]
        temp.mapBirth = data.mapBirth[i]
        temp.mapNum = data.mapNum[i]
        temp.thingResId = data.thingResId[i]
		temp.soundEffectId = data.soundEffectId[i]
		temp.town = data.town[i]
        temp.hasTownLogo = data.hasTownLogo[i]
        dic[temp.mapId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemMonster()
    local file = "SystemMonster.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.systemMonsterId do
        local temp = { }
        temp.systemMonsterId = data.systemMonsterId[i]
        temp.systemHeroId = data.systemHeroId[i]
        temp.level = data.level[i]
        temp.aiId = data.aiId[i]
        temp.monsterType = data.monsterType[i]
        dic[temp.systemMonsterId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemNpc()
    local file = "SystemNpc.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end
    local dic = { }
    for i = 1, #data.systemNpcId do
        local temp = { }
        temp.systemNpcId = data.systemNpcId[i]
        temp.npcName = data.npcName[i]
        temp.npcTalking = data.npcTalking[i]
        temp.resId = data.resId[i]
        temp.npcFunction = data.npcFunction[i]
        temp.mapId = data.mapId[i]
        temp.imgId = data.imgId[i]
        temp.x = data.x[i]
		temp.y = data.y[i]
		temp.npcTitle = data.npcTitle[i]
        temp.modelScale = data.modelScale[i]
        dic[temp.systemNpcId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemScene()
    local file = "SystemScene.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.sceneId do
        local temp = { }
        temp.sceneId = data.sceneId[i]
        temp.sceneType = data.sceneType[i]
        temp.sceneName = data.sceneName[i]
        temp.mapId = data.mapId[i]
		temp.minLevel = data.minLevel[i]
        dic[temp.sceneId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemSkill()
    local file = "SystemSkill.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.skillId do
        local temp = { }
        temp.skillId = data.skillId[i]
        temp.name = data.name[i]
        temp.remark = data.remark[i]
        temp.triggerType = data.triggerType[i]
        temp.resId = data.resId[i]
        temp.imgId = data.imgId[i]
        temp.expend = data.expend[i]
        temp.singTime = data.singTime[i]
        temp.cdTime = data.cdTime[i]
        temp.skillScope = data.skillScope[i]
        temp.skillDistance = data.skillDistance[i]
        temp.skillReferencePoint = data.skillReferencePoint[i]
        temp.targetSelect = data.targetSelect[i]
        temp.prop = data.prop[i]
        temp.textId = data.textId[i]
        temp.addMorale = data.addMorale[i]
        temp.isFar = data.isFar[i]
        temp.effectTimes = data.effectTimes[i]
        temp.needCareer = data.needCareer[i]
        dic[temp.skillId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemSkillEffect()
    local file = "SystemSkillEffect.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.skillEffectId do
        local temp = { }
        temp.skillEffectId = data.skillEffectId[i]
        temp.skillId = data.skillId[i]
        temp.effectId = data.effectId[i]
        temp.params = data.params[i]
        temp.round = data.round[i]
        temp.period = data.period[i]
        temp.triggerType = data.triggerType[i]
        temp.selectType = data.selectType[i]
        temp.showText = data.showText[i]
        temp.textName = data.textName[i]
        temp.showIcons = data.showIcons[i]
        temp.immediately = data.immediately[i]
        temp.removeAble = data.removeAble[i]
        temp.isReadRes = data.isReadRes[i]
        temp.nextEffectId = data.nextEffectId[i]
        temp.nextSelectType = data.nextSelectType[i]
        temp.addType = data.addType[i]
        temp.targetSelect = data.targetSelect[i]
        temp.appearType = data.appearType[i]
        temp.removeType = data.removeType[i]
        temp.invincible = data.invincible[i]
        temp.checkValue = data.checkValue[i]
        temp.hateValue1 = data.hateValue1[i]
        temp.hateValue2 = data.hateValue2[i]
        temp.hateValue3 = data.hateValue3[i]
        dic[temp.skillEffectId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemSkillEffectDefine()
    local file = "SystemSkillEffectDefine.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.effectId do
        local temp = { }
        temp.effectId = data.effectId[i]
        temp.remark = data.remark[i]
        temp.type = data.type[i]
        temp.name = data.name[i]
        temp.funId = data.funId[i]
        dic[temp.effectId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemTask()
    local file = "SystemTask.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.systemTaskId do
        local temp = { }
        temp.systemTaskId = data.systemTaskId[i]
        temp.taskType = data.taskType[i]
        temp.premiseTask = data.premiseTask[i]
        temp.taskName = data.taskName[i]
        temp.taskDesc = data.taskDesc[i]
        temp.needFinishTimes = data.needFinishTimes[i]
        temp.limitMinLevel = data.limitMinLevel[i]
        temp.limitMaxLevel = data.limitMaxLevel[i]
        temp.taskLibrary = data.taskLibrary[i]
        temp.taskPara = data.taskPara[i]
        temp.receiveTaskContent = data.receiveTaskContent[i]
        temp.handinTaskContent = data.handinTaskContent[i]
        temp.receiveTaskNpc = data.receiveTaskNpc[i]
        temp.handinTaskNpc = data.handinTaskNpc[i]
        temp.rewards = data.rewards[i]
        temp.imgId = data.imgId[i]
        temp.sort = data.sort[i]
        temp.logicSort = data.logicSort[i]
        temp.effectBeginTime = data.effectBeginTime[i]
        temp.effectEndTime = data.effectEndTime[i]
        temp.camp = data.camp[i]
		temp.status = GameField.taskStatus0
		temp.finishTimes = 0
        dic[temp.systemTaskId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemDailyTask()
    local file = "SystemDailyTask.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.systemTaskId do
        local temp = { }
        temp.systemTaskId = data.systemTaskId[i]
        temp.star = data.star[i]
        temp.minLevel = data.minLevel[i]
        temp.maxLevel = data.maxLevel[i]
        temp.lowerNum = data.lowerNum[i]
        temp.upperNum = data.upperNum[i]
        temp.camp = data.camp[i]
        temp.rewards = data.rewards[i]
        if not dic[temp.systemTaskId] then
            dic[temp.systemTaskId] = {}
        end
        dic[temp.systemTaskId][temp.star] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemTeamExp()
    local file = "SystemTeamExp.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.systemTeamLevel do
        local temp = { }
        temp.systemTeamLevel = data.systemTeamLevel[i]
        temp.exp = data.exp[i]
        temp.battleNum = data.battleNum[i]
        dic[temp.systemTeamLevel] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemTool()
    local file = "SystemTool.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.toolId do
        local temp = {}
        temp.toolId = data.toolId[i]
        temp.type = data.type[i]
        temp.color = data.color[i]
		temp.level = data.level[i]
        temp.name = data.name[i]
        temp.description = data.description[i]
        temp.isSell = data.isSell[i]
        temp.moneyType = data.moneyType[i]
        temp.price = data.price[i]
        temp.imgId = data.imgId[i]
        temp.animation = data.animation[i]
        temp.checkType = data.checkType[i]
        temp.sort = data.sort[i]
        temp.num = data.num[i]
        temp.overlapMax = data.overlapMax[i]
        temp.openBoxNeedLevel = data.openBoxNeedLevel[i]
        dic[temp.toolId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemTransfer()
    local file = "SystemTransfer.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.transferId do
        local temp = { }
        temp.transferId = data.transferId[i]
        temp.sceneId = data.sceneId[i]
        temp.resId = data.resId[i]
        temp.mapId = data.mapId[i]
        temp.level = data.level[i]
		temp.x = data.x[i]
        temp.y = data.y[i]
        dic[temp.transferId] = temp
    end
    return dic
end

-- 随机姓名表
function StaticDataLoader.loadName()
    local file = "SystemNameRule.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end
    return data
end

--[[function StaticDataLoader.loadSystemPrestigeLevel()
    local file = "SystemPrestigeLevel.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.level do
        local temp = { }
        temp.level = data.level[i]
        temp.exp = data.exp[i]
        dic[temp.level] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemPrestigeRewards()
    local file = "SystemPrestigeRewards.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.id do
        local temp = { }
        temp.id = data.id[i]
        temp.level = data.level[i]
        temp.rewards = data.rewards[i]
        dic[temp.id] = temp
    end
    return dic
end]]

function StaticDataLoader.loadSystemInviteHero()
    local file = "SystemInviteHero.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = {}
    for i = 1, #data.systemHeroId do
        local temp = {}
        temp.systemHeroId = data.systemHeroId[i]
        temp.level = data.level[i]
        temp.needGold = data.needGold[i]
        temp.camp = data.camp[i]
        dic[i] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemSkillLevel()
    local file = "SystemSkillLevel.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end
    local dic = { }
    for i = 1, #data.level do
        local temp = { }
        temp.level = data.level[i]
        temp.exp = data.exp[i]
        temp.color = data.color[i]
        temp.gold = data.gold[i]
        dic[temp.level .. "_" .. temp.color] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemQte()
    local file = "SystemQte.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.qteId do
        local temp = { }
        temp.qteId = data.qteId[i]
        temp.qteEffectId = data.qteEffectId[i]
        temp.monsterId = data.monsterId[i]
        temp.funParams = data.funParams[i]
        temp.triggerParas = data.triggerParas[i]
        temp.skillId = data.skillId[i]
        dic[temp.qteId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemQteEffect()
    local file = "SystemQteEffect.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.qteEffectId do
        local temp = { }
        temp.qteEffectId = data.qteEffectId[i]
        temp.name = data.name[i]
        temp.remark = data.remark[i]
        temp.funId = data.funId[i]
        temp.triggerType = data.triggerType[i]
        dic[temp.qteEffectId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemExploreExchange()
    local file = "SystemExploreExchange.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.systemHeroId do
        local temp = { }
        temp.systemHeroId = data.systemHeroId[i]
        temp.needIntegral = data.needIntegral[i]
        temp.needLevel = data.needLevel[i]
        temp.needVipLevel = data.needVipLevel[i]
        temp.camp = data.camp[i]
        dic[i] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemExploreMap()
    local file = "SystemExploreMap.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.mapId do
        local temp = { }
        temp.mapId = data.mapId[i]
        temp.name = data.name[i]
        temp.camp = data.camp[i]
        temp.resId = data.resId[i]
        temp.lowerNum = data.lowerNum[i]
        temp.upperNum = data.upperNum[i]
        temp.description = data.description[i]
        dic[temp.mapId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemExploreReward()
    local file = "SystemExploreReward.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.mapId do
        local temp = {}
        temp.mapId = data.mapId[i]
        temp.type = data.type[i]
        temp.rewards = data.rewards[i]
        temp.minLevel = data.minLevel[i]
        temp.maxLevel = data.maxLevel[i]
        temp.description = data.description[i]
		temp.result = data.result[i]
		dic[i] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemPawnShop()
    local file = "SystemPawnshop.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.mallId do
        local temp = { }
        temp.mallId = data.mallId[i]
        temp.toolType = data.toolType[i]
        temp.toolId = data.toolId[i]
        temp.toolNum = data.toolNum[i]
        temp.category = data.category[i]
        temp.price = data.price[i]
        dic[temp.mallId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemHeroProfit()
    local file = "SystemHeroProfit.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.systemCareerId do
        local temp = { }
        temp.systemCareerId = data.systemCareerId[i]
        temp.stamina = data.stamina[i]
        temp.strength = data.strength[i]
        temp.agile = data.agile[i]
        temp.intelligence = data.intelligence[i]
        dic[temp.systemCareerId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemMessageClient()
    local file = "SystemMessageClient.json"
	
	local data = ReadJsonFileContentTable(DIR..file)
    if not data then return nil end
	
	local dic = {}
    for i=1,#data.ID do
		local t =  {}
		t.ID = data.ID[i]
		t.txt = data.content[i]
		table.insert(dic,t)
    end
	return dic
end

function StaticDataLoader.loadSystemEquipAttr()
    local file = "SystemEquipAttr.json"
	
	local data = ReadJsonFileContentTable(DIR..file)
    if not data then return nil end
	
	local dic = {}
    for i=1,#data.equipId do
        local tmp = {}
        tmp.equipId = data.equipId[i]
        tmp.systemEquipAttrId = data.systemEquipAttrId[i]
        tmp.miniDamage = data.miniDamage[i]--最小伤害
        tmp.maxDamage = data.maxDamage[i]--最小伤害
        tmp.strength = data.strength[i]--力量
        tmp.agile = data.agile[i]--敏捷
        tmp.intelligence = data.intelligence[i]--智力
        tmp.stamina = data.stamina[i]--耐力
        tmp.hp = data.hp[i]--生命
        tmp.attackPower = data.attackPower[i]--攻击强度
        tmp.magicPower = data.magicPower[i]--法术强度
        tmp.phyCrit = data.phyCrit[i]--暴击
        tmp.armor = data.armor[i]--护甲
        tmp.dodge = data.dodge[i]--闪避
        tmp.speedUp = data.speedUp[i]--急速
        tmp.damageIncrease = data.damageIncrease[i]--伤害增幅
        tmp.toughIncrease = data.toughIncrease[i]--伤害减免增幅
        tmp.treatmentIncrease = data.treatmentIncrease[i]--治疗增幅
        tmp.parry = data.parry[i]--格挡
        dic[tmp.equipId] = tmp
    end
    return dic
end


function StaticDataLoader.loadSystemEquip()
    local file = "SystemEquip.json"
	
	local data = ReadJsonFileContentTable(DIR..file)
    if not data then return nil end
	local dic = {}
    for i=1,#data.equipId do
		local tmp =  {}
        tmp.equipId = data.equipId[i]
        tmp.toolId = tmp.equipId--附加字段 配合其在道具界面
        tmp.type = GameField.equip--附加字段 配合其在道具界面
		tmp.name = data.name[i]--装备名字
		tmp.quality = data.quality[i]--装备品质
		tmp.equipType = data.equipType[i]--装备类型
		tmp.level = data.level[i]--装备等级
        tmp.isSell = data.isSell[i]--是否可出售
        tmp.moneyType = data.moneyType[i]--出售类型
		tmp.price = data.price[i]--售价
		tmp.imgId = data.imgId[i]--装备图标
		tmp.needCareer = Split(data.needCareer[i], ",")--需要职业注意格式(1，2)(1) 0为全职业
		tmp.needLevel = data.needLevel[i]--所需等级
		tmp.equippos = Split(data.pos[i], ",")--位置 注意格式(1，2)(1)
        tmp.equipSkillId = data.equipSkillId[i]--装备技能
		tmp.description = data.description[i]--描述
		dic[tmp.equipId] = tmp
    end
	return dic
end

function StaticDataLoader.loadSystemLifeConfig()
    local file = "SystemLifeConfig.json"
	
	local data = ReadJsonFileContentTable(DIR..file)
    if not data then return nil end
	local dic = {}
    for i=1,#data.category do
		local tmp =  {}
        tmp.category = data.category[i]
        tmp.money = data.money[i]
        tmp.gold = data.gold[i]
		dic[tmp.category] = tmp
    end
	return dic
end

function StaticDataLoader.loadSystemLifeReward()
    local file = "SystemLifeReward.json"
	
	local data = ReadJsonFileContentTable(DIR..file)
    if not data then return nil end
	local dic = {}
    for i=1,#data.id do
		local tmp =  {}
        tmp.id = data.id[i]
        tmp.category = data.category[i]
        tmp.quality = data.quality[i]
        tmp.minLevel = data.minLevel[i]
        tmp.maxLevel = data.maxLevel[i]
        tmp.toolType = data.toolType[i]
        tmp.toolId = data.toolId[i]
		dic[tmp.id] = tmp
    end

	return dic
end

function StaticDataLoader.loadSystemEquipToolMall()
    local file = "SystemEquipToolMall.json"
	
	local data = ReadJsonFileContentTable(DIR..file)
    if not data then return nil end
	local dic = {}
    for i=1,#data.mallId do
		local tmp =  {}
        tmp.mallId = data.mallId[i]
        tmp.toolType = data.toolType[i]
        tmp.toolId = data.toolId[i]
        tmp.toolNum = data.toolNum[i]
        table.insert(dic, tmp)
    end

	return dic
end

function StaticDataLoader.loadSystemMagicToolMall()
    local file = "****.json"
	
	local data = ReadJsonFileContentTable(DIR..file)
    if not data then return nil end
	local dic = {}
    for i=1,#data.mallId do
		local tmp =  {}
		--dic[tmp.mallId] = tmp
        table.insert(dic, tmp)
    end
	return dic
end

function StaticDataLoader.loadSystemHonourExchange()
	local file = "SystemHonourExchange.json"
	local data = ReadJsonFileContentTable(DIR..file)
	if not data then return nil end

	local dic = {}
	for i=1, #data.mallId do
		local temp = {}
		temp.mallId=data.mallId[i]
		temp.needHonour=data.needHonour[i]
		temp.toolType=data.toolType[i]
		temp.toolId=data.toolId[i]
		temp.toolNum=data.toolNum[i]
		temp.dayBuyNum=data.dayBuyNum[i]
		temp.totalBuyNum=data.totalBuyNum[i]
		dic[temp.mallId] = temp
	end
	return dic
end
function StaticDataLoader.loadSystemToolForge()
    local file = "SystemToolForge.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end
    local dic = { }
    for i = 1, #data.toolId do
        local temp = { }
        temp.toolType = data.toolType[i]
        temp.toolId = data.toolId[i]
        temp.type = data.type[i]
        temp.num = data.num[i]
        temp.needLevel = data.needLevel[i]
		temp.material = data.material[i]
		table.insert(dic,temp)
    end
    return dic
end
function StaticDataLoader.loadSystemHeroPromoteStar()
    local file = "SystemHeroPromoteStar.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end
    local dic = { }
    for i = 1, #data.star do
        local temp = { }
        temp.type = data.type[i]
        temp.star = data.star[i]
        temp.needMaterial = data.needMaterial[i]
        temp.lowerNum = data.lowerNum[i]
		temp.upperNum = data.upperNum[i]
		table.insert(dic,temp)
    end
    return dic
end

function StaticDataLoader.loadSystemHeroInherit()
    local file = "SystemHeroInherit.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end
    local dic = { }
    for i = 1, #data.star do
        local temp = { }
        temp.star = data.star[i]
        temp.needMaterial = data.needMaterial[i]
		dic[temp.star] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemGemstone()
	local file = "SystemGemstone.json"
	local data = ReadJsonFileContentTable(DIR..file)
	if not data then return nil end

	local dic = {}
	for i=1, #data.gemstoneId do
		local temp = {}
		temp.gemstoneId=data.gemstoneId[i]
		temp.name=data.name[i]
		temp.quality=data.quality[i]
		temp.level=data.level[i]
		temp.imgId = data.imgId[i]
		temp.description=data.description[i]
		temp.modelId=data.modelId[i]
		dic[temp.gemstoneId] = temp
	end
	return dic
end

function StaticDataLoader.loadSystemGemstoneAttr()
	local file = "SystemGemstoneAttr.json"
	local data = ReadJsonFileContentTable(DIR..file)
	if not data then return nil end

	local dic = {}
	for i=1, #data.gemstoneId do
		local temp = {}
		temp.gemstoneId=data.gemstoneId[i]
		temp.attr=data.attr[i]
		temp.lowerNum=data.lowerNum[i]
		temp.upperNum=data.upperNum[i]
		table.insert(dic,temp)
	end
	return dic
end

function StaticDataLoader.loadSystemGemstoneForge()
	local file = "SystemGemstoneForge.json"
	local data = ReadJsonFileContentTable(DIR..file)
	if not data then return nil end

	local dic = {}
	for i=1, #data.toolId do
		local temp = {}
		temp.gemstoneId=data.toolId[i]
		temp.num=data.num[i]
		temp.type=data.type[i]
		temp.needLevel=data.needLevel[i]
		temp.material=data.material[i]
		table.insert(dic,temp)
	end
	return dic
end

function StaticDataLoader.loadSystemGemstoneUpgrade()
	local file = "SystemGemstoneUpgrade.json"
	local data = ReadJsonFileContentTable(DIR..file)
	if not data then return nil end

	local dic = {}
	for i=1, #data.gemstoneId do
		local temp = {}
		temp.gemstoneId=data.gemstoneId[i]
		temp.upgradeGemstoneId=data.upgradeGemstoneId[i]
		temp.needMaterial=data.needMaterial[i]
		dic[temp.gemstoneId] = temp
	end
	return dic
end

function StaticDataLoader.loadSystemMagicMaterial()
    local file = "SystemEquipMagic.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end
    local dic = { }
    for i = 1, #data.reelId do
        local temp = {}
        temp.reelId = data.reelId[i]
        temp.level = data.level[i]
        temp.material = data.material[i]
		dic[temp.reelId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemEquipFixedAttr()
    local file = "SystemEquipFixedAttr.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end
    local dic = { }
    for i = 1, #data.equipId do
        local temp = { }
        temp.equipId = data.equipId[i]
        temp.mainAttr = data.mainAttr[i]
        temp.secondaryAttr = data.secondaryAttr[i]
		dic[temp.equipId] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemAchievement()
    local file = "SystemAchievement.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.achievementId do
        local temp = { }
        temp.achievementId = data.achievementId[i]
        temp.type = data.type[i]
        temp.name = data.name[i]
        temp.description = data.description[i]
        temp.times = data.times[i]
        temp.rewards = data.rewards[i]
        temp.imgId = data.imgId[i]
        temp.color = data.color[i]
        dic[i] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemLoginReward30()
    local file = "SystemLoginReward30.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.day do
        local temp = {}
        temp.day = data.day[i]
        temp.toolType = data.toolType[i]
        temp.toolId = data.toolId[i]
        temp.toolNum = data.toolNum[i]
        temp.vipLevel = data.vipLevel[i]
        dic[i] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemCareerClearConfig()
    local file = "SystemCareerClearConfig.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.careerId do
        local temp = {}
        temp.careerId = data.careerId[i]
        temp.level = data.level[i]
        dic[i] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemCareerClear()
    local file = "SystemCareerClear.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.detailedCareerId do
        local temp = {}
        temp.detailedCareerId = data.detailedCareerId[i]
        temp.jobExp = data.jobExp[i]
        temp.userLevel = data.userLevel[i]
        temp.level = data.level[i]
        dic[i] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemHeroPromote()
    local file = "SystemHeroPromote.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.systemHeroId do
        local temp = {}
        temp.systemHeroId = data.systemHeroId[i]
        temp.proSystemHeroId = data.proSystemHeroId[i]
        temp.heroLevel = data.heroLevel[i]
        temp.material = data.material[i]
        dic[i] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemHeroCareerAdd()
    local file = "SystemHeroCareerAdd.json"
    local data = ReadJsonFileContentTable(DIR .. file)
    if not data then return nil end

    local dic = { }
    for i = 1, #data.detailedCareerId do
        local temp = {}
        temp.detailedCareerId = data.detailedCareerId[i]
        temp.level = data.level[i]
        temp.attribute = data.attribute[i]
        dic[i] = temp
    end
    return dic
end

function StaticDataLoader.loadSystemHeroGrowBase()
	local file = "SystemHeroGrowBase.json"
	local data = ReadJsonFileContentTable(DIR..file)
	if not data then return nil end

	local dic = {}
	for i=1, #data.level do
		local temp = {}
		temp.level=data.level[i]
		temp.baseValue=data.baseValue[i]
		dic[temp.level] = temp
	end
	return dic
end

function StaticDataLoader.loadSystemMainPropertyProfit()
	local file = "SystemHeroMainPropertyProfit.json"
	local data = ReadJsonFileContentTable(DIR..file)
	if not data then return nil end

	local dic = {}
	for i=1, #data.mainProperty do
		local temp = {}
		temp.mainProperty=data.mainProperty[i]
		temp.attackPower=data.attackPower[i]
		temp.magicPower=data.magicPower[i]
		temp.hp=data.hp[i]
		temp.armor=data.armor[i]
		temp.resistance=data.resistance[i]
		temp.crit=data.crit[i]
		temp.dodge=data.dodge[i]
		temp.weaponDamage=data.weaponDamage[i]
		temp.speedUp=data.speedUp[i]
		dic[temp.mainProperty] = temp
	end
	return dic
end

function StaticDataLoader.loadSystemSecondPropertyProfit()
	local file = "SystemHeroSecondPropertyProfit.json"
	local data = ReadJsonFileContentTable(DIR..file)
	if not data then return nil end

	local dic = {}
	for i=1, #data.secondProperty do
		local temp = {}
		temp.secondProperty=data.secondProperty[i]
		temp.attackPower=data.attackPower[i]
		temp.magicPower=data.magicPower[i]
		temp.hp=data.hp[i]
		temp.armor=data.armor[i]
		temp.resistance=data.resistance[i]
		temp.crit=data.crit[i]
		temp.dodge=data.dodge[i]
		temp.weaponDamage=data.weaponDamage[i]
		temp.speedUp=data.speedUp[i]
		dic[temp.secondProperty] = temp
	end
	return dic
end

function StaticDataLoader.loadSystemFightStandardValue()
	local file = "SystemFightStandardValue.json"
	local data = ReadJsonFileContentTable(DIR..file)
	if not data then return nil end

	local dic = {}
	for i=1, #data.level do
		local temp = {}
		temp.level=data.level[i]
		temp.armorValue=data.armorValue[i]
		temp.resistanceValue=data.resistanceValue[i]
		temp.critValue=data.critValue[i]
		temp.dodgeValue=data.dodgeValue[i]
		temp.parryValue=data.parryValue[i]
		dic[temp.level] = temp
	end
	return dic
end

function StaticDataLoader.loadSystemFightStandardRate()
	local file = "SystemFightStandardRate.json"
	local data = ReadJsonFileContentTable(DIR..file)
	if not data then return nil end

	local dic = {}
	for i=1, #data.id do
		local temp = {}
		temp.id=data.id[i]
		temp.armorRate=data.armorRate[i]
		temp.resistanceRate=data.resistanceRate[i]
		temp.critRate=data.critRate[i]
		temp.dodgeRate=data.dodgeRate[i]
		temp.parryRate=data.parryRate[i]
		dic[temp.id] = temp
	end
	return dic
end

function StaticDataLoader.loadSystemBossMap()
	local file = "SystemBossMap.json"
	local data = ReadJsonFileContentTable(DIR..file)
	if not data then return nil end

	local dic = {}
	for i=1, #data.mapId do
		local temp = {}
		temp.mapId=data.mapId[i]
		temp.systemHeroId=data.systemHeroId[i]
		temp.lowerNum=data.lowerNum[i]
		temp.upperNum=data.upperNum[i]
		table.insert(dic,temp)
	end
	return dic
end

function StaticDataLoader.loadSystemActivityTask()
	local file = "SystemActivityTask.json"
	local data = ReadJsonFileContentTable(DIR..file)
	if not data then return nil end
	local dic = {}
	for i=1, #data.activityTaskId do
		local temp = {}
		temp.activityTaskId=data.activityTaskId[i]
		temp.targetType=data.targetType[i]
		temp.targetDesc=data.targetDesc[i]
		temp.needFinishTimes=data.needFinishTimes[i]
		temp.point=data.point[i]
		dic[temp.activityTaskId] = temp
	end
	return dic
end

function StaticDataLoader.loadSystemActivityTaskReward()
	local file = "SystemActivityTaskReward.json"
	local data = ReadJsonFileContentTable(DIR..file)
	if not data then return nil end
	local dic = {}
	for i=1, #data.activityTaskRewardId do
		local temp = {}
		temp.activityTaskRewardId=data.activityTaskRewardId[i]
		temp.point=data.point[i]
		temp.rewards=data.rewards[i]
		dic[temp.activityTaskRewardId] = temp
	end
	return dic
end

function StaticDataLoader.loadSystemActivityTaskGuide()
	local file = "SystemActivityTaskGuide.json"
	local data = ReadJsonFileContentTable(DIR..file)
	if not data then return nil end
	local dic = {}
	for i=1, #data.targetType do
		local temp = {}
		temp.targetType=data.targetType[i]
		temp.minLevel=data.minLevel[i]
		temp.maxLevel=data.maxLevel[i]
		temp.params=data.params[i]
		temp.camp=data.camp[i]
		table.insert(dic, temp)
	end
	return dic
end
