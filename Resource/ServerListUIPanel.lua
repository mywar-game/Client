ServerListUIPanel = {
panel = nil,
}

function ServerListUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

--创建
function ServerListUIPanel:Create(para)
    local p_name = "ServerListUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)

    local function btnCallBack(sender,tag)
		if tag == 0 then
			self:Release()				
		end
    end

    local function OnItemShowCallback(scroll_view, item, data, idx)
        self.panel:setItemLabelText(item,"lab_heroName", data.serverName)
		--默认选中第一个
		if idx ~= 1 then
			self.panel:setItemVisable(item, "img_change", false)  
		end
		
    end
    local function OnItemClickCallback(item, data, idx) 
		--选中服务器信息
		local currentServer = data
		--设置选中状态
		self.panel:setItemVisable(item, "img_change", true)  
		local function loginCallBack(code,tag,data)--登录回调
			local result = json.decode(data)
			local rc=-1
			if result.rc~=nil then
				rc = result.rc
			end
			local msg = nil
			if result.msg~=nil then
				msg=result.msg
			end
			if rc==1000 then
				ConfigManager.setLoginInfo(result.dt.tk,currentServer.serverId,result.dt.uid,result.dt.puid,currentServer.port,currentServer.serverUrl)
				--para()--进入游戏
			 else
				if msg~=nil then
				   Tips("登录失败:"..msg)
				else
				   Tips("登录失败，ErrorCode["..rc.."]")   
				end
			end
		end
		--登录游戏
		if V.getPlatFormType() == 0 then--windows平台不支持sdk接入
			--para()
			cc.UserDefault:getInstance():setStringForKey(recentServerKey, currentServer.serverId)--保存最近登录的服务器
			cclog("OK-----------")
		else
			cc.UserDefault:getInstance():setStringForKey(recentServerKey, currentServer.serverId)--保存最近登录的服务器
			NetHttpReq.login(TOKEN,currentServer.serverId,localVersion,platInfo.partnerId,platInfo.qn,platInfo.imei,platInfo.mac,platInfo.mobile,loginCallBack)
		end

    end
	
	local serverList = {}
	local platInfo = V.getPlatInfo()
    local localVersion = platInfo.packageVersion.."."..VersionNumRes.getLocalResVersion()
    local function getServerList()
        local function getServerListCallBack(code,tag,data)
            data = json.decode(data)      
            if data~=nill and data.sl~=nil and #data.sl>0 then
                serverList = data.sl
				self.panel:InitListView(serverList,OnItemShowCallback,OnItemClickCallback,nil,nil,2)--初始化所有服务器
			end        
        end
        
        NetHttpReq.getServerList(localVersion,platInfo.partnerId,platInfo.qn,platInfo.imei,platInfo.mac,getServerListCallBack)
    end

	getServerList()
	
	self.panel:addNodeTouchEventListener("btn_close",btnCallBack,0)
	return panel
end


--退出
function ServerListUIPanel:Release()
	self.panel:Release(true)
end
--隐藏
function ServerListUIPanel:Hide()
	self.panel:Hide()	
end
--显示
function ServerListUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
