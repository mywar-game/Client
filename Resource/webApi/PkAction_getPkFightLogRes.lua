

PkAction_getPkFightLogRes = {}

--查看战斗日志
function PkAction_getPkFightLogRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function PkAction_getPkFightLogRes:init()
	
	self.list_logList={} --战斗日志列表

	self.actName = "PkAction_getPkFightLog"
end

function PkAction_getPkFightLogRes:getActName()
	return self.actName
end

--战斗日志列表
function PkAction_getPkFightLogRes:setList_logList(list_logList)
	self.list_logList = list_logList
end





function PkAction_getPkFightLogRes:encode(outputStream)
		
		self.list_logList = self.list_logList or {}
		local list_logListsize = #self.list_logList
		outputStream:WriteInt(list_logListsize)
		for list_logListi=1,list_logListsize do
            self.list_logList[list_logListi]:encode(outputStream)
		end
end

function PkAction_getPkFightLogRes:decode(inputStream)
	    local body = {}
		local logListTemp = {}
		local logListsize = inputStream:ReadInt()
		for logListi=1,logListsize do
            local entry = PkFightLogBO:New()
            table.insert(logListTemp,entry:decode(inputStream))

		end
		body.logList = logListTemp

	   return body
end