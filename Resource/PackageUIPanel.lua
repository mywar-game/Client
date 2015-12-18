PackageUIPanel = {
panel = nil,
}
function PackageUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

function PackageUIPanel:Create(para)
    local p_name = "PackageUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	local nowMaxNum = 0
    local packageSize = 20
	local allPackageSize = 80
	local cacheSelectMenu = 1
	local cacheSelectPackage = 1
	local config = DataManager.getSystemConfig()
	local lastEquip
	local lastTool
	local lastStone
	
	local x = para.x or 300
	local y = para.y or 0
	panel.layer:setPosition(cc.p(x,y))
	
	--对道具做整理 超出限制的将分为多个格子显示
	local function showUserToolList()
		local showToolList = {}
		local userToolList = DataManager.getUserToolList()

		for k,v in pairs(userToolList) do
			local nowToolNum = v.toolNum
			while true do
				local showTool = DeepCopy(v)
				if nowToolNum > v.overlapMax then
					showTool.toolNum = v.overlapMax
					nowToolNum = nowToolNum - v.overlapMax
					table.insert(showToolList, showTool)
				else
					showTool.toolNum = nowToolNum
					table.insert(showToolList, showTool)
					break
				end
			end
		end
		return showToolList
	end
	
	local function getPageckeToolList()
		local tempTool = {}
		local function insertTools(toolList)
			for k=1,#toolList do
				table.insert(tempTool,toolList[k])
			end
		end
		
		if cacheSelectMenu ~= 3 then --不等于道具
			insertTools(DataManager.getUserPackageEquipList())
		end
		
		if cacheSelectMenu ~= 2 then --不等于武器
			insertTools(showUserToolList())
			insertTools(DataManager.getCanMosaicGemstoneList())
		end
		
		local sortTool = {}
		local sIdx = (cacheSelectPackage-1)*packageSize
		local eIdx = cacheSelectPackage*packageSize
		for k=sIdx+1,eIdx do
			table.insert(sortTool,{index=k,tool=tempTool[k]})
		end
		
		return sortTool,#tempTool
	end
	
	local function useTool(data)
		if data.type == GameField.chest then--使用宝箱
			local openBoxReq = ToolAction_openBoxReq:New()
			openBoxReq:setInt_toolId(data.toolId)
			NetReqLua(openBoxReq,true)
		end
		if data.toolId == GameField.VanHorn then
			LayerManager.show("MarqueeSenderUIPanel")
		end
	end
	
	--检查是否丢弃
	local function checkContain(touchPos)
        local areaSprite = self.panel:getChildByName("img_discard")
        local location = areaSprite:convertToNodeSpace(touchPos)
        local s = areaSprite:getContentSize()
        local rect = cc.rect(0,0,s.width,s.height)
        if cc.rectContainsPoint(rect,location) then
            return true
        end
        return false
    end
	
	--删除物品警告回调
	local function callBackFun(args)
		local data = args.data
        local req = PackAction_abandonToolReq:New()
        req:setInt_toolType(data.type)
        req:setInt_toolId(data.toolId)
		req:setInt_toolNum(data.toolNum or 1)
		if data.userEquipId then req:setString_userEquipId(data.userEquipId) end
		if data.userGemstoneId then req:setString_userGemstoneId(data.userGemstoneId) end
        NetReqLua(req, true)
	end
	
	--丢弃物品警告框回调
	local function showDialog(args)
		LayerManager.showDialog(LabelChineseStr.PackageUIPanelDialogTitle_1,callBackFun, args)
	end

	local function equipAndToolTouchCallBack(para)
		if para.type == GameField.Event_Back then
		    self:Release()
        elseif para.type == GameField.Event_Move then--处理拖动
            if not cacheMoveSprite then
                cacheMoveSprite = IconUtil.GetIconByIdType(para.data.type,para.data.equipId or para.data.toolId or para.data.gemstoneId, nil)
                self.panel.layer:addChild(cacheMoveSprite,0xffff)
            end
            cacheMoveSprite:setPosition(self.panel.layer:convertToNodeSpace(para.touchPos))
            para.sprite:setVisible(false)
        elseif para.type == GameField.Event_End then--处理按下起立
            if cacheMoveSprite then
				if checkContain(para.touchPos) then
					showDialog({data = para.data})
				end
                cacheMoveSprite:removeFromParent()
                para.sprite:setVisible(true)
                cacheMoveSprite = nil
            end
		end
	end
	
	local function isLastGet(data)
		if data.type == GameField.equip then
			for k, v in pairs(lastEquip) do
				if v.userEquipId == data.userEquipId then
					return true
				end
			end
		elseif data.type == GameField.tool then
			for k, v in pairs(lastTool) do
				if v.toolId == data.toolId then
					return true
				end
			end
		elseif data.type == GameField.gemstone then
			for k, v in pairs(lastStone) do
				if v.userGemstoneId == data.userGemstoneId then
					return true
				end
			end
		end
		return false
	end

	local function OnItemShowCallback(scroll_view,item,data,idx)
		local tool = data.tool
		if tool then
			local iconSprite
			local size = item:getContentSize()
			local function iconTouchEvent(type,touchPos)
				if not para.disEnable then
					equipAndToolTouchCallBack({type=type,touchPos=touchPos,data=tool,sprite=iconSprite})
				end
				if tool.type == GameField.equip then--装备
					if para.equipTouchCallBack then 
						para.equipTouchCallBack({type=type,touchPos=touchPos,data=tool,sprite=iconSprite}) 
					end
				else--道具
					if para.toolTouchCallBack then
						para.toolTouchCallBack({type=type,touchPos=touchPos,data=tool,sprite=iconSprite})
					else
						if type == GameField.Event_DoubleClick then
							useTool(tool)
						end
					end
				end
			end
			iconSprite = IconUtil.GetIconByIdType(tool.type,tool.toolId,tool.toolNum,{data=tool,touchCallBack=iconTouchEvent})
			iconSprite:setPosition(cc.p(size.width/2,size.height/2))
			item:addChild(iconSprite,1000)			
			if isLastGet(tool) then
				local skeleton = CreateEffectSkeleton("t17")
				local size = iconSprite:getContentSize()
				skeleton:setPosition(cc.p(size.width/2,size.height/2))
				iconSprite:addChild(skeleton,10)
			end
		end
		
		local num = (cacheSelectPackage-1)*packageSize + idx
		if num <= nowMaxNum then
			self.panel:setItemNodeVisible(item,"img_clock",false)
		else
			if 1 ~= cacheSelectMenu then
				item:setVisible(false)
			end
		end
	end
	
	local function OnItemClickCallback(item,data,idx)
		--打开格子数量
		local num = (cacheSelectPackage-1)*packageSize + idx - nowMaxNum
		if data.tool == nil and num > 0 then
			--local temp = nowMaxNum - config.pack_init_num + num
			local temp = (nowMaxNum - 20) * num + (num * num + num) * 0.5			--等差求和(X+1,  X+2, .. X+num)  X 为 （nowMaxNum-20）
			local str1 = LabelChineseStr.PackageUIPanel_1
			local str2 = LabelChineseStr.PackageUIPanel_2
			local str3 = LabelChineseStr.common_zuanshi
			local str4 = str1..str2..(10*temp)..str3
			local function extendPackNet()
				local extendPackReq = PackAction_extendPackReq:New()
				extendPackReq:setInt_extendNum(num)
				NetReqLua(extendPackReq,true)
			end
			LayerManager.showDialog(str4,extendPackNet)
		end
	end
	
	local function refreshEquipToolInfo()
		lastEquip, lastTool, lastStone = DataManager.getLastGetGoods()
		
		local userInfo = DataManager.getUserBO()
		local data,num
		if nil ~= para.getPageckeToolList then
			data,num = para.getPageckeToolList(cacheSelectPackage, packageSize)
		else
			data,num = getPageckeToolList()
		end
		local selectSprite = self.panel:getChildByName("img_package_select")
		local packagetBtn = self.panel:getChildByName("btn_package_"..cacheSelectPackage)
		selectSprite:setPosition(packagetBtn:getPosition())
		for i = 1, 4 do
			self.panel:setBtnEnabled("btn_package_" .. i, true)
		end
		if cacheSelectMenu == 1 then
			nowMaxNum = config.pack_init_num + userInfo.packExtendTimes	--当前可放置的物品个格子
		else
			nowMaxNum = num												--如果不是“总览” 当前可放置的物品格子数 就是物品的格子数

			local maxPackge = math.ceil(nowMaxNum / 20.0)
			for i = maxPackge, 4 do
				local k = i + 1
				self.panel:setBtnEnabled("btn_package_" .. k, false)
			end
		end
	
		self.panel:setBitmapText("lab_money",userInfo.money)
		self.panel:setBitmapText("lab_gold",userInfo.gold)
		
		self.panel:setBtnEnabled("btn_all",cacheSelectMenu ~= 1)
		self.panel:setBtnEnabled("btn_equip",cacheSelectMenu ~= 2)
		self.panel:setBtnEnabled("btn_mateil",cacheSelectMenu ~= 3)
		self.panel:InitListView(data,OnItemShowCallback,OnItemClickCallback,"ListView","ListItem",4)
	end
	refreshEquipToolInfo()
	
	--删除物品
	function PackageUIPanel_PackAction_abandonTool(msgObj)
		Tips(LabelChineseStr.PackageUIPanelTips_1)
		if GameField.tool == msgObj.body.toolType then
				DataManager.reduceUserTool(msgObj.body.toolId, msgObj.body.toolNum)
		elseif GameField.equip == msgObj.body.toolType then
			DataManager.removeUserEquip(msgObj.body.userEquipId)
		elseif GameField.gemstone == msgObj.body.toolType then
			DataManager.removeGemstoneId(msgObj.body.userGemstoneId)
		end
		refreshEquipToolInfo()
	end
	
	function PackageUIPanel_ToolAction_openBox(msgObj)
		refreshEquipToolInfo()
	end	
	
	function PackageUIPanel_PackAction_extendPack()
		refreshEquipToolInfo()
	end
	
	local function btnMenuCallBack(sender,tag)
		if tag <= 3 then
			cacheSelectMenu = tag
			cacheSelectPackage = 1
			refreshEquipToolInfo()
		elseif tag <= 7 then
			cacheSelectPackage = tag - 3
			refreshEquipToolInfo()
		end
	end
	
	self.panel:addNodeTouchEventListener("btn_all",btnMenuCallBack,1)
	self.panel:addNodeTouchEventListener("btn_equip",btnMenuCallBack,2)
	self.panel:addNodeTouchEventListener("btn_mateil",btnMenuCallBack,3)
	self.panel:addNodeTouchEventListener("btn_package_1",btnMenuCallBack,4)
	self.panel:addNodeTouchEventListener("btn_package_2",btnMenuCallBack,5)
	self.panel:addNodeTouchEventListener("btn_package_3",btnMenuCallBack,6)
	self.panel:addNodeTouchEventListener("btn_package_4",btnMenuCallBack,7)

	function PackageUIPanel:reFreshPackage()
		refreshEquipToolInfo()
	end
	
    return panel
end

--退出
function PackageUIPanel:Release()
	DataManager.clearLastGetGoods()
	self.panel:Release()
end

--隐藏
function PackageUIPanel:Hide()
	self.panel:Hide()
end

--显示
function PackageUIPanel:Show()
	self.panel:Show()
end