--图片资源管理
--terry
ResourcesManager = {}

local DIR_HERO = "res/hero/"
local DIR_BG_HERO = "res/hero_background/"
local DIR_SMALL_HERO = "res/hero_home_page/"
local DIR_HERO_ICON = "res/hero_icon/"
local DIR_HERO_NAME_IMG = "res/hero_name_img/"
local DIR_TOOL = "res/tool/"
local DIR_TOOL_ICON = "res/tool_icon/"
local DIR_TOOL_NAME_IMG  = "res/tool_name_img/"
local DIR_HERO_NATION = "card/big/zhenying/"
local DIR_HERO_COLOR = "card/big/"
local DIR_TASK = "res/task/"
local DIR_Award = "res/award/"
local DIR_MAP = "map/"
local DIR_NPC = "npc/"
local DIR_EVENT_RES = "res/events/events/"
local DIR_EVENT_ICON = "res/events/events_icon/"
local DIR_EVENT = "events/"
local DIR_ACTIVITY = "res/activity/"
local DIR_FIGHT_BG = "res/fight_bg/"
local DIR_FIGHT_EFFECT = "res/fight_effect/"
local DIR_PRODUCT_TOOL = "res/tool/"        --商品大图
local DIR_PRODUCT_TOOL_ICON = "res/tool_icon/"    --商品小图
local DIR_TOWER_HEROGRAY_ICON = "babel/gray_hero/"    --塔 灰色头像

--武将灰色头像
function ResourcesManager.getHeroGrayIcon(imgId)
    if not imgId then return nil end
    return DIR_TOWER_HEROGRAY_ICON..imgId..".png"
end

--武将头像
function ResourcesManager.getHeroIcon(imgId)
    if not imgId then return nil end
    return DIR_HERO_ICON..imgId..".png"
end

--武将卡牌
function ResourcesManager.getHero(cardId)
    if not cardId then return nil end
    return DIR_HERO..cardId..".png"
end

--半身像卡牌
function ResourcesManager.getSmallHero(cardId)
    if not cardId then return nil end
    return DIR_SMALL_HERO..cardId..".png"
end

--背景卡牌
function ResourcesManager.getHeroBg(cardId)
    if not cardId then return nil end
    return DIR_BG_HERO..cardId..".png"
end

--武将名称图片
function ResourcesManager.getHeroNameImg(heroNameImgId)
    if not heroNameImgId then return nil end
    return DIR_HERO_NAME_IMG..heroNameImgId..".png"
end

--活动图片
function ResourcesManager.getEvent(toolId)
    if not toolId then return nil end
    return DIR_EVENT_RES..toolId..".png"
end

--活动图片
function ResourcesManager.getEventIcon(toolId)
    if not toolId then return nil end
    return DIR_EVENT_ICON..toolId..".png"
end

--道具图片
function ResourcesManager.getTool(toolId)
    if not toolId then return nil end
    return DIR_TOOL..toolId..".png"
end

--道具图标
function ResourcesManager.getToolIcon(toolId)
    if not toolId then return nil end
    return DIR_TOOL_ICON..toolId..".png"
end

----道具名称图片
function ResourcesManager.getToolNameImg(toolId)
    if not toolId then return nil end
    return DIR_TOOL_NAME_IMG..toolId..".png"
end


--品质
function ResourcesManager.getColor(color)
    if not color then return nil end
    return DIR_HERO_COLOR..color..".png"
end

--阵营
function ResourcesManager.getNation(nation)
    if not nation then return nil end
    return DIR_HERO_NATION..nation..".png"
end

--任务图标
function ResourcesManager.getTaskIcon(imgId)
	if not imgId then return nil end
    return DIR_TASK..imgId..".png"
end

--争霸兑奖奖品图标
function ResourcesManager.getAwardIcon(imgId)
	if not imgId then return nil end
    return DIR_Award..imgId..".png"

end

--npc形象
function ResourcesManager.getNpcImg(npcImgId)
	if not npcImgId then return nil end
    return DIR_NPC..npcImgId..".png"
end

--活动
function ResourcesManager.getEventImg(eventImgId)
	if not eventImgId then return nil end
    return DIR_EVENT.."icon_"..eventImgId..".png"
end

--出征地图
function ResourcesManager.getMapBgName(mapId)
	if not mapId then return nil end
    mapId = mapId % 10 --精英副本地图与普通副本地图共用
    return DIR_MAP.."bg"..mapId..".png"
end

--出征地图上场景的名称
function ResourcesManager.getSceneNameImgPath(sceneId)
	return string.format("name/%d.png",sceneId%10000)--精英副本地图与普通副本地图共用
end

--活动副本图片
function ResourcesManager.getActivitySceneImg(sceneId,isOpen)
	return DIR_ACTIVITY..sceneId..(isOpen and "_normal" or "_disable")..".png"
end

--获取战斗背景图
function ResourcesManager.getFightBg(fightBgId)
    if not fightBgId then fightBgId = 1 end
    return DIR_FIGHT_BG..fightBgId..".png"
end

--读取战斗特效帧
function ResourcesManager.getFightEffectFrame(action_id,frame_id)
    return DIR_FIGHT_EFFECT..action_id.."/"..frame_id..".png"
end

--读取粒子特效plist
function ResourcesManager.getFightEffectParticle(action_id)
    cclog( "163   读取粒子系统  "..action_id)
    return DIR_FIGHT_EFFECT..action_id.."/p.plist"
end

--地图动态序列帧
function ResourcesManager.getFightBgEffectFrame(bgId,frameId)
    return DIR_FIGHT_BG..bgId.."/"..frameId..".png"
end

--获取商品大图标
function ResourcesManager.getProductBigIcon(iconId)
    if not iconId then iconId = "1" end
    return DIR_PRODUCT_TOOL..iconId..".png"
end
--获取商品小图标
function ResourcesManager.getProductSmallIcon(iconId)
    if not iconId then iconId = "1" end
    return DIR_PRODUCT_TOOL_ICON..iconId..".png"
end

--获取头像路径
function ResourcesManager.getHeadPathByIdType(id,_type)
	 local icon
	 if _type == 3001 then
		local hero_info = DataManager.getHeroBySystemHeroId(id)
		icon = ResourcesManager.getHeroIcon(hero_info.imgId)
	 elseif _type == 2001 then
		local equ_info = DataManager.getEquipmentBySystemEquipId(id)
		icon = ResourcesManager.getToolIcon(equ_info.imgId)
	 elseif _type == 1001 or _type == 4001 or _type == 5001 or _type == 6001 then
		local tool_info = DataManager.getToolById(id)
		icon = ResourcesManager.getToolIcon(tool_info.imgId)
	 end
    return icon
end

--file end