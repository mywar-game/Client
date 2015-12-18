

GemstoneAction_gemstoneResolveReq = {}

--宝石分解
function GemstoneAction_gemstoneResolveReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function GemstoneAction_gemstoneResolveReq:init()
	
	self.list_userGemstoneIdList={} --用户宝石id列表

	self.int_status=0 --状态：1开始2取消3完成

	self.actName = "GemstoneAction_gemstoneResolve"
end

function GemstoneAction_gemstoneResolveReq:getActName()
	return self.actName
end

--用户宝石id列表
function GemstoneAction_gemstoneResolveReq:setList_userGemstoneIdList(list_userGemstoneIdList)
	self.list_userGemstoneIdList = list_userGemstoneIdList
end
--状态：1开始2取消3完成
function GemstoneAction_gemstoneResolveReq:setInt_status(int_status)
	self.int_status = int_status
end





function GemstoneAction_gemstoneResolveReq:encode(outputStream)
		
		self.list_userGemstoneIdList = self.list_userGemstoneIdList or {}
		local list_userGemstoneIdListsize = #self.list_userGemstoneIdList
		outputStream:WriteInt(list_userGemstoneIdListsize)
		for list_userGemstoneIdListi=1,list_userGemstoneIdListsize do
            outputStream:WriteUTFString(self.list_userGemstoneIdList[list_userGemstoneIdListi])
		end		outputStream:WriteInt(self.int_status)


end

function GemstoneAction_gemstoneResolveReq:decode(inputStream)
	    local body = {}
		local userGemstoneIdListTemp = {}
		local userGemstoneIdListsize = inputStream:ReadInt()
		for userGemstoneIdListi=1,userGemstoneIdListsize do
            table.insert(userGemstoneIdListTemp,inputStream:ReadUTFString())
		end
		body.userGemstoneIdList = userGemstoneIdListTemp
		body.status = inputStream:ReadInt()


	   return body
end