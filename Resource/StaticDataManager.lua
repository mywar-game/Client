--静态数据加载
--说明：静态数据的预加载可按需进行

require("StaticDataLoader")

local _hero_dic
local _hero_arrt_dic
local _hero_hate_dic
local _hero_energy_dic
local _monster_dic

local _skill_dic
local _skill_effect_dic
local _skill_effect_define_dic
local _formula_dic
local _map_dic

local _forces_dir
local _hero_skill_dir
local _scene_dir
local _npc_dir
local _transfer_dir
local _drop_dir
local _forces_monster_dir
local _tool_dir
local _team_exp_dir
local _task_dir
--[[local _prestige_dir
local _prestige_rewards_dir]]
local _prestige_invitehero_dir
local _hero_level_dir
local _bigForces_dir

local _qte_dir
local _qte_effect_dir

local _systemHeroSkillConfig_dic
local _systemHeroSkillLevel_dic
local _systemHeroSkillLevelMax_dic

local _systemExploreExchange_dic
local _systemExploreMap_dic
local _systemExploreReward_dic

local _systemPawnShop_dic
local _systemHeroProfit
local _system_message_client

local _system_equip_dic
local _system_equip_attr_dic

local _system_dailyTask_dic

local _system_lifeConfig_dic
local _system_lifeReward_dic

local _system_equipToolMall_dic
local _system_magicToolMall_dic
local _honour_dic

local _system_toolForge_dic
local _system_toolMagicMaterial_dic
local _system_promoteStar_dir
local _system_inherit_dir
local _system_gemstone_dir
local _system_gemstone_attr_dir
local _system_gemstone_forge_dir
local _system_gemstone_upgrade_dir
local _system_achievement_dic
local _system_loginReward30_dic
local _system_career_clear_config_dic
local _system_career_clear_dic
local _system_hero_promote_dic
local _system_hero_career_add_dic
local _system_hero_detail_info_dic

local _system_hero_grow_base_dir
local _system_main_property_profit_dic
local _system_second_property_profit_dic

local _system_fight_standard_value_dic
local _system_fight_standard_rate_dic
local _system_boss_map_dic 

local _system_activity_task_dic
local _system_activity_task_reward_dic
local _system_activity_task_guide_dic

StaticDataManager = {}

function StaticDataManager.init()
    --执行懒加载，按需加载，不在此一口气加载数据
end

--随机生成用户角色昵称
function StaticDataManager.getRandomName()
    --无需缓存数据
	local name = ""
    local dic = StaticDataLoader.loadName()
    local maleNames = dic.male
    local femaleNames = dic.female
    local suffixNames = dic.suffix

    local maleCount = #maleNames
    local femaleCount = #femaleNames
    local suffixCount = #suffixNames

    local sexNum = math.random(1, 2)
    local maleNum = math.random(maleCount)
    local femaleNum = math.random(femaleCount)
    local suffixNum = math.random(suffixCount)

    if sexNum == 1 then
        if maleNames[maleNum] then
            name = maleNames[maleNum]
        end

        if suffixNames[suffixNum] then
            name = name .. suffixNames[suffixNum]
        end
    else
        if femaleNames[femaleNum] then
            name = femaleNames[femaleNum]
        end

        if suffixNames[suffixNum] then
            name = name .. suffixNames[suffixNum]
        end
    end

    return name
end

--获取英雄对象
function StaticDataManager.getSystemHeroId(systemHeroId)
    if not _hero_dic then _hero_dic = StaticDataLoader.loadSystemHero() end
	return _hero_dic and DeepCopy(_hero_dic[systemHeroId])
end

--获取英雄属性
function StaticDataManager.getSystemHeroAttributeId(systemHeroId)
    if not _hero_arrt_dic then _hero_arrt_dic = StaticDataLoader.loadSystemHeroAttribute() end
	return _hero_arrt_dic and DeepCopy(_hero_arrt_dic[systemHeroId])
end

--获取英雄伤害
function StaticDataManager.getSystemHateValueId(careerId)
    if not _hero_hate_dic then _hero_hate_dic = StaticDataLoader.loadSystemHateValue() end
	return _hero_hate_dic and DeepCopy(_hero_hate_dic[careerId])
