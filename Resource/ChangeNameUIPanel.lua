ChangeNameUIPanel = 
{
	panel = nil,
}

function ChangeNameUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

--创建
function ChangeNameUIPanel:Create(para)
    local p_name = "ChangeNameUI"
	self.panel = Panel:New()
    self.panel:InitPanel(p_name)
	
	local randomName = DataManager.getRandomName()
	--local lab_Name = self.panel:getChildByName("lab_name")
	--lab_Name:setString(randomName)
	local parentNode = self.panel:getChildByName("img_tool")
	local size = parentNode:getContentSize()
	local iconSprite = IconUtil.GetIconByIdType(GameField.tool, GameField.changNameTool, nil ,{touchCallBack = nil})
	iconSprite:setPosition(cc.p(size.width/2 - 6,size.height/2 + 4))
	iconSprite:setScale(0.7)
	parentNode:addChild(iconSprite,1000)	
	
	local changeNameToolNum = DataManager.getUserToolNum(GameField.changNameTool) or 0
	self.panel:setLabelText("lab_toolnum", LabelChineseStr.ChangeNameUIPanelTips_2 .. changeNameToolNum)
	
    local function editBoxTextEventHandle(strEventName, pSender, name)
    	if strEventName == "ended" then
            if name == "team_name" then
				-- isAccordNameRule 表示是否符合命名规则，  0表示满足 命名规则，  大于0表示不满足，  并且代表着所满足的条件Id
				--{未知， 命名过短， 命名过长 , 包含空格, 包含非法字符}
				local isAccordNameRule = 1
				local inputName = pSender:getText()
				local nameTable = splitUTF8StrToSingleTab(inputName)
				local inputNameLength = string.len(inputName)
				local nameTableLength = #nameTable
				
				local s1, e1 = string.find(inputName, " ")
				local s2, e2 = string.find(inputName, "[%c%p]")
				if nil ~= s1 then
					isAccordNameRule = 4
				elseif nil ~= s2 then
					isAccordNameRule = 5
				else 
					if inputNameLength ==  nameTableLength		then				--全是英文字符
						if inputNameLength < 4 then
							isAccordNameRule = 2
						elseif inputNameLength > 12 then
							isAccordNameRule = 3
						else
							isAccordNameRule = 0
						end
					else				--全是中文字符
						if nameTableLength < 2 then
							isAccordNameRule = 2
						elseif nameTableLength > 6 then
							isAccordNameRule = 3
						else
							isAccordNameRule = 0
						end
					end
				end
				if isAccordNameRule ~= 0 then
					pSender:setText(randomName)
					Tips(LabelChineseStr.ChangeNameUIPanelError[isAccordNameRule])
				end
				isAccordNameRule = 1
            end
        end
	end

	--创建输入框	
    local bg = self.panel:getChildByName("img_namebg")
	local txt = 
	{
	    input = {callBack=editBoxTextEventHandle, max_length = 10, place_holder = '', pic = IconPath.qiming .. 'i_qmshuru.png',},
	    offset = {y = bg:getContentSize().height/2, x = bg:getContentSize().width/2,},
	    name = 'team_name',
	}
	local editBox = self.panel:createEditBox(txt)
    bg:addChild(editBox)
	editBox:setText(randomName)

	function ChangeNameUIPanel_UserAction_changeUserName(msgObj)
		UserInfoUIPanel_refresh()
		Tips(LabelChineseStr.ChangeNameUIPanelTips_1)
		self:Release()
	end
	
	local function btnCallBack(sender,tag)
		if tag == 0 then
			editBox:setText(DataManager.getRandomName())
			--self.panel:setLabelText("lab_name", DataManager.getRandomName())
		elseif tag == 1 then
			local createReq = UserAction_changeUserNameReq:New()	
			createReq:setString_name(editBox:getText())--lab_Name:getString()
			NetReqLua(createReq, true)
		elseif tag == 2 then
			self:Release(true)
		end
	end
	self.panel:addNodeTouchEventListener("btn_random",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_qd",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,2)

	return self.panel
end

--退出
function ChangeNameUIPanel:Release()
	self.panel:Release()
end

--隐藏
function ChangeNameUIPanel:Hide()
	self.panel:Hide()
end

--显示
function ChangeNameUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
