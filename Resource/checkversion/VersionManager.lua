VersionManager = {}
function VersionManager.checkVersion(ponError,ponSuccess,ponProgress,ponProgressNum)
    local resList={}
    local updateType = nil
    local packageName = nil
	local downLoadNum = 0--已下载个数
	local pathToSave = V.getUpdatePath()
	local platInfo = V.getPlatInfo()
    local localVersion = platInfo.packageVersion.."."..VersionNumRes.getLocalResVersion()
	
    print("localVersion==="..localVersion)
    local function onError(errorCode)
        --cc.ASSETSMANAGER_CREATE_FILE  = 0
        --cc.ASSETSMANAGER_NETWORK = 1
        --cc.ASSETSMANAGER_NO_NEW_VERSION = 2
        --cc.ASSETSMANAGER_UNCOMPRESS     = 3
        if errorCode == 0 then
            showJustTips(GameString.createFileFail)
        elseif errorCode == 1 then
            showJustTips(GameString.loaddownFail)
        elseif errorCode == 3 then
            showJustTips(GameString.zipFail)
        else
            ponError(errorCode)
        end
    end
	
    local function onProgress(percent)
        ponProgress(percent)
    end
	
    local function onSuccess()
        --progressLable:setString("downloading ok")
        ponProgress(100)
        downLoadNum = downLoadNum+1
       if updateType=="full" then
            VersionManager.installApk(packageName)
            ponProgressNum("(1/1)")
       else
            ponProgressNum("("..downLoadNum.."/"..#resList..")")
            if downLoadNum>=#resList then --如果所有包已经下载完成 则通知成功回调
                ponSuccess(true)
            else --继续下载剩余的更新包
                ponProgress(1)--重置更新条
                local packageNum = downLoadNum+1
                print("一共要下载资源包个数"..#resList.."继续下载第"..packageNum.."个更新包，url="..resList[packageNum])
                downLoadRes(resList[packageNum])
            end
       end
    end
	
    local function getAssetsManager(url,type)
        print("即将下载文件url="..url)
        print("即将下载文件type="..type)
        print("即将下载文件pathToSave="..pathToSave)
        local assetsManager = cc.AssetsManager:new(url,type,pathToSave)
        assetsManager:retain()
        --cc.ASSETSMANAGER_PROTOCOL_PROGRESS =  0
        --cc.ASSETSMANAGER_PROTOCOL_SUCCESS  =  1
        --cc.ASSETSMANAGER_PROTOCOL_ERROR    =  2
        assetsManager:setDelegate(onError, 2 )
        assetsManager:setDelegate(onProgress, 0)
        assetsManager:setDelegate(onSuccess, 1 )
        assetsManager:setConnectionTimeout(0)
        return assetsManager
    end
	
    function downLoadRes(url)
		getAssetsManager(url,updateType):update()
    end
	
    local function parseVersionInfo(code,tag,data)
        if code == 3000 then
            showJustTips("网络异常:"..(data or ""))
            return
        end
		
        data = V.decode(data)
        local dt = data.dt
        if dt == nil then
            if data.rc ~= nil and data.msg ~= nil then
                showJustTips(GameString.getVersionFail..code)
            end
        else
            dt = dt.dt
            if dt.resUrl~=nil and #dt.resUrl>0 then--有资源更新
                resList = VersionManager.SplitStr(dt.resUrl,";")
                updateType = "res"
                --print("需要升级的资源包，第1个URL="..resList[1])
                ponProgressNum("("..downLoadNum.."/"..#resList..")")
                downLoadRes(resList[1])
            elseif dt.apkUrl~=nil and #dt.apkUrl>0 then
                if V.getPlatFormType() ~= 3 then --只有android才有apk更新
                    ponSuccess(false)
                else
                    updateType = "full"
                    pathToSave = VersionManager.getApkPath()
                    packageName = dt.apkUrl
                    print("需要升级的APK包，URL="..dt.apkUrl..",pathToSave="..pathToSave)
                    ponProgressNum("(0/1)")
                    downLoadRes(dt.apkUrl)
                end
            else
                --print("无版本更新！")
                ponSuccess(false)
            end
			
            if dt.ver~=nil and #dt.ver>0 then
                print("当前最新版本为:"..dt.ver)
            end
			
            if dt.desc~=nil and #dt.desc>0 then
                print("当前最新版本描述信息为:"..dt.desc)
            end
        end
    end
    HttpClient.checkVersion(platInfo.checkVersionUrl,localVersion,platInfo.partnerId,platInfo.qn,platInfo.imei,platInfo.mac,parseVersionInfo)
end

--分割字符串
function VersionManager.SplitStr(str, delim, maxNb)
    if string.find(str, delim) == nil then
        return { str }
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0    -- No limit
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gfind(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end

--获取包的下载路径
function VersionManager.getApkPath()
    local args={}
    local ok,filePath =LuaJavaBridge.callStaticMethod("com/fantingame/xgame/JniCall", "getApkPath", args, "(Ljava/lang/String;)Ljava/lang/String;") --SendCmdToPlatFormHaveResult("com/fantingame/xgame/JniCall","getPlatInfo","")
    --local filePath = SendCmdToPlatFormHaveResult("com/fantingame/xgame/JniCall","getApkPath","")
    if filePath~=nil then
        print("获取filePath成功！~~~filePath="..filePath)
        return filePath
    else
        print("获取filePath失败！~~~")
        return nil
    end
end

--安装apk
function VersionManager.installApk(packageName)
    local args={packageName}
    LuaJavaBridge.callStaticMethod("com/fantingame/xgame/JniCall", "installApk", args, "(Ljava/lang/String;)V") --SendCmdToPlatFormHaveResult("com/fantingame/xgame/JniCall","getPlatInfo","")
    --SendCmdToPlatFormNoResult("com/fantingame/xgame/JniCall","installApk",packageName)
end

--调用sdk登陆
function VersionManager.startSdkLogin()
    local msg = {}
    msg.code=2
    msg.content=""
    if V.getPlatFormType() == 0 then

    elseif V.getPlatFormType() == 3 then --android平台
        local args={V.encode(msg)}
        LuaJavaBridge.callStaticMethod("com/fantingame/xgame/JniCall", "gameMsgDeal", args, "(Ljava/lang/String;)V")
    else
        LuaObjcBridge.callStaticMethod("LuaJni", "gameMsgDeal",msg)
    end
end

