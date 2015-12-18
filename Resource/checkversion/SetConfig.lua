--创建热更新文件存放目录，以apk版本号为目录名称
V = {}
local platInfo = nil
local PlatForm_Type = cc.Application:getInstance():getTargetPlatform()

local version_cjson = require "cjson.safe" 
function V.decode(str)--该方法只为版本检测返回结果服务
    local tbl,err = version_cjson.decode(str)
    if not tbl then
        print("\n\n================================")
        print("Json Decode Error:", err)
        print(str)
        print("================================\n\n")
    end
	
    if tbl == version_cjson.null then tbl=nil end
    --过滤cjson.null,将其替换为nil
    local function replace_cjson_null(t)
        if not t then return end
        if type(t) == "userdata" then t=nil return end
        if type(t) ~= "table" then return end
        for k,v in pairs(t) do
            if type(v) == "table" then
                replace_cjson_null(v)
            elseif type(v) == "userdata" then
                t[k] = nil
            else
			
            end
        end
    end
    replace_cjson_null(tbl)
    return tbl
end

function V.encode(tbl)
    return version_cjson.encode(tbl)
end

function V.decodeURI(s)
    s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    return s
end

function V.encodeURI(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(s, " ", "+")
end

--该接口为多平台调用接口   如果为ios则在else中进行添加
local rootIndexFileName = "Entry"
function V.initPlatInfo()
    if platInfo~=nil then return platInfo end
    platInfo={}
    print("PlatForm_Type===="..PlatForm_Type)    
    --cc.PLATFORM_OS_WINDOWS = 0
    --cc.PLATFORM_OS_LINUX   = 1
    --cc.PLATFORM_OS_MAC     = 2
    --cc.PLATFORM_OS_ANDROID = 3
    --cc.PLATFORM_OS_IPHONE  = 4
    --cc.PLATFORM_OS_IPAD    = 5
    --cc.PLATFORM_OS_BLACKBERRY = 6
    --cc.PLATFORM_OS_NACL    = 7
    --cc.PLATFORM_OS_EMSCRIPTEN = 8
    --cc.PLATFORM_OS_TIZEN   = 9
    if PlatForm_Type == 3 then --android平台的获取用户信息接口
        rootIndexFileName = "Resource/Entry"
        print("android平台")
        local args={}
        local ok,platInfotemp =LuaJavaBridge.callStaticMethod("com/fantingame/xgame/JniCall", "getPlatInfo", args, "(Ljava/lang/String;)Ljava/lang/String;") --SendCmdToPlatFormHaveResult("com/fantingame/xgame/JniCall","getPlatInfo","")
        platInfo = V.decode(platInfotemp)
    elseif PlatForm_Type == 0 then --widows
        print("windows平台，返回测试数据")
        --一下为测试所用
        platInfo.mac="testwindowsmac"
        platInfo.partnerId="1001"
        platInfo.imei="testiosimei"
        platInfo.qn="0"
        platInfo.checkVersionUrl="http://192.168.1.158:6001"
        platInfo.packageVersion="2.0"
        platInfo.mobile="testmobile"
        platInfo.loginServerUrl="http://192.168.1.158:81"
    else  --ios系统苹果的
        print("苹果系统")
        rootIndexFileName = "Resource/Entry"
        platInfo.mac="testiosmac"
        platInfo.partnerId="1001"
        platInfo.imei="testiosimei"
        platInfo.qn="0"
        platInfo.checkVersionUrl="http://192.168.1.191:5001"
        platInfo.packageVersion="1.0"
        platInfo.mobile="testmobile"
        platInfo.loginServerUrl="http://192.168.1.191:81"
        local args={}
        local ok,platInfotemp = LuaObjcBridge.callStaticMethod("LuaJni", "getPlatInfo",nil)
        print("苹果平台获得以下信息--->"..V.encode(platInfotemp))
        platInfo = platInfotemp
    end
end

V.initPlatInfo()
packageVersion = "1.0"

if platInfo~=nil and platInfo.packageVersion~=nil then
    packageVersion = platInfo.packageVersion
end

local updatePath = createDownloadDirAddName("updatedir"..packageVersion)
local entryPath = cc.FileUtils:getInstance():fullPathForFilename(rootIndexFileName)

local length=6
local rootPath = string.sub(entryPath,1,-length)

print("1 entryPath="..entryPath)
print("2 updatePath="..updatePath)
print("3 rootPath="..rootPath)

--重新设置搜索路径
local searchPaths = {}
table.insert(searchPaths,updatePath)
table.insert(searchPaths,rootPath)
cc.FileUtils:getInstance():setSearchPaths(searchPaths)
print("设置搜索路径完毕")

function V.getPlatFormType()
	return PlatForm_Type
end

function V.getPlatInfo()
	return platInfo
end

function V.getUpdatePath()
	return updatePath
end

function V.getVersionDomain()
	return ""
end



