

MailAction_oneClickReceiveRes = {}

--一键领取邮件附件
function MailAction_oneClickReceiveRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MailAction_oneClickReceiveRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --通用奖励对象

	self.actName = "MailAction_oneClickReceive"
end

function MailAction_oneClickReceiveRes:getActName()
	return self.actName
end

--通用奖励对象
function MailAction_oneClickReceiveRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end





function MailAction_oneClickReceiveRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)


end

function MailAction_oneClickReceiveRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)

	   return body
end