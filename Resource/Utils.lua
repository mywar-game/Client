------------------------------------------
-- 文件名称:    Utils.lua
-- 文件标识:   
-- 内容摘要:    工具
-- 其它说明:
-- 当前版本:    0.1
-- 作    者:    AlohaWu
-- 完成日期:    16:13 2013/5/9
------------------------------------------
Utils = {}
--冒泡排序
function BubbleSort(t, func)
		local n = #t
		for i=1,n do
			for j=1,n-i do
				if func(t[j+1],t[j]) then
					t[j+1],t[j] = t[j],t[j+1]
				end
			end
		end
end
--分割字符串
function Split(str, delim, maxNb)
    if not str or str == "" then  return {} end
    str = tostring(str)--防止类型错误
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

function strArrToIntArr(strArr)
	local intArr = {}
	for k,v in pairs(strArr) do
		intArr[k]= v+0
	end
	return initArr
end

function tableToStringForUIEditor(t,label)
	local str=''
	if type(label) == 'string' then
		str =label.."={"
	else
		str = "{"
	end
    for k,v in pairs(t) do
		if type(v) == 'table' then
			str = str..tableToStringForUIEditor(v,k)..","
		else
			if type(k) =='string' then
    			str = str..k.."="
			end
			if type(v)=='string' then
        		str = str.."'"..v.."',"
			elseif type(v)=='boolean' then
				str = str..(v and 'true' or 'false')..","
			else
				str = str..v..","
			end
		end
    end
	str= str.."}"
    return str
end

function tableToString(t,label)
	local str=''
	if type(label) == 'string' then
		str ="['"..label.."']".."={"
	else
		str = "{"
	end
    if t then
        for k,v in pairs(t) do
    		if type(v) == 'table' then
    			str = str..tableToString(v,k)..","
    		else
    			if type(k) =='string' then
        			str = str.."['"..k.."']".."="
    			end
    			if type(v)=='string' then
            		str = str.."'"..v.."',"
    			elseif type(v)=='boolean' then
    				str = str..(v and 'true' or 'false')..","
    			else
    				str = str..v..","
    			end
    		end
        end
     else
        str= str.."null,"
     end
	str= str.."}"
    return str
end

--从可写目录读取文件
function ReadFileContentFromWritablePath(filename)
	local fileUtils = cc.FileUtils:getInstance()
	local dataPath =  fileUtils:getWritablePath() 
    local filepath = dataPath..filename
	local f = io.open(filepath,"r")
	if not f then
		return nil
	end
	local content = f:read("*a")
	f:close() 
	return content   
end

--读文件
-- filename 相对Resources目录的文件
function ReadFileContentTableFromWritablePath(filename)
    local content = ReadFileContentFromWritablePath(filename)
    if not content then return nil end
    return json.decode(content)
end

--读文件
-- filename 相对Resources目录的文件
function ReadFileContentTable(filename)
    local content = ReadFileContent(filename)
    if not content then return nil end
    return json.decode(content)
end

--读文件
-- filename 相对Resources目录的文件
function ReadFileContent(filename)
	if file_exists(filename) then
		local f = ccString:createWithContentsOfFile(filename)
		local content = f and f:getCString() 
		return content
	end
end

--读取加密的文件为table
function ReadEncryptFileContentTable(filename)
    local content = ReadEncryptFileContent(filename)
    if not content then return nil end
    return json.decode(content)
end

--读取加密的文件
function ReadEncryptFileContent(filename)
    if file_exists(filename) then
        local f = readEncryptTxt(filename)
        local content = f and f:getCString() 
        return content
    end
end

--写文件
function WriteFile(fileName,data_table,mode)
    local fileUtils = cc.FileUtils:getInstance()
    local dataPath =  fileUtils:getWritablePath()
    local f = io.open(dataPath..fileName,mode or "w")
    if f then
		require("Json")
        local json_data =json.encode(data_table) 
        f:write(json_data)
        f:flush()
        f:close()
        return true
    end
    return false
end

function setNotPlaySound(data)
	ConfigManager.saveLocal(ConfigManager.sound_effect,data)
end

function setNotPlayBg(data)
	ConfigManager.saveLocal(ConfigManager.bg_effect,data)
end

function isNotPlaySound()
	local data = ConfigManager.getLocalValueByKey(ConfigManager.sound_effect)
	return data and data == 1
end

