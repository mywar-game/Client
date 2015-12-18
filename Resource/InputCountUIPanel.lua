--当铺数量选择
InputCountUIPanel = {}
function InputCountUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function InputCountUIPanel:Create(para)
	local p_name = "PawnNumSelectUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
	self.allCount = 1
	local upLimit = para.upLimit
	local lowLimit = para.lowLimit
	
	self.panel:setNodeVisible("lab_money", false)
	self.panel:setNodeVisible("lab_bottomTip", false)
	self.panel:setLabelText("lab_topTip", LabelChineseStr.ForgeLookUITitle_1)
	--self.panel:setBitmapText("BitmapLabel_30", LabelChineseStr.ForgeLookUITitle_2)
	local function refreshSelectNum(num)
		if upLimit < self.allCount + num then
			Tips("no more")
			return
		elseif lowLimit > self.allCount + num then
			Tips("error!!!")
			return
		end
		self.allCount = self.allCount + num
		self.panel:setLabelText("lab_num", self.allCount)
	end

	local function btnCallBack(sender,tag)
		
        if tag == "btn_close" or tag == "btn_cancel" then
		     self:Release()
        elseif tag == "btn_sure" then
			para.arguments.num = self.allCount
			para.callBack(para.arguments)
			self:Release()
        elseif tag == "btn_add" then
            refreshSelectNum(1)
        elseif tag == "btn_addTen" then
            refreshSelectNum(10)
        elseif tag == "btn_subtract" then
            refreshSelectNum(-1)
        elseif tag == "btn_subTen" then
            refreshSelectNum(-10)
        end
	end
	self.panel:addNodeTouchEventListener("btn_close",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_cancel",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_sure",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_add",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_addTen",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_subtract",btnCallBack)
	self.panel:addNodeTouchEventListener("btn_subTen",btnCallBack)

    return self.panel
end

--退出
function InputCountUIPanel:Release()
	self.panel:Release(true)
end

--隐藏
function InputCountUIPanel:Hide()
	self.panel:Hide()
end

--显示
function InputCountUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerTrue()
end