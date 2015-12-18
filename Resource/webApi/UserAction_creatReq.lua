

UserAction_creatReq = {}

--创建角色接口
function UserAction_creatReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function UserAction_creatReq:init()
	
	self.int_roleId=0 --角色id

	self.string_roleName="" --角色名称

	self.actName = "UserAction_creat"
end

function UserAction_creatReq:getActName()
	return self.actName
end

--角色id
function UserAction_creatReq:setInt_roleId(int_roleId)
	self.int_roleId = int_roleId
end
--角色名称
function UserAction_creatReq:setString_roleName(string_roleName)
	self.string_roleName = string_roleName
end





function UserAction_creatReq:encode(outputStream)
		outputStream:WriteInt(self.int_roleId)

		outputStream:WriteUTFString(self.string_roleName)


end

function UserAction_creatReq:decode(inputStream)
	    local body = {}
		body.roleId = inputStream:ReadInt()

		body.roleName = inputStream:ReadUTFString()


	   return body
end