

SettingAction_commitAdviceRes = {}

--提交建议
function SettingAction_commitAdviceRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function SettingAction_commitAdviceRes:init()
	
	self.actName = "SettingAction_commitAdvice"
end

function SettingAction_commitAdviceRes:getActName()
	return self.actName
end






function SettingAction_commitAdviceRes:encode(outputStream)

end

function SettingAction_commitAdviceRes:decode(inputStream)
	    local body = {}

	   return body
end