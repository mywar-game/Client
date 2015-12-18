

ToolAction_openBoxReq = {}

--打开宝箱
function ToolAction_openBoxReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ToolAction_openBoxReq:init()
	
	self.int_toolId=0 --宝箱id

	self.actName = "ToolAction_openBox"
end

function ToolAction_openBoxReq:getActName()
	return self.actName
end

--宝箱id
function ToolAction_openBoxReq:setInt_toolId(int_toolId)
	self.int_toolId = int_toolId
end





function ToolAction_openBoxReq:encode(outputStream)
		outputStream:WriteInt(self.int_toolId)


end

function ToolAction_openBoxReq:decode(inputStream)
	    local body = {}
		body.toolId = inputStream:ReadInt()


	   return body
end