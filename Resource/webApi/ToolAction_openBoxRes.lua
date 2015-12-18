

ToolAction_openBoxRes = {}

--打开宝箱
function ToolAction_openBoxRes:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
	self:init()
    return o
end

function ToolAction_openBoxRes:init()
	
	self.CommonGoodsBeanBO_drop=nil --获得的物品

	self.list_toolList={} --消耗的道具

	self.actName = "ToolAction_openBox"
end

function ToolAction_openBoxRes:getActName()
	return self.actName
end

--获得的物品
function ToolAction_openBoxRes:setCommonGoodsBeanBO_drop(CommonGoodsBeanBO_drop)
	self.CommonGoodsBeanBO_drop = CommonGoodsBeanBO_drop
end
--消耗的道具
function ToolAction_openBoxRes:setList_toolList(list_toolList)
	self.list_toolList = list_toolList
end





function ToolAction_openBoxRes:encode(outputStream)
		self.CommonGoodsBeanBO_drop:encode(outputStream)

		
		self.list_toolList = self.list_toolList or {}
		local list_toolListsize = #self.list_toolList
		outputStream:WriteInt(list_toolListsize)
		for list_toolListi=1,list_toolListsize do
            self.list_toolList[list_toolListi]:encode(outputStream)
		end
end

function ToolAction_openBoxRes:decode(inputStream)
	    local body = {}
        local dropTemp = CommonGoodsBeanBO:New()
        body.drop=dropTemp:decode(inputStream)
		local toolListTemp = {}
		local toolListsize = inputStream:ReadInt()
		for toolListi=1,toolListsize do
            local entry = GoodsBeanBO:New()
            table.insert(toolListTemp,entry:decode(inputStream))

		end
		body.toolList = toolListTemp

	   return body
end