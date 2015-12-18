LoginServerListUIPanel = {
panel = nil,
}
function LoginServerListUIPanel:New(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
   return o
end

--登录panel
function LoginServerListUIPanel:Create(para)
    local p_name = "LoginServerListUI"
    local panel = Panel:New()
	self.panel = panel
    panel:InitPanel(p_name)
	
	local MAXSERVER = 10
	local leftSprite = nil
	local rightSprite = nil
	local serverList = {}

	--服务器列表回调
	local function OnItemClickCallback(item, data, idx)
		rightSprite:setVisible(false)
		rightSprite = self.panel:getItemChildByName(item,"img_rightSelect")
		rightSprite:setVisible(true)
		
		para.callBack(data)
		self:Release()
	end
	
	local function OnItemShowCallback(scroll_view,item,data,idx)
		--1火爆 3新区 4维护
		local strText = data.idx..LabelChineseStr.LoginServerListUIPanel_1
 		if data.status == 1 then
			strText = strText.." "..data.serverName ..' '..LabelChineseStr.LoginServerListUIPanel_5
		elseif data.status == 3 then
			strText = strText.." "..data.serverName ..' '..LabelChineseStr.LoginServerListUIPanel_4
		else
			strText = strText.." "..data.serverName ..' '..LabelChineseStr.LoginServerListUIPanel_6
		end
		self.panel:setItemLabelText(item,"lab_serverName",strText)
		
		if rightSprite == nil then
			rightSprite = self.panel:getItemChildByName(item,"img_rightSelect")
			rightSprite:setVisible(true)
		end
	end
	
	local function showRightList(item,data)
		if leftSprite then
			leftSprite:setVisible(false)
		end
		leftSprite = self.panel:getItemChildByName(item,"img_leftSelect")
		leftSprite:setVisible(true)
		
		local tableTmp = {}
		local strServer = ""
		if data == 0 then
			for k,v in pairs(serverList) do
				if v.status == 3 then
					table.insert(tableTmp,v) 
				end
			end
			strServer = LabelChineseStr.LoginServerListUIPanel_3..LabelChineseStr.LoginServerListUIPanel_2
		else
			for k=(data-1)*MAXSERVER+1,data*MAXSERVER do
				for m,n in pairs(serverList)do
					if n.idx == k then
						table.insert(tableTmp,n)
					end
				end
			end
			strServer = LabelChineseStr.LoginServerListUIPanel_3..((data-1)*MAXSERVER+1).."--"..(data*MAXSERVER)..LabelChineseStr.LoginServerListUIPanel_1
		end
		rightSprite = nil
		self.panel:setLabelText("lab_name",strServer)
		self.panel:InitListView(tableTmp,OnItemShowCallback,OnItemClickCallback,"ListView_right","ListItem_right",2)			
	end
	
	local function LeftOnItemShowCallback(scroll_view,item,data,idx)
		if leftSprite == nil then
			showRightList(item,data)
		end
		local strText = ""
		if data == 0 then
			strText = LabelChineseStr.LoginServerListUIPanel_2
		else
			strText = ((data-1)*MAXSERVER+1)..'--'..(data*MAXSERVER)..LabelChineseStr.LoginServerListUIPanel_1
		end
		self.panel:setItemLabelText(item,"lab_text",strText)
	end
	
	--服务器区数表列回调
	local function LeftOnItemClickCallback(item, data, idx)
		showRightList(item,idx)
	end
			
	local function showServerList(sl)
		for k,v in pairs(sl) do
			local idx = string.sub(v.serverId,2,string.len(v.serverId))
			local copyServer = DeepCopy(v)
			copyServer.idx = tonumber(idx)
			table.insert(serverList,copyServer)
		end
		
		local function sortIdx(a,b)
			return a.idx < b.idx
		end
		table.sort(serverList,sortIdx)
		
		local temList = {}
		local count = math.ceil(#serverList/MAXSERVER)
		table.insert(temList,0)
		for k=count,1,-1 do
			table.insert(temList,k)
		end
		self.panel:InitListView(temList,LeftOnItemShowCallback,LeftOnItemClickCallback,"ListView_left","ListItem_left")			    
	end
	showServerList(para.sl)
 	
	return panel
end

function LoginServerListUIPanel:Release()
	self.panel:Release(true)
end
function LoginServerListUIPanel:Hide()
	self.panel:Hide()
end
function LoginServerListUIPanel:Show()
	self.panel:Show()
	self.panel:registerScriptTouchHandlerClose()
end
