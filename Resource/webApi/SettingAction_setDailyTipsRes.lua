

SettingAction_setDailyTipsRes = {}

--设置用户每日提示
function SettingAction_setDailyTipsRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function SettingAction_setDailyTipsRes:init()
	
	self.actName = "SettingAction_setDailyTips"
end

function SettingAction_setDailyTipsRes:getActName()
	return self.actName
end






function SettingAction_setDailyTipsRes:encode(outputStream)

end

function SettingAction_setDailyTipsRes:decode(inputStream)
	    local body = {}

	   return body
end