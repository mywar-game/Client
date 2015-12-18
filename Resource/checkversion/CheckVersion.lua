--创建下载目录
require("checkversion/SetConfig")
require("checkversion/VersionManager")
require("checkversion/HttpClient")
require("VersionNumRes")
require("GameString")
require("Config")
require("log")

local mScene = nil
local mLabelTTF = nil
local mloadingPro = nil
local mLoginLayer = nil
local mTipsSprite = nil

local function initCheckScene()
	local director = cc.Director:getInstance()
	local midWidth = director:getWinSize().width/2
	local midHeight = director:getWinSize().height/2
	
	mScene = cc.Scene:create()
	local runingScene = director:getRunningScene()
	if not runingScene then
		director:runWithScene(mScene)
	else
		director:replaceScene(mScene)
	end

	--[[]]
	local path = "NewUi/xinqietu/xuanqu/"
	mLoginLayer = cc.Layer:create()

	local loadingbg  = cc.Sprite:create(path.."i_jiazdi.png")
	loadingbg:setPosition(midWidth,77)
    mLoginLayer:addChild(loadingbg,1)

	local load_img = cc.Sprite:create(path.."i_jiazaitiao.png")
	local loading = cc.ProgressTimer:create(load_img)--loading条
	loading:setType(1)
	loading:setMidpoint({ x = 0, y = 1 })
	loading:setBarChangeRate({ x = 1, y = 0 })
	loading:setPosition(midWidth,77)
	loading:setPercentage(0)
	mLoginLayer:addChild(loading,2)
	mloadingPro = loading
	 
	mLabelTTF = cc.LabelTTF:create("","Arial",20,{width = 0, height = 0})
	local loadingPositionX = loading:getPositionX()
	local loadingPositionY = loading:getPositionY()
	mLabelTTF:setPosition(loadingPositionX,loadingPositionY-25)

	local labelTTFPercent = cc.LabelTTF:create(GameString.checkRes,"Arial",20,{width = 0, height = 0})
	labelTTFPercent:setPosition(loadingPositionX,loadingPositionY)

	mLoginLayer:addChild(mLabelTTF,4)
	mLoginLayer:addChild(labelTTFPercent,4)
	
	local root = "NewUi/xinqietu/denglujiemian/denglujiemian"
	local pngName = root.."0.png"
    local plistName = root.."0.plist"
    local exportJson = root..".ExportJson"
	
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(pngName, plistName, exportJson)
    local size = cc.Director:getInstance():getWinSize()
	local armature = ccs.Armature:create("denglujiemian")
	armature:setPosition(size.width/2,size.height/2)
    armature:getAnimation():play("tx")
	mLoginLayer:addChild(armature)
	
	mScene:addChild(mLoginLayer)
end

function showJustTips(txt)
    --删除tips
    local function removeTips() 
        if mTipsSprite then
			mTipsSprite:removeFromParent(true) 
			mTipsSprite=nil 
		end
    end
	removeTips()
	
    mTipsSprite = cc.LabelTTF:create(txt,"Arial",25,{width = 300, height = 200})
    mTipsSprite:setPosition(480,320)
    mLoginLayer:addChild(mTipsSprite, 1024)
	
    --出现后消失
    local arr = {}
    arr[1] = cc.FadeIn:create(0.1)
    arr[2] = cc.MoveTo:create(1,{x=480,y=320+50})
    arr[3] = cc.FadeOut:create(0.5)
    arr[4] = cc.CallFunc:create(removeTips)
    local sq = cc.Sequence:create(arr)
    mTipsSprite:runAction(sq)
end

--版本检查相关开始
local prePercent
local function setUpdateProcess(percent)
    if prePercent==nil or percent~=prePercent then
        labelTTFPercent:setString("("..percent.."%)")
        prePercent = percent
    end
    mloadingPro:setPercentage(percent)
end

local function onCheckVersionSuccess(state)
     --VersionManager.JustTips("更新成功！~~")
	 --local luatojavaresult = SendCmdToPlatForm("com/cocos2dx/sample/LuaJavaBridgeTest/JavaLuaBridgeTest","startPay","i am lua")
	 --print("i got result ====>"..luatojavaresult)
	if state then
		--清理路径缓存
		cc.FileUtils:getInstance():purgeCachedEntries()
		--清理已加载lua缓存
		local reloadmodule = {"checkversion/VersionManager","checkversion/HttpClient",
							  "checkversion/CheckVersion","checkversion/SetConfig",
							  "VersionNumRes","Config"}
		for k,v in pairs(reloadmodule) do	
			if package.loaded[v]~=nil then
				package.loaded[v] = nil
			end
		end
		mScene:removeFromParent(true)		
		require("checkversion/CheckVersion")
    else
		mScene:removeFromParent(true)
		require("Main")
	end
end

local function onCheckVersionError(errorCode)
    showJustTips(GameString.checkVersion..errorCode["..errorCode.."])
end

local function setProgressNum(text)
    mLabelTTF:setString(text)
end

local function checkVersion()
    if Config.isOpenApiAndCheckVersion then
        --正式版用这个
        VersionManager.checkVersion(onCheckVersionError,onCheckVersionSuccess,setUpdateProcess,setProgressNum)
    else
        onCheckVersionSuccess(false)
    end
end

initHttpClient()
initCheckScene()

local arr = {}
arr[1] = cc.ProgressTo:create(1,100)
arr[2] = cc.DelayTime:create(0.1)
arr[3] = cc.CallFunc:create(checkVersion)
local sequence = cc.Sequence:create(arr)
mloadingPro:runAction(sequence)

local mainBGMusicPath = cc.FileUtils:getInstance():fullPathForFilename("sound/login.mp3")
cc.SimpleAudioEngine:getInstance():playMusic(mainBGMusicPath,true)