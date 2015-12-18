LoginUIPanel = {
panel = nil,
}
function LoginUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

--登录panel
function LoginUIPanel:Create(para)
    local p_name = "LoginUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
    local sdkToken = nil
	local serverList = {}
    local currentServer = nil
	local recentServerKey="RECENT_SERVER_KEY"
	
	-- 读取骨骼	
	local path = "NewUi/xinqietu/denglujiemian/denglujiemian"
	local size = cc.Director:getInstance():getWinSize()
	local armature = CreateSkeleton(path,"denglujiemian")
	armature:setPosition(cc.p(size.width/2,size.height/2))
    armature:getAnimation():play("tx")
	self.panel.layer:addChild(armature,-1)
	
	--sdk返回token
	function sdkUserLoginToken(token)
		sdkToken = token
	end
	
	--登录接口
	function sdkUserLoginReq()
		VersionManager.startSdkLogin()
	end	
	
    function showServer(server)
        self.panel:setNodeVisible("process",false)--隐藏loading条
        self.panel:setNodeVisible("area",true)--显示选择服务器
        if server~=nil then
            self.panel:setLabelText("lab_area_one",server.serverName)
        else
            self.panel:setLabelText("lab_area_one","暂无服务器信息")
        end
    end
	
	local platInfo = V.getPlatInfo()
    local localVersion = platInfo.packageVersion.."."..VersionNumRes.getLocalResVersion()
	
    local function login()--登录游戏
	
    end
    
	local function enterGame()
        if currentServer==nil then
           Tips(GameString.selectServer)
        else
            cc.UserDefault:getInstance():setStringForKey(recentServerKey, currentServer.serverId)--保存最近登录的服务器
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
                    para()--进入游戏
                 else
                    if msg~=nil then
                       Tips(GameString.loginFail..msg)
                    else
                       Tips(GameString.loginFail.."ErrorCode["..rc.."]")   
                    end
                end
				
            end
            --登录游戏
            if V.getPlatFormType() == 0 then--windows平台不支持sdk接入
                para()
            else
				if sdkToken then
					NetHttpReq.login(sdkToken,currentServer.serverId,localVersion,platInfo.partnerId,platInfo.qn,platInfo.imei,platInfo.mac,platInfo.mobile,loginCallBack)
				else
					VersionManager.startSdkLogin()
				end
			end
        end
		
    end
	
	function serverListCallBack(data)
		if data ~= nil then
			currentServer = data
			local showServerEntry = data
			showServer(showServerEntry)
			sdkUserLoginReq()
		end
	end

	local function btnCallBack(sender,tag)
		if tag == 0 then
			LayerManager.show("LoginServerListUIPanel",{callBack=serverListCallBack,sl=serverList}) 
		elseif tag == 1 then
			enterGame()
		elseif tag == 2 then
			--Utils.sendNotifyToPlamt(5,"")
		end	
	end
	self.panel:addNodeTouchEventListener("btn_choose_area",btnCallBack,0)
	self.panel:addNodeTouchEventListener("btn_enter",btnCallBack,1)
	self.panel:addNodeTouchEventListener("btn_enter_uc",btnCallBack,2)
	
	local function getServerListCallBack(code,tag,data)
		data = json.decode(data)      
		if data ~= nill and data.sl ~= nil and #data.sl>0 then
			serverList = data.sl
			for k,v in pairs(serverList)do
				if v.status == 3 then
					currentServer = v
					local idx = string.sub(v.serverId,2,string.len(v.serverId))
					local strText = idx..LabelChineseStr.LoginServerListUIPanel_1
					if v.status == 1 then
						strText = strText.." "..v.serverName ..' '..LabelChineseStr.LoginServerListUIPanel_5
					elseif v.status == 3 then
						strText = strText.." "..v.serverName ..' '..LabelChineseStr.LoginServerListUIPanel_4
					else
						strText = strText.." "..v.serverName ..' '..LabelChineseStr.LoginServerListUIPanel_6
					end
					self.panel:setLabelText("lab_area_one",strText)
					break
				end
			end
		end
	end
	NetHttpReq.getServerList(localVersion,platInfo.partnerId,platInfo.qn,platInfo.imei,platInfo.mac,getServerListCallBack)
	
	return panel
end

function LoginUIPanel:Release()
	self.panel:Release()
end

function LoginUIPanel:Hide()
	self.panel:Hide()
end

function LoginUIPanel:Show()
	self.panel:Show()	
end
