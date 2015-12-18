

SettingAction_setDailyTipsReq = {}

--设置用户每日提示
function SettingAction_setDailyTipsReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function SettingAction_setDailyTipsReq:init()
	
	self.int_tip=0 --提示编号

	self.actName = "SettingAction_setDailyTips"
end

function SettingAction_setDailyTipsReq:getActName()
	return self.actName
end

--提示编号
function SettingAction_setDailyTipsReq:setInt_tip(int_tip)
	self.int_tip = int_tip
end





function SettingAction_setDailyTipsReq:encode(outputStream)
		outputStream:WriteInt(self.int_tip)


end

function SettingAction_setDailyTipsReq:decode(inputStream)
	    local body = {}
		body.tip = inputStream:ReadInt()


	   return body
end