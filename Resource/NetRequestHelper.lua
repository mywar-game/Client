--网络请求方法包装

function NetReqLua(actCls,isWait)
	local actName = actCls:getActName()
	local opHead = OutputStream:new()
	opHead:WriteInt(1)   --长度
	opHead:WriteInt(0)   --错误码
	opHead:WriteShort(0) --来源类型
	opHead:WriteUTFString("0") --来源id
	opHead:WriteShort(0) --目的类型
	opHead:WriteUTFString("0") --目的id
	opHead:WriteShort(1) --消息类型 1 请求消息 2响应消息 3广播消息
	opHead:WriteInt(0) --消息序列号
	opHead:WriteUTFString(actName) --消息接口名称
	opHead:WriteUTFString("0") --用户序列号	
	opHead:WriteBYTE(0) --用户序列号	
	local opBody = OutputStream:new()
	actCls:encode(opBody)
    NetReqRaw(opHead,opBody)
	opBody:delete()
	opHead:delete()
	
	if isWait == true then
		LayerManager.showWaiting()
	end
end