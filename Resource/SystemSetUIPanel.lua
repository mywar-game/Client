require("Utils")

SystemSetUIPanel = {
panel = nil,
}

function SystemSetUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

--创建
function SystemSetUIPanel:Create(para)
    local p_name = "SystemSetUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
    local function btnCallBack(sender,tag)
		if tag == 0 then
				self:Release()
		elseif tag == 1 then
			LayerManager.show("SwitchSetUIPanel")
		elseif tag == 2 then
			LayerManager.show("NoticeUIPanel")
		elseif tag == 3 then
			CppToLua:OpenURL("http://www.baidu.com")
		elseif tag == 4 then
			CppToLua:OpenURL("http://www.baidu.com")
		elseif tag == 5 then
			LayerManager.show("NotescontactUIPanel")
		elseif tag == 6 then
			LayerManager.show("ServerListUIPanel")
		end
    end
	
	local function checkBoxCallBack(sender,eventype, tag)
		if tag == 1  then
			setNotPlayBg(eventype)
			if eventype == 0 then
				local curSceneId = DataManager.getCurrentSceneId()
				local systemScene = DataManager.getSystemSceneId(curSceneId)
				local systemMap = DataManager.getSystemMapId(systemScene.mapId)
				SoundEffect.playBgMusic(systemMap.soundEffectId)
			else
				SoundEffect.stopBgMusic()
			end
		elseif tag == 2 then
			setNotPlaySound(eventype)
		elseif tag == 3 then
		
		elseif tag == 4 then
		
		elseif tag == 5 then
			
		end
	end
	
	--从配置文件中是否开启，音乐音效，和消息推送，以及人数
	local isPlayBg = isNotPlayBg()
	if nil == isPlayBg then
		self.panel:setCheckBoxSelect( "checkbox_music",true)
	else
		if isNotPlayBg() == false then
			self.panel:setCheckBoxSelect( "checkbox_music",true)
		else
			self.panel:setCheckBoxSelect( "checkbox_music",false)
		end 
	end

	local isPlaySound = isNotPlaySound()
	if nil == isPlaySound then
		self.panel:setCheckBoxSelect( "checkbox_soundeffect",true)
	else
		if isNotPlaySound() == false then
			self.panel:setCheckBoxSelect( "checkbox_soundeffect",  true)
		else
			self.panel:setCheckBoxSelect( "checkbox_soundeffect",  false)
		end
	end
	
	if ConfigManager.getLocalValueByKey("pushMsg") == nil then
		self.panel:setCheckBoxSelect( "checkbox_msg", true )
	else
		local data = ConfigManager.getLocalValueByKey("pushMsg")
		if data == 0 then
			self.panel:setCheckBoxSelect( "checkbox_msg", false )
		else
			self.panel:setCheckBoxSelect( "checkbox_msg", true )
		end
	end
	
	local oldPercent = 5
	local function sliderCallBack(sender,eventype)
		local node = self.panel:getChildByName("lab_nums")
		local node2 = self.panel:getChildByName("slider_bodynums")
		local nums2 = node2:getPercent()
		if nums2 < 10 then
			node2:setPercent(10)
		elseif nums2 > 87 then
			node2:setPercent(87)
		end
		
		--进度条调整显示方式
		if nums2 >= 0 and nums2 < 10 then
			node:setString("10")
		elseif nums2 >= 10 and nums2 < 20 then
			node:setString(12)
		elseif nums2 >= 20 and nums2 < 30 then
			node:setString(14)
		elseif nums2 >= 30 and nums2 < 40 then
			node:setString(16)
		elseif nums2 >= 40 and nums2 < 50 then
			node:setString(20)
		elseif nums2 >= 50 and nums2 < 60 then
			node:setString(22)
		elseif nums2 >= 60 and nums2 < 70 then
			node:setString(24)
		elseif nums2 >= 70 and nums2 < 80 then
			node:setString(26)
		elseif nums2 >= 80 and nums2 < 85 then
			node:setString("28")
		elseif nums2 >= 85 then
			node:setString(30)
		end
		
		--保存同屏显示人数到文件
		ConfigManager.saveLocal(ConfigManager.showPeopelNums, node:getString())
	end
	
	--获取本地保存同屏玩家数
	local systemConfig = DataManager.getSystemConfig() 
	local pepNums = tonumber( ConfigManager.getLocalValueByKey(ConfigManager.showPeopelNums))
	if pepNums == nil then 
		--如果没有保存就使用总推过来的默认值
		pepNums = tonumber(systemConfig.screen_display_lower_num)
	end 
	
	
	local node = self.panel:getChildByName("lab_nums")
	local node2 = self.panel:getChildByName("slider_bodynums")
	node:setString(pepNums)
	
	--设置进度条的位置根据人数值来设定
	if pepNums == 10 then
		node2:setPercent(10)
	elseif pepNums == 12 then
		node2:setPercent(20)
	elseif pepNums == 14 then
		node2:setPercent(30)
	elseif pepNums == 16 then
		node2:setPercent(40)
	elseif pepNums == 20 then
		node2:setPercent(50)
	elseif pepNums == 22 then
		node2:setPercent(60)
	elseif pepNums == 24 then
		node2:setPercent(65)
	elseif pepNums == 26 then
		node2:setPercent(70)
	elseif pepNums == 28 then
		node2:setPercent(75)
	elseif pepNums == 30 then
		node2:setPercent(85)
	end
		
	--进度条回调
	self.panel:registerSliderEvent("slider_bodynums", sliderCallBack)
	
	--按钮事件ID绑定
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_switch",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_notice",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_wbo",btnCallBack,3)
	self.panel:addNodeTouchEventListener("btn_forum",btnCallBack,4)
	self.panel:addNodeTouchEventListener("btn_contact",btnCallBack,5)
	self.panel:addNodeTouchEventListener("btn_serlist",btnCallBack,6)
	
	--checkBox 事件绑定
	self.panel:addCheckBoxNodeSelectEvent("checkbox_music",checkBoxCallBack,1)
	self.panel:addCheckBoxNodeSelectEvent("checkbox_soundeffect",checkBoxCallBack,2)
	self.panel:addCheckBoxNodeSelectEvent("checkbox_msg",checkBoxCallBack,3)
	
	return panel
end


--退出
function SystemSetUIPanel:Release()
	self.panel:Release()
end
--隐藏
function SystemSetUIPanel:Hide()
	self.panel:Hide()	
end
--显示
function SystemSetUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
