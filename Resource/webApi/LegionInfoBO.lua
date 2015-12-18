

LegionInfoBO = {}

--军团信息对象
function LegionInfoBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function LegionInfoBO:init()
	
	self.string_legionId="" --军团id

	self.int_exp=0 --军团经验

	self.int_level=0 --军团等级

	self.string_legionName="" --军团名称

	self.int_power=0 --军团战斗力

	self.string_notice="" --军团公告

	self.string_declaration="" --军团宣言

	self.string_legionLeaderName="" --军团长姓名

	self.int_maxNum=0 --最大人数

	self.int_currentNum=0 --当前军团人数

	self.actName = "LegionInfoBO"
end

function LegionInfoBO:getActName()
	return self.actName
end

--军团id
function LegionInfoBO:setString_legionId(string_legionId)
	self.string_legionId = string_legionId
end
--军团经验
function LegionInfoBO:setInt_exp(int_exp)
	self.int_exp = int_exp
end
--军团等级
function LegionInfoBO:setInt_level(int_level)
	self.int_level = int_level
end
--军团名称
function LegionInfoBO:setString_legionName(string_legionName)
	self.string_legionName = string_legionName
end
--军团战斗力
function LegionInfoBO:setInt_power(int_power)
	self.int_power = int_power
end
--军团公告
function LegionInfoBO:setString_notice(string_notice)
	self.string_notice = string_notice
end
--军团宣言
function LegionInfoBO:setString_declaration(string_declaration)
	self.string_declaration = string_declaration
end
--军团长姓名
function LegionInfoBO:setString_legionLeaderName(string_legionLeaderName)
	self.string_legionLeaderName = string_legionLeaderName
end
--最大人数
function LegionInfoBO:setInt_maxNum(int_maxNum)
	self.int_maxNum = int_maxNum
end
--当前军团人数
function LegionInfoBO:setInt_currentNum(int_currentNum)
	self.int_currentNum = int_currentNum
end





function LegionInfoBO:encode(outputStream)
		outputStream:WriteUTFString(self.string_legionId)

		outputStream:WriteInt(self.int_exp)

		outputStream:WriteInt(self.int_level)

		outputStream:WriteUTFString(self.string_legionName)

		outputStream:WriteInt(self.int_power)

		outputStream:WriteUTFString(self.string_notice)

		outputStream:WriteUTFString(self.string_declaration)

		outputStream:WriteUTFString(self.string_legionLeaderName)

		outputStream:WriteInt(self.int_maxNum)

		outputStream:WriteInt(self.int_currentNum)


end

function LegionInfoBO:decode(inputStream)
	    local body = {}
		body.legionId = inputStream:ReadUTFString()

		body.exp = inputStream:ReadInt()

		body.level = inputStream:ReadInt()

		body.legionName = inputStream:ReadUTFString()

		body.power = inputStream:ReadInt()

		body.notice = inputStream:ReadUTFString()

		body.declaration = inputStream:ReadUTFString()

		body.legionLeaderName = inputStream:ReadUTFString()

		body.maxNum = inputStream:ReadInt()

		body.currentNum = inputStream:ReadInt()


	   return body
end