end

--掉落
function StaticDataManager.getSystemDropEnergy()
    if not _hero_energy_dic then _hero_energy_dic = StaticDataLoader.loadSystemDropEnergy() end
	return _hero_energy_dic
end

--boss
function StaticDataManager.getSystemMonsterId(monsterId)
    if not _monster_dic then _monster_dic = StaticDataLoader.loadSystemMonster() end
	return _monster_dic and DeepCopy(_monster_dic[monsterId])
end

--技能
function StaticDataManager.getSystemSkillId(skillId)
    if not _skill_dic then _skill_dic = StaticDataLoader.loadSystemSkill() end
	return _skill_dic and DeepCopy(_skill_dic[skillId])
end

--技能效果
function StaticDataManager.getSystemSkillEffect()
    if not _skill_effect_dic then _skill_effect_dic = StaticDataLoader.loadSystemSkillEffect() end
	return _skill_effect_dic
end

--技能效果定义
function StaticDataManager.getSystemSkillEffectDefineId(defineId)
    if not _skill_effect_define_dic then _skill_effect_define_dic = StaticDataLoader.loadSystemSkillEffectDefine() end
	return _skill_effect_define_dic and DeepCopy(_skill_effect_define_dic[defineId])
end

--公式参数
function StaticDataManager.getSystemFormulaParaId(formulaId)
    if not _formula_dic then _formula_dic = StaticDataLoader.loadSystemFormulaPara() end
	return _formula_dic and DeepCopy(_formula_dic[formulaId])
end

--地图
function StaticDataManager.getSystemMapId(mapId)
    if not _map_dic then _map_dic = StaticDataLoader.loadSystemMap() end
	return _map_dic and DeepCopy(_map_dic[mapId])
end

--地图全数据
function StaticDataManager.getSystemMap()
    if not _map_dic then _map_dic = StaticDataLoader.loadSystemMap() end
	return _map_dic
end

--小关卡
function StaticDataManager.getSystemForces()
    if not _forces_dir then _forces_dir = StaticDataLoader.loadSystemForces() end
	return _forces_dir 
end

--技能
function StaticDataManager.getSystemHeroSkillId()
    if not _hero_skill_dir then _hero_skill_dir = StaticDataLoader.loadSystemHeroSkill() end
	return _hero_skill_dir
end

--场景
function StaticDataManager.getSystemSceneId(sceneId)
    if not _scene_dir then _scene_dir = StaticDataLoader.loadSystemScene() end
	return _scene_dir and DeepCopy(_scene_dir[sceneId])
end

--获取场景
function StaticDataManager.getSystemScene()
    if not _scene_dir then _scene_dir = StaticDataLoader.loadSystemScene() end
	return _scene_dir
end

--npc
function StaticDataManager.getSystemNpc()
    if not _npc_dir then _npc_dir = StaticDataLoader.loadSystemNpc() end
	return _npc_dir
end

--传送点
function StaticDataManager.getSystemTransfer()
    if not _transfer_dir then _transfer_dir = StaticDataLoader.loadSystemTransfer() end
	return _transfer_dir
end

--掉落表
function StaticDataManager.getSystemForcesDropTool()
	if not _drop_dir then _drop_dir = StaticDataLoader.loadSystemForcesDropTool() end
	return _drop_dir
end

--怪物表
function StaticDataManager.getSystemForcesMonster()
	if not _forces_monster_dir then _forces_monster_dir = StaticDataLoader.loadSystemForcesMonster() end
	return _forces_monster_dir and _forces_monster_dir
end

--道具表
function StaticDataManager.getSystemTool(toolId)
	if not _tool_dir then _tool_dir = StaticDataLoader.loadSystemTool() end
	return _tool_dir and DeepCopy(_tool_dir[toolId])
end

--团队经验
function StaticDataManager.getSystemTeamExp(teamExp)
	if not _team_exp_dir then _team_exp_dir = StaticDataLoader.loadSystemTeamExp() end
	return _team_exp_dir and DeepCopy(_team_exp_dir[teamExp])
end

