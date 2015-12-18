

User_midNightPushNotify = {}

--用户午夜推送信息
function User_midNightPushNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function User_midNightPushNotify:init()
	
	self.UserExploreInfoBO_userExploreInfoBO=nil --用户探索信息

	self.long_systemTime=0 --当前服务器时间

	self.actName = "User_midNightPush"
end

function User_midNightPushNotify:getActName()
	return self.actName
end

--用户探索信息
function User_midNightPushNotify:setUserExploreInfoBO_userExploreInfoBO(UserExploreInfoBO_userExploreInfoBO)
	self.UserExploreInfoBO_userExploreInfoBO = UserExploreInfoBO_userExploreInfoBO
end
--当前服务器时间
function User_midNightPushNotify:setLong_systemTime(long_systemTime)
	self.long_systemTime = long_systemTime
end





function User_midNightPushNotify:encode(outputStream)
		self.UserExploreInfoBO_userExploreInfoBO:encode(outputStream)

		outputStream:WriteLong(self.long_systemTime)


end

function User_midNightPushNotify:decode(inputStream)
	    local body = {}
        local userExploreInfoBOTemp = UserExploreInfoBO:New()
        body.userExploreInfoBO=userExploreInfoBOTemp:decode(inputStream)
		body.systemTime = inputStream:ReadLong()


	   return body
end