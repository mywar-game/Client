HttpClient = {}
HttpClient.HttpCallback = {}

-- port 接口
-- data 参数数据
-- callBack 回调方法
-- HttpClient.sendRequest("login","userId=111",loginPanel_Response) 示例
function HttpClient.sendRequest(action,data,callBack,url,isWait)
	local url = url and url or V.getVersionDomain()
    local full_url = string.format("%s/%s?%s",url,action,data)
    ccloge("Request For Url->"..full_url)
    HttpClient.HttpCallback[action] = callBack
    NetHttpReqRaw(full_url,nil,"get",action or "")
end

--获取版本信息
function HttpClient.checkVersion(url,localVersion,partnerId,qn,fr,mac,callBack)
    local data = "partnerId="..partnerId.."&qn="..qn.."&fr="..fr.."&mac="..mac.."&version="..localVersion
    HttpClient.sendRequest("/webApi/checkVersion.do",data,callBack,url)
end

function HttpClientRecv(code,tag,msg)
    if not tag then ccloge("HttpClientRecv -> tag is nil") return end
    local callback = HttpClient.HttpCallback[tag] 	
    if callback then
        callback(code,tag,msg)
    else
        ccloge("HttpClientRecv -> not handle response, tag="..tag)
    end
end

--初始化http
function initHttpClient()
	NetHttpInitRaw(HttpClientRecv)
end