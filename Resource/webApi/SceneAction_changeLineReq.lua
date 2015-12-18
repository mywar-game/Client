

SceneAction_changeLineReq = {}

--换线
function SceneAction_changeLineReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function SceneAction_changeLineReq:init()
	
	self.int_sceneId=0 --场景id

	self.int_targetLineNum=0 --目标线编号（从0开始计数即0为1线1为2线）

	self.actName = "SceneAction_changeLine"
end

function SceneAction_changeLineReq:getActName()
	return self.actName
end

--场景id
function SceneAction_changeLineReq:setInt_sceneId(int_sceneId)
	self.int_sceneId = int_sceneId
end
--目标线编号（从0开始计数即0为1线1为2线）
function SceneAction_changeLineReq:setInt_targetLineNum(int_targetLineNum)
	self.int_targetLineNum = int_targetLineNum
end





function SceneAction_changeLineReq:encode(outputStream)
		outputStream:WriteInt(self.int_sceneId)

		outputStream:WriteInt(self.int_targetLineNum)


end

function SceneAction_changeLineReq:decode(inputStream)
	    local body = {}
		body.sceneId = inputStream:ReadInt()

		body.targetLineNum = inputStream:ReadInt()


	   return body
end