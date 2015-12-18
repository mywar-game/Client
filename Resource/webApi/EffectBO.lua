

EffectBO = {}

--技能效果对象
function EffectBO:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function EffectBO:init()
	
	self.list_attactList={} --用户攻击信息列表

	self.string_buff="" --效果buff

	self.actName = "EffectBO"
end

function EffectBO:getActName()
	return self.actName
end

--用户攻击信息列表
function EffectBO:setList_attactList(list_attactList)
	self.list_attactList = list_attactList
end
--效果buff
function EffectBO:setString_buff(string_buff)
	self.string_buff = string_buff
end





function EffectBO:encode(outputStream)
		
		self.list_attactList = self.list_attactList or {}
		local list_attactListsize = #self.list_attactList
		outputStream:WriteInt(list_attactListsize)
		for list_attactListi=1,list_attactListsize do
            self.list_attactList[list_attactListi]:encode(outputStream)
		end		outputStream:WriteUTFString(self.string_buff)


end

function EffectBO:decode(inputStream)
	    local body = {}
		local attactListTemp = {}
		local attactListsize = inputStream:ReadInt()
		for attactListi=1,attactListsize do
            local entry = UserAttactBossInfoBO:New()
            table.insert(attactListTemp,entry:decode(inputStream))

		end
		body.attactList = attactListTemp
		body.buff = inputStream:ReadUTFString()


	   return body
end