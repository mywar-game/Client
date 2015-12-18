require("Config")

NetHttpReq = {}
NetHttpReq.HttpCallback = {}
local url = ""

-- port 接口
-- data 参数数据
-- callBack 回调方法
-- NetHttpReq.sendRequest("login","userId=111",loginPanel_Response) 示例
function NetHttpReq.sendRequest(port,data,callBack,url,isWait)
    if isWait~=nil then
        LayerManager.showWaiting()
    end
	local platInfo = V.getPlatInfo()
    print(platInfo.loginServerUrl)
    local full_url = string.format("%s/%s?%s",url and url or platInfo.loginServerUrl,port,data)
    print("full_url"..full_url)
    cclog("Request For Url->"..full_url)
	NetHttpReq.HttpCallback[port] = callBack
	NetHttpGet(full_url,port)
end

--签名算法
function getSign(str)
    return str
end

--向服务器发送下单请求
function NetHttpReq.getTradeOrder(amount,tradeName,callBack)
    local userConfig = DataManager.getUserConfig()

    local partnerId = ConfigManager.getPid() or ""       --合作平台ID
    local serverId = ConfigManager.getSid() or ""	    --服务器ID
    local partnerUserId = DataManager.getPartnerUserId() or ""	--用户ID
    local tk = ConfigManager.getTk() or ""
    local esqn = ConfigManager.getEsqn() or ""          --二级渠道号


    local timestamp	= DataManager.getServerSystemTimeAtStart() + (os.time()*1000 - DataManager.getClientSystemTimeAtStart())     --时间戳
    local sign =  getSign(partnerId..serverId..partnerUserId..amount..tradeName..timestamp..tk)          --签名
    sign ="null"
    local data = "partnerId="..partnerId.."&serverId="..serverId.."&partnerUserId="..partnerUserId.."&amount="..amount.."&timestamp="..timestamp.."&sign="..sign.."&tradeName="..tradeName.."&esqn="..esqn
    
    NetHttpReq.sendRequest("/webApi/createOrder.do",data,callBack)
end

--模拟登陆
function NetHttpReq.simulationLogin(uid,pid,sid,callBack,url)
    local data = "partnerUserId="..uid.."&partnerId="..pid.."&serverId="..sid
	NetHttpReq.sendRequest("gameApi/loadUserToken.do",data,callBack,url)
end

--获取是否排队信息
function NetHttpReq.sendQeueuInfo(serverId, callBack)   
    local data = "serverId="..serverId
    local timestamp = "123456"
    local data = "token="..token.."&serverId="..serverId.."&partnerId="..partnerId.."&qn="..string.gsub(qn, " ", "-").."&fr="..fr.."&idfa="..fr.."&mac="..mac.."&version="..localVersion.."&ua="..string.gsub(mobile, " ", "-").."&timestamp="..timestamp
    data = data.."&sign=bbsc"
    NetHttpReq.sendRequest("/webApi/login.do",data,callBack,nil,1)
    --print(data)
    NetHttpReq.sendRequest("webApi/login.do",data,callBack,nil,1)
end

--appstore
function NetHttpReq.sendAppStoreOrder(strReceipt,orderData,callBack)
    local url = Config.api_domain.."/webApi/applePayment.do"
    local data = "receiptData="..strReceipt.."&appOrderId="..orderData.reqFee.."&gameOrderId="..orderData.tradeId
	NetHttpReq.HttpCallback["applePayment"] = callBack
	require("Network")
    NetHttpPost(url,data,"applePayment")
end

--向服务端发送脚本错误信息
function NetHttpReq.sendErrorLog(errorLog)
    local playerId = DataManager.getUserPlayerId()
    local timeStamp = os.time()*1000
    local phoneModel = ConfigManager.getPhoneModel()
	local version = ConfigManager.getGameVersion()
	local errStr = "log="..Json.Encode({playerId=playerId,timeStamp=timeStamp,phoneModel=phoneModel,errorLog=errorLog,version=version})
	NetHttpPost(Config.api_error_log,errStr,NetHttpReq.TAG_sendErrorLog)
end

--获取服务器列表
function NetHttpReq.getServerList(localVersion,partnerId,qn,fr,mac,callBack)
    local data = "partnerId="..partnerId.."&qn="..qn.."&fr="..fr.."&mac="..mac.."&version="..localVersion
    NetHttpReq.sendRequest("/webApi/getServerList.do",data,callBack,nil,1)
end

--登录游戏
function NetHttpReq.login(token,serverId,localVersion,partnerId,qn,fr,mac,mobile,callBack)
    local timestamp = "123456"
    local data = "token="..token.."&serverId="..serverId.."&partnerId="..partnerId.."&qn="..string.gsub(qn, " ", "-").."&fr="..fr.."&idfa="..fr.."&mac="..mac.."&version="..localVersion.."&ua="..string.gsub(mobile, " ", "-").."&timestamp="..timestamp
    data = data.."&sign=bbsc"
    cclog(data)
    NetHttpReq.sendRequest("/webApi/login.do",data,callBack,nil,1)
end