--任务Id
function StaticDataManager.getSystemTask()
	if not _task_dir then _task_dir = StaticDataLoader.loadSystemTask() end
	return _task_dir
end

--声望升级经验表
--[[function StaticDataManager.getSystemPrestigeLevel()
	if not _prestige_dir then _prestige_dir = StaticDataLoader.loadSystemPrestigeLevel() end
	return _prestige_dir and _prestige_dir
end

--声望奖励(deprecated)
function StaticDataManager.getSystemPrestigeRewards()
	if not _prestige_rewards_dir then _prestige_rewards_dir = StaticDataLoader.loadSystemPrestigeRewards() end
	return _prestige_rewards_dir and _prestige_rewards_dir
end]]

--声望招募
function StaticDataManager.getSystemInviteHero()
	if not _prestige_invitehero_dir then _prestige_invitehero_dir = StaticDataLoader.loadSystemInviteHero() end
	return _prestige_invitehero_dir
end

--英雄经验
function StaticDataManager.getSystemHeroLevel()
	if not _hero_level_dir then _hero_level_dir = StaticDataLoader.loadSystemHeroLevel() end
	return _hero_level_dir
end

--英雄经验
function StaticDataManager.getSystemBigForces()
	if not _bigForces_dir then _bigForces_dir = StaticDataLoader.loadSystemBigForces() end
	return _bigForces_dir
end

--团长技能学习配置
function StaticDataManager.getSystemHeroSkillConfig(systemHeroSkillId)
    if not _systemHeroSkillConfig_dic then _systemHeroSkillConfig_dic = StaticDataLoader.loadSystemHeroSkillConfig() end
    return _systemHeroSkillConfig_dic and DeepCopy(_systemHeroSkillConfig_dic[systemHeroSkillId])
end
--团长技能升级经验配置
function StaticDataManager.getSystemHeroSkillLevel(level,color)
    if not _systemHeroSkillLevel_dic then _systemHeroSkillLevel_dic = StaticDataLoader.loadSystemSkillLevel() end
    local key=level.."_"..color
    return _systemHeroSkillLevel_dic and DeepCopy(_systemHeroSkillLevel_dic[key])
end
--团长技能可升级到的最高等级配置
function StaticDataManager.getSystemHeroSkillMaxLevel(color)
    if not _systemHeroSkillLevelMax_dic then _systemHeroSkillLevelMax_dic = StaticDataLoader.loadSystemHeroSkillLevelMax() end
    if _systemHeroSkillLevelMax_dic~=nil then
        return DeepCopy(_systemHeroSkillLevelMax_dic[color])
    end
    return nil
end

function StaticDataManager.getSystemQte()
    if not _qte_dir then _qte_dir = StaticDataLoader.loadSystemQte() end
    return _qte_dir
end

function StaticDataManager.getSystemQteEffectId(qteEffectId)
     if not _qte_effect_dir then _qte_effect_dir = StaticDataLoader.loadSystemQteEffect() end
    return _qte_effect_dir and DeepCopy(_qte_effect_dir[qteEffectId])
end

function StaticDataManager.getSystemExploreExchange()
     if not _systemExploreExchange_dic then _systemExploreExchange_dic = StaticDataLoader.loadSystemExploreExchange() end
    return _systemExploreExchange_dic
end

function StaticDataManager.getSystemExploreMap()
     if not _systemExploreMap_dic then _systemExploreMap_dic = StaticDataLoader.loadSystemExploreMap() end
    return _systemExploreMap_dic
end

function StaticDataManager.getSystemExploreReward()
     if not _systemExploreReward_dic then _systemExploreReward_dic = StaticDataLoader.loadSystemExploreReward() end
    return _systemExploreReward_dic
end

function StaticDataManager.getSystemPawnShop(mallId)
    if not _systemPawnShop_dic then _systemPawnShop_dic = StaticDataLoader.loadSystemPawnShop() end
    return _systemPawnShop_dic[mallId]
end

function StaticDataManager.getSystemHeroProfit(careerId)
    if not _systemHeroProfit then _systemHeroProfit = StaticDataLoader.loadSystemHeroProfit() end
    return _systemHeroProfit[careerId]
end

