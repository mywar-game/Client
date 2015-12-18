

GemstoneAction_gemstoneUpgradeReq = {}

--宝石精炼升级
function GemstoneAction_gemstoneUpgradeReq:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function GemstoneAction_gemstoneUpgradeReq:init()
	
	self.string_userGemstoneId="" --用户宝石id

	self.int_status=0 --状态：1开始2取消3完成

	self.actName = "GemstoneAction_gemstoneUpgrade"
end

function GemstoneAction_gemstoneUpgradeReq:getActName()
	return self.actName
end

--用户宝石id
function GemstoneAction_gemstoneUpgradeReq:setString_userGemstoneId(string_userGemstoneId)
	self.string_userGemstoneId = string_userGemstoneId
end
--状态：1开始2取消3完成
function GemstoneAction_gemstoneUpgradeReq:setInt_status(int_status)
	self.int_status = int_status
end





function GemstoneAction_gemstoneUpgradeReq:encode(outputStream)
		outputStream:WriteUTFString(self.string_userGemstoneId)

		outputStream:WriteInt(self.int_status)


end

function GemstoneAction_gemstoneUpgradeReq:decode(inputStream)
	    local body = {}
		body.userGemstoneId = inputStream:ReadUTFString()

		body.status = inputStream:ReadInt()


	   return body
end