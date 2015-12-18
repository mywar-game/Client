

ForcesAction_getCopyForcesInfoRes = {}

--获取用户副本关卡信息列表
function ForcesAction_getCopyForcesInfoRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ForcesAction_getCopyForcesInfoRes:init()
	
	self.list_userForcesList={} --用户副本关卡信息列表

	self.actName = "ForcesAction_getCopyForcesInfo"
end

function ForcesAction_getCopyForcesInfoRes:getActName()
	return self.actName
end

--用户副本关卡信息列表
function ForcesAction_getCopyForcesInfoRes:setList_userForcesList(list_userForcesList)
	self.list_userForcesList = list_userForcesList
end





function ForcesAction_getCopyForcesInfoRes:encode(outputStream)
		
		self.list_userForcesList = self.list_userForcesList or {}
		local list_userForcesListsize = #self.list_userForcesList
		outputStream:WriteInt(list_userForcesListsize)
		for list_userForcesListi=1,list_userForcesListsize do
            self.list_userForcesList[list_userForcesListi]:encode(outputStream)
		end
end

function ForcesAction_getCopyForcesInfoRes:decode(inputStream)
	    local body = {}
		local userForcesListTemp = {}
		local userForcesListsize = inputStream:ReadInt()
		for userForcesListi=1,userForcesListsize do
            local entry = UserForcesBO:New()
            table.insert(userForcesListTemp,entry:decode(inputStream))

		end
		body.userForcesList = userForcesListTemp

	   return body
end