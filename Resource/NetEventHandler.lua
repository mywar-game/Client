require("LayerManager")
require("LabelChStr")

NetEventHandler = {
	isAutoConn = true --是否自动连接
}

--socket连接成功
function NetEventHandler.onSocketOpen()
	local tk = ConfigManager.getTk()
    local sid = ConfigManager.getSid()
    local uid = ConfigManager.getUid()
    local pid = ConfigManager.getPid()
	
	if tk then
		NetReqAct("User.login",{uid=uid,pid=pid,sid=sid,ut=0,tk=tk})
	else
		NetReqAct("User.login",nil,1)
	end
	NetEventHandler.isAutoConn = true
end

--从socket收到新消息
function NetEventHandler.onMessage(msg,len)
    NetResponseHelper_onRecvMessage(msg,len)
end

--socket重连成功
function NetEventHandler.onSocketReconnectSucc()
    --重连成功后，服务端会发送
    LayerManager.showWaiting(GameString.NetEventHandler_1)
    --发送重新登录请求
    NetEventHandler.onSocketOpen()
end

--socket重连失败
function NetEventHandler.onSocketReconnectFailed()
    function NetEventHandler_onSocketReconnectFailed(buttonOrder)
        if buttonOrder ==1 then--确定
            LayerManager.showWaiting(GameString.NetEventHandler_2)
			NetReconnect()
		end
    end
    LayerManager.showDialog(GameString.NetEventHandler_3,NetEventHandler_onSocketReconnectFailed)
end

--socket显示SDK
function NetEventHandler.onShowSdk()
    function NetEventHandler_onShowPPSdk(buttonOrder)
        if buttonOrder ==1 then--确定
            LayerManager.showWaiting(GameString.NetEventHandler_4)
			NetReconnect()
		end
    end
    LayerManager.showDialog(GameString.NetEventHandler_5,NetEventHandler_onShowPPSdk)
end

--服务器返回Error消息
function NetEventHandler.onErrorMsg(msg)
    LayerManager.showSysDialog(msg)
end

--socket创建异常
function NetEventHandler.onSocketError()
    LayerManager.showSysDialog(GameString.NetEventHandler_8..json.encode(msgObj or GameString.NetEventHandler_9))
end

--socket关闭
function NetEventHandler.onSocketClose()
    --网络断开后，自动重连
	if NetEventHandler.isAutoConn then
		NetReconnect()
		LayerManager.showWaiting(GameString.NetEventHandler_10)
	else
		LayerManager.showSysDialog(GameString.otherLogin)
	end
end

--socket手动关闭
function NetEventHandler.onSocketManuallyClose()
	NetReq.User_logout()
    NetReconnectClose()
	NetEventHandler.onShowSdk()
end