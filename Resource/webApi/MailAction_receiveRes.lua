

MailAction_receiveRes = {}

--领取邮件附件
function MailAction_receiveRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function MailAction_receiveRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --通用奖励对象

	self.actName = "MailAction_receive"
end

function MailAction_receiveRes:getActName()
	return self.actName
end

--通用奖励对象
function MailAction_receiveRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end





function MailAction_receiveRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)


end

function MailAction_receiveRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)

	   return body
end