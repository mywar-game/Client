
--http响应分发
require("NetHttpRequestHelper")

NetHttpDataSaver = {}
--保存数据示例
function NetHttpDataSaver.NetHttpResponseHelper_save_xxx(data)
	
end

function NetHttpResponseHelper_get_onRecvMessage(code,tag,data)
    LayerManager.hideWaiting()
    if code==3000 then 
		ccloge("networkError") 
		return 
	end
	
    if not tag then 
		ccloge("NetHttpResponseHelper_get_onRecvMessage -> tag is nil") 
		return 
	end
	
    local callback = NetHttpReq.HttpCallback[tag]    
    if callback then
		--保存数据
		local func = NetHttpDataSaver[string.format("NetHttpResponseHelper_save_%s",tag)]
		if func then
			func(data)
		end
        callback(code,tag,data)
    else
        ccloge("NetHttpResponseHelper_get_onRecvMessage -> not handle response, tag="..tag)
    end
end