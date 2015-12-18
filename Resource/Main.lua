-- main逻辑文件
--
collectgarbage("setpause", 100)
collectgarbage("setstepmul", 5000)
require("Cocos2d")
require("log")
require("Json")
require("Utils")
require("Director")
require("Config")
require("Scheduler")
require("Debug")
require("webApi/ActFileHead")
require("Network")
require("UIPanel")
require("UIUtils")
require("GameScene")
require("FpsChecker")
require("LabelChStr")
require("ConfigManager")
require("PointerManager")
require("CacheManager")
require("ActionHelper")
require("GameField")
require("StaticField")
require("GameString")
require("IconUtil")
require("IconPath")
require("Formula")
require("EquipDetailUtil")
require("cocos2d/GuiConstants")

math.randomseed(os.time())                  --初始化随机数产生器

function __G__TRACKBACK__(msg)
    print("\n\n\n----------------------------------------")
    local errorLog = msg.."\n"..debug.traceback()
    Main_logToUi(errorLog)                  --将脚本异常信息输出到屏幕
    --NetHttpReq.sendErrorLog(errorLog)       --将脚本异常信息发送到服务器
    print(msg)                         --将脚本异常打印到命令行
    print("----------------------------------------\n\n\n")
end

--加载场景
function StartGame()
    NetHttpInitRaw(NetHttpRecv) --初始化http
	local game_scene = GameScene:New()
    game_scene:createAndRun()
    
    -- 游戏加速器检测
    FpsChecker.start()
end

--以下是测试临时用
xpcall(StartGame,__G__TRACKBACK__)