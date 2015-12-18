

UserAction_creatRes = {}

--创建角色接口
function UserAction_creatRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserAction_creatRes:init()
	
	self.actName = "UserAction_creat"
end

function UserAction_creatRes:getActName()
	return self.actName
end






function UserAction_creatRes:encode(outputStream)

end

function UserAction_creatRes:decode(inputStream)
	    local body = {}

	   return body
end