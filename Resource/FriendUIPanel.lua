--好友主界面
FriendUIPanel = {}
function FriendUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

--创建
function FriendUIPanel:Create(para)
	local p_name = "FriendUI"
    self.panel = Panel:New()
    self.panel:InitPanel(p_name)
	
	local cacheUserId = nil
	local selectSprite = nil
    local cacheSelectIndex = 0
    local cacheFriendList = {}
    local cacheBlackList = {}
	local systemConfig = DataManager.getSystemConfig()
	
	--拉黑
	local function pullBlackCallBack(userId)
		local addBlackReq = FriendAction_addBlackReq:New()
        addBlackReq:setString_targetUserId(userId)
		NetReqLua(addBlackReq,true)
	end
	
	--添加好友
	local function addFriendCallBack(name)
		local applyFriendReq = FriendAction_applyFriendReq:New()
		applyFriendReq:setString_name(name)
		NetReqLua(applyFriendReq,true)
	end
	
    local function OnItemShowCallback(scroll_view, item, data, idx)
        self.panel:setItemLabelText(item,"lab_name", data.name)
        self.panel:setItemLabelText(item,"lab_teamLevel", data.level)
        self.panel:setItemLabelText(item,"lab_equipLevel", data.effective)
        self.panel:setItemImageTexture(item, "img_team", IconUtil.getTeamImgPath(data.camp))
        self.panel:setItemNodeVisible(item, "img_select", false)
		
        local systemHero = DataManager.getStaticSystemHeroId(data.systemHeroId)
        if systemHero then
			self.panel:setItemImageTexture(item,"img_headColor",IconPath.pinzhiYaun..systemHero.heroColor..".png")
			self.panel:setItemImageTexture(item,"img_heroHead",IconPath.yingxiong..systemHero.imgId..".png")
		end
    end
	
    local function OnItemClickCallback(item, data, idx)
		cacheUserId = data.userId
		if selectSprite then
			selectSprite:setVisible(false)
		end
		selectSprite = self.panel:getItemChildByName(item,"img_select")
		selectSprite:setVisible(true)
		
		if cacheSelectIndex == 1 then
			LayerManager.show("FriendDetailUIPanel",{data=data,callBack=pullBlackCallBack})
        end
    end
	
    local function reFreshUI()
        local str = nil
		local tmpData = nil
		selectSprite = nil
		cacheUserId = nil
		
        if cacheSelectIndex == 1 then
            tmpData = cacheFriendList
			str = GameString.addFriend
        else
           tmpData = cacheBlackList
           str = GameString.deleteFriend
        end
		
		local function sortOnline(a,b)
			return a.isOnline > b.isOnline
		end
		table.sort(tmpData,sortOnline)
		self.panel:setBitmapText("img_state",str)
		self.panel:setNodeVisible("lab_nothing",#tmpData == 0)
		self.panel:setLabelText("lab_friendNum",#tmpData.."/"..systemConfig.friend_max_num)
        self.panel:InitListView(tmpData,OnItemShowCallback, OnItemClickCallback)
    end
	
    local function switchTab(selectIndex)
        --还原
		cacheSelectIndex = selectIndex
        self.panel:setBtnEnabled("btn_1", selectIndex ~= 1)
        self.panel:setBtnEnabled("btn_2", selectIndex ~= 2)
		
        --选定
        if selectIndex == 1 then--好友列表获取
            if #cacheFriendList > 0 then
                reFreshUI()
            else
                local userFriendsReq = FriendAction_getUserFriendListReq:New()
                NetReqLua(userFriendsReq, true)
            end
        elseif selectIndex == 2 then--黑名单列表
            if #cacheBlackList > 0 then
                reFreshUI()
            else 
                local userBlacksReq = FriendAction_getUserBlackListReq:New()
                NetReqLua(userBlacksReq,true)
            end
        end
    end
    switchTab(1)
	
    local function btnCallBack(sender,tag)
        if tag == 0 then
		    self:Release() 
        elseif tag == 1 then 
            switchTab(1)
        elseif tag == 2 then
            switchTab(2)
        elseif tag == 3 then--添加玩家/同时也是删除黑名单
            if cacheSelectIndex == 1 then
                LayerManager.show("FriendAddUIPanel",{callBack = addFriendCallBack})
            else
                if cacheUserId then
                    local deleteBlackReq = FriendAction_deleteBlackReq:New()
                    deleteBlackReq:setString_userBlackId(cacheUserId)
                    NetReqLua(deleteBlackReq, true)
                else
                    Tips(LabelChineseStr.FriendUIPanel_7)
                end
            end
        end
	end
	self.panel:addNodeTouchEventListener("btn_back",btnCallBack,0)
    self.panel:addNodeTouchEventListener("btn_1", btnCallBack,1)
    self.panel:addNodeTouchEventListener("btn_2", btnCallBack,2)
	self.panel:addNodeTouchEventListener("btn_addFriend",btnCallBack,3)

    function FriendUIPanel_FriendAction_getUserFriendListReq(msgObj)
        cacheFriendList = msgObj.body.userFriendInfoBOList
        reFreshUI()
    end
	
    function FriendUIPanel_FriendAction_getUserBlackList(msgObj)
        cacheBlackList = msgObj.body.userBlackInfoBOList
        reFreshUI()
    end
    
	function FriendUIPanel_FriendAction_applyFriend(msgObj)
        Tips(LabelChineseStr.FriendUIPanel_4)
    end
	
    function FriendUIPanel_FriendAction_addBlack(msgObj)
		for k=#cacheFriendList,1,-1 do
			if cacheFriendList[k].userId == cacheUserId then
				if #cacheBlackList > 0 then
					table.insert(cacheBlackList,v)
				end
				table.remove(cacheFriendList,k)
			end
		end
        reFreshUI()
		Tips(LabelChineseStr.FriendUIPanel_5)
    end
	
    function FriendUIPanel_FriendAction_deleteBlack(msgObj)
		for k=#cacheBlackList,1,-1 do
			if cacheBlackList[k].userId == cacheUserId then
				table.remove(cacheBlackList,k)
			end
		end
        reFreshUI()
		Tips(LabelChineseStr.FriendUIPanel_6)
    end
    
	return self.panel
end

--退出
function FriendUIPanel:Release()
	self.panel:Release()
end

--隐藏
function FriendUIPanel:Hide()
	self.panel:Hide()
end

--显示
function FriendUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end