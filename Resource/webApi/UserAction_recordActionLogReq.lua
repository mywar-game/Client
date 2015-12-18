

UserAction_recordActionLogReq = {}

--记录打点日志
function UserAction_recordActionLogReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserAction_recordActionLogReq:init()
	
	self.int_actionId=0 --打点id

	self.string_ip="" --ip

	self.actName = "UserAction_recordActionLog"
end

function UserAction_recordActionLogReq:getActName()
	return self.actName
end

--打点id
function UserAction_recordActionLogReq:setInt_actionId(int_actionId)
	self.int_actionId = int_actionId
end
--ip
function UserAction_recordActionLogReq:setString_ip(string_ip)
	self.string_ip = string_ip
end





function UserAction_recordActionLogReq:encode(outputStream)
		outputStream:WriteInt(self.int_actionId)

		outputStream:WriteUTFString(self.string_ip)


end

function UserAction_recordActionLogReq:decode(inputStream)
	    local body = {}
		body.actionId = inputStream:ReadInt()

		body.ip = inputStream:ReadUTFString()


	   return body
end