function isNotPlayBg()
	local data = ConfigManager.getLocalValueByKey(ConfigManager.bg_effect)
	return data and data == 1
end

function saveCurPerform(data)
	ConfigManager.saveLocal(ConfigManager.cur_perform,data)
end

function getCurPerform()
	local data = ConfigManager.getLocalValueByKey(ConfigManager.cur_perform)
	return  data or 0
end

--深度拷贝
function DeepCopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end


function ToJsonStr(t)
    local str = json.encode(t)
    return str
end


--判断文件是否存在
function file_exists(filename)
	local fileUtils = cc.FileUtils:getInstance()
	local dataPath = fileUtils:getWritablePath() 
    local filepath = dataPath..filename
    local os = cc.Application:getInstance():getTargetPlatform() 
    if os == kTargetAndroid then
		return fileUtils:isFileExist(fileUtils:fullPathForFilename(filename))
    elseif os == kTargetIphone or os == kTargetIpad then
		return fileUtils:isFileExist(fileUtils:fullPathForFilename(filename))
    else
        return cc.FileUtils:getInstance():isFileExist(filename)
    end
end

--遮罩
function Cover(maskSprite,textureSprite)
    local maskSprite_c = maskSprite:getContentSize()
    local rt = cc.RenderTexture:create(maskSprite_c.width,maskSprite_c.height)
    
    
    local textureSprite_c = textureSprite:getContentSize()
    maskSprite:setPosition(maskSprite_c.width/2,maskSprite_c.height/2);
    textureSprite:setPosition(textureSprite_c.width/2, textureSprite_c.height/2);
    
     
    local m_bfc = ccBlendFunc:new()
    m_bfc.src = GL_ONE
    m_bfc.dtc = GL_ZERO
    maskSprite:setBlendFunc(m_bfc)
    local t_bfc = ccBlendFunc:new()
    t_bfc.src = GL_DST_ALPHA
    t_bfc.dtc = GL_ZERO
    textureSprite:setBlendFunc(t_bfc)
    
    rt:begin()
    maskSprite:visit()
    textureSprite:visit()
    rt:endToLua()
    
    local tex = rt:getSprite():getTexture()
    local retval = rt:getSprite() --cc.Sprite:spriteWithTexture(tex)
    retval:setFlipY(true)
    return retval
end

--将时间格式化为hh:mm:ss,主要用于倒计时
function Utils.remainTimeToStringHHMMSS(remainTime)
    if not remainTime or remainTime <= 0 then
        return "00:00:00"
    end
    local h = math.floor(remainTime/1000/60/60)
    local m = math.floor(remainTime/1000/60)%60
    local s = math.floor(remainTime/1000)%60
    return string.format("%02d:%02d:%02d",h,m,s)
end

--将时间格式化为mm:ss,主要用于倒计时
function Utils.remainTimeToStringMMSS(remainTime)
    if not remainTime or remainTime <= 0 then
        return "00:00"
    end
    local h = math.floor(remainTime/1000/60/60)
    local m = math.floor(remainTime/1000/60) % 60
    local s = math.floor(remainTime/1000) % 60
    return string.format("%02d:%02d",m,s)
end

--将秒转成日期 
function Utils.remainTimeToDates(tiems)
    local tab = os.date("*t", tiems);
	--local dates = tab.year..LabelChineseStr.Utils_1..tab.month..LabelChineseStr.Utils_2..tab.day..LabelChineseStr.Utils_3 
    local dates = tab.year.."/"..tab.month.."/"..tab.day 
	return dates
end

--将秒转成日期 
function Utils.remainTimeToDateTime(tiems)
    local tab = os.date("*t", tiems)
	local dates = string.format("%d.%d.%d %02d:%02d:%02d",tab.year,tab.month,tab.day,tab.hour,tab.min,tab.sec)
	return dates
end

--将浮点数转化为整数
function Utils.toint(n)
    local s = tostring(n)
    local i, j = s:find('%.')
    if i then
        return tonumber(s:sub(1, i-1))
    else
        return n
    end
end

--保留小数点后几位
function Utils.formatFloat(n,num)
    -- n 为要精确的小数，num为要保留num位
    return tonumber(string.format("%." ..num.. "f",n))
end


