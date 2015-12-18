

User_pushUserPropertiesNotify = {}

--刷新用户属性值
function User_pushUserPropertiesNotify:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function User_pushUserPropertiesNotify:init()
	
	self.list_userPropertiesList={} --需要刷新的属性列表

	self.actName = "User_pushUserProperties"
end

function User_pushUserPropertiesNotify:getActName()
	return self.actName
end

--需要刷新的属性列表
function User_pushUserPropertiesNotify:setList_userPropertiesList(list_userPropertiesList)
	self.list_userPropertiesList = list_userPropertiesList
end





function User_pushUserPropertiesNotify:encode(outputStream)
		
		self.list_userPropertiesList = self.list_userPropertiesList or {}
		local list_userPropertiesListsize = #self.list_userPropertiesList
		outputStream:WriteInt(list_userPropertiesListsize)
		for list_userPropertiesListi=1,list_userPropertiesListsize do
            self.list_userPropertiesList[list_userPropertiesListi]:encode(outputStream)
		end
end

function User_pushUserPropertiesNotify:decode(inputStream)
	    local body = {}
		local userPropertiesListTemp = {}
		local userPropertiesListsize = inputStream:ReadInt()
		for userPropertiesListi=1,userPropertiesListsize do
            local entry = UserPropertiesBO:New()
            table.insert(userPropertiesListTemp,entry:decode(inputStream))

		end
		body.userPropertiesList = userPropertiesListTemp

	   return body
end