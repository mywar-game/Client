

SceneAction_changeLineRes = {}

--换线
function SceneAction_changeLineRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function SceneAction_changeLineRes:init()
	
	self.int_userLineNum=0 --（从0开始计数即0为1线1为2线）

	self.list_sceneUsersList={} --场景内的用户数据对象列表

	self.actName = "SceneAction_changeLine"
end

function SceneAction_changeLineRes:getActName()
	return self.actName
end

--（从0开始计数即0为1线1为2线）
function SceneAction_changeLineRes:setInt_userLineNum(int_userLineNum)
	self.int_userLineNum = int_userLineNum
end
--场景内的用户数据对象列表
function SceneAction_changeLineRes:setList_sceneUsersList(list_sceneUsersList)
	self.list_sceneUsersList = list_sceneUsersList
end





function SceneAction_changeLineRes:encode(outputStream)
		outputStream:WriteInt(self.int_userLineNum)

		
		self.list_sceneUsersList = self.list_sceneUsersList or {}
		local list_sceneUsersListsize = #self.list_sceneUsersList
		outputStream:WriteInt(list_sceneUsersListsize)
		for list_sceneUsersListi=1,list_sceneUsersListsize do
            self.list_sceneUsersList[list_sceneUsersListi]:encode(outputStream)
		end
end

function SceneAction_changeLineRes:decode(inputStream)
	    local body = {}
		body.userLineNum = inputStream:ReadInt()

		local sceneUsersListTemp = {}
		local sceneUsersListsize = inputStream:ReadInt()
		for sceneUsersListi=1,sceneUsersListsize do
            local entry = UserSceneDataBO:New()
            table.insert(sceneUsersListTemp,entry:decode(inputStream))

		end
		body.sceneUsersList = sceneUsersListTemp

	   return body
end