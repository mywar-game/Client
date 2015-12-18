

LegionAction_editNoticeReq = {}

--修改公告
function LegionAction_editNoticeReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_editNoticeReq:init()
	
	self.string_notice="" --公告内容

	self.actName = "LegionAction_editNotice"
end

function LegionAction_editNoticeReq:getActName()
	return self.actName
end

--公告内容
function LegionAction_editNoticeReq:setString_notice(string_notice)
	self.string_notice = string_notice
end





function LegionAction_editNoticeReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_notice)


end

function LegionAction_editNoticeReq:decode(inputStream)
	    local body = {}
		body.notice = inputStream:ReadUTFString()


	   return body
end