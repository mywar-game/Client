

LifeAction_getUserLifeInfoRes = {}

--获取用户生活技能信息
function LifeAction_getUserLifeInfoRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LifeAction_getUserLifeInfoRes:init()
	
	self.list_userLifeInfoBOList={} --用户生活信息对象列表

	self.actName = "LifeAction_getUserLifeInfo"
end

function LifeAction_getUserLifeInfoRes:getActName()
	return self.actName
end

--用户生活信息对象列表
function LifeAction_getUserLifeInfoRes:setList_userLifeInfoBOList(list_userLifeInfoBOList)
	self.list_userLifeInfoBOList = list_userLifeInfoBOList
end





function LifeAction_getUserLifeInfoRes:encode(outputStream)
		
		self.list_userLifeInfoBOList = self.list_userLifeInfoBOList or {}
		local list_userLifeInfoBOListsize = #self.list_userLifeInfoBOList
		outputStream:WriteInt(list_userLifeInfoBOListsize)
		for list_userLifeInfoBOListi=1,list_userLifeInfoBOListsize do
            self.list_userLifeInfoBOList[list_userLifeInfoBOListi]:encode(outputStream)
		end
end

function LifeAction_getUserLifeInfoRes:decode(inputStream)
	    local body = {}
		local userLifeInfoBOListTemp = {}
		local userLifeInfoBOListsize = inputStream:ReadInt()
		for userLifeInfoBOListi=1,userLifeInfoBOListsize do
            local entry = UserLifeInfoBO:New()
            table.insert(userLifeInfoBOListTemp,entry:decode(inputStream))

		end
		body.userLifeInfoBOList = userLifeInfoBOListTemp

	   return body
end