--跑马灯
function StaticDataManager.getSystemMessageClient()
	if not _system_message_client then _system_message_client = StaticDataLoader.loadSystemMessageClient() end
	return _system_message_client
end

--装备
function StaticDataManager.getSystemEquip(equipId)
    if not _system_equip_dic then _system_equip_dic = StaticDataLoader.loadSystemEquip() end
    return DeepCopy(_system_equip_dic[equipId])
end

--装备属性
function StaticDataManager.getSystemEquipAttr(equipId)
    if not _system_equip_attr_dic then _system_equip_attr_dic = StaticDataLoader.loadSystemEquipAttr() end
    return DeepCopy(_system_equip_attr_dic[equipId])
end

--日常任务刷新表
function StaticDataManager.getSystemDailyTask(systemTaskId)
    if not _system_dailyTask_dic then _system_dailyTask_dic = StaticDataLoader.loadSystemDailyTask() end
    return DeepCopy(_system_dailyTask_dic[systemTaskId])
end

--生活配置表
function StaticDataManager.getSystemLifeConfig(category)
    if not _system_lifeConfig_dic then _system_lifeConfig_dic = StaticDataLoader.loadSystemLifeConfig() end
    return _system_lifeConfig_dic[category]
end

--生活奖励表
function StaticDataManager.getSystemReward()
    if not _system_lifeReward_dic then _system_lifeReward_dic = StaticDataLoader.loadSystemReward() end
    return _system_lifeReward_dic
end

--装备道具商店
function StaticDataManager.getSystemEquipToolMall()
    if not _system_equipToolMall_dic then _system_equipToolMall_dic = StaticDataLoader.loadSystemEquipToolMall() end
    return _system_equipToolMall_dic
end

--荣誉兑换
function StaticDataManager.getSystemHonourExchange()
    if not _honour_dic then _honour_dic = StaticDataLoader.loadSystemHonourExchange() end
    return _honour_dic
end

--锻造
function StaticDataManager.getSystemToolForge()
    if not _system_toolForge_dic then _system_toolForge_dic = StaticDataLoader.loadSystemToolForge() end
	return _system_toolForge_dic
end

--附魔
function StaticDataManager.getSystemMagicMaterial()
    if not _system_toolMagicMaterial_dic then
		_system_toolMagicMaterial_dic = StaticDataLoader.loadSystemMagicMaterial()
	end
	return _system_toolMagicMaterial_dic
end

--升星
function StaticDataManager.getSystemHeroPromoteStar()
    if not _system_promoteStar_dir then _system_promoteStar_dir = StaticDataLoader.loadSystemHeroPromoteStar() end
	return _system_promoteStar_dir
end

--升星
function StaticDataManager.getSystemHeroInherit(star)
    if not _system_inherit_dir then _system_inherit_dir = StaticDataLoader.loadSystemHeroInherit() end
	return DeepCopy(_system_inherit_dir[star]) 
end

--宝石
function StaticDataManager.getSystemGemstone(gemstoneId)
    if not _system_gemstone_dir then _system_gemstone_dir = StaticDataLoader.loadSystemGemstone() end
	return DeepCopy(_system_gemstone_dir[gemstoneId]) 
end

--宝石属性
function StaticDataManager.getSystemGemstoneAttr()
    if not _system_gemstone_attr_dir then _system_gemstone_attr_dir = StaticDataLoader.loadSystemGemstoneAttr() end
	return _system_gemstone_attr_dir 
end

--宝石锻造
function StaticDataManager.getSystemGemstoneForgeList()
	if not _system_gemstone_forge_dir then _system_gemstone_forge_dir = StaticDataLoader.loadSystemGemstoneForge() end
	return _system_gemstone_forge_dir
end

--宝石升级
function StaticDataManager.getSystemGemstoneUpgrade(gemstoneId)
    if not _system_gemstone_upgrade_dir then _system_gemstone_upgrade_dir = StaticDataLoader.loadSystemGemstoneUpgrade() end
	return DeepCopy(_system_gemstone_upgrade_dir[gemstoneId]) 
end

