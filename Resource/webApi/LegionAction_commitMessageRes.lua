

LegionAction_commitMessageRes = {}

--提交留言信息
function LegionAction_commitMessageRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionAction_commitMessageRes:init()
	
	self.UserMessageInfoBO_userMessageInfoBO=nil --用户留言信息

	self.actName = "LegionAction_commitMessage"
end

function LegionAction_commitMessageRes:getActName()
	return self.actName
end

--用户留言信息
function LegionAction_commitMessageRes:setUserMessageInfoBO_userMessageInfoBO(UserMessageInfoBO_userMessageInfoBO)
	self.UserMessageInfoBO_userMessageInfoBO = UserMessageInfoBO_userMessageInfoBO
end





function LegionAction_commitMessageRes:encode(outputStream)
		self.UserMessageInfoBO_userMessageInfoBO:encode(outputStream)


end

function LegionAction_commitMessageRes:decode(inputStream)
	    local body = {}
        local userMessageInfoBOTemp = UserMessageInfoBO:New()
        body.userMessageInfoBO=userMessageInfoBOTemp:decode(inputStream)

	   return body
end