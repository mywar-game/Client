--��Ϣ��ʾ���߼�
FightPasueUIPanel = {}
function FightPasueUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--����
function FightPasueUIPanel:Create(para)
	local p_name = "FightPasueUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
	
	local function btnCallBack(sender,tag)
		if tag == 2 then
			para.callBack()
		end
		self:Release()
	end
	--cc.Director:getInstance():pause()
	--cc.Director:getInstance():resume()
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_cancel",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_ok",btnCallBack,2)

    return self.panel
end

--�˳�
function FightPasueUIPanel:Release()
	self.panel:Release(true)
end

--����
function FightPasueUIPanel:Hide()
	self.panel:Hide()
end

--��ʾ
function FightPasueUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerTrue()
end