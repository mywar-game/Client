

LegionAction_cancleApplyReq = {}

--取消申请
function LegionAction_cancleApplyReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_cancleApplyReq:init()
	
	self.string_legionId="" --公会id

	self.actName = "LegionAction_cancleApply"
end

function LegionAction_cancleApplyReq:getActName()
	return self.actName
end

--公会id
function LegionAction_cancleApplyReq:setString_legionId(string_legionId)
	self.string_legionId = string_legionId
end





function LegionAction_cancleApplyReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_legionId)


end

function LegionAction_cancleApplyReq:decode(inputStream)
	    local body = {}
		body.legionId = inputStream:ReadUTFString()


	   return body
end