-- 参数:待分割的字符串,分割字符
-- 返回:子串表.(含有空串)
function lua_string_split(str,split_char)
    local sub_str_tab = {};
    while (true) do
        local pos = string.find(str, split_char);
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str;
            break;
        end
        local sub_str = string.sub(str, 1, pos - 1);
        sub_str_tab[#sub_str_tab + 1] = sub_str;
        str = string.sub(str, pos + 1, #str);
    end

    return sub_str_tab;
end
  
function lua_string_array(str)
	local i = 1
	local tb = {}
	while i <= #str  do
	   c = str:sub(i,i)
	   ord = c:byte()
	   if ord > 128 then
		  table.insert(tb,str:sub(i,i+2))
		  i = i+3
	   else
		  table.insert(tb,c)
		  i=i+1
	   end
	end
	return tb
end

function SpriteGetTextureForKey(path)
	cclog("path==="..path)
	--local texture = cc.Director:getInstance():getTextureCache():getTextureForKey(path)
	local texture = cc.Director:getInstance():getTextureCache():addImage(path)
	return texture
end

--返回时间hh:mm:ss---
function formatTime(timeNum, format)
	if format == nil then
		format = "%02d:%02d:%02d"
	end
	return string.format(format, NdCalculateTime(timeNum))
end

function NdCalculateTime(timeNum)
	local nSec=timeNum
	local h=0
	local m=0
	local s=0
	h=math.floor(nSec/ 3600)
	m=math.floor((nSec%3600) /60)
	s=nSec%60

	return h,m,s
end

function ConversionXY(maxTileNumY,xy)
	local tmp = Split(xy,",")
	local x = 1 + tonumber(tmp[1])
	local y = 1 + tonumber(tmp[2])
	return x,y
end

function transformEffectParams(params)
	local paras = {}
	local nParas = string.gsub(params,"：",":")
	local tmp = Split(nParas,",")
	for k,v in pairs(tmp)do
		local t = Split(v,":")
		local k = t[1]
		local v = t[2]
		paras[k] = tonumber(v)
	end
	return paras
end

--将utf8字符串拆分为独立字符表
function splitUTF8StrToSingleTab(str)
    local arr={0xc0,0xe0,0xf0,0xf8,0xfc};
    local retTab = {}
    local startPos = 1
    while string.len(str) > 0 do
        local tmp = string.byte(str, startPos)
        local offset = 5
        while offset > 0 and tmp < arr[offset] do
            offset = offset - 1
        end
        table.insert(retTab, string.sub(str, startPos, startPos + offset))
        startPos = startPos + offset + 1
        if startPos > string.len(str) then break end
    end 
    return retTab
end

--分X个字符插入指定文本
function getInsertStrbyConLen(originStr, len, insertStr, maxLen)
    local strTab = splitUTF8StrToSingleTab(originStr)
    local retStr = ""
    local localLen = 0--计算长度 中文占一个 英文占半个(为了加\n)
    for k=1, #strTab do
        retStr = string.format("%s%s", retStr, strTab[k])
        if (string.byte(strTab[k], 1)) >= 0xe0 then
            localLen = localLen + 2
        else
            localLen = localLen + 1
        end
        if localLen >= len*2 then
            localLen = 0
            retStr = string.format("%s%s", retStr, insertStr)
        end
        if k >= maxLen then break end
    end
    return retStr
end

--直接退出
--code=1;
--//吊起第三方的登陆界面
--code= 2;
--//吊起第三方支付
--code= 3;
--//切换第三方账户
--code= 4;
--//进入sdk用户中心
--code = 5;
--//注销sdk用户
--code = 6;
function Utils.sendNotifyToPlamt(pcode,pcontent)
    local msg = {}
    msg.code=pcode
    msg.content=pcontent
    if V.getPlatFormType() == 3 then --android平台
        local args={V.encode(msg)}
        LuaJavaBridge.callStaticMethod("com/fantingame/xgame/JniCall", "gameMsgDeal", args, "(Ljava/lang/String;)V")
    else
        LuaObjcBridge.callStaticMethod("LuaJni", "gameMsgDeal",msg)
    end
end

--四舍五入
function Utils.round(num)
    if num - math.ceil(num) >= 0.5 then
        return math.floor(num)
    else
        return math.ceil(num)
    end    
end

--计算两点的距离
function Utils.calcPointsDistance(p1, p2)
    return math.sqrt( math.pow((p1.x-p2.x), 2) + math.pow((p1.y-p2.y), 2) )
end

--计算两点的距离
function Utils.calcPointsVector(sp, ep)
    return cc.p(ep.x-sp.x, ep.y-sp.y)
end