--装备固定属性
function StaticDataManager.getSystemEquipFixedAttr(equipId)
    if not _system_equip_fixed_attr_dir then _system_equip_fixed_attr_dir = StaticDataLoader.loadSystemEquipFixedAttr() end
	return DeepCopy(_system_equip_fixed_attr_dir[equipId]) 
end

--成就系统
function StaticDataManager.getSystemAchievement()
    if not _system_achievement_dic then _system_achievement_dic = StaticDataLoader.loadSystemAchievement() end
    return _system_achievement_dic
end

--签到活动奖励
function StaticDataManager.getSystemLoginReward30()
    if not _system_loginReward30_dic then _system_loginReward30_dic = StaticDataLoader.loadSystemLoginReward30() end
    return _system_loginReward30_dic
end

function StaticDataManager.getSystemHeroGrowBase(level)
    if not _system_hero_grow_base_dir then _system_hero_grow_base_dir = StaticDataLoader.loadSystemHeroGrowBase() end
    return _system_hero_grow_base_dir[level]
end

function StaticDataManager.getSystemMainPropertyProfit(mainPropertyId)
    if not _system_main_property_profit_dic then _system_main_property_profit_dic = StaticDataLoader.loadSystemMainPropertyProfit() end
    return _system_main_property_profit_dic[mainPropertyId]
end

function StaticDataManager.getSystemSecondPropertyProfit(mainPropertyId)
    if not _system_second_property_profit_dic then _system_second_property_profit_dic = StaticDataLoader.loadSystemSecondPropertyProfit() end
    return _system_second_property_profit_dic[mainPropertyId]
end

function StaticDataManager.getSystemFightStandardValue(level)
    if not _system_fight_standard_value_dic then _system_fight_standard_value_dic = StaticDataLoader.loadSystemFightStandardValue() end
    return _system_fight_standard_value_dic[level]
end

function StaticDataManager.getSystemFightStandardRate()
    if not _system_fight_standard_rate_dic then _system_fight_standard_rate_dic = StaticDataLoader.loadSystemFightStandardRate() end
    return _system_fight_standard_rate_dic[1]
end

--英雄职业解锁配置
function StaticDataManager.getSystemCareerClearConfig()
    if not _system_career_clear_config_dic then _system_career_clear_config_dic = StaticDataLoader.loadSystemCareerClearConfig() end
    return _system_career_clear_config_dic
end

--英雄职业解锁
function StaticDataManager.getSystemCareerClear()
    if not _system_career_clear_dic then _system_career_clear_dic = StaticDataLoader.loadSystemCareerClear() end
    return _system_career_clear_dic
end

--英雄进阶
function StaticDataManager.getSystemHeroPromote()
    if not _system_hero_promote_dic then _system_hero_promote_dic = StaticDataLoader.loadSystemHeroPromote() end
    return _system_hero_promote_dic
end

--英雄职业加成
function StaticDataManager.getSystemHeroCareerAdd()
    if not _system_hero_career_add_dic then _system_hero_career_add_dic = StaticDataLoader.loadSystemHeroCareerAdd() end
    return _system_hero_career_add_dic
end

--获取英雄详细职业ID
function StaticDataManager.getSystemHeroDetailInfo()
    if not _system_hero_detail_info_dic then _system_hero_detail_info_dic = StaticDataLoader.loadSystemHero() end
    return _system_hero_detail_info_dic
end

--世界BOSS
function StaticDataManager.getSystemBossMap()
    if not _system_boss_map_dic then _system_boss_map_dic = StaticDataLoader.loadSystemBossMap() end
    return _system_boss_map_dic
end

function StaticDataManager.getSystemActivityTask()
	if not _system_activity_task_dic then _system_activity_task_dic = StaticDataLoader.loadSystemActivityTask() end
    return _system_activity_task_dic
end


function StaticDataManager.getSystemActivityTaskReward()
	if not _system_activity_task_reward_dic then _system_activity_task_reward_dic = StaticDataLoader.loadSystemActivityTaskReward() end
    return _system_activity_task_reward_dic
end

function StaticDataManager.getSystemActivityTaskGuide()
	if not _system_activity_task_guide_dic then _system_activity_task_guide_dic = StaticDataLoader.loadSystemActivityTaskGuide() end
    return _system_activity_task_guide_dic
end
