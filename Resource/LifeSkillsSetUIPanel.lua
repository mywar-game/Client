--挖矿挂机设置界面

LifeSkillsSetUIPanel = {
panel = nil,
}

function LifeSkillsSetUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

--创建
function LifeSkillsSetUIPanel:Create(para)
    local p_name = "LifeSkillsSetUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	local dataObj = para
	local userData = DataManager.getUserBO()
    local systemConfig = DataManager.getSystemConfig()
    
	local isVipLevel = false
    local cacheFriendList = nil--列表好友
    local cacheSelectList = {}--四个框的英雄数据
	local heroSpriteList = {}
    local cacheSelectIndex = 0--选中四个框的任一个
    local labLastTime = self.panel:getChildByName("lab_leijitimes")
    
	if userData.vipLevel >= tonumber(systemConfig.hangup_num_four_vip_level) then  --vip 等级判断
		isVipLevel = true
		self.panel:setNodeVisible("img_vip",false)
		self.panel:setNodeVisible("img_btnadd3",true)
	else
		self.panel:setBtnEnabled("btn_add3",false)
	end
				
    --填充四个框的数据从dataObj
    local function fillSelectListFromDataObj()
        for k=1,4 do
			if k == 4 then
				cacheSelectList[k] = dataObj.friendSystemHeroId
			else
				local userHeroId = dataObj["userHeroId"..k]
				local userHero = DataManager.getUserHeroId(userHeroId)
				if userHero then
					cacheSelectList[k] = userHero.systemHeroId
				else
					cacheSelectList[k] = ""
				end
			end
        end
    end
    fillSelectListFromDataObj()
	
	local function refertFourHero()
		for k,v in pairs(heroSpriteList) do
			v:removeFromParent(true)
		end
		heroSpriteList = {}
		for k,v in pairs(cacheSelectList)do
			local systemHero
			if k <= 3 then
				systemHero = DataManager.getUserHeroId(v)
			else
				if cacheFriendList then
					for m,n in pairs(cacheFriendList) do
						if n.userId == v then
							systemHero = DataManager.getStaticSystemHeroId(n.systemHeroId)
						end
					end
				end
			end
			if systemHero then
				self.panel:setNodeVisible("img_btnadd"..k,false)
				local addBtn = self.panel:getChildByName("btn_add"..k)
				local imgSize = addBtn:getContentSize()
				local headSprite = CreateCCSprite(IconPath.yingxiong..systemHero.imgId..".png")
				headSprite:setPosition(cc.p(imgSize.width/2,imgSize.height/2))
				addBtn:addChild(headSprite)
				
				local size = headSprite:getContentSize()
				local colorSprite = CreateCCSprite(IconPath.pinzhiYaun..systemHero.heroColor..".png")
				colorSprite:setPosition(cc.p(size.width/2,size.height/2))
				headSprite:addChild(colorSprite)
				table.insert(heroSpriteList,headSprite)
			else
				if k == 3 then
					if isVipLevel then
						self.panel:setNodeVisible("img_btnadd"..k,true)
					end
				else
					self.panel:setNodeVisible("img_btnadd"..k,true)
				end
			end
		end
	end

	local function OnItemShowCallback(scroll_view, item, data, idx)
		local status = data.status or 1
		self.panel:setItemLabelText(item,"lab_state",GameString["heroState"..status])
		
		local systemHero = DataManager.getStaticSystemHeroId(data.systemHeroId)
        self.panel:setItemImageTexture(item,"img_headColor",IconPath.pinzhiYaun..systemHero.heroColor..".png")
		self.panel:setItemImageTexture(item,"img_heroHead",IconPath.yingxiong..systemHero.imgId..".png")
    end
	
    local function OnItemClickCallback(item,data,idx)
		if cacheSelectIndex == 1 then
			if data.status == 1 then
				local num = isVipLevel and 3 or 2
				for k=1,num do
					if cacheSelectList[k] == data.userHeroId then
						break
					end
					
					if cacheSelectList[k] == "" then
						cacheSelectList[k] = data.userHeroId
						refertFourHero()
						break
					end
				end
			else
				Tips(GameString.lifeStatueTips)
			end
		else
			cacheSelectList[4] = data.userId
			refertFourHero()
		end
    end
	
	local function refreshHeroList(idx,pos)
		if cacheSelectList[pos] ~= "" then
			cacheSelectList[pos] = ""
			refertFourHero()
		end
		
		if cacheSelectIndex == idx then
			return
		end
		
		cacheSelectIndex = idx
		self.panel:setNodeVisible("ListView",true)
		self.panel:setNodeVisible("img_donghuadi",false)
		
		local heroList = cacheSelectIndex == 2 and cacheFriendList or DataManager.getUserHeroList()
		self.panel:InitListView(heroList,OnItemShowCallback,OnItemClickCallback,nil,nil,5)
    end

    local function updateTimes()
        dataObj.remainderTime = dataObj.remainderTime - 1000
        if dataObj.remainderTime > 0 then
			labLastTime:setString(Utils.remainTimeToStringHHMMSS(dataObj.remainderTime))
		else
			if dataObj.status == 2 then --挂机中
				self.panel:setBtnEnabled("btn_switch",false)
			end
			self:StopSchedule()
            labLastTime:setString(LabelChineseStr.LifeSkillsUIPanel_5)
        end
    end

    --更新UI
	local function refreshLifeUI(flag)
        --累计收益		
		if #dataObj.drop.goodsList == 0 then
			self.panel:setBtnEnabled("btn_receive",false)
			self.panel:setNodeVisible("img_shouyidi",false)
		else
			self.panel:setBtnEnabled("btn_switch",true)
			self.panel:setBtnEnabled("btn_receive",true)
			self.panel:setNodeVisible("img_shouyidi",true)
			local shouyiSprite = self.panel:getChildByName("img_shouyidi")
			local size = shouyiSprite:getContentSize()
			
			local dropList = {}
			local idx = 0
			for k,v in pairs(dataObj.drop.goodsList) do				
				table.insert(dropList,{goodsType=v.goodsType,goodsId=v.goodsId,goodsNum=v.goodsNum})
			end
			
			for k,v in pairs(dataObj.drop.heroList) do
				table.insert(dropList,{goodsType=v.GameField.hero,goodsId=v.systemHeroId,goodsNum=nil})
			end
			
			for k,v in pairs(dataObj.drop.heroSkillList) do
				table.insert(dropList,{goodsType=v.GameField.skillBook,goodsId=v.systemHeroSkillId,goodsNum=nil})
			end
			
			for k,v in pairs(dataObj.drop.equipList) do
				table.insert(dropList,{goodsType=v.GameField.equip,goodsId=v.equipId,goodsNum=nil})
			end
			
			for k,v in pairs(dataObj.drop.gemstoneList) do
				table.insert(dropList,{goodsType=v.GameField.gemstone,goodsId=v.gemstoneId,goodsNum=nil})
			end
			
			for k,v in pairs(dropList)do
				local toolSprite = IconUtil.GetIconByIdType(v.goodsType,v.goodsId,v.goodsNum)
				toolSprite:setPosition(cc.p(140+idx*80,size.height/2))
				toolSprite:setScale(0.5)
				shouyiSprite:addChild(toolSprite)
			end
		end
		
		self:StopSchedule()
		if dataObj.status == 2 then--挂机
			updateTimes() --显示剩余时间
			self.schedule = self.panel:scheduleScriptFunc(updateTimes,1)
			self.panel:setNodeVisible("img_shengyusj",true)
            self.panel:setBitmapText("img_switch", GameString.stopHeadUp)
        else
            labLastTime:setString(LabelChineseStr.LifeSkillsUIPanel_5)
			self.panel:setNodeVisible("img_shengyusj",false)
            self.panel:setBitmapText("img_switch", GameString.startHeadUp)
		end
		self.panel:setNodeVisible("ListView",false)
		self.panel:setNodeVisible("img_donghuadi",true)
		
		if flag then
			for k,v in pairs(cacheSelectList)do
				cacheSelectList[k] = ""
			end
			cacheSelectIndex = 0
		end
		refertFourHero()
	end
    refreshLifeUI(false)
	
	function LifeSkillsSetUIPanel_FriendAction_getUserFriendList(msgObj)
        cacheFriendList = msgObj.body.userFriendInfoBOList
		refreshHeroList(2,4)
    end
	
    function LifeSkillsSetUIPanel_LifeAction_hangup(msgObj)
        dataObj = msgObj.body.userLifeInfoBO
		refreshLifeUI(false)
    end

    function LifeSkillsUIPanel_LifeAction_cancelHangup(msgObj)
        dataObj = msgObj.body.userLifeInfoBO
		refreshLifeUI(true)
    end

    function LifeSkillsSetUIPanel_LifeAction_receiveReward(msgObj)
		dataObj = msgObj.body.userLifeInfoBO
		refreshLifeUI(true)
        LayerManager.show("DialogRewardsUIPanel",msgObj.body.drop)--展示获得东西
    end

    function LifeSkillsSetUIPanel_LifeAction_getHangupRewardList(msgObj)
	
    end
	
	local function netReceiveReward()
        local receiveRewardReq = LifeAction_receiveRewardReq:New()
        receiveRewardReq:setInt_category(dataObj.category)
        NetReqLua(receiveRewardReq, true)
    end
	
	local function netCancelHangupReq()
		local cancelHangupReq = LifeAction_cancelHangupReq:New()
		cancelHangupReq:setInt_category(dataObj.category)
		NetReqLua(cancelHangupReq, true)
	end
	
	local function netHangupReq()
		--获取英雄
		local userFriendId = 0
		local sendHeroList = {}
		for k,v in pairs(cacheSelectList) do
			if v ~= "" then
				if k == 4 then
					userFriendId = v
				else
					local userHero = DataManager.getUserHeroId(v)
					table.insert(sendHeroList,userHero.userHeroId) 
				end
			end
		end
		
		local handUpReq = LifeAction_hangupReq:New()
		handUpReq:setInt_category(dataObj.category)
		if #sendHeroList > 0 then 
			handUpReq:setList_userHeroIdList(sendHeroList) 
		end
		
		if userFriendId ~= 0 then 
			handUpReq:setString_userFriendId(userFriendId) 
		end
		
		if #sendHeroList > 0 or userFriendId ~= 0 then
			NetReqLua(handUpReq, true)
		else
			Tips(LabelChineseStr.LifeSkillsSetUIPanel_2)
		end
	end
	
	local function btnCallBack(sender,tag)
		if tag == 0 then
            LayerManager.show("LifeSkillsUIPanel")
        elseif tag == 5 then
            if dataObj.status == 2 then--挂机中(取消挂机)
                netCancelHangupReq()
            else--未挂机(请求挂机)
                netHangupReq()
            end
        elseif tag == 6 then--领取奖励
            netReceiveReward()
        else
            if dataObj.status == 2 then--挂机状态
                Tips(LabelChineseStr.LifeSkillsSetUIPanel_3)
                return
            end
			
            if tag == 1 then
				refreshHeroList(1,1)
		    elseif tag == 2 then
				refreshHeroList(1,2)
		    elseif tag == 3 then
				refreshHeroList(1,3)
		    elseif tag == 4 then
                if cacheFriendList then --请求好友数据
					refreshHeroList(2,4)
                else
		            local userFriendsReq = FriendAction_getUserFriendListReq:New()
                    NetReqLua(userFriendsReq, true)
                end
            end
		end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_add1",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_add2",btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_add3",btnCallBack,3)
	self.panel:addNodeTouchEventListener("btn_add4",btnCallBack,4)
    self.panel:addNodeTouchEventListener("btn_switch",btnCallBack,5)
    self.panel:addNodeTouchEventListener("btn_receive",btnCallBack,6)

	return panel
end

--退出
function LifeSkillsSetUIPanel:StopSchedule()
	if self.schedule then
		self.panel:unscheduleScriptEntry(self.schedule)
		self.schedule = nil
	end
end

function LifeSkillsSetUIPanel:Release()
	self:StopSchedule()
	self.panel:Release()
end
--隐藏
function LifeSkillsSetUIPanel:Hide()
	self.panel:Hide()	
end
--显示
function LifeSkillsSetUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerTrue()
end
