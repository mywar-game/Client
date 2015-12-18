

SceneAction_enterRes = {}

--进入场景
function SceneAction_enterRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function SceneAction_enterRes:init()
	
	self.int_userLineNum=0 --给用户分配的线数（从0开始计数即0为1线1为2线）

	self.int_sceneLineNum=0 --场景的线条数

	self.actName = "SceneAction_enter"
end

function SceneAction_enterRes:getActName()
	return self.actName
end

--给用户分配的线数（从0开始计数即0为1线1为2线）
function SceneAction_enterRes:setInt_userLineNum(int_userLineNum)
	self.int_userLineNum = int_userLineNum
end
--场景的线条数
function SceneAction_enterRes:setInt_sceneLineNum(int_sceneLineNum)
	self.int_sceneLineNum = int_sceneLineNum
end





function SceneAction_enterRes:encode(outputStream)
		outputStream:WriteInt(self.int_userLineNum)

		outputStream:WriteInt(self.int_sceneLineNum)


end

function SceneAction_enterRes:decode(inputStream)
	    local body = {}
		body.userLineNum = inputStream:ReadInt()

		body.sceneLineNum = inputStream:ReadInt()


	   return body
end