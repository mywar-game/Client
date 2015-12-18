require("Config")
require("DataManager")
require("Json")
--用户配置信息
--通过本地文本文件，维护用户配置

ConfigManager = {}

local _config_cache = {}

--用户个人设置中的key
ConfigManager.KEY_is_chapter_anim_showed = "is_chapter_anim_showed"
ConfigManager.KEY_is_dialog_to_elite_showed = "is_dialog_to_elite_showed"
ConfigManager.sound_effect = "sound_effect"
ConfigManager.bg_effect = "bg_effect"
ConfigManager.cur_perform = "cur_perform"
ConfigManager.pushMsg = "pushMsg"	--是否推送消息
ConfigManager.showPeopelNums = "showPeopelNums"	--当前屏幕显示人数
ConfigManager.KEY_FIGHT_SPEED = "fight_speed"
ConfigManager.KEY_TOWER_ACTION = "tower_action"

ConfigManager.KEY_TASK_OPEN = "task_open"
ConfigManager.KEY_PK_OPEN = "pk_open"
ConfigManager.KEY_TALK_LEVEL = "talk_level"

--保存配置key,value
function ConfigManager.saveLocal(key,value)
    _config_cache[key] = value
    local user_id = DataManager.getUserPlayerId()
    --写文件
	if user_id then
		cclog(Config.UserSettingFile..(user_id and ("_"..user_id) or ""))
		WriteFile(Config.UserSettingFile..(user_id and ("_"..user_id) or ""),_config_cache)
	end
end

--根据key读取配置value
function ConfigManager.getLocalValueByKey(key)
    if not _config_cache[key] then 
		local user_id = DataManager.getUserPlayerId()
        local tab = ReadFileContentTableFromWritablePath(Config.UserSettingFile..(user_id and ("_"..user_id) or ""))
        if tab then 
            _config_cache = tab
        end
    end
    return _config_cache[key]
end

--保存配置key,value
function ConfigManager.save(key)
	NetReq.User_recordGuideStep(key)
    DataManager.setUserGuideKey(key,key)
end

--根据key读取配置value
function ConfigManager.getValueByKey(key)
    return DataManager.getUserGuideKey(key)
end

local _loginInfo

function ConfigManager.getLoginInfoItem(item)
    if not _loginInfo then
        _loginInfo = ReadFileContentTableFromWritablePath(Config.loginInfoTempFile)
    end

    return _loginInfo and _loginInfo[item]
end
function ConfigManager.setLoginInfo(tk,sid,uid,puid,port,serverUrl)
	local platInfo = V.getPlatInfo()
    _loginInfo={}
    _loginInfo["tk"]=tk
    _loginInfo["sid"]=sid
    _loginInfo["pid"]=platInfo.partnerId
    _loginInfo["uid"]=uid
    _loginInfo["puid"]=puid
    _loginInfo["port"]=port
    _loginInfo["qn"]=platInfo.qn
    _loginInfo["serverUrl"]=serverUrl
end
--登陆token，该token为登陆服务器返回的一个唯一字串，代表用户已经登陆成功，可进入游戏
function ConfigManager.getTk()
    return ConfigManager.getLoginInfoItem("tk")
end

--	服务器ID
function ConfigManager.getSid()
    return ConfigManager.getLoginInfoItem("sid") or "d1"
end

--	合作商ID
function ConfigManager.getPid()
    return ConfigManager.getLoginInfoItem("pid")
end

--	合作商用户ID
function ConfigManager.getUid()
    return ConfigManager.getLoginInfoItem("uid")
end

--	合作用户ID
function ConfigManager.getPuid()
    return ConfigManager.getLoginInfoItem("puid")
end


--	服务器端口
function ConfigManager.getPort()
    return ConfigManager.getLoginInfoItem("port") or "9999"
end

--	手机机型
function ConfigManager.getPhoneModel()
    return ConfigManager.getLoginInfoItem("phone_model") or "unknow"
end

--获取宜搜二级渠道号
function ConfigManager.getEsqn()
    return ConfigManager.getLoginInfoItem("esqn") or ""
end

--获取 服务器地址
function ConfigManager.getServerUrl()
   return ConfigManager.getLoginInfoItem("serverUrl")
end

--	手机版本号
function ConfigManager.getPhoneVersion()
    return ConfigManager.getLoginInfoItem("phone_model") or "1.0.0"
end

--	游戏版本号
function ConfigManager.getGameVersion()
    return ConfigManager.getLoginInfoItem("gver") or "1.0"
end


