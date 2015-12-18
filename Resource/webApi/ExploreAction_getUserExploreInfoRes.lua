

ExploreAction_getUserExploreInfoRes = {}

--获取用户探索信息
function ExploreAction_getUserExploreInfoRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ExploreAction_getUserExploreInfoRes:init()
	
	self.UserExploreInfoBO_userExploreInfoBO=nil --用户探索信息

	self.actName = "ExploreAction_getUserExploreInfo"
end

function ExploreAction_getUserExploreInfoRes:getActName()
	return self.actName
end

--用户探索信息
function ExploreAction_getUserExploreInfoRes:setUserExploreInfoBO_userExploreInfoBO(UserExploreInfoBO_userExploreInfoBO)
	self.UserExploreInfoBO_userExploreInfoBO = UserExploreInfoBO_userExploreInfoBO
end





function ExploreAction_getUserExploreInfoRes:encode(outputStream)
		self.UserExploreInfoBO_userExploreInfoBO:encode(outputStream)


end

function ExploreAction_getUserExploreInfoRes:decode(inputStream)
	    local body = {}
        local userExploreInfoBOTemp = UserExploreInfoBO:New()
        body.userExploreInfoBO=userExploreInfoBOTemp:decode(inputStream)

	   return body
end