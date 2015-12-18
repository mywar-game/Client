

MessageAction_sendMsgRes = {}

--发送跑马灯
function MessageAction_sendMsgRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MessageAction_sendMsgRes:init()
	
	self.GoodsBeanBO_goodsBeanBO=nil --消耗的道具

	self.actName = "MessageAction_sendMsg"
end

function MessageAction_sendMsgRes:getActName()
	return self.actName
end

--消耗的道具
function MessageAction_sendMsgRes:setGoodsBeanBO_goodsBeanBO(GoodsBeanBO_goodsBeanBO)
	self.GoodsBeanBO_goodsBeanBO = GoodsBeanBO_goodsBeanBO
end





function MessageAction_sendMsgRes:encode(outputStream)
		self.GoodsBeanBO_goodsBeanBO:encode(outputStream)


end

function MessageAction_sendMsgRes:decode(inputStream)
	    local body = {}
        local goodsBeanBOTemp = GoodsBeanBO:New()
        body.goodsBeanBO=goodsBeanBOTemp:decode(inputStream)

	   return body
end